/**
 * MatchWise matching engine (our own trained model).
 * - classify(): predicts the service type (plumbing, electrical, ...) from free text
 * - matchProviders(): scores providers by category fit, text similarity, location and rating
 * Pure TypeScript, no libraries, runs inside the Cloudflare Worker.
 */
import { MODEL_JSON } from "./serviceModel";

type TermTable = Record<string, number[]>; // term -> [idf, coef_class0, coef_class1, ...]
interface Model {
  labels: string[];
  intercept: number[];
  word: TermTable;
  char: TermTable;
}

let _model: Model | null = null;
function model(): Model {
  if (!_model) _model = JSON.parse(MODEL_JSON) as Model;
  return _model;
}

export const LABEL_NAMES: Record<string, string> = {
  plumbing: "Plumbing",
  electrical: "Electrical",
  cleaning: "Cleaning",
  gardening: "Gardening & Landscaping",
  painting: "Painting",
  carpentry: "Carpentry",
  tutoring: "Tutoring",
  moving: "Moving & Transport",
  appliance_repair: "Appliance Repair",
  car_mechanic: "Car Mechanic",
  hair_beauty: "Hair & Beauty",
  it_support: "IT Support",
  photography: "Photography & Video",
  security: "Security",
  catering: "Catering",
  other: "Other",
};

const STOPWORDS = new Set(
  ("i me my we our you your a an the and or of to in on at for with is are am was be it its this that these those there here " +
    "need needs want looking look find someone anyone somebody who can could would should please help hi hello hey good day urgently asap thank thanks " +
    "from as by about up out have has had do does get got new not any some very just so if but").split(" "),
);

// ---------- text -> numbers (must behave exactly like scikit-learn's TfidfVectorizer) ----------
function wordTerms(text: string): string[] {
  const tokens = text.toLowerCase().match(/[\p{L}\p{N}_]{2,}/gu) ?? [];
  const terms = [...tokens];
  for (let i = 0; i + 1 < tokens.length; i++) terms.push(tokens[i] + " " + tokens[i + 1]);
  return terms;
}

function charTerms(text: string): string[] {
  const out: string[] = [];
  for (const raw of text.toLowerCase().split(/\s+/).filter(Boolean)) {
    const w = " " + raw + " ";
    for (let n = 3; n <= 5; n++) {
      let offset = 0;
      out.push(w.slice(offset, offset + n));
      while (offset + n < w.length) {
        offset++;
        out.push(w.slice(offset, offset + n));
      }
      if (offset === 0) break;
    }
  }
  return out;
}

/** TF-IDF weights (sublinear tf, L2 normalised) for the terms the model knows. */
function tfidf(terms: string[], table: TermTable): Map<string, number> {
  const counts = new Map<string, number>();
  for (const t of terms) if (t in table) counts.set(t, (counts.get(t) ?? 0) + 1);
  const weights = new Map<string, number>();
  let sumSq = 0;
  for (const [t, c] of counts) {
    const w = (1 + Math.log(c)) * table[t][0];
    weights.set(t, w);
    sumSq += w * w;
  }
  const norm = Math.sqrt(sumSq) || 1;
  for (const [t, w] of weights) weights.set(t, w / norm);
  return weights;
}

export interface Classification {
  probs: number[];
  label: string;
  confidence: number;
  keywords: string[];
}

export function classify(text: string): Classification {
  const m = model();
  const logits = [...m.intercept];
  const wordW = tfidf(wordTerms(text), m.word);
  const charW = tfidf(charTerms(text), m.char);
  for (const [t, w] of wordW) for (let k = 0; k < logits.length; k++) logits[k] += w * m.word[t][1 + k];
  for (const [t, w] of charW) for (let k = 0; k < logits.length; k++) logits[k] += w * m.char[t][1 + k];

  const max = Math.max(...logits);
  const exps = logits.map((l) => Math.exp(l - max));
  const total = exps.reduce((a, b) => a + b, 0);
  const probs = exps.map((e) => e / total);
  const best = probs.indexOf(Math.max(...probs));

  // keywords = single words that pushed the prediction towards the winning class the most
  const kw: [string, number][] = [];
  for (const [t, w] of wordW) if (!t.includes(" ")) kw.push([t, w * m.word[t][1 + best]]);
  kw.sort((a, b) => b[1] - a[1]);
  const keywords = kw.filter((x) => x[1] > 0 && !STOPWORDS.has(x[0])).slice(0, 5).map((x) => x[0]);

  return { probs, label: m.labels[best], confidence: probs[best], keywords };
}

function similarity(a: string, b: string): number {
  const m = model();
  const wa = tfidf(wordTerms(a), m.word);
  const wb = tfidf(wordTerms(b), m.word);
  let dot = 0;
  for (const [t, w] of wa) dot += w * (wb.get(t) ?? 0);
  return dot;
}

// ---------- ranking ----------
export interface ProviderInput {
  id: string;
  business_name: string | null;
  category: string | null;
  bio: string | null;
  location: string | null;
  avg_rating: number | null;
  rating_count: number | null;
}

export interface MatchOutput {
  service_type: string;
  keywords: string[];
  summary: string;
  ranked: { provider_id: string; score: number; reason: string }[];
}

const norm = (s: string | null | undefined) => (s ?? "").toLowerCase().trim();

/** Does the provider's location appear in what the client typed (or the location box)? */
function locationMatch(clientLocation: string | null | undefined, requestText: string, providerLocation: string | null): boolean {
  const pl = norm(providerLocation);
  if (!pl) return false;
  const haystack = norm(clientLocation) + " " + norm(requestText);
  const parts = pl.split(/[,/;-]|\s+/).filter((p) => p.length >= 4);
  return haystack.includes(pl) || parts.some((p) => haystack.includes(p));
}

export function matchProviders(
  requestText: string,
  clientLocation: string | null | undefined,
  providers: ProviderInput[],
  maxResults = 5,
): MatchOutput {
  const req = classify(requestText);
  const service = LABEL_NAMES[req.label] ?? req.label;
  const hasLocation = norm(clientLocation).length > 0;

  // The model could not recognise a service (off-topic or unclear request) -> no match.
  if (req.label === "other" || req.confidence < 0.3) {
    return {
      service_type: "Unrecognised",
      keywords: req.keywords,
      summary: "We could not tell which service you need. Try describing the job, e.g. 'fix a leaking tap in Pretoria'.",
      ranked: [],
    };
  }

  const scored = providers.map((p) => {
    const pText = `${p.category ?? ""}. ${p.category ?? ""}. ${p.business_name ?? ""}. ${p.bio ?? ""}`;
    const pc = classify(pText);
    // category fit = how much the request and the provider point to the same service(s)
    const catFit = req.probs.reduce((sum, r, k) => sum + r * pc.probs[k], 0);
    const sim = similarity(requestText, pText);
    const locHit = locationMatch(clientLocation, requestText, p.location);
    const locScore = locHit ? 1 : hasLocation ? 0 : 0.5;
    // smoothed rating: providers with no reviews start at a neutral 3.5/5
    const count = p.rating_count ?? 0;
    const avg = p.avg_rating ?? 0;
    const rating = (avg * count + 3.5 * 3) / (count + 3) / 5;

    const score = 100 * (0.6 * catFit + 0.15 * sim + 0.1 * locScore + 0.15 * rating);
    const parts = [`${Math.round(catFit * 100)}% fit for ${service}`];
    parts.push(count > 0 ? `rated ${avg.toFixed(1)}/5 from ${count} review${count === 1 ? "" : "s"}` : "new provider, no reviews yet");
    if (locHit && p.location) parts.push(`serves ${p.location}`);
    return { provider_id: p.id, score: Math.round(Math.max(0, Math.min(100, score))), reason: parts.join(", "), catFit };
  });

  const ranked = scored
    .filter((s) => s.catFit >= 0.2)
    .sort((a, b) => b.score - a.score)
    .slice(0, maxResults)
    .map(({ provider_id, score, reason }) => ({ provider_id, score, reason }));

  return {
    service_type: service,
    keywords: req.keywords,
    summary: `Looking for ${service} services${hasLocation ? ` in ${clientLocation}` : ""}.`,
    ranked,
  };
}
