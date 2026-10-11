"""
STEP 1 - Build the training dataset.

Run:  python generate_dataset.py
Output: dataset.csv  (columns: text,label)

Where the data comes from (3 sources, all ours - no outside AI needed):
  1. Building blocks below (tasks / statements per category) combined with
     sentence templates, South African place names, and urgency phrases.
  2. YOUR OWN sentences in my_examples.csv (text,label). Every group member
     should add 20+ per category. They are added to the training data
     (and repeated 3x so they carry more weight).
  3. test_handwritten.csv is NEVER used for training. It is the exam paper.
"""
import csv, os, random

random.seed(42)

# label -> (tasks, statements)
# tasks fit after "I need someone to ..."; statements are complete sentences.
DATA = {
"plumbing": (
 ["fix a leaking tap", "unblock my kitchen sink", "repair a burst pipe", "replace my geyser",
  "fix a leaking geyser", "unblock a blocked drain", "install a new toilet", "fix a running toilet",
  "repair the water pressure in my shower", "install a new basin", "fix leaking pipes under the sink",
  "clear a blocked sewer line", "install a washing machine water connection", "find and fix a water leak in the wall"],
 ["My geyser burst and there is water everywhere", "The toilet keeps overflowing", "Water is dripping from the ceiling and I think a pipe is leaking",
  "My drain smells terrible and the water drains very slowly", "There is no hot water in the house since this morning",
  "The kitchen tap has been dripping all night", "My bath will not drain at all", "I have low water pressure in every tap"]),
"electrical": (
 ["fix a power outage in my house", "install new plug points", "replace a broken light switch", "install ceiling lights",
  "fix a tripping circuit breaker", "rewire two rooms", "install a prepaid electricity meter", "repair the DB board",
  "install an electric fence energiser", "fix flickering lights", "get an electrical certificate of compliance", "install a stove isolator",
  "mount and wire outdoor security lights", "fix a socket that sparks"],
 ["The lights keep tripping every time I switch on the kettle", "Half of my house has no electricity", "I smell burning from a wall plug",
  "My electric stove stopped working and I think it is the wiring", "The power keeps going off in the bedroom only",
  "I need a COC before I can sell my house", "My lights flicker whenever the fridge turns on", "The main switch keeps tripping"]),
"cleaning": (
 ["clean my house", "do a deep clean of my apartment", "clean my office every week", "clean carpets and couches",
  "do a move out clean", "wash my windows", "clean my kitchen and bathrooms", "do weekly house cleaning",
  "clean after renovations", "steam clean my mattress", "clean a guesthouse between guests", "iron and do laundry for the family",
  "do spring cleaning", "clean an airbnb"],
 ["My apartment needs a proper deep clean before my landlord inspects", "I need a domestic worker twice a week", "The carpets are stained and need professional cleaning",
  "We just finished building and there is dust everywhere", "I have guests arriving and the whole house is a mess",
  "I am looking for a reliable cleaner for my office", "My couches smell and need to be cleaned", "I want a cleaning service for my restaurant after hours"]),
"gardening": (
 ["mow my lawn", "trim the hedges", "landscape my backyard", "remove a tree stump", "plant a vegetable garden",
  "cut down a dead tree", "set up an irrigation system", "maintain my garden every month", "lay new grass sod",
  "prune my fruit trees", "clear an overgrown yard", "design a small garden", "remove weeds and garden refuse", "build a rockery"],
 ["My garden is completely overgrown", "The grass is knee high and I cannot mow it myself", "I want to plant flowers and new shrubs in my front yard",
  "A big tree branch is hanging over my roof", "My lawn has brown patches and needs treatment", "I need a garden service once a month",
  "The hedge along my wall has become huge", "My sprinklers stopped working and the garden is dying"]),
"painting": (
 ["paint my house", "paint the inside walls of my flat", "repaint my roof", "paint my fence and gate", "waterproof and paint outside walls",
  "paint two bedrooms", "do wall plastering and painting", "paint my office", "repaint the garage", "fix damp patches and repaint the walls",
  "paint a house exterior", "paint my kitchen cupboards", "apply a feature wall", "paint a new build before moving in"],
 ["The walls in my lounge are peeling and need a fresh coat", "I just bought a house and want it painted before we move in", "My roof paint is faded and rusty",
  "There are damp marks on the bedroom wall that need fixing and painting", "I want my whole house painted white inside",
  "The outside of my house looks old and needs new paint", "My boundary wall needs plaster and paint", "I need a painter for my shop front"]),
"carpentry": (
 ["build custom kitchen cupboards", "make a wooden wardrobe", "fix broken doors", "install a new wooden floor", "build a deck",
  "repair a wooden fence", "make a built in cupboard", "build a carport", "fix a roof truss", "make a custom bed frame",
  "install door frames and windows", "build a pergola", "repair my broken table", "put up shelving in my study"],
 ["My wardrobe door fell off its hinges", "I want built in cupboards in my bedroom", "The wooden deck outside is rotting and needs to be rebuilt",
  "I need a carpenter for a custom dining table", "My front door does not close properly", "I need shelves built for my garage",
  "Termites damaged my wooden window frames", "I am looking for someone who works with wood to make a bookshelf"]),
"tutoring": (
 ["teach my son maths", "help my daughter with physics", "tutor grade 12 accounting", "give english lessons", "prepare me for my matric exams",
  "teach my child to read", "tutor first year university statistics", "help with life sciences homework", "give online maths lessons",
  "teach coding to teenagers", "help me with my programming assignment", "tutor afrikaans", "give extra lessons after school", "teach my kid isiZulu"],
 ["My son is failing maths and needs extra lessons", "I need a tutor for grade 10 science", "My daughter writes matric this year and needs help with physical sciences",
  "I struggle with calculus at university and need a tutor", "I want someone to teach me how to code", "My kids need homework help every afternoon",
  "I need lessons to improve my english before my exam", "Looking for a private teacher for accounting"]),
"moving": (
 ["move my furniture to a new house", "transport a fridge and a washing machine", "move my flat contents to another city", "move my office",
  "deliver a bed and a couch", "pack and move my belongings", "hire a truck and two helpers", "move a piano",
  "do a long distance move", "collect furniture I bought online", "move boxes from storage", "relocate my small business",
  "haul away old furniture", "move a few items across town"],
 ["I am relocating next month and need a moving truck", "I bought a couch and need it delivered to my house", "I need help carrying heavy furniture up to the third floor",
  "We are moving from Johannesburg to Cape Town and need a reliable removal company", "I need a bakkie to transport building material",
  "I need packers and movers for the weekend", "I need to move out of my flat by Friday", "I need someone with a truck to take rubbish to the dump"]),
"appliance_repair": (
 ["fix my washing machine", "repair my fridge", "repair a dishwasher", "fix my tumble dryer", "repair my microwave",
  "fix an air conditioner", "repair my oven", "fix my television", "fix a freezer that is not cooling",
  "repair a vacuum cleaner", "service my aircon", "fix my stove plate", "repair a coffee machine", "fix a washing machine that will not spin"],
 ["My fridge is making a loud noise and is not cold anymore", "The washing machine stopped mid cycle and will not drain", "My oven does not heat up",
  "My dishwasher leaks water on the floor", "The tumble dryer runs but there is no heat", "The aircon blows warm air",
  "My microwave sparks when I use it", "My freezer is full of ice and food is spoiling"]),
"car_mechanic": (
 ["service my car", "fix my brakes", "replace my clutch", "do a wheel alignment", "repair my gearbox", "diagnose an engine problem",
  "replace my car battery", "fix my car aircon", "change the oil and filters", "repair my exhaust", "tow my broken down car",
  "replace tyres", "fix my radiator", "repair a car that will not start"],
 ["My car will not start this morning", "There is a strange noise coming from my engine", "The engine light is on and I do not know why",
  "My brakes are squeaking and feel soft", "My car overheats on the highway", "I need a mobile mechanic to come to my house",
  "My car is leaking oil in the driveway", "I need a roadworthy certificate for my vehicle"]),
"hair_beauty": (
 ["do my hair for a wedding", "braid my hair", "do bridal makeup", "do my nails", "give me a haircut at home", "do a facial",
  "do gel nails and pedicures", "style my hair for matric farewell", "do lash extensions", "do a full body massage",
  "do makeup for a photoshoot", "cut my son's hair", "install a weave", "do a manicure"],
 ["I need a hairdresser for my wedding party", "I want a mobile makeup artist for my birthday", "I am looking for someone to do box braids",
  "I need a barber who can come to my house", "I want my nails done this Saturday", "I need a bridal makeup artist and hair stylist",
  "I need a relaxing massage after a stressful week", "I need dreadlocks maintenance and a retwist"]),
"it_support": (
 ["fix my laptop", "set up my home wifi", "remove a virus from my computer", "recover deleted files", "build a website for my business",
  "install software on my pc", "fix my phone screen", "set up a small office network", "reinstall windows", "set up CCTV cameras and an app",
  "fix my printer", "upgrade my laptop memory", "set up an email for my company", "back up my data"],
 ["My computer is very slow and keeps freezing", "My laptop screen is cracked", "My wifi keeps dropping all day", "I think my laptop has a virus because pop ups keep appearing",
  "I need a website for my new business", "My phone fell in water and will not switch on", "I need an IT technician for my small company",
  "My laptop will not start and shows a blue screen"]),
"photography": (
 ["photograph my wedding", "take photos at my birthday party", "do a family photoshoot", "shoot a corporate event", "take professional headshots",
  "film my wedding video", "photograph my product range", "take graduation photos", "do a maternity photoshoot", "shoot a music video",
  "take real estate photos", "film a church event", "do a drone shoot", "photograph a baby shower"],
 ["I am getting married in December and need a photographer", "I need professional photos for my business website", "I want a videographer for my brother's graduation",
  "We need someone to take photos at our company year end function", "I want a family portrait session at the beach",
  "I need product photos for my online store", "I need a photographer and a videographer for a traditional wedding", "I want newborn pictures of my baby"]),
"security": (
 ["install an alarm system", "install CCTV cameras", "guard my building at night", "install an electric fence", "provide security for an event",
  "install a gate motor and intercom", "patrol my complex", "install burglar bars", "do a security assessment of my house", "install a panic button and armed response",
  "provide a bodyguard", "fit a safe", "set up access control for my office", "install razor wire on my wall"],
 ["My house was broken into and I want better security", "I need a security guard for my shop", "My neighbourhood has a lot of crime and I want an alarm and armed response",
  "I want cameras so I can watch my house from my phone", "My gate motor stopped working and the gate will not close", "We need event security for a concert",
  "I need burglar proofing for all my windows", "I am looking for a night watchman for my construction site"]),
"catering": (
 ["cater for my wedding", "cater a birthday party for fifty people", "provide food for a funeral", "bake a wedding cake", "supply finger food for a corporate function",
  "do a braai buffet", "make a birthday cake", "provide a private chef for a dinner", "cater lunch for my office every day", "prepare food for a baby shower",
  "supply snacks and drinks for an event", "cook traditional food for a ceremony", "do a three course dinner at my house", "make cupcakes for a party"],
 ["I am hosting a party for sixty guests and need catering", "I need a caterer for a traditional wedding", "I want someone to bake and decorate a birthday cake",
  "We need lunch served at our staff meeting", "I need a chef to cook a special dinner for my anniversary", "I want a food truck at my event",
  "I need waiters and food for my engagement party", "Looking for a catering company for a year end function"]),
}

TASK_TEMPLATES = [
 "I need someone to {t}", "Looking for a professional to {t}", "Can anyone {t}?", "Who can {t}?", "Please help me find someone to {t}",
 "I want to hire someone to {t}", "I am looking for a reliable person to {t}", "Need a quote to {t}", "Recommend a service provider to {t}",
 "Is there anyone available to {t}?", "I need help to {t}", "Searching for an expert who can {t}", "Hi, can you find me someone to {t}",
 "Urgently need a person to {t}",
]
# some tasks are phrased with an object, so also allow noun style:
PLACES = ["Johannesburg","Pretoria","Cape Town","Durban","Soweto","Sandton","Centurion","Randburg","Midrand","Bloemfontein","Polokwane",
          "Pietermaritzburg","Port Elizabeth","Gqeberha","East London","Stellenbosch","Mamelodi","Tembisa","Roodepoort","Benoni","Boksburg",
          "Umhlanga","Nelspruit","Kimberley","Potchefstroom","Rustenburg","Mthatha","Soshanguve","Alberton","Krugersdorp"]
PREFIX = ["", "", "", "", "Hi, ", "Hello, ", "Please help. ", "Good day, ", "Hey, ", "Good morning, "]
SUFFIX = ["", "", "", "", " asap", " urgently", " this weekend", " tomorrow", " as soon as possible", " on a small budget",
          " please", " thank you", " within this week", " and I can pay cash", " - price negotiable"]
LOC_TEMPLATES = [" in {p}", " around {p}", " near {p}", " - I am in {p}", " (location: {p})", ", {p}"]

OTHER = [
 "what is the weather like today", "tell me a joke", "who won the soccer match last night", "how do I reset my password", "hello how are you",
 "I want to buy a laptop", "what is the capital of France", "I need a loan of fifty thousand rand", "how do I delete my account", "what time does the bank close",
 "can you recommend a good movie", "I am bored", "testing testing one two three", "how much is the dollar today", "write me a poem about love",
 "what is the meaning of life", "I want to invest in bitcoin", "how do I apply for a passport", "my cat is sick and needs a vet", "I need a lawyer for my divorce",
 "I am looking for a job as an accountant", "how do I lose weight fast", "sell my old phone", "where can I watch the news", "I need medical advice for my headache",
 "just checking how this website works", "how do i contact support", "what is your name", "I want to learn how this app works", "is this free to use",
 "I need a taxi to the airport", "book me a flight to Durban", "I want to open a bank account", "lol this is funny", "need a doctor now", "how do I change my profile picture", "what is the price of bread", "can you help me with my taxes", "where do I see my notifications", "I need a nurse for my grandmother", "how do I update my email address", "I want to buy a house", "help me write a cv", "what is the latest news",
]
GIBBERISH_WORDS = ["asdf","qwer","zxcv","lorem","ipsum","hjkl","blah","random","words","nothing","xyz","abc","test"]

KEYBOARD_NEIGHBOURS = {"a":"qs","e":"wr","i":"uo","o":"ip","u":"yi","s":"ad","t":"ry","n":"bm","r":"et","l":"k","m":"n","c":"v","p":"o","h":"gj","d":"sf"}

def add_typo(s):
    if len(s) < 8: return s
    i = random.randrange(1, len(s) - 1)
    kind = random.choice(["drop", "swap", "dup", "neighbour"])
    if s[i] == " " or s[i+1] == " ":
        return s
    if kind == "drop": return s[:i] + s[i+1:]
    if kind == "swap": return s[:i] + s[i+1] + s[i] + s[i+2:]
    if kind == "dup": return s[:i] + s[i] + s[i:]
    c = s[i].lower()
    return s[:i] + random.choice(KEYBOARD_NEIGHBOURS.get(c, c)) + s[i+1:]

ROOMS = [" in my kitchen", " in the bathroom", " in my bedroom", " in the lounge", " in my garage", " at my house", " at my flat",
         " at my office", " at home", " at my shop", " for my family", " for my business", " at our complex"]

def decorate(core):
    s = core
    # room/place words must appear in EVERY category so the model does not use them as clues
    if random.random() < 0.35:
        s += random.choice(ROOMS)
    if random.random() < 0.45:
        s += random.choice(LOC_TEMPLATES).format(p=random.choice(PLACES))
    s = random.choice(PREFIX) + s + random.choice(SUFFIX)
    if random.random() < 0.20: s = s.lower()
    if random.random() < 0.18: s = add_typo(s)
    return s.strip()


# Second data source: professions and everyday nouns people actually type.
# label -> (professions, things)
KEYWORDS = {
"plumbing": (["plumber","plumbing company","drain specialist","geyser installer","emergency plumber","pipe fitter"],
             ["tap","taps","pipes","drain","toilet","geyser","shower","sink","basin","bathroom plumbing","water meter","mixer","sewer","water leak","cistern"]),
"electrical": (["electrician","electrical contractor","certified electrician","wireman","solar installer"],
             ["plugs","sockets","wiring","light switch","db board","circuit breaker","power supply","lights","electricity","fuse box","generator","solar panels","inverter"]),
"cleaning": (["cleaner","maid","domestic worker","cleaning company","cleaning lady","janitor","carpet cleaner","housekeeper"],
             ["house","carpets","windows","couches","office space","kitchen","apartment","bathroom","mattress","floors","rental unit"]),
"gardening": (["gardener","landscaper","garden service","tree feller","lawn care expert","groundsman"],
             ["lawn","garden","hedge","trees","grass","flower beds","yard","palm tree","sprinklers","plants","weeds","turf"]),
"painting": (["painter","painting contractor","house painter","decorator","plasterer"],
             ["walls","ceiling","roof paint","house colour","fence paint","exterior walls","bedroom walls","damp walls","paintwork","plaster"]),
"carpentry": (["carpenter","joiner","woodworker","cabinet maker","handyman who works with wood","furniture maker"],
             ["cupboards","wardrobe","table","wooden door","shelves","deck","window frames","staircase","timber","bookshelf","kitchen units","wooden floor"]),
"tutoring": (["tutor","maths teacher","private teacher","lesson teacher","coach for my exams","homework helper","online tutor"],
             ["maths","physics","accounting","english","matric exams","homework","grade 9 science","university course","statistics","reading skills","programming course","exam preparation"]),
"moving": (["removal company","mover","furniture removals","man with a van","courier with a bakkie","truck driver","packer"],
             ["furniture","boxes","belongings","fridge delivery","new house move","office relocation","bed and couch","household goods","big items"]),
"appliance_repair": (["appliance technician","fridge repairman","aircon technician","washing machine repairman","electronics repair shop","TV technician"],
             ["washing machine","fridge","freezer","dishwasher","microwave","oven","tumble dryer","aircon","television","kettle","heater","stove","geyser element"]),
"car_mechanic": (["mechanic","auto electrician","panel beater","mobile mechanic","car service centre","tyre fitter","motor mechanic"],
             ["car","bakkie","engine","brakes","gearbox","clutch","tyres","car battery","exhaust","suspension","vehicle","radiator","windscreen"]),
"hair_beauty": (["hairdresser","hair stylist","makeup artist","barber","nail technician","beautician","braider","massage therapist"],
             ["hair","braids","nails","makeup","wig","lashes","haircut","pedicure","facial","dreadlocks","weave","bridal hair"]),
"it_support": (["IT technician","computer repair guy","web developer","software developer","network technician","phone repair shop","app developer"],
             ["laptop","computer","wifi","router","website","phone screen","printer","email setup","software","data backup","online store","mobile app","network"]),
"photography": (["photographer","videographer","wedding photographer","cameraman","drone pilot","event photographer"],
             ["wedding photos","family portraits","event coverage","product pictures","headshots","video shoot","engagement shoot","graduation pictures","photo session"]),
"security": (["security guard","security company","alarm installer","CCTV installer","armed response company","bouncer","gate motor technician"],
             ["alarm","cameras","electric fence","burglar bars","gate motor","intercom","armed response","access control","night guard","panic button"]),
"catering": (["caterer","catering company","chef","baker","cake maker","food vendor","event cook","waiters"],
             ["wedding food","party food","birthday cake","buffet","funeral catering","lunch for staff","finger foods","cupcakes","traditional food","braai meat","canapes"]),
}
PRO_T = ["I need a {p}", "Looking for a {p}", "Any good {p} around?", "Where can I find a {p}?", "{p} needed", "Need a {p} urgently",
         "Can someone recommend a {p}?", "Anyone know a reliable {p}?", "Searching for a {p}", "Please find me a {p}"]
THING_T = ["My {n} is broken", "Problem with my {n}", "{n} problem", "Something is wrong with my {n}", "Need help with {n}",
           "My {n} is not working", "I need someone to look at my {n}", "Who can sort out my {n}?", "Need quotes for {n}", "Help with {n} please"]

PER_CLASS = 260
rows = []
for label, (tasks, statements) in DATA.items():
    seen = set()
    tries = 0
    while len(seen) < PER_CLASS and tries < 20000:
        tries += 1
        if random.random() < 0.55:
            core = random.choice(TASK_TEMPLATES).format(t=random.choice(tasks))
        else:
            core = random.choice(statements)
        s = decorate(core)
        seen.add(s)
    rows += [(s, label) for s in sorted(seen)]


# keyword rows (professions + everyday nouns)
for label, (pros, things) in KEYWORDS.items():
    seen = set()
    tries = 0
    while len(seen) < 120 and tries < 5000:
        tries += 1
        if random.random() < 0.5:
            core = random.choice(PRO_T).format(p=random.choice(pros))
        else:
            core = random.choice(THING_T).format(n=random.choice(things))
        seen.add(decorate(core))
    rows += [(s, label) for s in sorted(seen)]

# "other" class: off-topic text, so the system can say "no match"
seen = set()
tries = 0
while len(seen) < PER_CLASS and tries < 20000:
    tries += 1
    if random.random() < 0.8:
        core = random.choice(OTHER)
    else:
        core = " ".join(random.choice(GIBBERISH_WORDS) for _ in range(random.randint(2, 5)))
    seen.add(decorate(core))
rows += [(s, "other") for s in sorted(seen)]

# Our own sentences (optional file)
mine = 0
if os.path.exists("my_examples.csv"):
    with open("my_examples.csv", newline="", encoding="utf-8") as f:
        for r in csv.DictReader(f):
            if r["text"].strip() and r["label"].strip():
                for _ in range(3):
                    rows.append((r["text"].strip(), r["label"].strip()))
                mine += 1

random.shuffle(rows)
with open("dataset.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f); w.writerow(["text", "label"]); w.writerows(rows)
print(f"Wrote dataset.csv with {len(rows)} rows ({mine} of your own sentences from my_examples.csv)")
