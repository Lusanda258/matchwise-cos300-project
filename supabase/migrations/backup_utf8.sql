--
-- PostgreSQL database dump
--

\restrict m63zohCVG30B9W0LFFzPDd5C6cJRHRLjjueoHCo5yiOTVKPGgKxTt6ODGgJ7F34

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone',
    'recovery_code'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: app_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.app_role AS ENUM (
    'client',
    'provider',
    'admin'
);


ALTER TYPE public.app_role OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_realtime_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in',
    'like',
    'ilike',
    'is',
    'match',
    'imatch',
    'isdistinct'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_realtime_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text,
	negate boolean
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_realtime_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_realtime_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_realtime_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
    revoke trigger on cron.job_run_details from postgres;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
begin
    if not exists (
        select 1
        from pg_catalog.pg_event_trigger_ddl_commands() ev
        join pg_catalog.pg_extension e on ev.objid = e.oid
        where e.extname = 'pg_graphql'
    ) then
        return;
    end if;

    drop function if exists graphql_public.graphql;
    create or replace function graphql_public.graphql(
        "operationName" text default null,
        query text default null,
        variables jsonb default null,
        extensions jsonb default null
    )
        returns jsonb
        language sql
    as $$
        select graphql.resolve(
            query := query,
            variables := coalesce(variables, '{}'),
            "operationName" := "operationName",
            extensions := extensions
        );
    $$;

    -- Attach the wrapper to the extension so DROP EXTENSION cascades to it,
    -- which in turn triggers set_graphql_placeholder to reinstall the "not enabled" stub.
    alter extension pg_graphql add function graphql_public.graphql(text, text, jsonb, jsonb);

    grant usage on schema graphql to postgres, anon, authenticated, service_role;
    grant execute on function graphql.resolve to postgres, anon, authenticated, service_role;
    grant usage on schema graphql to postgres with grant option;
    grant usage on schema graphql_public to postgres with grant option;
end;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8.0', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
            set search_path to ''
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: clear_all_notifications(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.clear_all_notifications() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  deleted_count INTEGER;

BEGIN

  DELETE FROM public.notifications 

  WHERE user_id = auth.uid();

  GET DIAGNOSTICS deleted_count = ROW_COUNT;

  RETURN deleted_count;

END;

$$;


ALTER FUNCTION public.clear_all_notifications() OWNER TO postgres;

--
-- Name: create_match_notification(uuid, text, text, text, jsonb, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_match_notification(p_match_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb DEFAULT '{}'::jsonb, p_sender_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  v_request_id UUID;

  v_provider_id UUID;

  v_client_id UUID;

  v_provider_user_id UUID;

  v_recipient_id UUID;

  v_notification_id UUID;

BEGIN

  -- Get the match details

  SELECT request_id, provider_id INTO v_request_id, v_provider_id

  FROM public.matches

  WHERE id = p_match_id;

  

  IF NOT FOUND THEN

    RAISE EXCEPTION 'Match not found';

  END IF;

  

  -- Get the client_id from service_requests

  SELECT client_id INTO v_client_id

  FROM public.service_requests

  WHERE id = v_request_id;

  

  IF NOT FOUND THEN

    RAISE EXCEPTION 'Service request not found';

  END IF;

  

  -- Get the provider's user_id

  SELECT user_id INTO v_provider_user_id

  FROM public.service_providers

  WHERE id = v_provider_id;

  

  IF NOT FOUND THEN

    RAISE EXCEPTION 'Provider not found';

  END IF;

  

  -- Determine recipient: notify the person who is NOT the sender

  -- If sender is client, notify provider. If sender is provider, notify client.

  -- If no sender specified, use the old logic based on title.

  IF p_sender_id IS NOT NULL THEN

    IF p_sender_id = v_client_id THEN

      v_recipient_id := v_provider_user_id;

      RAISE NOTICE 'Sender is client, notifying provider: %', v_provider_user_id;

    ELSE

      v_recipient_id := v_client_id;

      RAISE NOTICE 'Sender is provider, notifying client: %', v_client_id;

    END IF;

  ELSE

    -- Fallback to title-based logic for backward compatibility

    IF p_title = 'New Service Request' THEN

      v_recipient_id := v_provider_user_id;

      RAISE NOTICE 'No sender, using title-based logic: notifying provider';

    ELSE

      v_recipient_id := v_client_id;

      RAISE NOTICE 'No sender, using title-based logic: notifying client';

    END IF;

  END IF;

  

  -- Create the notification

  INSERT INTO public.notifications (user_id, type, title, message, metadata)

  VALUES (v_recipient_id, p_type, p_title, p_message, p_metadata)

  RETURNING id INTO v_notification_id;

  

  RETURN v_notification_id;

END;

$$;


ALTER FUNCTION public.create_match_notification(p_match_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb, p_sender_id uuid) OWNER TO postgres;

--
-- Name: create_notification(uuid, text, text, text, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_notification(p_user_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb DEFAULT '{}'::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  new_notification_id UUID;

BEGIN

  INSERT INTO public.notifications (user_id, type, title, message, metadata)

  VALUES (p_user_id, p_type, p_title, p_message, p_metadata)

  RETURNING id INTO new_notification_id;

  RETURN new_notification_id;

END;

$$;


ALTER FUNCTION public.create_notification(p_user_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb) OWNER TO postgres;

--
-- Name: delete_notification(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_notification(notification_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

BEGIN

  DELETE FROM public.notifications 

  WHERE id = notification_id AND user_id = auth.uid();

  RETURN FOUND;

END;

$$;


ALTER FUNCTION public.delete_notification(notification_id uuid) OWNER TO postgres;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$

declare

  selected_role public.app_role;

begin

  insert into public.profiles (id, full_name, email)

  values (

    new.id,

    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email,'@',1)),

    new.email

  );



  selected_role := coalesce((new.raw_user_meta_data->>'role')::public.app_role, 'client');



  if selected_role = 'admin' then

    selected_role := 'client';

  end if;



  insert into public.user_roles (user_id, role)

  values (new.id, selected_role);



  return new;

end;

$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: has_role(uuid, public.app_role); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.has_role(_user_id uuid, _role public.app_role) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$

  select exists (

    select 1 from public.user_roles

    where user_id = _user_id and role = _role

  )

$$;


ALTER FUNCTION public.has_role(_user_id uuid, _role public.app_role) OWNER TO postgres;

--
-- Name: log_notification_email(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_notification_email() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  v_user_email TEXT;

BEGIN

  -- Get user email from auth.users

  SELECT email INTO v_user_email

  FROM auth.users

  WHERE id = NEW.user_id;

  

  -- Insert into email queue with email

  INSERT INTO public.email_queue (user_id, email, notification_id, title, message, status)

  VALUES (

    NEW.user_id, 

    v_user_email, 

    NEW.id, 

    NEW.title, 

    NEW.message, 

    'pending'

  );

  

  RAISE NOTICE 'Email queued for notification % (email: %)', NEW.id, v_user_email;

  

  RETURN NEW;

EXCEPTION

  WHEN OTHERS THEN

    RAISE WARNING 'Trigger error for notification %: %', NEW.id, SQLERRM;

    RETURN NEW;

END;

$$;


ALTER FUNCTION public.log_notification_email() OWNER TO postgres;

--
-- Name: mark_all_notifications_as_read(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mark_all_notifications_as_read() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  updated_count INTEGER;

BEGIN

  UPDATE public.notifications 

  SET read = TRUE 

  WHERE user_id = auth.uid() AND read = FALSE;

  GET DIAGNOSTICS updated_count = ROW_COUNT;

  RETURN updated_count;

END;

$$;


ALTER FUNCTION public.mark_all_notifications_as_read() OWNER TO postgres;

--
-- Name: mark_notification_as_read(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mark_notification_as_read(notification_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

BEGIN

  UPDATE public.notifications 

  SET read = TRUE 

  WHERE id = notification_id AND user_id = auth.uid();

  RETURN FOUND;

END;

$$;


ALTER FUNCTION public.mark_notification_as_read(notification_id uuid) OWNER TO postgres;

--
-- Name: recalc_provider_rating(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recalc_provider_rating() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$

begin

  update public.service_providers sp

  set avg_rating = coalesce(

        (select avg(rating)::numeric(3,2) from public.ratings where provider_id = sp.id), 0

      ),

      rating_count = (

        select count(*) from public.ratings where provider_id = sp.id

      )

  where sp.id = coalesce(new.provider_id, old.provider_id);



  return null;

end;

$$;


ALTER FUNCTION public.recalc_provider_rating() OWNER TO postgres;

--
-- Name: request_provider_with_notification(uuid, text, uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.request_provider_with_notification(p_match_id uuid, p_message text, p_client_user_id uuid, p_preferred_date text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  v_provider_user_id UUID;

  v_provider_id UUID;

  v_notification_id UUID;

BEGIN

  -- Verify the match exists and belongs to the client

  IF NOT EXISTS (

    SELECT 1 FROM public.matches m

    JOIN public.service_requests sr ON m.request_id = sr.id

    WHERE m.id = p_match_id AND sr.client_id = p_client_user_id

  ) THEN

    RETURN jsonb_build_object('success', false, 'error', 'Match not found or unauthorized');

  END IF;

  

  -- Update the match status

  UPDATE public.matches

  SET 

    inquiry_status = 'requested',

    inquiry_message = p_message,

    inquiry_preferred_date = p_preferred_date,

    inquiry_requested_at = NOW()

  WHERE id = p_match_id;

  

  -- Get provider user_id

  SELECT provider_id INTO v_provider_id

  FROM public.matches

  WHERE id = p_match_id;

  

  -- Get the actual user_id from service_providers

  SELECT user_id INTO v_provider_user_id

  FROM public.service_providers

  WHERE id = v_provider_id;

  

  -- Create notification for provider

  INSERT INTO public.notifications (user_id, type, title, message, metadata)

  VALUES (

    v_provider_user_id,

    'info',

    'New Service Request',

    'You have received a new service request. Check your dashboard to respond.',

    jsonb_build_object('match_id', p_match_id)

  )

  RETURNING id INTO v_notification_id;

  

  RETURN jsonb_build_object('success', true);

END;

$$;


ALTER FUNCTION public.request_provider_with_notification(p_match_id uuid, p_message text, p_client_user_id uuid, p_preferred_date text) OWNER TO postgres;

--
-- Name: reset_verification_on_profile_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reset_verification_on_profile_update() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$

begin

  if (

    old.business_name is distinct from new.business_name or

    old.category is distinct from new.category or

    old.bio is distinct from new.bio or

    old.hourly_rate is distinct from new.hourly_rate or

    old.location is distinct from new.location or

    old.service_radius_km is distinct from new.service_radius_km or

    old.status is distinct from new.status

  ) then

    new.verification_status := 'pending';

  end if;

  return new;

end;

$$;


ALTER FUNCTION public.reset_verification_on_profile_update() OWNER TO postgres;

--
-- Name: respond_to_inquiry_with_notification(uuid, text, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.respond_to_inquiry_with_notification(p_match_id uuid, p_action text, p_provider_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  v_client_id UUID;

  v_provider_business_name TEXT;

  v_provider_id UUID;

  v_notification_id UUID;

BEGIN

  -- Update the match status

  UPDATE public.matches

  SET inquiry_status = p_action

  WHERE id = p_match_id;

  

  -- If accepted, create notification for client

  IF p_action = 'accepted' THEN

    -- Get match details

    SELECT request_id, provider_id INTO v_client_id, v_provider_id

    FROM public.matches

    WHERE id = p_match_id;

    

    -- Get provider business name

    SELECT business_name INTO v_provider_business_name

    FROM public.service_providers

    WHERE id = v_provider_id;

    

    -- Get client_id from service_requests

    SELECT client_id INTO v_client_id

    FROM public.service_requests

    WHERE id = v_client_id;

    

    -- Create notification

    INSERT INTO public.notifications (user_id, type, title, message, metadata)

    VALUES (

      v_client_id,

      'success',

      'Request Accepted!',

      v_provider_business_name || ' has accepted your service request. You can now start chatting.',

      jsonb_build_object('match_id', p_match_id, 'provider_id', v_provider_id)

    )

    RETURNING id INTO v_notification_id;

  END IF;

  

  RETURN jsonb_build_object('success', true, 'status', p_action);

END;

$$;


ALTER FUNCTION public.respond_to_inquiry_with_notification(p_match_id uuid, p_action text, p_provider_user_id uuid) OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

  NEW.updated_at = NOW();

  RETURN NEW;

END;

$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
    -- Regclass of the table e.g. public.notes
    entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

    -- I, U, D, T: insert, update ...
    action realtime.action = (
        case wal ->> 'action'
            when 'I' then 'INSERT'
            when 'U' then 'UPDATE'
            when 'D' then 'DELETE'
            else 'ERROR'
        end
    );

    -- Is row level security enabled for the table
    is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

    subscriptions realtime.subscription[] = array_agg(subs)
        from
            realtime.subscription subs
        where
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
    claimed_role regrole;
    claims jsonb;

    subscription_id uuid;
    subscription_has_access bool;
    visible_to_subscription_ids uuid[] = '{}';

    -- structured info for wal's columns
    columns realtime.wal_column[];
    -- previous identity values for update/delete
    old_columns realtime.wal_column[];

    error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

    -- Primary jsonb output for record
    output jsonb;

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

begin
    perform set_config('role', null, true);

    columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'columns') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    old_columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'identity') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
        columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(columns) c;

        old_columns =
                array_agg(
                    (
                        c.name,
                        c.type_name,
                        c.type_oid,
                        c.value,
                        c.is_pkey,
                        pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                    )::realtime.wal_column
                )
                from
                    unnest(old_columns) c;

        if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

            for subscription_id, claims in (
                    select
                        subs.subscription_id,
                        subs.claims
                    from
                        unnest(subscriptions) subs
                    where
                        subs.entity = entity_
                        and subs.claims_role = working_role
                        and (
                            realtime.is_visible_through_filters(columns, subs.filters)
                            or (
                              action = 'DELETE'
                              and realtime.is_visible_through_filters(old_columns, subs.filters)
                            )
                        )
            ) loop

                if not is_rls_enabled or action = 'DELETE' then
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    -- Reset the role on every FOR..LOOP batch execution.
                    -- The first batch of 10 rows is pre-fetched using the current connection role (PG internal behaviour)
                    -- then we have to reset it again otherwise it would use the role defined in the `set_config` above
                    -- to fetch the remaining rows when rows>10, which could be a user-defined role that lacks execution grants.
                    -- The flow is:
                    --   1. run batch with conn role
                    --   2. set_config working_role
                    --   3. execute walrus
                    --   4. reset role (revert)
                    --   5. repeat
                    perform set_config('role', null, true);

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

                output = jsonb_build_object(
                    'schema', wal ->> 'schema',
                    'table', wal ->> 'table',
                    'type', action,
                    'commit_timestamp', to_char(
                        ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                        'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
                    ),
                    'columns', (
                        select
                            jsonb_agg(
                                jsonb_build_object(
                                    'name', pa.attname,
                                    'type', pt.typname
                                )
                                order by pa.attnum asc
                            )
                        from
                            pg_attribute pa
                            join pg_type pt
                                on pa.atttypid = pt.oid
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
                    )
                )
                -- Add "record" key for insert and update
                || case
                    when action in ('INSERT', 'UPDATE') then
                        jsonb_build_object(
                            'record',
                            (
                                select
                                    jsonb_object_agg(
                                        -- if unchanged toast, get column name and value from old record
                                        coalesce((c).name, (oc).name),
                                        case
                                            when (c).name is null then (oc).value
                                            else (c).value
                                        end
                                    )
                                from
                                    unnest(columns) c
                                    full outer join unnest(old_columns) oc
                                        on (c).name = (oc).name
                                where
                                    coalesce((c).is_selectable, (oc).is_selectable)
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            )
                        )
                    else '{}'::jsonb
                end
                -- Add "old_record" key for update and delete
                || case
                    when action = 'UPDATE' then
                        jsonb_build_object(
                                'old_record',
                                (
                                    select jsonb_object_agg((c).name, (c).value)
                                    from unnest(old_columns) c
                                    where
                                        (c).is_selectable
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                        and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                )
                            )
                    when action = 'DELETE' then
                        jsonb_build_object(
                            'old_record',
                            (
                                select jsonb_object_agg((c).name, (c).value)
                                from unnest(old_columns) c
                                where
                                    (c).is_selectable
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_realtime_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_realtime_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
/*
Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
*/
declare
    op_symbol text = (
        case
            when op = 'eq' then '='
            when op = 'neq' then '!='
            when op = 'lt' then '<'
            when op = 'lte' then '<='
            when op = 'gt' then '>'
            when op = 'gte' then '>='
            when op = 'in' then '= any'
            else 'UNKNOWN OP'
        end
    );
    res boolean;
begin
    execute format(
        'select %L::'|| type_::text || ' ' || op_symbol
        || ' ( %L::'
        || (
            case
                when op = 'in' then type_::text || '[]'
                else type_::text end
        )
        || ')', val_1, val_2) into res;
    return res;
end;
$$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
declare
    op_symbol text;
    res boolean;
begin
    -- IS DISTINCT FROM / IS NOT DISTINCT FROM: infix, both sides typed literals
    if op = 'isdistinct' then
        execute format(
            'select %L::%s %s %L::%s',
            val_1,
            type_::text,
            case when negate then 'IS NOT DISTINCT FROM' else 'IS DISTINCT FROM' end,
            val_2,
            type_::text
        ) into res;
        return res;
    end if;

    -- IS requires a keyword RHS (NULL, TRUE, FALSE, UNKNOWN), not a typed literal
    if op = 'is' then
        if val_2 not in ('null', 'true', 'false', 'unknown') then
            raise exception 'invalid value for is filter: must be null, true, false, or unknown';
        end if;
        execute format(
            'select %L::%s %s %s',
            val_1,
            type_::text,
            case when negate then 'IS NOT' else 'IS' end,
            upper(val_2)
        ) into res;
        return res;
    end if;

    op_symbol = case
        when op = 'eq'    then '='
        when op = 'neq'   then '!='
        when op = 'lt'    then '<'
        when op = 'lte'   then '<='
        when op = 'gt'    then '>'
        when op = 'gte'   then '>='
        when op = 'in'    then '= any'
        when op = 'like'   then 'LIKE'
        when op = 'ilike'  then 'ILIKE'
        when op = 'match'  then '~'
        when op = 'imatch' then '~*'
        else null
    end;

    if op_symbol is null then
        raise exception 'unsupported equality operator: %', op::text;
    end if;

    execute format(
        'select %L::%s %s (%L::%s)',
        val_1,
        type_::text,
        op_symbol,
        val_2,
        case when op = 'in' then type_::text || '[]' else type_::text end
    ) into res;

    return case when negate then not res else res end;
end;
$$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) OWNER TO supabase_realtime_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    select
        filters is null
        or array_length(filters, 1) is null
        or coalesce(
            count(col.name) = count(1)
            and sum(
                realtime.check_equality_op(
                    op:=f.op,
                    type_:=coalesce(col.type_oid::regtype, col.type_name::regtype),
                    val_1:=col.value #>> '{}',
                    val_2:=f.value,
                    negate:=coalesce(f.negate, false)
                )::int
            ) filter (where col.name is not null) = count(col.name),
            false
        )
    from
        unnest(filters) f
        left join unnest(columns) col
            on f.column_name = col.name;
$$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_realtime_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_realtime_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    col_names text[] = coalesce(
            array_agg(a.attname order by a.attnum),
            '{}'::text[]
        )
        from
            pg_catalog.pg_attribute a
        where
            a.attrelid = new.entity
            and a.attnum > 0
            and not a.attisdropped
            and pg_catalog.has_column_privilege(
                (new.claims ->> 'role'),
                a.attrelid,
                a.attnum,
                'SELECT'
            );
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
begin
    for filter in select * from unnest(new.filters) loop
        if not filter.column_name = any(col_names) then
            raise exception 'invalid column for filter %', filter.column_name;
        end if;

        col_type = (
            select atttypid::regtype
            from pg_catalog.pg_attribute
            where attrelid = new.entity
                  and attname = filter.column_name
        );
        if col_type is null then
            raise exception 'failed to lookup type for column %', filter.column_name;
        end if;

        if filter.op = 'in'::realtime.equality_op then
            in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
            if coalesce(jsonb_array_length(in_val), 0) > 100 then
                raise exception 'too many values for `in` filter. Maximum 100';
            end if;
        elsif filter.op = 'is'::realtime.equality_op then
            -- `is` requires a keyword RHS rather than a typed literal
            if filter.value not in ('null', 'true', 'false', 'unknown') then
                raise exception 'invalid value for is filter: must be null, true, false, or unknown';
            end if;
            -- IS NULL works for any type, but IS TRUE/FALSE/UNKNOWN require a boolean
            -- operand. Reject the non-null keywords on non-boolean columns here so they
            -- don't abort apply_rls at WAL time.
            if filter.value <> 'null' and col_type <> 'boolean'::regtype then
                raise exception 'is % filter requires a boolean column, got %', filter.value, col_type::text;
            end if;
        elsif filter.op in ('like'::realtime.equality_op, 'ilike'::realtime.equality_op) then
            -- like/ilike apply the text pattern operator (~~); reject column types that
            -- have no such operator instead of failing at WAL time
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = '~~' and oprleft = col_type
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
        elsif filter.op in ('match'::realtime.equality_op, 'imatch'::realtime.equality_op) then
            -- match/imatch apply the regex operators ~ / ~*; reject column types that have
            -- no such operator (e.g. integer) instead of failing at WAL time, mirroring the
            -- like/ilike guard above.
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = case when filter.op = 'imatch'::realtime.equality_op then '~*' else '~' end
                  and oprleft = col_type
                  and oprright = col_type
                  and oprresult = 'boolean'::regtype
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
            -- validate the regex eagerly so a bad pattern is rejected here, not inside
            -- apply_rls where it would abort the WAL stream for the entity
            begin
                perform '' ~ filter.value;
            exception when others then
                raise exception 'invalid regular expression for % filter: %', filter.op::text, sqlerrm;
            end;
        else
            -- eq/neq/lt/lte/gt/gte: value must be coercable to the type
            perform realtime.cast(filter.value, col_type);
        end if;
    end loop;

    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    -- Apply consistent order to filters so the unique constraint can't be tricked by a
    -- different filter order. negate is part of the sort key.
    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value, f.negate),
        '{}'
    ) from unnest(new.filters) f;

    -- Normalize selected_columns order so ARRAY['a','b'] and ARRAY['b','a'] are treated
    -- as the same subscription group in apply_rls. Preserve an empty array as '{}'
    -- ("primary keys only") so it stays distinct from NULL ("all columns"); array_agg
    -- over an empty set would otherwise collapse '{}' back to NULL.
    if new.selected_columns is not null then
        new.selected_columns = coalesce(
            (
                select array_agg(c order by c)
                from unnest(new.selected_columns) c
            ),
            '{}'::text[]
        );
    end if;

    return new;
end;
$$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_realtime_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_realtime_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


ALTER FUNCTION realtime.wal2json_escape_identifier(name text) OWNER TO supabase_realtime_admin;

--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_lifecycle_service_role(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_lifecycle_service_role() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
BEGIN
  IF current_user::text IS DISTINCT FROM TG_ARGV[0]
     AND (
       OLD.lifecycle_configuration IS DISTINCT FROM NEW.lifecycle_configuration
       OR OLD.lifecycle_configuration_generation IS DISTINCT FROM NEW.lifecycle_configuration_generation
     ) THEN
    -- AFTER runs only after caller RLS has accepted the proposed row. The API
    -- recognizes this specific error after rolling back its permission probe;
    -- direct non-service writes still fail and cannot persist the change.
    RAISE EXCEPTION 'bucket control columns may only be changed by the configured storage service role'
      USING ERRCODE = 'PST01',
            SCHEMA = TG_TABLE_SCHEMA,
            TABLE = TG_TABLE_NAME,
            CONSTRAINT = TG_NAME;
  END IF;

  RETURN NULL;
END;
$$;


ALTER FUNCTION storage.enforce_bucket_lifecycle_service_role() OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    RETURN _parts[array_length(_parts, 1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN p_delimiter <> ''
         AND position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(
        p_key,
        length(p_prefix)
            + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1))
            + length(p_delimiter) - 1
    )
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket(noncurrent_versions text DEFAULT 'include'::text, delete_markers text DEFAULT 'include'::text) RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'include');
    delete_markers := COALESCE(delete_markers, 'include');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'include';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'include';
    END IF;

    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        where (noncurrent_versions != 'exclude' OR obj.archived_at IS NULL)
          and (noncurrent_versions != 'only' OR obj.archived_at IS NOT NULL)
          and (delete_markers != 'exclude' OR NOT obj.is_delete_marker)
          and (delete_markers != 'only' OR obj.is_delete_marker)
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket(noncurrent_versions text, delete_markers text) OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text, raw_prefix_param text DEFAULT NULL::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE sql STABLE
    AS $_$
WITH candidates AS (
    SELECT
        upload.key AS object_key,
        CASE
            WHEN position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1)) > 0
            THEN left(
                upload.key,
                length(coalesce($7, $2))
                    + position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1))
                    + length($3) - 1
            )
            ELSE upload.key
        END AS result_key,
        upload.id,
        upload.created_at,
        position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1)) > 0 AS is_common_prefix
    FROM storage.s3_multipart_uploads AS upload
    WHERE upload.bucket_id = $1
      AND upload.key COLLATE "C" LIKE $2 || '%'
), filtered AS (
    SELECT candidate.*
    FROM candidates AS candidate
    WHERE $5 = ''
       OR candidate.result_key COLLATE "C" > $5
       OR (
           candidate.result_key COLLATE "C" = $5
           AND NOT candidate.is_common_prefix
           AND $6 <> ''
           -- A completed or aborted marker repeats the remaining same-key uploads.
           AND COALESCE(
               (candidate.created_at, candidate.id COLLATE "C") > (
                   SELECT marker.created_at, marker.id COLLATE "C"
                   FROM storage.s3_multipart_uploads AS marker
                   WHERE marker.bucket_id = $1
                     AND marker.key COLLATE "C" = $5
                     AND marker.id = $6
               ),
               TRUE
           )
       )
), ranked AS (
    SELECT
        filtered.*,
        row_number() OVER (
            PARTITION BY filtered.result_key COLLATE "C"
            ORDER BY filtered.created_at, filtered.id COLLATE "C"
        ) AS prefix_rank
    FROM filtered
)
SELECT ranked.result_key, ranked.id, ranked.created_at
FROM ranked
WHERE NOT ranked.is_common_prefix OR ranked.prefix_rank = 1
ORDER BY ranked.result_key COLLATE "C", ranked.created_at, ranked.id COLLATE "C"
LIMIT $4;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text, raw_prefix_param text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text, text, text, timestamp with time zone, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, next_token_archived_at timestamp with time zone DEFAULT NULL::timestamp with time zone, next_token_version text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_start_relative TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;
    v_version_filter TEXT;

    -- true when noncurrent_versions can return >1 row per name; keeps them
    -- ordered most-recent-first and lets pagination resume mid-key
    v_multi_row BOOLEAN;
    v_name_order TEXT;
    v_exact_range_predicate TEXT;
    v_strict_range_predicate TEXT;
    v_inclusive_range_predicate TEXT;

    -- Seek state for the current name. archived_at is normalized to JavaScript's
    -- millisecond precision and version breaks ties within the same millisecond.
    -- Current rows use 'infinity'; NULL means no tiebreak has been established.
    v_next_seek TEXT;
    v_next_seek_at TIMESTAMPTZ;
    v_next_seek_version TEXT;
    v_next_seek_strict BOOLEAN := false;
    v_cursor_is_folder BOOLEAN;
    v_count INT := 0;
    v_previous_seek TEXT;
    v_previous_seek_at TIMESTAMPTZ;
    v_previous_seek_version TEXT;
    v_previous_count INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;
    v_batch_query_strict TEXT;
    v_delete_marker_peek_query TEXT;
    v_delete_marker_peek_query_strict TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);
    v_next_seek_at := NULL;
    v_next_seek_version := '';

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    v_multi_row := noncurrent_versions IN ('only', 'include');
    v_name_order := CASE WHEN v_is_asc THEN 'ASC' ELSE 'DESC' END;

    v_version_filter := '';
    IF noncurrent_versions = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NULL';
    ELSIF noncurrent_versions = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NOT NULL';
    END IF;
    IF delete_markers = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND NOT o.is_delete_marker';
    ELSIF delete_markers = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.is_delete_marker';
    END IF;

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Keep caller-provided cursors inside the requested prefix range.
    IF v_start <> '' AND v_upper_bound IS NOT NULL THEN
        IF v_is_asc THEN
            IF v_start COLLATE "C" < v_prefix COLLATE "C" THEN
                v_start := '';
            ELSIF v_start COLLATE "C" >= v_upper_bound COLLATE "C" THEN
                RETURN;
            END IF;
        ELSE
            IF v_start COLLATE "C" < v_prefix COLLATE "C" THEN
                RETURN;
            ELSIF v_start COLLATE "C" >= v_upper_bound COLLATE "C" THEN
                v_start := '';
            END IF;
        END IF;
    END IF;

    v_start_relative := substring(v_start FROM length(v_prefix) + 1);

    -- Direction affects only the indexed name range and its ordering. Cursor
    -- state transitions and within-key version ordering stay shared.
    IF v_is_asc THEN
        v_exact_range_predicate := 'TRUE';
        v_strict_range_predicate := 'o.name COLLATE "C" > $2';
        v_inclusive_range_predicate := 'o.name COLLATE "C" >= $2';
        IF v_upper_bound IS NOT NULL THEN
            v_exact_range_predicate := 'o.name COLLATE "C" < $3';
            v_strict_range_predicate := v_strict_range_predicate || ' AND o.name COLLATE "C" < $3';
            v_inclusive_range_predicate := v_inclusive_range_predicate || ' AND o.name COLLATE "C" < $3';
        END IF;
    ELSE
        v_exact_range_predicate := 'TRUE';
        v_strict_range_predicate := 'o.name COLLATE "C" < $2';
        v_inclusive_range_predicate := 'o.name COLLATE "C" < $2';
        IF v_prefix <> '' THEN
            v_exact_range_predicate := 'o.name COLLATE "C" >= $3';
            v_strict_range_predicate := v_strict_range_predicate || ' AND o.name COLLATE "C" >= $3';
            v_inclusive_range_predicate := v_inclusive_range_predicate || ' AND o.name COLLATE "C" >= $3';
        END IF;
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    -- The multi-row order matches the externally serialized cursor exactly:
    -- archived_at at millisecond precision, then version as the final tiebreak.
    --
    -- When v_multi_row, the seek is a keyset tuple comparison ("name > $2 OR
    -- (name = $2 AND tiebreak)") - Postgres won't split that OR into indexable
    -- form (confirmed even with fully literal values), so as one WHERE clause
    -- it forces a full bucket scan filtered row-by-row. Splitting it into two
    -- independently-indexable branches (exact name match with the tiebreak
    -- filter, vs. strictly-past names) combined with UNION ALL lets each
    -- branch keep name as a real index condition; the outer ORDER BY/LIMIT
    -- re-merges them into the same page the single query used to produce.
    IF v_multi_row THEN
        v_batch_query := format(
            $sql$
            SELECT *
            FROM (
                (
                    SELECT o.name, o.id, o.updated_at, o.created_at,
                           o.last_accessed_at, o.metadata, o.version,
                           o.archived_at, o.is_delete_marker, o.is_versioned
                    FROM storage.objects o
                    WHERE o.bucket_id = $1
                      AND o.name COLLATE "C" = $2
                      AND %s
                      AND NOT $7::boolean
                      AND (
                          $5::timestamptz IS NULL
                          OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < $5
                          OR (
                              COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = $5
                              AND COALESCE(o.version, '') > $6
                          )
                      )
                      %s
                    ORDER BY
                        COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC,
                        COALESCE(o.version, '') ASC
                    LIMIT $4
                )
                UNION ALL
                (
                    SELECT o.name, o.id, o.updated_at, o.created_at,
                           o.last_accessed_at, o.metadata, o.version,
                           o.archived_at, o.is_delete_marker, o.is_versioned
                    FROM storage.objects o
                    WHERE o.bucket_id = $1
                      AND %s
                      %s
                    ORDER BY
                        o.name COLLATE "C" %s,
                        COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC,
                        COALESCE(o.version, '') ASC
                    LIMIT $4
                )
            ) sub
            ORDER BY
                sub.name COLLATE "C" %s,
                COALESCE(date_trunc('milliseconds', sub.archived_at), 'infinity'::timestamptz) DESC,
                COALESCE(sub.version, '') ASC
            LIMIT $4
            $sql$,
            v_exact_range_predicate,
            v_version_filter,
            v_strict_range_predicate,
            v_version_filter,
            v_name_order,
            v_name_order
        );
    ELSE
        v_batch_query := format(
            $sql$
            SELECT o.name, o.id, o.updated_at, o.created_at,
                   o.last_accessed_at, o.metadata, o.version,
                   o.archived_at, o.is_delete_marker, o.is_versioned
            FROM storage.objects o
            WHERE o.bucket_id = $1
              AND %s
              %s
            ORDER BY o.name COLLATE "C" %s, o.archived_at DESC
            LIMIT $4
            $sql$,
            v_inclusive_range_predicate,
            v_version_filter,
            v_name_order
        );

        -- Strict counterpart of the query above: used once the single-row
        -- ASC batch advance (below) has left v_next_seek pointing at the
        -- last row already emitted, so an inclusive predicate would
        -- re-match it forever. Only single-row mode ever sets strict mode,
        -- so this variant is never needed when v_multi_row.
        v_batch_query_strict := format(
            $sql$
            SELECT o.name, o.id, o.updated_at, o.created_at,
                   o.last_accessed_at, o.metadata, o.version,
                   o.archived_at, o.is_delete_marker, o.is_versioned
            FROM storage.objects o
            WHERE o.bucket_id = $1
              AND %s
              %s
            ORDER BY o.name COLLATE "C" %s, o.archived_at DESC
            LIMIT $4
            $sql$,
            v_strict_range_predicate,
            v_version_filter,
            v_name_order
        );
    END IF;

    -- The static peek predicates cannot use the partial delete-marker index
    -- once PL/pgSQL switches to a generic plan because whether
    -- is_delete_marker is required remains parameter-dependent. Reuse the
    -- already-specialized batch query with a one-row limit for this sparse
    -- filter so the plan sees a literal `o.is_delete_marker` predicate.
    IF delete_markers = 'only' THEN
        v_delete_marker_peek_query :=
            'SELECT marker_page.name FROM (' || v_batch_query || ') marker_page LIMIT 1';
        IF NOT v_multi_row THEN
            v_delete_marker_peek_query_strict :=
                'SELECT marker_page.name FROM (' || v_batch_query_strict || ') marker_page LIMIT 1';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor performs one specialized initial seek so
            -- partial current-version and delete-marker indexes remain available.
            EXECUTE format(
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1%s%s ORDER BY o.name COLLATE "C" DESC LIMIT 1',
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND o.name COLLATE "C" >= $2 AND o.name COLLATE "C" < $3'
                    ELSE ''
                END,
                v_version_filter
            )
            INTO v_next_seek
            USING _bucket_id, v_prefix, v_upper_bound;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Folder continuation tokens retain their trailing delimiter. A
        -- delimiter-less startAfter is always a literal key boundary.
        v_cursor_is_folder := delimiter_param <> ''
            AND v_start_relative <> ''
            AND right(v_start_relative, length(delimiter_param)) = delimiter_param;

        IF v_cursor_is_folder THEN
            v_next_seek := CASE
                WHEN right(v_start, length(delimiter_param)) = delimiter_param
                    THEN v_start
                ELSE v_start || delimiter_param
            END;
            IF v_is_asc THEN
                v_next_seek := left(v_next_seek, -1)
                    || chr(ascii(right(v_next_seek, 1)) + 1);
            END IF;
            v_next_seek_strict := NOT v_is_asc;
        ELSE
            -- leaf object: when v_multi_row, stay on v_start with the
            -- caller-supplied tiebreak so a page boundary mid-key resumes
            -- that key's remaining rows instead of skipping them. Truncate
            -- to milliseconds like every other v_next_seek_at assignment -
            -- harmless today since object.ts's cursor always round-trips
            -- through JS Date first, but this shouldn't rely on that.
            IF v_multi_row THEN
                v_next_seek := v_start;
                v_next_seek_at := date_trunc('milliseconds', next_token_archived_at);
                v_next_seek_version := coalesce(next_token_version, '');
                v_next_seek_strict := coalesce(next_token, '') = '';
            ELSIF v_is_asc THEN
                v_next_seek := v_start;
                v_next_seek_strict := true;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        v_previous_seek := v_next_seek;
        v_previous_seek_at := v_next_seek_at;
        v_previous_seek_version := v_next_seek_version;
        v_previous_count := v_count;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        -- v_multi_row is branched here (rather than folded into the WHERE
        -- clause as a bound parameter) so each concrete query keeps an
        -- unconditional seek predicate - once PL/pgSQL switches to its
        -- cached generic plan (after 5 calls), a parameter-gated
        -- "(NOT v_multi_row AND name >= $x) OR (v_multi_row AND ...)"
        -- predicate stops the planner from using name as an index
        -- condition at all, degrading every subsequent peek to a full
        -- index scan filtered row-by-row instead of a bounded range scan.
        -- v_multi_row's seek predicate is a keyset tuple comparison
        -- ("name > x OR (name = x AND tiebreak)") - Postgres does not
        -- split this OR into indexable form even with fully literal
        -- values, so it falls back to a full scan filtered row-by-row.
        -- Splitting it into two independently-indexable branches (exact
        -- name match with the tiebreak filter, vs. strictly-past name)
        -- combined with UNION ALL lets each branch keep name as a real
        -- index condition; the outer ORDER BY/LIMIT picks whichever of
        -- the (at most 2) rows sorts first.
        IF delete_markers = 'only' THEN
            EXECUTE CASE WHEN v_next_seek_strict AND NOT v_multi_row
                THEN v_delete_marker_peek_query_strict
                ELSE v_delete_marker_peek_query
            END
                INTO v_peek_name
                USING _bucket_id, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END,
                    1, v_next_seek_at, v_next_seek_version, v_next_seek_strict;
        ELSIF v_multi_row THEN
            IF v_is_asc THEN
                IF v_upper_bound IS NOT NULL THEN
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND o.name COLLATE "C" < v_upper_bound
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" > v_next_seek AND o.name COLLATE "C" < v_upper_bound
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" ASC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" > v_next_seek
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" ASC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSE
                IF v_upper_bound IS NOT NULL THEN
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND o.name COLLATE "C" >= v_prefix
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" DESC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" DESC LIMIT 1;
                ELSE
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" DESC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" DESC LIMIT 1;
                END IF;
            END IF;
        ELSE
            -- Single-row mode is always noncurrent_versions='exclude'. Keep
            -- this predicate literal so generic plans use the current index.
            IF v_is_asc THEN
                IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" > v_next_seek
                      AND o.name COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSIF v_next_seek_strict THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" > v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSIF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" >= v_next_seek
                      AND o.name COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" >= v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSE
                IF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" < v_next_seek
                      AND o.name COLLATE "C" >= v_prefix
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" DESC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" < v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" DESC LIMIT 1;
                END IF;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := v_common_prefix;
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            version := NULL;
            archived_at := NULL;
            is_delete_marker := NULL;
            is_versioned := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1)
                    || chr(ascii(right(v_common_prefix, 1)) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
            v_next_seek_at := NULL;
            v_next_seek_version := '';
            v_next_seek_strict := NOT v_is_asc;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE CASE WHEN v_next_seek_strict AND NOT v_multi_row THEN v_batch_query_strict ELSE v_batch_query END
                USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size, v_next_seek_at, v_next_seek_version,
                v_next_seek_strict
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it. Reset
                    -- strict mode too it may have been set by an earlier
                    -- row in this same batch (see the single-row ASC advance
                    -- below), and v_next_seek here is the folder-triggering
                    -- row's own name, which the next peek must find inclusively.
                    v_next_seek := CASE
                        WHEN v_is_asc THEN v_current.name
                        ELSE v_current.name || delimiter_param
                    END;
                    v_next_seek_at := NULL;
                    v_next_seek_version := '';
                    v_next_seek_strict := false;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                version := v_current.version;
                archived_at := v_current.archived_at;
                is_delete_marker := v_current.is_delete_marker;
                is_versioned := v_current.is_versioned;
                RETURN NEXT;
                v_count := v_count + 1;

                -- when v_multi_row, stay on this name and record its
                -- archived_at as the new tiebreak so remaining rows for the
                -- same key are picked up before moving to the next name
                IF v_multi_row THEN
                    v_next_seek := v_current.name;
                    v_next_seek_at := COALESCE(date_trunc('milliseconds', v_current.archived_at), 'infinity'::timestamptz);
                    v_next_seek_version := COALESCE(v_current.version, '');
                    v_next_seek_strict := false;
                ELSIF v_is_asc THEN
                    -- Appending the delimiter as a fake lexical successor
                    -- would skip a real key like `name || '!'` (or any
                    -- character sorting below the delimiter), which sorts
                    -- between `name` and `name || delimiter`. Track the real
                    -- name and mark the next comparison strict instead.
                    v_next_seek := v_current.name;
                    v_next_seek_strict := true;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;

        IF v_count = v_previous_count
           AND v_next_seek IS NOT DISTINCT FROM v_previous_seek
           AND v_next_seek_at IS NOT DISTINCT FROM v_previous_seek_at
           AND v_next_seek_version IS NOT DISTINCT FROM v_previous_seek_version THEN
            RAISE EXCEPTION 'storage.list_objects_with_delimiter made no progress at seek (%, %, %)',
                v_next_seek, v_next_seek_at, v_next_seek_version;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text, noncurrent_versions text, delete_markers text, next_token_archived_at timestamp with time zone, next_token_version text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_bucket_control_columns(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_bucket_control_columns() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  configuration_changed boolean;
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.lifecycle_configuration IS NOT NULL
       OR NEW.lifecycle_configuration_generation IS NOT NULL THEN
      IF NOT pg_has_role(current_user, TG_ARGV[0], 'MEMBER') THEN
        RAISE EXCEPTION 'only members of the configured storage service role may insert lifecycle policy state'
          USING ERRCODE = '42501',
                HINT = format(
                  'Insert with both lifecycle columns NULL and configure lifecycle through the Storage API afterward, or insert as a member of %I.',
                  TG_ARGV[0]
                );
      END IF;
    END IF;

    RETURN NEW;
  END IF;

  configuration_changed =
    OLD.lifecycle_configuration IS DISTINCT FROM NEW.lifecycle_configuration
    OR OLD.lifecycle_configuration_generation IS DISTINCT FROM NEW.lifecycle_configuration_generation;

  IF NOT configuration_changed THEN
    RETURN NEW;
  END IF;

  IF NEW.type IS DISTINCT FROM 'STANDARD' THEN
    RAISE EXCEPTION 'bucket versioning and lifecycle controls require a Standard bucket'
      USING ERRCODE = '0A000';
  END IF;

  IF NEW.lifecycle_configuration IS NULL
     AND NEW.lifecycle_configuration_generation IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.lifecycle_configuration IS NULL
     OR NEW.lifecycle_configuration_generation IS NULL
     OR OLD.lifecycle_configuration IS NOT DISTINCT FROM NEW.lifecycle_configuration
     OR OLD.lifecycle_configuration_generation IS NOT DISTINCT FROM NEW.lifecycle_configuration_generation THEN
    RAISE EXCEPTION 'a changed lifecycle policy requires a new non-null generation'
      USING ERRCODE = '22023';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION storage.protect_bucket_control_columns() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_prefix_len INT;
    v_prefix_start INT;
    v_combined_levels INT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;
    v_version_filter TEXT;
    v_multi_row BOOLEAN;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;
    v_delete_marker_peek_query TEXT;
    v_delete_marker_peek_query_strict TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_next_seek_at TIMESTAMPTZ;
    v_next_seek_version TEXT;
    v_next_seek_strict BOOLEAN := false;
    v_count INT := 0;
    v_skipped INT := 0;
    v_previous_seek TEXT;
    v_previous_seek_at TIMESTAMPTZ;
    v_previous_seek_version TEXT;
    v_previous_count INT;
    v_previous_skipped INT;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_prefix_len := length(coalesce(prefix, ''));
    v_prefix_start := coalesce(array_length(string_to_array(coalesce(prefix, ''), v_delimiter), 1), 1);
    v_combined_levels := coalesce(array_length(string_to_array(v_prefix, v_delimiter), 1), 1);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);
    v_next_seek_at := NULL;
    v_next_seek_version := '';

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    v_multi_row := noncurrent_versions IN ('only', 'include');

    v_version_filter := '';
    IF noncurrent_versions = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NULL';
    ELSIF noncurrent_versions = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NOT NULL';
    END IF;
    IF delete_markers = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND NOT o.is_delete_marker';
    ELSIF delete_markers = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.is_delete_marker';
    END IF;

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT array_to_string(path_tokens[$1:$2], '/') AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $3 || '%%'
                  AND bucket_id = $4
                  AND array_length(objects.path_tokens, 1) <> $2
                  AND ($7 != 'exclude' OR objects.archived_at IS NULL)
                  AND ($7 != 'only' OR objects.archived_at IS NOT NULL)
                  AND ($8 != 'exclude' OR NOT objects.is_delete_marker)
                  AND ($8 != 'only' OR objects.is_delete_marker)
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata,
                   NULL::text AS version,
                   NULL::timestamptz AS archived_at,
                   NULL::boolean AS is_delete_marker,
                   NULL::boolean AS is_versioned FROM folders)
            UNION ALL
            (SELECT array_to_string(path_tokens[$1:$2], '/') AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata,
                   version, archived_at, is_delete_marker, is_versioned
             FROM storage.objects
             WHERE objects.name ILIKE $3 || '%%'
               AND bucket_id = $4
               AND array_length(objects.path_tokens, 1) = $2
               AND ($7 != 'exclude' OR objects.archived_at IS NULL)
               AND ($7 != 'only' OR objects.archived_at IS NOT NULL)
               AND ($8 != 'exclude' OR NOT objects.is_delete_marker)
               AND ($8 != 'only' OR objects.is_delete_marker)
             -- name, then version, as tiebreaks so two versions of the same
             -- key tying on the sort column still sort deterministically
             ORDER BY %I %s, name COLLATE "C" %s, COALESCE(version, '') %s)
            LIMIT $5 OFFSET $6
            $sql$, v_sort_order, v_order_by, v_sort_order, v_sort_order, v_sort_order
        ) USING v_prefix_start, v_combined_levels, v_prefix, bucketname, v_limit, offsets, noncurrent_versions, delete_markers;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build a resume-safe batch query. The exact-name branch returns remaining
    -- versions after the current (archived_at, version) boundary; the strict
    -- name branch returns subsequent keys. UNION ALL keeps both predicates
    -- independently indexable.
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" > $2 AND lower(o.name) COLLATE "C" < $3' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" ASC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" > $2' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" ASC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 AND lower(o.name) COLLATE "C" >= $3' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" DESC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" DESC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        END IF;
    END IF;

    -- Keep the delete-marker predicate literal so the cached generic
    -- plan can use idx_objects_delete_markers during the main-loop peek.
    IF delete_markers = 'only' THEN
        IF v_multi_row THEN
            v_delete_marker_peek_query :=
                'SELECT marker_page.name FROM (' || v_batch_query || ') marker_page LIMIT 1';
        ELSIF v_is_asc THEN
            -- Two separate literal query strings, not one gated by a bound
            -- boolean: folding "$n AND op1 OR NOT $n AND op2" into a single
            -- query defeats the generic plan's ability to push either
            -- comparison into the index. Branching in PL/pgSQL control flow
            -- instead keeps each query's index condition intact.
            v_delete_marker_peek_query :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" >= $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" < $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1';
            -- Strict variant: used once the single-row ASC batch advance
            -- (below) has left v_next_seek pointing at the last row already
            -- emitted, so a plain >= would re-match it forever.
            v_delete_marker_peek_query_strict :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" > $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" < $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1';
        ELSE
            v_delete_marker_peek_query :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" < $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" >= $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC performs one specialized initial seek so partial current-version
        -- and delete-marker indexes remain available.
        EXECUTE format(
            'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1%s%s ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1',
            CASE WHEN v_upper_bound IS NOT NULL
                THEN ' AND lower(o.name) COLLATE "C" >= $2 AND lower(o.name) COLLATE "C" < $3'
                ELSE ''
            END,
            v_version_filter
        )
        INTO v_peek_name
        USING bucketname, v_prefix_lower, v_upper_bound;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch and
    -- the delete-marker-only path
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        v_previous_seek := v_next_seek;
        v_previous_seek_at := v_next_seek_at;
        v_previous_seek_version := v_next_seek_version;
        v_previous_count := v_count;
        v_previous_skipped := v_skipped;

        -- STEP 1: PEEK
        v_peek_name := NULL;
        IF delete_markers = 'only' THEN
            EXECUTE CASE WHEN v_next_seek_strict
                THEN v_delete_marker_peek_query_strict
                ELSE v_delete_marker_peek_query
            END
                INTO v_peek_name
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END,
                    1, v_next_seek_at, v_next_seek_version;
        ELSIF v_multi_row AND v_next_seek_at IS NOT NULL THEN
            SELECT o.name INTO v_peek_name
            FROM storage.objects o
            WHERE o.bucket_id = bucketname
              AND lower(o.name) COLLATE "C" = v_next_seek
              AND (COALESCE(o.archived_at, 'infinity'::timestamptz) < v_next_seek_at
                   OR (COALESCE(o.archived_at, 'infinity'::timestamptz) = v_next_seek_at
                       AND COALESCE(o.version, '') > v_next_seek_version))
              AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
              AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
              AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
              AND (delete_markers != 'only' OR o.is_delete_marker)
            ORDER BY COALESCE(o.archived_at, 'infinity'::timestamptz) DESC,
                     COALESCE(o.version, '') ASC
            LIMIT 1;

            -- The current key is exhausted. Clear its version boundary and
            -- make the following ASC name peek strict. Appending '/' is not a
            -- valid lexical successor because keys ending in characters such
            -- as '!' sort between the exhausted name and name || '/'.
            IF v_peek_name IS NULL THEN
                IF v_is_asc THEN
                    v_next_seek_strict := true;
                END IF;
                v_next_seek_at := NULL;
                v_next_seek_version := '';
            END IF;
        END IF;

        -- Single-row mode is always noncurrent_versions='exclude'. Keep the
        -- current-row predicate literal so generic plans use the current index.
        IF delete_markers != 'only' AND v_peek_name IS NULL AND NOT v_multi_row THEN
            IF v_is_asc THEN
                IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSIF v_next_seek_strict THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSIF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSIF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                  AND o.archived_at IS NULL
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                  AND o.archived_at IS NULL
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        ELSIF delete_markers != 'only' AND v_peek_name IS NULL AND v_is_asc THEN
            IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSIF v_next_seek_strict THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSIF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSIF delete_markers != 'only' AND v_peek_name IS NULL THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- If the peek landed on a different key than we were tracking, any
        -- version boundary belongs to the OLD key and must not leak into the
        -- new one - e.g. the deleteMarkers='only' peek doesn't know or care
        -- whether it's continuing the same key or jumping to a new one, so
        -- it never clears these itself.
        IF lower(v_peek_name) IS DISTINCT FROM v_next_seek THEN
            v_next_seek_at := NULL;
            v_next_seek_version := '';
        END IF;

        -- The peek is authoritative for the next key to process. This is
        -- especially important after exhausting a multi-version key: the
        -- version boundary has been cleared, so executing the batch against
        -- a stale v_next_seek would replay every version of that old key.
        v_next_seek := lower(v_peek_name);
        v_next_seek_strict := false;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := substring(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter) from v_prefix_len + 1);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                version := NULL;
                archived_at := NULL;
                is_delete_marker := NULL;
                is_versioned := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
            v_next_seek_at := NULL;
            v_next_seek_version := '';
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size,
                    v_next_seek_at, v_next_seek_version
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it. Reset
                    -- strict mode too - it may have been set by an earlier
                    -- row in this same batch (see the single-row ASC advance
                    -- below), and v_next_seek here is the folder-triggering
                    -- row's own name, which the next peek must find inclusively.
                    v_next_seek := CASE
                        WHEN v_is_asc THEN lower(v_current.name)
                        ELSE lower(v_current.name) || v_delimiter
                    END;
                    v_next_seek_at := NULL;
                    v_next_seek_version := '';
                    v_next_seek_strict := false;
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := substring(v_current.name from v_prefix_len + 1);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    version := v_current.version;
                    archived_at := v_current.archived_at;
                    is_delete_marker := v_current.is_delete_marker;
                    is_versioned := v_current.is_versioned;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Multi-row mode must remain on this key until all of its
                -- versions have crossed the internal batch boundary.
                IF v_multi_row THEN
                    v_next_seek := lower(v_current.name);
                    v_next_seek_at := COALESCE(v_current.archived_at, 'infinity'::timestamptz);
                    v_next_seek_version := COALESCE(v_current.version, '');
                ELSIF v_is_asc THEN
                    -- Appending the delimiter as a fake lexical successor would
                    -- skip a real key like `name || '!'` (or any character
                    -- sorting below the delimiter), which sorts between `name`
                    -- and `name || delimiter`. Track the real name and mark the
                    -- next comparison strict instead - same fix as the
                    -- exhausted-key case above.
                    v_next_seek := lower(v_current.name);
                    v_next_seek_strict := true;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;

        IF v_count = v_previous_count
           AND v_skipped = v_previous_skipped
           AND v_next_seek IS NOT DISTINCT FROM v_previous_seek
           AND v_next_seek_at IS NOT DISTINCT FROM v_previous_seek_at
           AND v_next_seek_version IS NOT DISTINCT FROM v_previous_seek_version THEN
            RAISE EXCEPTION 'storage.search made no progress at seek (%, %, %)',
                v_next_seek, v_next_seek_at, v_next_seek_version;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text, noncurrent_versions text, delete_markers text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, p_start_after_version text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
    v_prefix_pattern text;
    v_sort_order text;
    v_sort_column text;
    v_version_tiebreak text;
BEGIN
    v_prefix := coalesce(p_prefix, '');
    -- Keep the raw prefix for common-prefix calculations and escape only LIKE metacharacters.
    v_prefix_pattern := replace(v_prefix, chr(92), chr(92) || chr(92));
    v_prefix_pattern := replace(v_prefix_pattern, '%', chr(92) || '%');
    v_prefix_pattern := replace(v_prefix_pattern, '_', chr(92) || '_');

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    -- $9 is only populated in multi-row mode; it's always '' otherwise, so
    -- only use each row's real version as a tiebreak in multi-row mode.
    v_version_tiebreak := CASE WHEN noncurrent_versions IN ('only', 'include') THEN 'COALESCE(version, '''')' ELSE '''''' END;

    -- Defense-in-depth: this function is independently reachable and must
    -- not trust p_sort_order/p_sort_column to already be validated by a
    -- caller. Normalize to the same strict allow-list storage.search_v2
    -- uses before interpolating anything into dynamic SQL below.
    v_sort_order := lower(coalesce(p_sort_order, 'asc'));
    IF v_sort_order NOT IN ('asc', 'desc') THEN
        v_sort_order := 'asc';
    END IF;

    v_sort_column := lower(coalesce(p_sort_column, 'updated_at'));
    IF v_sort_column NOT IN ('updated_at', 'created_at') THEN
        v_sort_column := 'updated_at';
    END IF;

    IF v_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                o.version AS obj_version,
                o.archived_at AS obj_archived_at,
                o.is_delete_marker AS obj_is_delete_marker,
                o.is_versioned AS obj_is_versioned,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $10 || '%%'
              AND ($7 != 'exclude' OR o.archived_at IS NULL)
              AND ($7 != 'only' OR o.archived_at IS NOT NULL)
              AND ($8 != 'exclude' OR NOT o.is_delete_marker)
              AND ($8 != 'only' OR o.is_delete_marker)
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                common_prefix AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                NULL::text AS version,
                NULL::timestamptz AS archived_at,
                NULL::boolean AS is_delete_marker,
                NULL::boolean AS is_versioned,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                obj_version AS version,
                obj_archived_at AS archived_at,
                obj_is_delete_marker AS is_delete_marker,
                obj_is_versioned AS is_versioned,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz),
                    name COLLATE "C",
                    %s
                ) %s ROW(
                    -- truncated the same way as the stored value above
                    date_trunc('milliseconds', COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz)),
                    $5,
                    $9
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata,
            version,
            archived_at,
            is_delete_marker,
            is_versioned
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s,
            COALESCE(version, '') %s
        LIMIT $4
    $sql$,
        v_sort_column,
        v_version_tiebreak,
        v_cursor_op,
        v_sort_column,
        v_sort_order,
        v_sort_order,
        v_sort_order
    );

    -- version is the third tiebreak component for two versions of the same
    -- key tying on both timestamp and name (see filtered CTE / ORDER BY above)
    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after, noncurrent_versions, delete_markers, coalesce(p_start_after_version, ''), v_prefix_pattern;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text, noncurrent_versions text, delete_markers text, p_start_after_version text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text, text, text, timestamp with time zone, text, boolean); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, start_after_archived_at timestamp with time zone DEFAULT NULL::timestamp with time zone, start_after_version text DEFAULT ''::text, start_after_is_continuation boolean DEFAULT false) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata,
            l.version,
            l.archived_at,
            l.is_delete_marker,
            l.is_versioned
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            CASE WHEN start_after_is_continuation THEN '' ELSE start_after END,
            CASE WHEN start_after_is_continuation THEN start_after ELSE '' END,
            v_sort_ord,
            noncurrent_versions,
            delete_markers,
            start_after_archived_at,
            start_after_version
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after,
            noncurrent_versions, delete_markers, start_after_version
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text, noncurrent_versions text, delete_markers text, start_after_archived_at timestamp with time zone, start_after_version text, start_after_is_continuation boolean) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    custom_claims_allowlist text[] DEFAULT '{}'::text[] NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: mfa_recovery_code_sets; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_recovery_code_sets (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    mfa_factor_id uuid NOT NULL,
    failed_verification_count integer DEFAULT 0 NOT NULL,
    verification_locked_until timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mfa_recovery_code_sets_failed_verification_count_check CHECK ((failed_verification_count >= 0))
);


ALTER TABLE auth.mfa_recovery_code_sets OWNER TO supabase_auth_admin;

--
-- Name: mfa_recovery_codes; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_recovery_codes (
    id uuid NOT NULL,
    mfa_recovery_code_set_id uuid NOT NULL,
    code_hash text NOT NULL,
    consumed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE auth.mfa_recovery_codes OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: scim_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.scim_tokens (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    token_hash text NOT NULL,
    prefix text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    revoked_at timestamp with time zone,
    last_used_at timestamp with time zone,
    CONSTRAINT scim_tokens_expires_at_future CHECK (((expires_at IS NULL) OR (expires_at > created_at))),
    CONSTRAINT scim_tokens_revoked_after_created CHECK (((revoked_at IS NULL) OR (revoked_at >= created_at))),
    CONSTRAINT scim_tokens_token_hash_check CHECK ((token_hash ~ '^[0-9a-f]{64}$'::text))
);


ALTER TABLE auth.scim_tokens OWNER TO supabase_auth_admin;

--
-- Name: scim_users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.scim_users (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    user_id uuid,
    resource jsonb NOT NULL,
    user_name text GENERATED ALWAYS AS (lower((resource ->> 'userName'::text))) STORED NOT NULL,
    external_id text GENERATED ALWAYS AS ((resource ->> 'externalId'::text)) STORED,
    active boolean GENERATED ALWAYS AS (COALESCE(((resource ->> 'active'::text))::boolean, true)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE auth.scim_users OWNER TO supabase_auth_admin;

--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documents (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_id uuid NOT NULL,
    file_path text NOT NULL,
    file_name text NOT NULL,
    doc_type text,
    status text DEFAULT 'pending'::text NOT NULL,
    reviewed_by uuid,
    review_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.documents OWNER TO postgres;

--
-- Name: email_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    recipient text NOT NULL,
    subject text NOT NULL,
    status text DEFAULT 'sent'::text NOT NULL,
    service text NOT NULL,
    error_message text,
    sent_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.email_logs OWNER TO postgres;

--
-- Name: email_queue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_queue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    email text,
    notification_id uuid NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    status text DEFAULT 'pending'::text,
    created_at timestamp with time zone DEFAULT now(),
    sent_at timestamp with time zone,
    error_message text,
    CONSTRAINT email_queue_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'sent'::text, 'failed'::text])))
);


ALTER TABLE public.email_queue OWNER TO postgres;

--
-- Name: favorite_providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favorite_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    provider_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.favorite_providers OWNER TO postgres;

--
-- Name: matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    request_id uuid NOT NULL,
    provider_id uuid NOT NULL,
    score numeric(5,2) NOT NULL,
    reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    inquiry_status text DEFAULT 'none'::text NOT NULL,
    inquiry_message text,
    inquiry_preferred_date date,
    inquiry_requested_at timestamp with time zone,
    CONSTRAINT matches_inquiry_status_check CHECK ((inquiry_status = ANY (ARRAY['none'::text, 'requested'::text, 'accepted'::text, 'declined'::text, 'completed'::text, 'cancelled'::text])))
);


ALTER TABLE public.matches OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    match_id uuid NOT NULL,
    sender_id uuid NOT NULL,
    message text NOT NULL,
    read boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    type text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    read boolean DEFAULT false,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT notifications_type_check CHECK ((type = ANY (ARRAY['success'::text, 'error'::text, 'warning'::text, 'info'::text])))
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    full_name text NOT NULL,
    email text,
    phone text,
    location text,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: provider_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provider_reports (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    match_id uuid NOT NULL,
    provider_id uuid NOT NULL,
    client_id uuid NOT NULL,
    report_text text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    admin_notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT provider_reports_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'reviewed'::text, 'resolved'::text, 'dismissed'::text])))
);


ALTER TABLE public.provider_reports OWNER TO postgres;

--
-- Name: ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ratings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_id uuid NOT NULL,
    client_id uuid NOT NULL,
    rating integer NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ratings_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.ratings OWNER TO postgres;

--
-- Name: service_providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    business_name text NOT NULL,
    category text NOT NULL,
    bio text,
    hourly_rate numeric(10,2),
    location text,
    service_radius_km integer DEFAULT 25,
    status text DEFAULT 'offline'::text NOT NULL,
    verification_status text DEFAULT 'pending'::text NOT NULL,
    avg_rating numeric(3,2) DEFAULT 0,
    rating_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    review_notes text,
    registration_number text,
    business_registration_number text
);


ALTER TABLE public.service_providers OWNER TO postgres;

--
-- Name: service_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    request_text text NOT NULL,
    service_type text,
    location text,
    status text DEFAULT 'pending'::text NOT NULL,
    ai_summary text,
    ai_keywords text[],
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT service_requests_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'matched'::text, 'in_progress'::text, 'complete'::text, 'cancelled'::text])))
);


ALTER TABLE public.service_requests OWNER TO postgres;

--
-- Name: user_onboarding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_onboarding (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    completed_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_onboarding OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role public.app_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_09_12; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_09_12 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_09_12 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_09_13; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_09_13 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_09_13 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_09_14; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_09_14 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_09_14 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_09_15; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_09_15 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_09_15 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_09_16; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_09_16 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_09_16 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_09_17; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_09_17 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_09_17 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_09_18; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_09_18 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_09_18 OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_realtime_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL,
    versioning_status text DEFAULT 'DISABLED'::text NOT NULL,
    lifecycle_configuration jsonb,
    lifecycle_configuration_generation uuid,
    CONSTRAINT buckets_lifecycle_configuration_pair_check CHECK (((lifecycle_configuration IS NULL) = (lifecycle_configuration_generation IS NULL))),
    CONSTRAINT buckets_lifecycle_configuration_shape_check CHECK (((lifecycle_configuration IS NULL) OR ((jsonb_typeof(lifecycle_configuration) = 'object'::text) AND (lifecycle_configuration ? 'rules'::text) AND
CASE
    WHEN (jsonb_typeof((lifecycle_configuration -> 'rules'::text)) = 'array'::text) THEN ((jsonb_array_length((lifecycle_configuration -> 'rules'::text)) >= 1) AND (jsonb_array_length((lifecycle_configuration -> 'rules'::text)) <= 1000))
    ELSE false
END))),
    CONSTRAINT buckets_lifecycle_configuration_standard_only_check CHECK (((type = 'STANDARD'::storage.buckettype) OR ((lifecycle_configuration IS NULL) AND (lifecycle_configuration_generation IS NULL)))),
    CONSTRAINT buckets_versioning_dark_check CHECK ((versioning_status = 'DISABLED'::text)),
    CONSTRAINT buckets_versioning_standard_only_check CHECK (((type = 'STANDARD'::storage.buckettype) OR (versioning_status = 'DISABLED'::text))),
    CONSTRAINT buckets_versioning_status_check CHECK ((versioning_status = ANY (ARRAY['DISABLED'::text, 'ENABLED'::text, 'SUSPENDED'::text])))
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    archived_at timestamp with time zone,
    is_delete_marker boolean DEFAULT false NOT NULL,
    is_versioned boolean DEFAULT false NOT NULL
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: messages_2026_09_12; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_09_12 FOR VALUES FROM ('2026-09-12 00:00:00') TO ('2026-09-13 00:00:00');


--
-- Name: messages_2026_09_13; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_09_13 FOR VALUES FROM ('2026-09-13 00:00:00') TO ('2026-09-14 00:00:00');


--
-- Name: messages_2026_09_14; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_09_14 FOR VALUES FROM ('2026-09-14 00:00:00') TO ('2026-09-15 00:00:00');


--
-- Name: messages_2026_09_15; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_09_15 FOR VALUES FROM ('2026-09-15 00:00:00') TO ('2026-09-16 00:00:00');


--
-- Name: messages_2026_09_16; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_09_16 FOR VALUES FROM ('2026-09-16 00:00:00') TO ('2026-09-17 00:00:00');


--
-- Name: messages_2026_09_17; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_09_17 FOR VALUES FROM ('2026-09-17 00:00:00') TO ('2026-09-18 00:00:00');


--
-- Name: messages_2026_09_18; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_09_18 FOR VALUES FROM ('2026-09-18 00:00:00') TO ('2026-09-19 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at, custom_claims_allowlist) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
172652f0-c720-405e-a842-c737ecc5f9cb	172652f0-c720-405e-a842-c737ecc5f9cb	{"sub": "172652f0-c720-405e-a842-c737ecc5f9cb", "role": "provider", "email": "kopanoananias22@gmail.com", "full_name": "ananias", "email_verified": true, "phone_verified": false}	email	2026-09-07 18:04:27.206181+00	2026-09-07 18:04:27.206224+00	2026-09-07 18:04:27.206224+00	b8803e1f-f5cd-4832-9026-2a04ba31c199
18303ea7-fc4e-48d3-b73b-93d016816902	18303ea7-fc4e-48d3-b73b-93d016816902	{"sub": "18303ea7-fc4e-48d3-b73b-93d016816902", "role": "client", "email": "harhimongwe@gmail.com", "full_name": "Harhi Mongwe ", "email_verified": true, "phone_verified": false}	email	2026-09-07 18:04:21.287754+00	2026-09-07 18:04:21.287875+00	2026-09-07 18:04:21.287875+00	4cd6ec6f-9453-4428-a484-59628a290cd1
ecf8ae09-72d2-4547-b40c-09615742c082	ecf8ae09-72d2-4547-b40c-09615742c082	{"sub": "ecf8ae09-72d2-4547-b40c-09615742c082", "role": "client", "email": "clementmaebela@gmail.com", "full_name": "Thabo Mokoena", "email_verified": false, "phone_verified": false}	email	2026-09-09 11:57:33.231993+00	2026-09-09 11:57:33.23204+00	2026-09-09 11:57:33.23204+00	67f43532-42e7-4a9f-a200-5568b8b82612
322deaf8-c652-4e90-ae39-38c0aa185e38	322deaf8-c652-4e90-ae39-38c0aa185e38	{"sub": "322deaf8-c652-4e90-ae39-38c0aa185e38", "role": "provider", "email": "mulaudzishaun688@gmail.com", "full_name": "Shaun", "email_verified": true, "phone_verified": false}	email	2026-09-09 17:39:47.619367+00	2026-09-09 17:39:47.619422+00	2026-09-09 17:39:47.619422+00	6fb5e07c-6d4b-4a7b-9d8c-e863a9be79b1
c0bc5412-8793-4a43-8bf5-de0f1aff2914	c0bc5412-8793-4a43-8bf5-de0f1aff2914	{"sub": "c0bc5412-8793-4a43-8bf5-de0f1aff2914", "role": "provider", "email": "raedanindileni@gmail.com", "full_name": "Ndileni", "email_verified": true, "phone_verified": false}	email	2026-09-09 17:57:00.62536+00	2026-09-09 17:57:00.625416+00	2026-09-09 17:57:00.625416+00	e4f995a7-ff59-453c-8a4a-003f308fe852
7144aa93-d014-48b9-a8fe-af41de8baf8f	7144aa93-d014-48b9-a8fe-af41de8baf8f	{"sub": "7144aa93-d014-48b9-a8fe-af41de8baf8f", "role": "client", "email": "sambomphile258@gmail.com", "full_name": "Nkosingiphile", "email_verified": true, "phone_verified": false}	email	2026-09-09 18:33:39.918844+00	2026-09-09 18:33:39.918898+00	2026-09-09 18:33:39.918898+00	db1f2d95-8ff5-457e-8c90-89cee526c4ea
e1b0f19a-c9cf-458d-91fc-38073221ac53	e1b0f19a-c9cf-458d-91fc-38073221ac53	{"sub": "e1b0f19a-c9cf-458d-91fc-38073221ac53", "role": "client", "email": "folet95486@airhemp.com", "full_name": "folet95486@airhemp.com", "email_verified": false, "phone_verified": false}	email	2026-09-11 13:28:00.593045+00	2026-09-11 13:28:00.593098+00	2026-09-11 13:28:00.593098+00	69aa6dd9-0aa6-40b6-a3db-09c3c61611e2
3d104c94-3cce-4ed3-a8c8-59f675d1806a	3d104c94-3cce-4ed3-a8c8-59f675d1806a	{"sub": "3d104c94-3cce-4ed3-a8c8-59f675d1806a", "role": "provider", "email": "tadale1848@airhemp.com", "full_name": "tadale1848@airhemp.com", "email_verified": true, "phone_verified": false}	email	2026-09-11 13:32:06.121811+00	2026-09-11 13:32:06.121861+00	2026-09-11 13:32:06.121861+00	f59d7bc6-e362-4d2b-a738-1c3f554a6caf
3b7077bc-b9d6-4ffc-b2b9-74a6b6044f7c	3b7077bc-b9d6-4ffc-b2b9-74a6b6044f7c	{"sub": "3b7077bc-b9d6-4ffc-b2b9-74a6b6044f7c", "role": "client", "email": "mulaudzi@gmail.com", "full_name": "Shaun", "email_verified": false, "phone_verified": false}	email	2026-09-09 17:32:11.614765+00	2026-09-09 17:32:11.614814+00	2026-09-09 17:32:11.614814+00	a1db22ea-07e1-44c7-b716-754b9851262b
fc0d4183-26a7-49ee-aa8b-c864ac60a689	fc0d4183-26a7-49ee-aa8b-c864ac60a689	{"sub": "fc0d4183-26a7-49ee-aa8b-c864ac60a689", "role": "client", "email": "ndilenifransina@gmail.com", "full_name": "Ndileni", "email_verified": true, "phone_verified": false}	email	2026-09-09 17:43:12.024969+00	2026-09-09 17:43:12.025073+00	2026-09-09 17:43:12.025073+00	1c916e00-4baf-4cee-b37e-6f017cc99c64
1f49d8c3-a080-424d-aeb0-d403a4dc953e	1f49d8c3-a080-424d-aeb0-d403a4dc953e	{"sub": "1f49d8c3-a080-424d-aeb0-d403a4dc953e", "role": "provider", "email": "wefora5609@airhemp.com", "full_name": "wefora5609@airhemp.com", "email_verified": true, "phone_verified": false}	email	2026-09-11 13:25:52.35779+00	2026-09-11 13:25:52.357844+00	2026-09-11 13:25:52.357844+00	f60e47b4-eabe-4c12-b9a0-d2e0d6bd89f6
4bf09add-01d5-4358-9199-53662f131d8d	4bf09add-01d5-4358-9199-53662f131d8d	{"sub": "4bf09add-01d5-4358-9199-53662f131d8d", "role": "client", "email": "jefero2661@airhemp.com", "full_name": "jefero2661@airhemp.com", "email_verified": true, "phone_verified": false}	email	2026-09-11 13:30:26.569882+00	2026-09-11 13:30:26.569936+00	2026-09-11 13:30:26.569936+00	51430ce6-6503-4eb5-b91b-014061ffdc73
8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	{"sub": "8db5eff3-7ff2-4eb6-9918-7b076ef1bc93", "role": "provider", "email": "sambomphile258@outlook.com", "full_name": "Nkosingiphile", "email_verified": true, "phone_verified": false}	email	2026-09-05 19:02:57.227581+00	2026-09-05 19:02:57.227625+00	2026-09-05 19:02:57.227625+00	2d5b16d5-4dd4-4985-a5d4-5c71eb28b09a
51763d35-9b2a-4bd7-a4c9-4039abcd90cc	51763d35-9b2a-4bd7-a4c9-4039abcd90cc	{"sub": "51763d35-9b2a-4bd7-a4c9-4039abcd90cc", "role": "client", "email": "group14cos300@gmail.com", "full_name": "admin", "email_verified": true, "phone_verified": false}	email	2026-09-05 19:04:58.472204+00	2026-09-05 19:04:58.472261+00	2026-09-05 19:04:58.472261+00	bd8a33b1-4d7b-4840-a512-909636284d65
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
bb871ed4-cffe-4189-8902-f158d4cebe21	2026-09-09 17:57:19.283117+00	2026-09-09 17:57:19.283117+00	password	2bd56a4a-c900-4e63-a098-60f06f56e032
18234c2c-83c8-439a-abc0-89cf9079885c	2026-09-09 17:57:26.892461+00	2026-09-09 17:57:26.892461+00	password	6791710e-92fb-46b1-af3f-fb42174cfc65
acad16bf-5e06-4362-a1e9-389bd719b01b	2026-09-09 19:13:20.750076+00	2026-09-09 19:13:20.750076+00	password	bf6c15e0-9e53-4c38-ba34-a0fabe20a1cb
1e33c248-cfdf-4ab8-b24c-9093da738be8	2026-09-11 13:30:42.415607+00	2026-09-11 13:30:42.415607+00	otp	57185d70-5811-498c-9db1-948e13d3f3cf
1b162b8f-b98e-40b8-be94-63dd28338273	2026-09-11 13:41:01.397163+00	2026-09-11 13:41:01.397163+00	password	c2f979f1-1baa-4574-8ada-2eaa739dcda8
ce2a0bfa-66ae-4368-9394-bfa101ab53a6	2026-09-11 13:43:08.620775+00	2026-09-11 13:43:08.620775+00	password	ee87bab4-da56-47a6-b89a-8a8f1d515880
d2dc57b0-2d98-494e-9d61-470427f254df	2026-09-15 21:44:33.47514+00	2026-09-15 21:44:33.47514+00	password	60ff2af3-8e0f-4715-aca1-551a98d92de7
907dafb6-2bbf-4209-8938-eefe991ad865	2026-09-07 18:05:25.899302+00	2026-09-07 18:05:25.899302+00	otp	43f20ecd-92fe-4dd6-9c17-3d311e3e2ed9
7d9c2c69-416f-4541-8322-0bcf093e49c4	2026-09-07 18:05:58.652815+00	2026-09-07 18:05:58.652815+00	password	6e1b2298-7caf-41e3-aff4-049a74798628
ee083012-c296-44f3-914f-dc2084e95dff	2026-09-09 17:40:41.605511+00	2026-09-09 17:40:41.605511+00	otp	62094165-ea53-4d2e-84b4-fb98a184e883
ff78c6dd-9973-46b7-a04a-56d5ef2a9485	2026-09-09 17:43:42.31623+00	2026-09-09 17:43:42.31623+00	otp	179eb688-e62f-4c37-975a-c2a66d22ce63
8f3c6a9e-556d-4c44-8917-6ce2db672214	2026-09-09 17:53:21.367606+00	2026-09-09 17:53:21.367606+00	password	ccd3f3c9-15d6-43d2-ae5c-6d6b15292479
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: mfa_recovery_code_sets; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_recovery_code_sets (id, user_id, mfa_factor_id, failed_verification_count, verification_locked_until, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_recovery_codes; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_recovery_codes (id, mfa_recovery_code_set_id, code_hash, consumed_at, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at, expires_at) FROM stdin;
8b124eba-ede9-4914-b6f9-7bde84048af7	ecf8ae09-72d2-4547-b40c-09615742c082	confirmation_token	e2ad2a93540ed215194314bec2ded647bda22b1c4d6a3e62637ad6c2	clementmaebela@gmail.com	2026-09-09 11:59:33.239218	2026-09-09 11:59:33.239218	\N
db7dbb11-ab87-4920-8ed4-e3452c49122d	3b7077bc-b9d6-4ffc-b2b9-74a6b6044f7c	confirmation_token	95c665270eaf8b8e54d7f4af0ca31900db336522d682f2d94480c505	mulaudzi@gmail.com	2026-09-09 17:32:13.789133	2026-09-09 17:32:13.789133	\N
ce269b00-7acb-48b6-bf88-b6d451c00ef0	e1b0f19a-c9cf-458d-91fc-38073221ac53	confirmation_token	1a9e8dfcba9ed0e90c62e50838a42b7644269694c7bd9dd70a8f4855	folet95486@airhemp.com	2026-09-11 13:28:01.720951	2026-09-11 13:28:01.720951	\N
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	683	xmajdi7u3txe	172652f0-c720-405e-a842-c737ecc5f9cb	f	2026-09-07 18:05:25.893032+00	2026-09-07 18:05:25.893032+00	\N	907dafb6-2bbf-4209-8938-eefe991ad865
00000000-0000-0000-0000-000000000000	739	giad6ihejoj2	322deaf8-c652-4e90-ae39-38c0aa185e38	f	2026-09-09 19:13:20.744552+00	2026-09-09 19:13:20.744552+00	\N	acad16bf-5e06-4362-a1e9-389bd719b01b
00000000-0000-0000-0000-000000000000	729	2g24nckbfkjq	172652f0-c720-405e-a842-c737ecc5f9cb	t	2026-09-09 18:28:31.399541+00	2026-09-09 19:39:46.280201+00	64rbfemknzzm	7d9c2c69-416f-4541-8322-0bcf093e49c4
00000000-0000-0000-0000-000000000000	684	d7x2h3vkzlvr	172652f0-c720-405e-a842-c737ecc5f9cb	t	2026-09-07 18:05:58.651322+00	2026-09-07 19:07:00.058331+00	\N	7d9c2c69-416f-4541-8322-0bcf093e49c4
00000000-0000-0000-0000-000000000000	740	cwhqhhpptrrx	172652f0-c720-405e-a842-c737ecc5f9cb	f	2026-09-09 19:39:46.314766+00	2026-09-09 19:39:46.314766+00	2g24nckbfkjq	7d9c2c69-416f-4541-8322-0bcf093e49c4
00000000-0000-0000-0000-000000000000	743	7t4kowpz5ipa	4bf09add-01d5-4358-9199-53662f131d8d	f	2026-09-11 13:30:42.411368+00	2026-09-11 13:30:42.411368+00	\N	1e33c248-cfdf-4ab8-b24c-9093da738be8
00000000-0000-0000-0000-000000000000	750	7jqgcvnyxflt	7144aa93-d014-48b9-a8fe-af41de8baf8f	f	2026-09-11 13:43:08.612457+00	2026-09-11 13:43:08.612457+00	\N	ce2a0bfa-66ae-4368-9394-bfa101ab53a6
00000000-0000-0000-0000-000000000000	748	ugf3ezh2k2h2	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	t	2026-09-11 13:41:01.374789+00	2026-09-15 21:44:30.497754+00	\N	1b162b8f-b98e-40b8-be94-63dd28338273
00000000-0000-0000-0000-000000000000	751	xsvkeumy6b7u	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	f	2026-09-15 21:44:30.520674+00	2026-09-15 21:44:30.520674+00	ugf3ezh2k2h2	1b162b8f-b98e-40b8-be94-63dd28338273
00000000-0000-0000-0000-000000000000	752	zqef4sxntfxv	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	f	2026-09-15 21:44:33.45876+00	2026-09-15 21:44:33.45876+00	\N	d2dc57b0-2d98-494e-9d61-470427f254df
00000000-0000-0000-0000-000000000000	693	imdn2iiqcqs4	172652f0-c720-405e-a842-c737ecc5f9cb	t	2026-09-07 19:07:00.087722+00	2026-09-09 17:27:52.999724+00	d7x2h3vkzlvr	7d9c2c69-416f-4541-8322-0bcf093e49c4
00000000-0000-0000-0000-000000000000	714	bus3xj36jfxo	322deaf8-c652-4e90-ae39-38c0aa185e38	f	2026-09-09 17:40:41.5857+00	2026-09-09 17:40:41.5857+00	\N	ee083012-c296-44f3-914f-dc2084e95dff
00000000-0000-0000-0000-000000000000	715	qjzyorxoajd2	fc0d4183-26a7-49ee-aa8b-c864ac60a689	f	2026-09-09 17:43:42.311672+00	2026-09-09 17:43:42.311672+00	\N	ff78c6dd-9973-46b7-a04a-56d5ef2a9485
00000000-0000-0000-0000-000000000000	721	rg5wnn4tpumb	18303ea7-fc4e-48d3-b73b-93d016816902	f	2026-09-09 17:53:21.366062+00	2026-09-09 17:53:21.366062+00	\N	8f3c6a9e-556d-4c44-8917-6ce2db672214
00000000-0000-0000-0000-000000000000	723	sywgozdc2aii	322deaf8-c652-4e90-ae39-38c0aa185e38	f	2026-09-09 17:57:19.281277+00	2026-09-09 17:57:19.281277+00	\N	bb871ed4-cffe-4189-8902-f158d4cebe21
00000000-0000-0000-0000-000000000000	724	n67g3ynou2hj	322deaf8-c652-4e90-ae39-38c0aa185e38	f	2026-09-09 17:57:26.890998+00	2026-09-09 17:57:26.890998+00	\N	18234c2c-83c8-439a-abc0-89cf9079885c
00000000-0000-0000-0000-000000000000	713	64rbfemknzzm	172652f0-c720-405e-a842-c737ecc5f9cb	t	2026-09-09 17:27:53.019611+00	2026-09-09 18:28:31.389283+00	imdn2iiqcqs4	7d9c2c69-416f-4541-8322-0bcf093e49c4
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
20260625000000
20260821000000
20260821010000
20260824000000
20260824000001
20260831180000
\.


--
-- Data for Name: scim_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.scim_tokens (id, sso_provider_id, token_hash, prefix, created_at, expires_at, revoked_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: scim_users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.scim_users (id, sso_provider_id, user_id, resource, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
ee083012-c296-44f3-914f-dc2084e95dff	322deaf8-c652-4e90-ae39-38c0aa185e38	2026-09-09 17:40:41.556635+00	2026-09-09 17:40:41.556635+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36	165.16.189.87	\N	\N	\N	\N	\N
ff78c6dd-9973-46b7-a04a-56d5ef2a9485	fc0d4183-26a7-49ee-aa8b-c864ac60a689	2026-09-09 17:43:42.309787+00	2026-09-09 17:43:42.309787+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36	196.21.218.222	\N	\N	\N	\N	\N
acad16bf-5e06-4362-a1e9-389bd719b01b	322deaf8-c652-4e90-ae39-38c0aa185e38	2026-09-09 19:13:20.7138+00	2026-09-09 19:13:20.7138+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	165.16.189.87	\N	\N	\N	\N	\N
8f3c6a9e-556d-4c44-8917-6ce2db672214	18303ea7-fc4e-48d3-b73b-93d016816902	2026-09-09 17:53:21.364832+00	2026-09-09 17:53:21.364832+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1	196.21.218.222	\N	\N	\N	\N	\N
7d9c2c69-416f-4541-8322-0bcf093e49c4	172652f0-c720-405e-a842-c737ecc5f9cb	2026-09-07 18:05:58.647703+00	2026-09-09 19:39:46.365769+00	\N	aal1	\N	2026-09-09 19:39:46.365642	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	41.126.7.149	\N	\N	\N	\N	\N
bb871ed4-cffe-4189-8902-f158d4cebe21	322deaf8-c652-4e90-ae39-38c0aa185e38	2026-09-09 17:57:19.274102+00	2026-09-09 17:57:19.274102+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36	165.16.189.87	\N	\N	\N	\N	\N
18234c2c-83c8-439a-abc0-89cf9079885c	322deaf8-c652-4e90-ae39-38c0aa185e38	2026-09-09 17:57:26.890015+00	2026-09-09 17:57:26.890015+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36	165.16.189.87	\N	\N	\N	\N	\N
1e33c248-cfdf-4ab8-b24c-9093da738be8	4bf09add-01d5-4358-9199-53662f131d8d	2026-09-11 13:30:42.393639+00	2026-09-11 13:30:42.393639+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	196.21.218.222	\N	\N	\N	\N	\N
907dafb6-2bbf-4209-8938-eefe991ad865	172652f0-c720-405e-a842-c737ecc5f9cb	2026-09-07 18:05:25.883555+00	2026-09-07 18:05:25.883555+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36	41.126.47.131	\N	\N	\N	\N	\N
ce2a0bfa-66ae-4368-9394-bfa101ab53a6	7144aa93-d014-48b9-a8fe-af41de8baf8f	2026-09-11 13:43:08.600973+00	2026-09-11 13:43:08.600973+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	196.21.218.222	\N	\N	\N	\N	\N
1b162b8f-b98e-40b8-be94-63dd28338273	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	2026-09-11 13:41:01.331803+00	2026-09-15 21:44:30.552442+00	\N	aal1	\N	2026-09-15 21:44:30.55233	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0	104.28.222.40	\N	\N	\N	\N	\N
d2dc57b0-2d98-494e-9d61-470427f254df	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	2026-09-15 21:44:33.440231+00	2026-09-15 21:44:33.440231+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0	104.28.222.40	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	322deaf8-c652-4e90-ae39-38c0aa185e38	authenticated	authenticated	mulaudzishaun688@gmail.com	$2a$10$dCOnnHOO2hyYT5qujmFC2ujMatp0nKwUQOuQ4HRWOfohE4lYCQbJq	2026-09-09 17:40:41.541123+00	\N		2026-09-09 17:39:47.635555+00		\N			\N	2026-09-09 19:13:20.710591+00	{"provider": "email", "providers": ["email"]}	{"sub": "322deaf8-c652-4e90-ae39-38c0aa185e38", "role": "provider", "email": "mulaudzishaun688@gmail.com", "full_name": "Shaun", "email_verified": true, "phone_verified": false}	\N	2026-09-09 17:39:47.597739+00	2026-09-09 19:13:20.747369+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	172652f0-c720-405e-a842-c737ecc5f9cb	authenticated	authenticated	kopanoananias22@gmail.com	$2a$10$cvBvFYnyi5B87ENzAJdY3.j0e6YQBr4VY9MP/yBbBHgzrpis1.O/6	2026-09-07 18:05:25.776338+00	\N		2026-09-07 18:04:27.208648+00		\N			\N	2026-09-07 18:05:58.647545+00	{"provider": "email", "providers": ["email"]}	{"sub": "172652f0-c720-405e-a842-c737ecc5f9cb", "role": "provider", "email": "kopanoananias22@gmail.com", "full_name": "ananias", "email_verified": true, "phone_verified": false}	\N	2026-09-07 18:04:27.202952+00	2026-09-09 19:39:46.33567+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3b7077bc-b9d6-4ffc-b2b9-74a6b6044f7c	authenticated	authenticated	mulaudzi@gmail.com	$2a$10$nhCtCLMx7j4pnstWb/LVn.Dwn5ckt7XtmJmrMsWaRalB/Lgjr2hI6	\N	\N	95c665270eaf8b8e54d7f4af0ca31900db336522d682f2d94480c505	2026-09-09 17:32:11.639451+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "3b7077bc-b9d6-4ffc-b2b9-74a6b6044f7c", "role": "client", "email": "mulaudzi@gmail.com", "full_name": "Shaun", "email_verified": false, "phone_verified": false}	\N	2026-09-09 17:32:11.547857+00	2026-09-09 17:32:13.78018+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ecf8ae09-72d2-4547-b40c-09615742c082	authenticated	authenticated	clementmaebela@gmail.com	$2a$10$4o2eeUCvr2plGBGf9apX0.BQT7uOfvQoZQHkhkFLtkDtdIXiEmUy2	\N	\N	e2ad2a93540ed215194314bec2ded647bda22b1c4d6a3e62637ad6c2	2026-09-09 11:59:32.053916+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "ecf8ae09-72d2-4547-b40c-09615742c082", "role": "client", "email": "clementmaebela@gmail.com", "full_name": "Thabo Mokoena", "email_verified": false, "phone_verified": false}	\N	2026-09-09 11:57:33.142738+00	2026-09-09 11:59:33.234829+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e1b0f19a-c9cf-458d-91fc-38073221ac53	authenticated	authenticated	folet95486@airhemp.com	$2a$10$WIQyTlJOH.AuTAnLpMB7QuhTlcaW5xu25vcmaHS80QqsZ2RKdMrVq	\N	\N	1a9e8dfcba9ed0e90c62e50838a42b7644269694c7bd9dd70a8f4855	2026-09-11 13:28:00.60296+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "e1b0f19a-c9cf-458d-91fc-38073221ac53", "role": "client", "email": "folet95486@airhemp.com", "full_name": "folet95486@airhemp.com", "email_verified": false, "phone_verified": false}	\N	2026-09-11 13:28:00.57129+00	2026-09-11 13:28:01.718889+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	7144aa93-d014-48b9-a8fe-af41de8baf8f	authenticated	authenticated	sambomphile258@gmail.com	$2a$10$7k3ZB//BamgcmtGQwa0xDucF.M4nVtw9eZpKYGNThfo5ncsHTSLlS	2026-09-09 18:34:13.943367+00	\N		2026-09-09 18:33:39.929236+00		\N			\N	2026-09-11 13:43:08.600836+00	{"provider": "email", "providers": ["email"]}	{"sub": "7144aa93-d014-48b9-a8fe-af41de8baf8f", "role": "client", "email": "sambomphile258@gmail.com", "full_name": "Nkosingiphile", "email_verified": true, "phone_verified": false}	\N	2026-09-09 18:33:39.892555+00	2026-09-11 13:43:08.617536+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	1f49d8c3-a080-424d-aeb0-d403a4dc953e	authenticated	authenticated	wefora5609@airhemp.com	$2a$10$IVQVLdMAuQ6CdF7ypHctTedioadQws63S0WA2PHinG9vpypwWmGo.	2026-09-11 13:26:10.768676+00	\N		2026-09-11 13:25:52.385202+00		\N			\N	2026-09-11 13:37:24.147341+00	{"provider": "email", "providers": ["email"]}	{"sub": "1f49d8c3-a080-424d-aeb0-d403a4dc953e", "role": "provider", "email": "wefora5609@airhemp.com", "full_name": "wefora5609@airhemp.com", "email_verified": true, "phone_verified": false}	\N	2026-09-11 13:25:52.193899+00	2026-09-11 13:37:24.167018+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	51763d35-9b2a-4bd7-a4c9-4039abcd90cc	authenticated	authenticated	group14cos300@gmail.com	$2a$10$QhlRQYvCjmkRh2i0k3VMs.YDXphjEfuXCleGsI9N7owYRR.KzI.lu	2026-09-05 19:05:35.372156+00	\N		2026-09-05 19:04:58.476189+00		\N			\N	2026-09-11 13:42:11.701345+00	{"provider": "email", "providers": ["email"]}	{"sub": "51763d35-9b2a-4bd7-a4c9-4039abcd90cc", "role": "client", "email": "group14cos300@gmail.com", "full_name": "admin", "email_verified": true, "phone_verified": false}	\N	2026-09-05 19:04:58.454435+00	2026-09-11 13:42:11.71461+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	fc0d4183-26a7-49ee-aa8b-c864ac60a689	authenticated	authenticated	ndilenifransina@gmail.com	$2a$10$N8U22yBhQkUJ25jXdJfcCuclFJxDWA78lLW2tLeV1nh9TtA5UATy2	2026-09-09 17:43:42.302945+00	\N		2026-09-09 17:43:12.039985+00		\N			\N	2026-09-09 17:43:42.309633+00	{"provider": "email", "providers": ["email"]}	{"sub": "fc0d4183-26a7-49ee-aa8b-c864ac60a689", "role": "client", "email": "ndilenifransina@gmail.com", "full_name": "Ndileni", "email_verified": true, "phone_verified": false}	\N	2026-09-09 17:43:11.993602+00	2026-09-09 17:43:42.315635+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	authenticated	authenticated	sambomphile258@outlook.com	$2a$10$frqjPWltZxcNQ31SS2e.jOm2DDEXAhaxXmK8U4n0CPB.EnPWa6cX2	2026-09-05 19:03:54.369441+00	\N		2026-09-05 19:02:57.231935+00		\N			\N	2026-09-15 21:44:33.440135+00	{"provider": "email", "providers": ["email"]}	{"sub": "8db5eff3-7ff2-4eb6-9918-7b076ef1bc93", "role": "provider", "email": "sambomphile258@outlook.com", "full_name": "nkosingiphile", "email_verified": true, "phone_verified": false}	\N	2026-09-05 19:02:57.209077+00	2026-09-15 21:44:33.459999+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	18303ea7-fc4e-48d3-b73b-93d016816902	authenticated	authenticated	harhimongwe@gmail.com	$2a$10$Y8eOxtzE6Bexq8zbCezXP.W481kX6Kx0U/IzKUTSAqZxxMsHCuJIm	2026-09-07 18:05:58.886249+00	\N		2026-09-07 18:04:21.297079+00		\N			\N	2026-09-09 17:53:21.364728+00	{"provider": "email", "providers": ["email"]}	{"sub": "18303ea7-fc4e-48d3-b73b-93d016816902", "role": "client", "email": "harhimongwe@gmail.com", "full_name": "Harhi Mongwe ", "email_verified": true, "phone_verified": false}	\N	2026-09-07 18:04:21.263443+00	2026-09-09 17:53:21.367175+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c0bc5412-8793-4a43-8bf5-de0f1aff2914	authenticated	authenticated	raedanindileni@gmail.com	$2a$10$dnom/.eMiygccaLlUnR5TuUyCobRBM3JkOfAJxp1MmNdVKLQ4YvKW	2026-09-09 17:59:03.032356+00	\N		2026-09-09 17:57:00.643018+00		\N			\N	2026-09-09 18:22:20.229417+00	{"provider": "email", "providers": ["email"]}	{"sub": "c0bc5412-8793-4a43-8bf5-de0f1aff2914", "role": "provider", "email": "raedanindileni@gmail.com", "full_name": "Ndileni", "email_verified": true, "phone_verified": false}	\N	2026-09-09 17:57:00.582076+00	2026-09-09 18:22:20.290931+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4bf09add-01d5-4358-9199-53662f131d8d	authenticated	authenticated	jefero2661@airhemp.com	$2a$10$t9/pgasUdzHEITL2V8d9FOlkvJ7NSloVAXY0ZFBH7PHTinakM94x.	2026-09-11 13:30:42.360809+00	\N		2026-09-11 13:30:26.581287+00		\N			\N	2026-09-11 13:30:42.391973+00	{"provider": "email", "providers": ["email"]}	{"sub": "4bf09add-01d5-4358-9199-53662f131d8d", "role": "client", "email": "jefero2661@airhemp.com", "full_name": "jefero2661@airhemp.com", "email_verified": true, "phone_verified": false}	\N	2026-09-11 13:30:26.552829+00	2026-09-11 13:30:42.414918+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3d104c94-3cce-4ed3-a8c8-59f675d1806a	authenticated	authenticated	tadale1848@airhemp.com	$2a$10$6VHeWvI5t/gRZ6jvMBGD8usjzkyXrmyKKsD4mhGLJO9EIECVabPOe	2026-09-11 13:32:18.460982+00	\N		2026-09-11 13:32:06.142267+00		\N			\N	2026-09-11 13:35:58.760453+00	{"provider": "email", "providers": ["email"]}	{"sub": "3d104c94-3cce-4ed3-a8c8-59f675d1806a", "role": "provider", "email": "tadale1848@airhemp.com", "full_name": "tadale1848@airhemp.com", "email_verified": true, "phone_verified": false}	\N	2026-09-11 13:32:06.090612+00	2026-09-11 13:35:58.779995+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, provider_id, file_path, file_name, doc_type, status, reviewed_by, review_notes, created_at) FROM stdin;
ab1eaec4-a982-4f5a-805b-62e1e12beb92	bbf3da2a-df84-4ad6-8b21-9e1645233773	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93/1788635558284-Business name.pdf	Business name.pdf	application/pdf	approved	\N	\N	2026-09-05 19:12:39.524377+00
6d0e17e8-ecd0-4e49-b369-878ef445b36a	db4bbf8f-35d6-4b13-883f-2a1bd84d987a	172652f0-c720-405e-a842-c737ecc5f9cb/1788804675788-2026_SRS_Template.pdf	2026_SRS_Template.pdf	application/pdf	approved	\N	\N	2026-09-07 18:11:23.012113+00
2fb92a25-aa58-4cb8-9397-a6588df809c1	65b23554-ddf9-40ad-9951-9957b689bedb	322deaf8-c652-4e90-ae39-38c0aa185e38/1788977422551-DOC-20260909-WA0061.pdf	DOC-20260909-WA0061.pdf	application/pdf	pending	\N	\N	2026-09-09 18:10:24.732939+00
526d3bc5-53dd-401b-9d6f-abd0803faa05	deefe7b0-ab33-4d1a-824b-c988ef5d75c8	c0bc5412-8793-4a43-8bf5-de0f1aff2914/1788977749192-2024-Undergraduate-Student-Information-Brochure-final-2-003.pdf	2024-Undergraduate-Student-Information-Brochure-final-2-003.pdf	application/pdf	pending	\N	\N	2026-09-09 18:15:54.588994+00
\.


--
-- Data for Name: email_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_logs (id, recipient, subject, status, service, error_message, sent_at, created_at) FROM stdin;
\.


--
-- Data for Name: email_queue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_queue (id, user_id, email, notification_id, title, message, status, created_at, sent_at, error_message) FROM stdin;
3b2b00a6-66e6-4ebb-9147-68b78308a771	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	026eef5e-846f-41aa-af89-8dd988b9e727	New Message	You have a new message.	failed	2026-09-05 22:31:44.121052+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
0ad8199f-14be-4e34-a911-c71ef0836e9b	51763d35-9b2a-4bd7-a4c9-4039abcd90cc	group14cos300@gmail.com	14fc906f-578f-4277-b7c3-3f9228944d39	Test Email Notification	This is a test email to verify the MatchWise notification system is working correctly.	sent	2026-09-05 22:42:48.74484+00	2026-09-05 22:44:03.028+00	\N
6f52b230-b12b-49bb-b185-b897f8ec046c	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	0c6e0ff1-218c-4c3b-aa37-c223c04fed1c	New Message	You have a new message.	failed	2026-09-06 18:22:03.124626+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
63188635-485b-4869-9419-bd9864fd0033	378f6028-c32c-49eb-baf3-3f7bc0a67f45	\N	0f14f2f6-d2f8-4423-a19c-c623c14108fb	Test Notification	This is a test email notification	failed	2026-09-05 12:44:18.429495+00	\N	No email address
dfc5835a-dfbb-4677-8497-1b3e653cc683	378f6028-c32c-49eb-baf3-3f7bc0a67f45	nkosingiphile@mail.com	8fb73528-c70d-4b1a-9382-e989b5af37c9	Test Email	Testing email notification with address	failed	2026-09-05 12:46:13.583327+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
012640cf-6b9d-4e5b-b6a8-78e35b9a6e5b	23c63ea8-dd8f-4f61-85ce-b52bcc930848	provider2@mail.com	5b49302a-7868-4570-b6f1-7564f4a22d35	New Message	You have a new message.	failed	2026-09-05 12:46:59.731194+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
78819fc4-3731-4f06-90cc-e65b3d8d584b	ae21b781-c45b-4ebc-bda5-a0de01539597	sambomphile258@outlook.com	bef225f4-b6e9-4a10-86d6-f69454b5fffe	Test Email Notification	This is a test email notification from MatchWise	failed	2026-09-05 12:50:36.783472+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
2ff024e5-caed-4578-918f-c9c2c327d1e1	ae21b781-c45b-4ebc-bda5-a0de01539597	sambomphile258@outlook.com	75c501da-9783-4e68-89c2-bf33759b9b5c	New Message	You have a new message.	failed	2026-09-05 12:47:47.896001+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
5e2145c4-6ea5-49e6-9b4f-11cc33dd33c3	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	99200ad4-04b7-4dad-8245-85de5bf526e2	New Message	You have a new message.	failed	2026-09-05 22:15:44.049316+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
37660906-b4ce-477f-8569-3c9741adf13c	378f6028-c32c-49eb-baf3-3f7bc0a67f45	nkosingiphile@mail.com	5f7b0864-1bc8-47e7-8609-ce0663de41d2	Test Notification	This is a test email notification	failed	2026-09-05 12:38:55.58784+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
a1a25464-6ceb-4f86-9e2a-c63970da3687	51763d35-9b2a-4bd7-a4c9-4039abcd90cc	group14cos300@gmail.com	0e098a9e-930d-4fe2-bd49-f9f3f170f157	Test SendGrid Email	This test verifies SendGrid integration is working correctly!	sent	2026-09-06 18:54:07.10873+00	2026-09-06 18:59:29.467+00	\N
4d838130-6249-4bc0-8f31-7568f3e94356	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	1f58c18f-a99f-4349-834d-af5c3684495c	New Message	You have a new message.	sent	2026-09-06 19:03:58.32576+00	2026-09-06 20:14:55.268+00	\N
2ec6d4eb-897f-4605-b86c-ff56adf18c72	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	aae76056-af5f-4ccf-9de5-44a72c664375	Service Completed	Dr Khoza Surgery has marked this service as completed.	sent	2026-09-06 21:03:06.128213+00	2026-09-06 21:10:41.775+00	\N
65ca5fe4-bafa-45fa-9a4c-7cd0617af715	5bb65515-a2c0-4041-ab2f-ee2e464826d6	sambomphile258@gmail.com	39f5001d-df5e-4668-948f-bc8e8aa56a11	Request Accepted!	Ranku business has accepted your service request. You can now start chatting.	sent	2026-09-07 19:07:56.874061+00	2026-09-07 19:10:02.76+00	\N
b42fbbf2-cb21-4079-8b0e-bb86df0a597f	5bb65515-a2c0-4041-ab2f-ee2e464826d6	sambomphile258@gmail.com	3ca1d0ec-32bc-4bfe-b2a4-1fccbc6cab3b	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	sent	2026-09-09 10:03:58.038395+00	2026-09-09 10:05:02.033+00	\N
9513827f-dad4-4674-878e-3a2691d9f773	26191d12-37f5-4dd3-b8b3-cc8baf215cbd	group14cos300@gmail.com	c17726b5-8f7f-4aa1-b76a-d01889e41fc1	Test Email Notification	This is a test email notification from MatchWise	sent	2026-09-05 12:58:32.683504+00	2026-09-05 12:59:26.81+00	\N
757529fe-9e4e-4eff-bbea-d8ab6daf0c6a	5bb65515-a2c0-4041-ab2f-ee2e464826d6	sambomphile258@gmail.com	a321d79d-37e6-401f-b23b-daa18167f192	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	sent	2026-09-09 13:35:22.395433+00	2026-09-09 13:40:03.887+00	\N
33183600-276a-403b-a764-25d7c1c9e43d	5bb65515-a2c0-4041-ab2f-ee2e464826d6	sambomphile258@gmail.com	8b05695a-0a0d-4b70-a254-b44251f57844	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	sent	2026-09-09 13:44:53.149891+00	2026-09-09 13:45:04.302+00	\N
b6d77809-9660-45e0-8e72-94c4872d895b	5bb65515-a2c0-4041-ab2f-ee2e464826d6	sambomphile258@gmail.com	262aaa42-dd4a-4d2d-9f2c-6e1de3a1d513	Service Cancelled	Dr Khoza Surgery has cancelled this service request.	sent	2026-09-09 14:25:20.466705+00	2026-09-09 14:30:05.548+00	\N
9ab21c3b-25e5-45b3-88f3-a1a6793fcb1c	26191d12-37f5-4dd3-b8b3-cc8baf215cbd	group14cos300@gmail.com	afef6e86-7a43-4a98-9cd6-cc12277c4d08	Request Accepted!	Learning Academy has accepted your service request. You can now start chatting.	sent	2026-09-05 13:29:20.005208+00	2026-09-05 13:32:01.112+00	\N
b91a5386-8532-4cb2-8970-9f7d14d47583	26191d12-37f5-4dd3-b8b3-cc8baf215cbd	group14cos300@gmail.com	32b46c0b-bb88-453b-b447-d04ae37fb0b2	New Message	You have a new message.	sent	2026-09-05 13:27:39.954295+00	2026-09-05 13:32:01.124+00	\N
d3e835bf-c199-4186-8a8c-eec153b5c837	7144aa93-d014-48b9-a8fe-af41de8baf8f	sambomphile258@gmail.com	96929679-1778-4272-9e6d-3ab5de80fb91	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	sent	2026-09-11 13:44:41.288402+00	2026-09-11 13:45:02.853+00	\N
4c679557-e66e-4342-b992-a598b3d57921	378f6028-c32c-49eb-baf3-3f7bc0a67f45	nkosingiphile@mail.com	b0924130-eb2c-4bd1-b3f5-b4cd591cb069	Test Notification	This is a test email notification	failed	2026-09-05 12:38:19.923474+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
e920a96c-d954-4fe0-bd0f-321176ebe639	26191d12-37f5-4dd3-b8b3-cc8baf215cbd	group14cos300@gmail.com	2f4cd8bd-ad41-40f1-8780-a63617e39564	New Message	You have a new message.	sent	2026-09-05 13:29:59.158084+00	2026-09-05 13:32:01.138+00	\N
c1958ada-6bf0-4670-a41b-304ecd803137	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	2f8128f9-bee2-4242-9343-382418abb8f7	New Message	You have a new message.	failed	2026-09-05 20:50:15.46191+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
544e2bab-b783-4e83-9cbb-4f9e9aa09921	ae21b781-c45b-4ebc-bda5-a0de01539597	sambomphile258@outlook.com	68e40c4e-a6be-4318-8787-9a6e87b0960c	New Message	You have a new message.	failed	2026-09-05 13:12:57.640358+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
ffce5ab9-d7fa-4686-bb1d-65f3230d2c8e	23c63ea8-dd8f-4f61-85ce-b52bcc930848	provider2@mail.com	5af1b02a-7c53-4abe-bf80-d68861dd9327	New Service Request	You have received a new service request. Check your dashboard to respond.	failed	2026-09-05 13:13:45.711056+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
1f32454e-fc37-4b3c-a9c4-3bc2d4169908	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	9e81f804-f6f7-445e-9343-73411257bda5	New Message	You have a new message.	failed	2026-09-05 22:15:49.861344+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
3560ce11-8e67-43e6-8a2d-1461363df121	378f6028-c32c-49eb-baf3-3f7bc0a67f45	nkosingiphile@mail.com	42d354c9-5e45-48ad-9744-fa8411ca6f55	Test Email	Testing email notification with address	failed	2026-09-05 12:46:16.03999+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
a9fed031-bf6b-4e54-9771-18d46fb224c5	378f6028-c32c-49eb-baf3-3f7bc0a67f45	nkosingiphile@mail.com	099bb2c1-adf5-454c-85e3-e88775126025	Test Notification	This is a test email notification	failed	2026-09-05 12:35:25.918853+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
11c9d0f6-c1c8-4161-90d1-6074ca3652bb	23c63ea8-dd8f-4f61-85ce-b52bcc930848	provider2@mail.com	27467adc-1717-4d40-b29d-dfd7a631bc19	New Message	You have a new message.	failed	2026-09-05 13:27:25.026977+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
520cbae9-022f-408b-bf17-86214dab07c1	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	909f3ded-997d-41f7-aa53-fd2c3a005ab9	New Message	You have a new message.	failed	2026-09-05 22:34:49.187471+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
dbd4d9ca-a065-403e-9f1d-e1db57b96bb8	23c63ea8-dd8f-4f61-85ce-b52bcc930848	provider2@mail.com	742ebf9f-8355-4d62-8fba-982f87681223	New Message	You have a new message.	failed	2026-09-05 13:25:38.702463+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
914605df-00fc-4569-8093-a4e826867436	ae21b781-c45b-4ebc-bda5-a0de01539597	sambomphile258@outlook.com	021dd895-1026-41a1-8ad9-40c1276e56c4	Test Email Notification	This is a test email notification from MatchWise	failed	2026-09-05 12:53:53.184083+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
f953fda6-ea09-45b2-b275-d5ac342a2375	ae21b781-c45b-4ebc-bda5-a0de01539597	sambomphile258@outlook.com	54336e2b-e9f4-4891-8ac5-373bf6226e5f	Test Email Notification	This is a test email notification from MatchWise	failed	2026-09-05 12:55:33.153181+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
3f155f1c-c274-4a65-9eda-f406ad4d6bb0	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	08f9fc97-fa34-4138-96f6-56d29c6cd61a	New Message	You have a new message.	failed	2026-09-05 22:45:35.805276+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
54b6b1db-1e8e-42f2-8e47-174815926e79	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	eff3d859-78e5-42c5-99c2-ba9a0b893049	New Message	You have a new message.	failed	2026-09-05 22:45:45.348666+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
ae92df73-a971-4fe3-aba0-2c67e0a27b5e	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	7b0dbe56-b7a1-4435-9be7-bf1d70879b91	New Message	You have a new message.	failed	2026-09-06 18:50:24.217215+00	\N	SendGrid API error: {"errors":[{"message":"The from object must be provided for every email send. It is an object that requires the email parameter, but may also contain a name parameter.  e.g. {\\"email\\" : \\"example@example.com\\"}  or {\\"email\\" : \\"example@example.com\\", \\"name\\" : \\"Example Recipient\\"}.","field":"from.email","help":"http://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/errors.html#message.from"},{"message":"Unless a valid template_id is provided, the content parameter is required. There must be at least one defined content block. We typically suggest both text/plain and text/html blocks are included, but only one block is required.","field":"content","help":"http://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/errors.html#message.content"}]}
391112da-f1dc-4b8b-b75e-6678aab83c1b	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	c069b2b9-b124-4086-9834-75a285b5b3fe	New Message	You have a new message.	failed	2026-09-05 20:39:41.588036+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
8f0f149a-1ed0-444b-966b-4a899c5d8e6a	ae21b781-c45b-4ebc-bda5-a0de01539597	sambomphile258@outlook.com	d081e510-8636-4fe2-b20b-3a7c9ab2e86a	Test Email Notification	This is a test email notification from MatchWise	failed	2026-09-05 12:53:57.315834+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
cffdd246-f931-4f8e-a560-96b4e62184a6	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	3eccaa03-5203-429b-bb9a-a294a8f96b14	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	failed	2026-09-05 20:39:07.899116+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
970a56d5-db69-43dc-8990-f0222cdc9c06	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	233e0edc-fa45-4fab-8b0a-eeac4d368df5	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	failed	2026-09-05 21:16:52.213436+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
fc360862-a339-47da-96cd-c357951f621a	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	d9854222-07b3-4257-a748-0fbc4668d26c	New Message	You have a new message.	failed	2026-09-05 21:53:24.207506+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
907fd9fb-6f3c-4e19-8357-766e45ecc6b1	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	ec71d061-69c0-4908-ab30-fc91257a0b4f	New Message	You have a new message.	failed	2026-09-05 21:18:12.090555+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
15fb2465-9aab-4d6b-95e5-fa04e003b73c	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	0208394b-09d3-4f61-8cb8-8df4b35026b7	New Message	You have a new message.	failed	2026-09-05 21:48:33.655564+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
302fa7b4-634e-4e26-a172-a07327fca2de	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	d695fa8e-2079-4e3b-ac32-e22900e5d23d	New Message	You have a new message.	failed	2026-09-05 21:18:43.389628+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
67fcc2fe-4f7f-46b9-844d-74191560777c	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	dcfb8511-a47f-4782-aceb-26e005f5d522	New Message	You have a new message.	failed	2026-09-05 20:50:32.634903+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
e7600319-2344-402d-b597-3294b722899a	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	3c435f68-1755-4d86-915f-9733c434cd0c	New Message	You have a new message.	failed	2026-09-05 21:49:11.912739+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
6106463b-ade2-49ac-baf1-639395585cb1	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	0d01f918-cd05-4fbd-9174-1bedc86530ad	New Message	You have a new message.	failed	2026-09-05 21:17:50.115766+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
0e9664d9-ee2e-4bf9-8fa1-34ca855a3a6a	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	33372e6a-ce16-45ac-84fb-192e9c51e079	New Message	You have a new message.	failed	2026-09-05 21:53:52.702302+00	\N	Resend API error: {"statusCode":403,"message":"The gmail.com domain is not verified. Please, add and verify your domain on https://resend.com/domains","name":"validation_error"}
c1e1a659-3f72-46f1-9541-8d75dffba60d	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	01426d95-3dba-473e-ac2c-2b2f6d2694b6	New Message	You have a new message.	failed	2026-09-05 22:36:01.123662+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
4de95395-b975-48be-8455-c9914ed58f5c	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	601d8669-fe47-4004-8d2d-e928b271b2ef	New Message	You have a new message.	failed	2026-09-06 18:16:12.739402+00	\N	Resend API error: {"statusCode":403,"name":"validation_error","message":"You can only send testing emails to your own email address (group14cos300@gmail.com). To send emails to other recipients, please verify a domain at resend.com/domains, and change the `from` address to an email using this domain."}
e6540d98-95ca-4e3a-9601-beb08a0d706c	51763d35-9b2a-4bd7-a4c9-4039abcd90cc	group14cos300@gmail.com	ce2d4b05-91d7-4227-ac98-4241bfbc2c9e	Test SendGrid Any Email	This test proves SendGrid can send to any email address, not just verified accounts!	sent	2026-09-06 18:53:08.97681+00	2026-09-06 18:59:29.461+00	\N
a19770d3-9ba0-4ac8-b090-fc5cda3efba4	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	sambomphile258@outlook.com	41fb6984-cc49-4a65-aea9-8d07cc426431	New Message	You have a new message.	sent	2026-09-06 19:02:02.6758+00	2026-09-06 19:02:07.814+00	\N
ebe7e99b-4db7-46bd-84aa-4f2067d90d01	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	b8e82fbd-e444-48f1-89d9-4a79e4a22b65	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	sent	2026-09-06 20:53:21.704016+00	2026-09-06 21:10:41.667+00	\N
d6901aea-43ef-464c-b87c-9e5cdcd2b483	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	c295f41f-0fbb-4c18-96a1-ff935a10d816	New Message	You have a new message.	sent	2026-09-06 21:23:05.966634+00	2026-09-06 21:25:02.201+00	\N
410e9310-be3a-4924-852f-77a8e939c7f4	0eef229f-836e-4d1d-859b-94a3e4ee1a2d	sambomphile258@gmail.com	99fbfe2e-8f01-4379-b677-aa8c2c79cfbf	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	sent	2026-09-06 21:22:52.226733+00	2026-09-06 21:25:02.351+00	\N
eeb28274-9445-4a15-9cc7-404e785451e7	172652f0-c720-405e-a842-c737ecc5f9cb	kopanoananias22@gmail.com	2e4cea00-762f-4cc1-8604-24a595ec1d44	New Message	You have a new message.	sent	2026-09-07 19:09:28.895141+00	2026-09-07 19:10:02.705+00	\N
430b1e58-cd1f-4034-95ce-c1306d1d6eb4	5bb65515-a2c0-4041-ab2f-ee2e464826d6	sambomphile258@gmail.com	e48efd4a-735b-44fb-a5c7-5981928f88b1	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	sent	2026-09-09 13:30:36.309605+00	2026-09-09 13:35:02.333+00	\N
9522924e-2e1c-4ade-a05d-cc8a258aac99	5bb65515-a2c0-4041-ab2f-ee2e464826d6	sambomphile258@gmail.com	31ef0855-4480-40c0-b05c-fb5a5e36777e	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	sent	2026-09-09 13:37:47.275858+00	2026-09-09 13:40:03.961+00	\N
18ae3bc5-256c-45ca-b292-402fb79de05b	5bb65515-a2c0-4041-ab2f-ee2e464826d6	sambomphile258@gmail.com	fdb491d8-7e93-46d5-83eb-91a74c635545	Request Declined	Dr Khoza Surgery has declined your service request.	sent	2026-09-09 14:25:00.801586+00	2026-09-09 14:25:03.227+00	\N
a25fdabe-9536-41ed-ae02-db04da57d64b	5bb65515-a2c0-4041-ab2f-ee2e464826d6	sambomphile258@gmail.com	cb3c192e-254e-4c2b-af66-94fd6fa876ff	Service Cancelled	Dr Khoza Surgery has cancelled this service request.	sent	2026-09-09 14:25:15.645339+00	2026-09-09 14:30:05.443+00	\N
ef21612a-aa9e-4996-91b3-4e675c2fbbf3	7144aa93-d014-48b9-a8fe-af41de8baf8f	sambomphile258@gmail.com	3fac3d20-3621-4dda-a07b-3a24c87e60b3	New Message	You have a new message.	sent	2026-09-11 13:45:45.563135+00	2026-09-11 13:50:02.322+00	\N
\.


--
-- Data for Name: favorite_providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorite_providers (id, client_id, provider_id, created_at) FROM stdin;
6af192ba-5468-4beb-9701-63de4fe524eb	7144aa93-d014-48b9-a8fe-af41de8baf8f	bbf3da2a-df84-4ad6-8b21-9e1645233773	2026-09-11 13:53:21.271085+00
\.


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matches (id, request_id, provider_id, score, reason, created_at, inquiry_status, inquiry_message, inquiry_preferred_date, inquiry_requested_at) FROM stdin;
db25c8dc-90d5-4512-8f89-8ec6264095fc	5195eb3e-59fd-4c72-b75c-fc4bce6e8d1c	bbf3da2a-df84-4ad6-8b21-9e1645233773	95.00	This provider is a 'Medical Practisioner', which directly matches the client's need for help due to being sick. It is the only relevant provider among the given options.	2026-09-11 13:43:58.901425+00	accepted	are you available on weekend	\N	2026-09-11 13:44:21.871+00
1cca8ca9-0170-44b2-a662-39c546e9e3bb	5e5225af-e2e3-4ced-a56e-f515e65a5229	bbf3da2a-df84-4ad6-8b21-9e1645233773	100.00	Direct request from favorite providers	2026-09-11 13:53:36.898639+00	requested	hutrutrurturt	\N	2026-09-11 13:53:38.381+00
eb09045e-05a4-4bde-847a-6c7dc8d38a7e	c9eea694-5fda-43ff-abaf-52cfc433f69f	bbf3da2a-df84-4ad6-8b21-9e1645233773	30.00	Dr Khoza Surgery is a medical practitioner, directly matching the 'doctor' service type, and is located in Limpopo (Polokwane is in Limpopo). This makes them a relevant match for service and location. However, the provider is currently offline, which significantly reduces their immediate suitability for a client who 'needs' a doctor.	2026-09-07 18:08:25.944119+00	none	\N	\N	\N
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, match_id, sender_id, message, read, created_at, updated_at) FROM stdin;
750bcc7b-a3cb-410a-9cfe-92db949fe6d5	db25c8dc-90d5-4512-8f89-8ec6264095fc	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	hi	f	2026-09-11 13:45:44.8267+00	2026-09-11 13:45:44.8267+00
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, type, title, message, read, metadata, created_at, updated_at) FROM stdin;
14fc906f-578f-4277-b7c3-3f9228944d39	51763d35-9b2a-4bd7-a4c9-4039abcd90cc	info	Test Email Notification	This is a test email to verify the MatchWise notification system is working correctly.	t	{"test": true, "timestamp": "2026-09-06", "verified_email_test": true}	2026-09-05 22:42:48.74484+00	2026-09-07 18:01:48.417944+00
ce2d4b05-91d7-4227-ac98-4241bfbc2c9e	51763d35-9b2a-4bd7-a4c9-4039abcd90cc	info	Test SendGrid Any Email	This test proves SendGrid can send to any email address, not just verified accounts!	t	{}	2026-09-06 18:53:08.97681+00	2026-09-07 18:01:48.417944+00
0e098a9e-930d-4fe2-bd49-f9f3f170f157	51763d35-9b2a-4bd7-a4c9-4039abcd90cc	info	Test SendGrid Email	This test verifies SendGrid integration is working correctly!	t	{}	2026-09-06 18:54:07.10873+00	2026-09-07 18:01:48.417944+00
2e4cea00-762f-4cc1-8604-24a595ec1d44	172652f0-c720-405e-a842-c737ecc5f9cb	info	New Message	You have a new message.	t	{"match_id": "fa785cab-82cf-4b59-afcf-cd06c98376f6"}	2026-09-07 19:09:28.895141+00	2026-09-09 17:41:07.055599+00
3fac3d20-3621-4dda-a07b-3a24c87e60b3	7144aa93-d014-48b9-a8fe-af41de8baf8f	info	New Message	You have a new message.	f	{"match_id": "db25c8dc-90d5-4512-8f89-8ec6264095fc"}	2026-09-11 13:45:45.563135+00	2026-09-11 13:45:45.563135+00
96929679-1778-4272-9e6d-3ab5de80fb91	7144aa93-d014-48b9-a8fe-af41de8baf8f	success	Request Accepted!	Dr Khoza Surgery has accepted your service request. You can now start chatting.	t	{"match_id": "db25c8dc-90d5-4512-8f89-8ec6264095fc", "provider_id": "bbf3da2a-df84-4ad6-8b21-9e1645233773"}	2026-09-11 13:44:41.288402+00	2026-09-11 13:46:14.709307+00
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, full_name, email, phone, location, avatar_url, created_at, updated_at) FROM stdin;
51763d35-9b2a-4bd7-a4c9-4039abcd90cc	admin	group14cos300@gmail.com	\N	\N	\N	2026-09-05 19:04:58.454108+00	2026-09-05 19:04:58.454108+00
8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	nkosingiphile	sambomphile258@outlook.com	\N	\N	\N	2026-09-05 19:02:57.208709+00	2026-09-05 19:02:57.208709+00
18303ea7-fc4e-48d3-b73b-93d016816902	Harhi Mongwe 	harhimongwe@gmail.com	\N	\N	\N	2026-09-07 18:04:21.255831+00	2026-09-07 18:04:21.255831+00
172652f0-c720-405e-a842-c737ecc5f9cb	ananias	kopanoananias22@gmail.com	\N	\N	\N	2026-09-07 18:04:27.200029+00	2026-09-07 18:04:27.200029+00
ecf8ae09-72d2-4547-b40c-09615742c082	Thabo Mokoena	clementmaebela@gmail.com	\N	\N	\N	2026-09-09 11:57:33.136736+00	2026-09-09 11:57:33.136736+00
3b7077bc-b9d6-4ffc-b2b9-74a6b6044f7c	Shaun	mulaudzi@gmail.com	\N	\N	\N	2026-09-09 17:32:11.543669+00	2026-09-09 17:32:11.543669+00
322deaf8-c652-4e90-ae39-38c0aa185e38	Shaun	mulaudzishaun688@gmail.com	\N	\N	\N	2026-09-09 17:39:47.593348+00	2026-09-09 17:39:47.593348+00
fc0d4183-26a7-49ee-aa8b-c864ac60a689	Ndileni	ndilenifransina@gmail.com	\N	\N	\N	2026-09-09 17:43:11.988826+00	2026-09-09 17:43:11.988826+00
c0bc5412-8793-4a43-8bf5-de0f1aff2914	Ndileni	raedanindileni@gmail.com	\N	\N	\N	2026-09-09 17:57:00.57921+00	2026-09-09 17:57:00.57921+00
7144aa93-d014-48b9-a8fe-af41de8baf8f	Nkosingiphile	sambomphile258@gmail.com	\N	\N	\N	2026-09-09 18:33:39.888532+00	2026-09-09 18:33:39.888532+00
1f49d8c3-a080-424d-aeb0-d403a4dc953e	wefora5609@airhemp.com	wefora5609@airhemp.com	\N	\N	\N	2026-09-11 13:25:52.190425+00	2026-09-11 13:25:52.190425+00
e1b0f19a-c9cf-458d-91fc-38073221ac53	folet95486@airhemp.com	folet95486@airhemp.com	\N	\N	\N	2026-09-11 13:28:00.564786+00	2026-09-11 13:28:00.564786+00
4bf09add-01d5-4358-9199-53662f131d8d	jefero2661@airhemp.com	jefero2661@airhemp.com	\N	\N	\N	2026-09-11 13:30:26.550359+00	2026-09-11 13:30:26.550359+00
3d104c94-3cce-4ed3-a8c8-59f675d1806a	tadale1848@airhemp.com	tadale1848@airhemp.com	\N	\N	\N	2026-09-11 13:32:06.086619+00	2026-09-11 13:32:06.086619+00
\.


--
-- Data for Name: provider_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provider_reports (id, match_id, provider_id, client_id, report_text, status, admin_notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ratings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ratings (id, provider_id, client_id, rating, comment, created_at) FROM stdin;
\.


--
-- Data for Name: service_providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_providers (id, user_id, business_name, category, bio, hourly_rate, location, service_radius_km, status, verification_status, avg_rating, rating_count, created_at, updated_at, review_notes, registration_number, business_registration_number) FROM stdin;
bbf3da2a-df84-4ad6-8b21-9e1645233773	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	Dr Khoza Surgery	Medical Practisioner		250.00	Limpopo	25	offline	verified	0.00	0	2026-09-05 19:12:18.782954+00	2026-09-05 19:12:18.782954+00	\N	\N	1122233344
db4bbf8f-35d6-4b13-883f-2a1bd84d987a	172652f0-c720-405e-a842-c737ecc5f9cb	Ranku business	Tutoring	I am passionate about teaching and love to share knowledge with others	300.00	Mankweng	25	offline	verified	0.00	0	2026-09-07 18:10:54.373182+00	2026-09-07 18:10:54.373182+00	\N	\N	CoR14.3 
65b23554-ddf9-40ad-9951-9957b689bedb	322deaf8-c652-4e90-ae39-38c0aa185e38	Mulaudzi's logistics 	Tutoring 	I help student' with maths and physics \nGrade 10-12	15.30	Polokwane 	25	offline	verified	0.00	0	2026-09-09 18:05:41.784743+00	2026-09-09 18:05:41.784743+00	\N	\N	1445445
deefe7b0-ab33-4d1a-824b-c988ef5d75c8	c0bc5412-8793-4a43-8bf5-de0f1aff2914	Ndileni's hair studio	Hair	Affordable mini hair salon in Mankweng specializing in braids, wig installs, weaves, haircuts and natural hair styling. Neat, fast & professional service. Walk-ins and bookings are welcome.	\N	Mankweng 	25	offline	pending	0.00	0	2026-09-09 18:14:37.425741+00	2026-09-09 18:14:37.425741+00	\N	\N	2024/123456/07
\.


--
-- Data for Name: service_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_requests (id, client_id, request_text, service_type, location, status, ai_summary, ai_keywords, created_at) FROM stdin;
5195eb3e-59fd-4c72-b75c-fc4bce6e8d1c	7144aa93-d014-48b9-a8fe-af41de8baf8f	i'm very sick i need help	Medical Assistance	\N	in_progress	The client is feeling very sick and needs medical help.	{sick,help}	2026-09-11 13:43:54.932343+00
5e5225af-e2e3-4ced-a56e-f515e65a5229	7144aa93-d014-48b9-a8fe-af41de8baf8f	i'm very sick i need help	\N	\N	in_progress	\N	\N	2026-09-11 13:53:36.661638+00
c9eea694-5fda-43ff-abaf-52cfc433f69f	18303ea7-fc4e-48d3-b73b-93d016816902	I need a doctor near me 	Doctor	Polokwane 	cancelled	The client is looking for a medical doctor near Polokwane. Dr Khoza Surgery is a medical practitioner located in Limpopo, which aligns with the service type and general location. However, the provider is currently offline.	{doctor,"medical practitioner",Polokwane,Limpopo}	2026-09-07 18:08:16.267458+00
\.


--
-- Data for Name: user_onboarding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_onboarding (id, user_id, completed_at) FROM stdin;
c3fe0ccf-8372-4f78-b823-fc2d0c64ee79	7144aa93-d014-48b9-a8fe-af41de8baf8f	2026-09-09 18:36:06.563048+00
15593d66-4128-4c41-8f39-38ef0e788888	172652f0-c720-405e-a842-c737ecc5f9cb	2026-09-09 19:40:09.204962+00
b6736369-175f-4704-be3f-64a4939a3bb2	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	2026-09-11 13:34:22.523842+00
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (id, user_id, role, created_at) FROM stdin;
cffe4f03-4def-44bb-92bb-76cb16859838	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	provider	2026-09-05 19:02:57.208709+00
f1e72d58-9e87-4da6-8d75-897834a50f57	51763d35-9b2a-4bd7-a4c9-4039abcd90cc	admin	2026-09-05 19:04:58.454108+00
f94eca87-6b74-4435-bb10-ed446779304d	172652f0-c720-405e-a842-c737ecc5f9cb	provider	2026-09-07 18:04:27.200029+00
e54f366d-8fbf-42f9-82e8-060790a4388f	18303ea7-fc4e-48d3-b73b-93d016816902	client	2026-09-07 18:04:21.255831+00
600f3014-2a74-4831-96a9-f22a8fc36f77	ecf8ae09-72d2-4547-b40c-09615742c082	client	2026-09-09 11:57:33.136736+00
01357831-425f-4016-bd1f-cc53a17b0df0	3b7077bc-b9d6-4ffc-b2b9-74a6b6044f7c	client	2026-09-09 17:32:11.543669+00
1685b96e-3768-46d4-837d-92c7ba883286	322deaf8-c652-4e90-ae39-38c0aa185e38	provider	2026-09-09 17:39:47.593348+00
f8bfba7e-45a3-408d-9cf7-c57031d09237	fc0d4183-26a7-49ee-aa8b-c864ac60a689	client	2026-09-09 17:43:11.988826+00
f40c9457-4440-4a58-9f16-485e6340c1df	c0bc5412-8793-4a43-8bf5-de0f1aff2914	provider	2026-09-09 17:57:00.57921+00
fa69ac63-e874-407e-b197-ac6cccc41d90	7144aa93-d014-48b9-a8fe-af41de8baf8f	client	2026-09-09 18:33:39.888532+00
bc05f395-e562-4b63-a495-3119b20d488e	1f49d8c3-a080-424d-aeb0-d403a4dc953e	provider	2026-09-11 13:25:52.190425+00
c295d967-b194-4c73-a839-62d130b103d5	e1b0f19a-c9cf-458d-91fc-38073221ac53	client	2026-09-11 13:28:00.564786+00
bfd094e3-e2f7-42d3-bc4d-865b23884751	4bf09add-01d5-4358-9199-53662f131d8d	client	2026-09-11 13:30:26.550359+00
8a0454f1-c5ed-4ed6-8b0f-d7a09836ae34	3d104c94-3cce-4ed3-a8c8-59f675d1806a	provider	2026-09-11 13:32:06.086619+00
\.


--
-- Data for Name: messages_2026_09_12; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_09_12 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- Data for Name: messages_2026_09_13; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_09_13 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- Data for Name: messages_2026_09_14; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_09_14 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- Data for Name: messages_2026_09_15; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_09_15 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- Data for Name: messages_2026_09_16; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_09_16 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- Data for Name: messages_2026_09_17; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_09_17 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- Data for Name: messages_2026_09_18; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.messages_2026_09_18 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-04-29 20:57:37
20211116045059	2026-04-29 20:57:37
20211116050929	2026-04-29 20:57:37
20211116051442	2026-04-29 20:57:37
20211116212300	2026-04-29 20:57:37
20211116213355	2026-04-29 20:57:37
20211116213934	2026-04-29 20:57:37
20211116214523	2026-04-29 20:57:37
20211122062447	2026-04-29 20:57:37
20211124070109	2026-04-29 20:57:37
20211202204204	2026-04-29 20:57:37
20211202204605	2026-04-29 20:57:37
20211210212804	2026-04-29 20:57:37
20211228014915	2026-04-29 20:57:37
20220107221237	2026-04-29 20:57:37
20220228202821	2026-04-29 20:57:37
20220312004840	2026-04-29 20:57:37
20220603231003	2026-04-29 20:57:37
20220603232444	2026-04-29 20:57:37
20220615214548	2026-04-29 20:57:37
20220712093339	2026-04-29 20:57:37
20220908172859	2026-04-29 20:57:37
20220916233421	2026-04-29 20:57:37
20230119133233	2026-04-29 20:57:37
20230128025114	2026-04-29 20:57:37
20230128025212	2026-04-29 20:57:37
20230227211149	2026-04-29 20:57:37
20230228184745	2026-04-29 20:57:37
20230308225145	2026-04-29 20:57:37
20230328144023	2026-04-29 20:57:37
20231018144023	2026-04-29 20:57:37
20231204144023	2026-04-29 20:57:38
20231204144024	2026-04-29 20:57:38
20231204144025	2026-04-29 20:57:38
20240108234812	2026-04-29 20:57:38
20240109165339	2026-04-29 20:57:38
20240227174441	2026-04-29 20:57:38
20240311171622	2026-04-29 20:57:38
20240321100241	2026-04-29 20:57:38
20240401105812	2026-04-29 20:57:38
20240418121054	2026-04-29 20:57:38
20240523004032	2026-04-29 20:57:38
20240618124746	2026-04-29 20:57:38
20240801235015	2026-04-29 20:57:38
20240805133720	2026-04-29 20:57:38
20240827160934	2026-04-29 20:57:38
20240919163303	2026-04-29 20:57:38
20240919163305	2026-04-29 20:57:38
20241019105805	2026-04-29 20:57:38
20241030150047	2026-04-29 20:57:38
20241108114728	2026-04-29 20:57:38
20241121104152	2026-04-29 20:57:38
20241130184212	2026-04-29 20:57:38
20241220035512	2026-04-29 20:57:38
20241220123912	2026-04-29 20:57:38
20241224161212	2026-04-29 20:57:38
20250107150512	2026-04-29 20:57:38
20250110162412	2026-04-29 20:57:38
20250123174212	2026-04-29 20:57:38
20250128220012	2026-04-29 20:57:38
20250506224012	2026-04-29 20:57:38
20250523164012	2026-04-29 20:57:38
20250714121412	2026-04-29 20:57:38
20250905041441	2026-04-29 20:57:38
20251103001201	2026-04-29 20:57:38
20251120212548	2026-04-29 20:57:38
20251120215549	2026-04-29 20:57:38
20260218120000	2026-04-29 20:57:38
20260326120000	2026-04-29 20:57:38
20260514120000	2026-06-24 18:52:26
20260527120000	2026-06-24 18:52:26
20260528120000	2026-06-24 18:52:26
20260603120000	2026-06-24 18:52:26
20260605120000	2026-06-24 18:52:26
20260606110000	2026-06-24 18:52:26
20260616120000	2026-07-16 16:37:29
20260624120000	2026-07-16 16:37:29
20260626120000	2026-07-16 16:37:29
20260706120000	2026-07-16 16:37:29
20260707120000	2026-07-16 16:37:29
20260709120000	2026-07-16 16:37:29
20260714120000	2026-09-05 08:47:27
20260827120000	2026-09-24 23:50:37
20260914120000	2026-09-24 23:50:37
20260916120000	2026-09-24 23:50:37
20260922120000	2026-09-24 23:50:37
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter, selected_columns) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type, versioning_status, lifecycle_configuration, lifecycle_configuration_generation) FROM stdin;
provider-documents	provider-documents	\N	2026-04-29 23:22:47.568727+00	2026-04-29 23:22:47.568727+00	f	f	10485760	\N	\N	STANDARD	DISABLED	\N	\N
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-04-29 16:46:04.503364
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-04-29 16:46:04.543473
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-04-29 16:46:04.548377
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-04-29 16:46:04.572348
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-04-29 16:46:04.584183
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-04-29 16:46:04.588444
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-04-29 16:46:04.593018
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-04-29 16:46:04.597675
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-04-29 16:46:04.602019
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-04-29 16:46:04.606332
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-04-29 16:46:04.610896
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-04-29 16:46:04.615335
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-04-29 16:46:04.619928
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-04-29 16:46:04.624554
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-04-29 16:46:04.628811
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-04-29 16:46:04.653766
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-04-29 16:46:04.657964
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-04-29 16:46:04.662878
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-04-29 16:46:04.666871
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-04-29 16:46:04.672697
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-04-29 16:46:04.677202
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-04-29 16:46:04.683313
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-04-29 16:46:04.698641
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-04-29 16:46:04.708508
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-04-29 16:46:04.713729
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-04-29 16:46:04.71795
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-04-29 16:46:04.723244
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-04-29 16:46:04.727187
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-04-29 16:46:04.731475
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-04-29 16:46:04.735593
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-04-29 16:46:04.739524
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-04-29 16:46:04.743275
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-04-29 16:46:04.747559
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-04-29 16:46:04.752002
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-04-29 16:46:04.756139
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-04-29 16:46:04.760201
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-04-29 16:46:04.764196
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-04-29 16:46:04.768985
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-04-29 16:46:04.773801
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-04-29 16:46:04.784233
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-04-29 16:46:04.788029
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-04-29 16:46:04.792084
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-04-29 16:46:04.795987
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-04-29 16:46:04.800015
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-04-29 16:46:04.804687
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-04-29 16:46:04.810764
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-04-29 16:46:04.823335
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-04-29 16:46:04.828058
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-04-29 16:46:04.832111
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-04-29 16:46:04.84807
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-04-29 16:46:04.85322
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-04-29 16:46:05.314879
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-04-29 16:46:05.316826
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-04-29 16:46:05.325679
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-04-29 16:46:05.328332
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-04-29 16:46:05.330124
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-29 16:46:05.340492
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-29 16:46:05.344632
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-04-29 16:46:05.335119
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-06-24 18:51:28.944724
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-06-24 18:51:28.973038
61	mark-filename-immutable	fe0096517ae9d60aaec1d110172ba9036dc66bb7	2026-08-14 08:50:44.383776
62	object-versioning-core	0b855f00ff3be0bfca91efee02a9858912491a9a	2026-08-25 14:16:50.595663
63	fix-search-name-relative-to-prefix	c7485e417624f795ce8bb2da21927f48e088904d	2026-08-25 14:16:50.647089
64	fix-search-by-timestamp-sqli	0af424ecd388a39bb1645184b222185a12149675	2026-08-25 14:16:50.668451
66	objects-current-version-index	191466c93aa2c46a00e36505577c5fcab8d7cb4b	2026-09-07 18:11:26.843895
67	objects-null-version-index	15bfe8c35b66642b6c78ba60060fa8793bd2207a	2026-09-07 18:11:26.855639
65	objects-key-version-index	da319c4b89ba800ce795d1b699f3a70675138058	2026-09-07 18:11:26.826836
68	bucket-lifecycle-configuration	3c08f6f889922f399519722a932b51007c11bebc	2026-09-24 23:50:43.828891
69	validate-bucket-lifecycle-constraints	4febacaaaa0e61e2b783bef081fe03a287e65eb3	2026-09-24 23:50:43.903595
70	list-objects-with-versions	5c17c3777616cd8d7b18b82835525fa3205af57b	2026-09-24 23:50:43.914941
71	objects-delete-marker-index	6d14858e66c66f8d6accf8a2630aefd1527fddba	2026-09-24 23:50:43.978201
72	drop-bucketid-objname-index	302beb09e1b469d7d4db19566f2389d280b64aa3	2026-09-24 23:50:44.348624
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, archived_at, is_delete_marker, is_versioned) FROM stdin;
7cd07081-4bda-41af-9540-a4d76dfdfdda	provider-documents	c00e7b4f-2bf8-49f6-a81a-ea3f88d57373/1777505077203-provider-verification-test.pdf	c00e7b4f-2bf8-49f6-a81a-ea3f88d57373	2026-04-29 23:24:37.824001+00	2026-04-29 23:24:37.824001+00	2026-04-29 23:24:37.824001+00	{"eTag": "\\"4c16cf404028e6d8fac554a98944e324\\"", "size": 4888, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-04-29T23:24:38.000Z", "contentLength": 4888, "httpStatusCode": 200}	ceb97626-6975-44bf-92b4-80f918696fc7	c00e7b4f-2bf8-49f6-a81a-ea3f88d57373	{}	\N	f	f
8a51c8b9-6cea-4882-9ab5-dfbd6b6c53bb	provider-documents	15e18939-46ec-4fea-a24c-48cbf7347f05/1777509579123-provider-verification-test.pdf	15e18939-46ec-4fea-a24c-48cbf7347f05	2026-04-30 00:39:40.057324+00	2026-04-30 00:39:40.057324+00	2026-04-30 00:39:40.057324+00	{"eTag": "\\"4c16cf404028e6d8fac554a98944e324\\"", "size": 4888, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-04-30T00:39:40.000Z", "contentLength": 4888, "httpStatusCode": 200}	3a21f8ee-d853-4369-a0b7-1239c1ac0a53	15e18939-46ec-4fea-a24c-48cbf7347f05	{}	\N	f	f
47c95b95-2e79-4f6b-aefa-f43721e87382	provider-documents	c9636992-6c8a-4175-a448-780950e85864/1777536854099-provider-verification-test.pdf	c9636992-6c8a-4175-a448-780950e85864	2026-04-30 08:14:16.054219+00	2026-04-30 08:14:16.054219+00	2026-04-30 08:14:16.054219+00	{"eTag": "\\"4c16cf404028e6d8fac554a98944e324\\"", "size": 4888, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-04-30T08:14:17.000Z", "contentLength": 4888, "httpStatusCode": 200}	95444a25-3fe8-4ebc-b461-af7953a5dde0	c9636992-6c8a-4175-a448-780950e85864	{}	\N	f	f
74919ad6-533d-4fc4-9ef1-162c83019cc4	provider-documents	436a1357-212a-4cb4-bf5b-8a53ca0880cd/1786017326390-Valid cos300 tutor.pdf	436a1357-212a-4cb4-bf5b-8a53ca0880cd	2026-08-06 11:55:29.08612+00	2026-08-06 11:55:29.08612+00	2026-08-06 11:55:29.08612+00	{"eTag": "\\"4903f02b108e22fba2c7ee1cc7a72fe2\\"", "size": 18076, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-08-06T11:55:30.000Z", "contentLength": 18076, "httpStatusCode": 200}	3a02637b-cc50-40a9-a8b0-1fe90da2e1dd	436a1357-212a-4cb4-bf5b-8a53ca0880cd	{}	\N	f	f
1228bd25-21f2-4fab-81b2-9d65a786d453	provider-documents	436a1357-212a-4cb4-bf5b-8a53ca0880cd/1786022261252-Valid cos300 tutor.pdf	436a1357-212a-4cb4-bf5b-8a53ca0880cd	2026-08-06 13:17:43.792574+00	2026-08-06 13:17:43.792574+00	2026-08-06 13:17:43.792574+00	{"eTag": "\\"4903f02b108e22fba2c7ee1cc7a72fe2\\"", "size": 18076, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-08-06T13:17:44.000Z", "contentLength": 18076, "httpStatusCode": 200}	2436ad9b-ce11-4b38-80cc-415832b0daf3	436a1357-212a-4cb4-bf5b-8a53ca0880cd	{}	\N	f	f
622ed61c-90f2-461c-ad99-d63522fad157	provider-documents	436a1357-212a-4cb4-bf5b-8a53ca0880cd/1786022486448-Valid cos300 tutor.pdf	436a1357-212a-4cb4-bf5b-8a53ca0880cd	2026-08-06 13:21:29.116571+00	2026-08-06 13:21:29.116571+00	2026-08-06 13:21:29.116571+00	{"eTag": "\\"4903f02b108e22fba2c7ee1cc7a72fe2\\"", "size": 18076, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-08-06T13:21:30.000Z", "contentLength": 18076, "httpStatusCode": 200}	05dd6fd9-3236-4f74-ac40-89845c6ce1bc	436a1357-212a-4cb4-bf5b-8a53ca0880cd	{}	\N	f	f
98e3e1d3-126e-4e27-aa94-5fc8caeba185	provider-documents	436a1357-212a-4cb4-bf5b-8a53ca0880cd/1786022491802-9c0ee8ec-8785-4887-895e-a9671930b421.pdf	436a1357-212a-4cb4-bf5b-8a53ca0880cd	2026-08-06 13:21:34.816444+00	2026-08-06 13:21:34.816444+00	2026-08-06 13:21:34.816444+00	{"eTag": "\\"538b20952f6d14d5daae10fd55082f48\\"", "size": 132998, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-08-06T13:21:35.000Z", "contentLength": 132998, "httpStatusCode": 200}	a8d2b8a2-8b7d-4781-8323-969567f1244c	436a1357-212a-4cb4-bf5b-8a53ca0880cd	{}	\N	f	f
2e6b2b24-b93b-4261-b16a-ee7ca3ba8040	provider-documents	436a1357-212a-4cb4-bf5b-8a53ca0880cd/1786022628320-9c0ee8ec-8785-4887-895e-a9671930b421.pdf	436a1357-212a-4cb4-bf5b-8a53ca0880cd	2026-08-06 13:23:50.974051+00	2026-08-06 13:23:50.974051+00	2026-08-06 13:23:50.974051+00	{"eTag": "\\"538b20952f6d14d5daae10fd55082f48\\"", "size": 132998, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-08-06T13:23:51.000Z", "contentLength": 132998, "httpStatusCode": 200}	771183a6-0d71-4d01-b654-cc41dc868b6f	436a1357-212a-4cb4-bf5b-8a53ca0880cd	{}	\N	f	f
d7ed24fc-cbcd-4b46-ae4a-5a19969f880a	provider-documents	436a1357-212a-4cb4-bf5b-8a53ca0880cd/1786022695136-Valid cos300 tutor.pdf	436a1357-212a-4cb4-bf5b-8a53ca0880cd	2026-08-06 13:24:57.699506+00	2026-08-06 13:24:57.699506+00	2026-08-06 13:24:57.699506+00	{"eTag": "\\"4903f02b108e22fba2c7ee1cc7a72fe2\\"", "size": 18076, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-08-06T13:24:58.000Z", "contentLength": 18076, "httpStatusCode": 200}	21043900-629b-470e-9aeb-895fc8103054	436a1357-212a-4cb4-bf5b-8a53ca0880cd	{}	\N	f	f
4b52aadf-013e-4d0d-b1fb-b6d2763916b9	provider-documents	436a1357-212a-4cb4-bf5b-8a53ca0880cd/1786023270561-Valid cos300 tutor.pdf	436a1357-212a-4cb4-bf5b-8a53ca0880cd	2026-08-06 13:34:33.170238+00	2026-08-06 13:34:33.170238+00	2026-08-06 13:34:33.170238+00	{"eTag": "\\"4903f02b108e22fba2c7ee1cc7a72fe2\\"", "size": 18076, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-08-06T13:34:34.000Z", "contentLength": 18076, "httpStatusCode": 200}	1e783139-1202-4f9b-8348-6aa2ea1c038e	436a1357-212a-4cb4-bf5b-8a53ca0880cd	{}	\N	f	f
52156110-a67e-4fcb-9181-b079b314755b	provider-documents	436a1357-212a-4cb4-bf5b-8a53ca0880cd/1786024262634-Valid cos300 tutor.pdf	436a1357-212a-4cb4-bf5b-8a53ca0880cd	2026-08-06 13:51:05.021223+00	2026-08-06 13:51:05.021223+00	2026-08-06 13:51:05.021223+00	{"eTag": "\\"4903f02b108e22fba2c7ee1cc7a72fe2\\"", "size": 18076, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-08-06T13:51:05.000Z", "contentLength": 18076, "httpStatusCode": 200}	b03a3d07-fdef-4c3f-9473-22fbfa09fc6e	436a1357-212a-4cb4-bf5b-8a53ca0880cd	{}	\N	f	f
9fef198f-7476-49f6-9397-275ccf3d39ab	provider-documents	2d087b81-75b6-4c4e-b6da-db050903f879/1786697440718-Business name.pdf	2d087b81-75b6-4c4e-b6da-db050903f879	2026-08-14 08:50:42.396619+00	2026-08-14 08:50:42.396619+00	2026-08-14 08:50:42.396619+00	{"eTag": "\\"96ac4384a414dbc66eaa1c1e6500cca7\\"", "size": 17157, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-08-14T08:50:43.000Z", "contentLength": 17157, "httpStatusCode": 200}	c5055e19-d9a6-4e0e-9427-8ffd36285fe4	2d087b81-75b6-4c4e-b6da-db050903f879	{}	\N	f	f
a11de165-7516-478f-ba6b-858b4e41dbe0	provider-documents	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93/1788635558284-Business name.pdf	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	2026-09-05 19:12:39.259887+00	2026-09-05 19:12:39.259887+00	2026-09-05 19:12:39.259887+00	{"eTag": "\\"96ac4384a414dbc66eaa1c1e6500cca7\\"", "size": 17157, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-09-05T19:12:40.000Z", "contentLength": 17157, "httpStatusCode": 200}	58dd9044-ce11-4dfb-9e7e-e850a95800c2	8db5eff3-7ff2-4eb6-9918-7b076ef1bc93	{}	\N	f	f
1c866a47-1b08-492c-92d6-507ea6324c54	provider-documents	172652f0-c720-405e-a842-c737ecc5f9cb/1788804675788-2026_SRS_Template.pdf	172652f0-c720-405e-a842-c737ecc5f9cb	2026-09-07 18:11:22.482835+00	2026-09-07 18:11:22.482835+00	2026-09-07 18:11:22.482835+00	{"eTag": "\\"3bdeca3f6fe5477649b16d0260b45799\\"", "size": 527322, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-09-07T18:11:23.000Z", "contentLength": 527322, "httpStatusCode": 200}	b54502b4-4a0c-4e1f-aa21-0b6d375c149e	172652f0-c720-405e-a842-c737ecc5f9cb	{}	\N	f	f
ad399a21-0ee1-4b8c-94ec-20ead91086ed	provider-documents	322deaf8-c652-4e90-ae39-38c0aa185e38/1788977422551-DOC-20260909-WA0061.pdf	322deaf8-c652-4e90-ae39-38c0aa185e38	2026-09-09 18:10:24.104621+00	2026-09-09 18:10:24.104621+00	2026-09-09 18:10:24.104621+00	{"eTag": "\\"e0f4f07e08b53d6b37a5a89ba0991783\\"", "size": 16523, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-09-09T18:10:25.000Z", "contentLength": 16523, "httpStatusCode": 200}	5e8dc49c-5b74-4c05-b4bc-448e9e6c2f0e	322deaf8-c652-4e90-ae39-38c0aa185e38	{}	\N	f	f
c7ad6863-a958-493d-8cb8-729ce08ac715	provider-documents	c0bc5412-8793-4a43-8bf5-de0f1aff2914/1788977749192-2024-Undergraduate-Student-Information-Brochure-final-2-003.pdf	c0bc5412-8793-4a43-8bf5-de0f1aff2914	2026-09-09 18:15:54.216626+00	2026-09-09 18:15:54.216626+00	2026-09-09 18:15:54.216626+00	{"eTag": "\\"3e73fa6808054ea93bb79d996688a84b\\"", "size": 4898087, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-09-09T18:15:55.000Z", "contentLength": 4898087, "httpStatusCode": 200}	74b890ed-b64e-4556-841a-8c71bc67161f	c0bc5412-8793-4a43-8bf5-de0f1aff2914	{}	\N	f	f
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20260429144638	{"-- Roles enum + table (security best practice)\ncreate type public.app_role as enum ('client', 'provider', 'admin')","create table public.user_roles (\n  id uuid primary key default gen_random_uuid(),\n  user_id uuid not null references auth.users(id) on delete cascade,\n  role public.app_role not null,\n  created_at timestamptz not null default now(),\n  unique (user_id, role)\n)","alter table public.user_roles enable row level security","create or replace function public.has_role(_user_id uuid, _role public.app_role)\nreturns boolean\nlanguage sql stable security definer set search_path = public\nas $$\n  select exists (select 1 from public.user_roles where user_id = _user_id and role = _role)\n$$","create policy \\"users view own roles\\" on public.user_roles for select to authenticated\n  using (user_id = auth.uid() or public.has_role(auth.uid(), 'admin'))","create policy \\"admins manage roles\\" on public.user_roles for all to authenticated\n  using (public.has_role(auth.uid(), 'admin')) with check (public.has_role(auth.uid(), 'admin'))","-- Profiles\ncreate table public.profiles (\n  id uuid primary key references auth.users(id) on delete cascade,\n  full_name text not null,\n  email text,\n  phone text,\n  location text,\n  avatar_url text,\n  created_at timestamptz not null default now(),\n  updated_at timestamptz not null default now()\n)","alter table public.profiles enable row level security","create policy \\"profiles select all authenticated\\" on public.profiles for select to authenticated using (true)","create policy \\"profiles insert own\\" on public.profiles for insert to authenticated with check (id = auth.uid())","create policy \\"profiles update own\\" on public.profiles for update to authenticated using (id = auth.uid())","-- Auto-create profile + default client role on signup\ncreate or replace function public.handle_new_user()\nreturns trigger language plpgsql security definer set search_path = public\nas $$\ndeclare\n  selected_role public.app_role;\nbegin\n  insert into public.profiles (id, full_name, email)\n  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email,'@',1)), new.email);\n\n  selected_role := coalesce((new.raw_user_meta_data->>'role')::public.app_role, 'client');\n  -- prevent self-promotion to admin\n  if selected_role = 'admin' then selected_role := 'client'; end if;\n  insert into public.user_roles (user_id, role) values (new.id, selected_role);\n  return new;\nend;\n$$","create trigger on_auth_user_created\nafter insert on auth.users\nfor each row execute function public.handle_new_user()","-- Service providers\ncreate table public.service_providers (\n  id uuid primary key default gen_random_uuid(),\n  user_id uuid not null unique references auth.users(id) on delete cascade,\n  business_name text not null,\n  category text not null,\n  bio text,\n  hourly_rate numeric(10,2),\n  location text,\n  service_radius_km integer default 25,\n  status text not null default 'offline', -- online | offline | busy\n  verification_status text not null default 'pending', -- pending | verified | rejected\n  avg_rating numeric(3,2) default 0,\n  rating_count integer default 0,\n  created_at timestamptz not null default now(),\n  updated_at timestamptz not null default now()\n)","alter table public.service_providers enable row level security","create policy \\"providers public read\\" on public.service_providers for select using (true)","create policy \\"providers insert own\\" on public.service_providers for insert to authenticated with check (user_id = auth.uid())","create policy \\"providers update own\\" on public.service_providers for update to authenticated using (user_id = auth.uid() or public.has_role(auth.uid(),'admin'))","create policy \\"admins delete providers\\" on public.service_providers for delete to authenticated using (public.has_role(auth.uid(),'admin'))","-- Service requests\ncreate table public.service_requests (\n  id uuid primary key default gen_random_uuid(),\n  client_id uuid not null references auth.users(id) on delete cascade,\n  request_text text not null,\n  service_type text,\n  location text,\n  status text not null default 'pending', -- pending | matched | in_progress | complete\n  ai_summary text,\n  ai_keywords text[],\n  created_at timestamptz not null default now()\n)","alter table public.service_requests enable row level security","create policy \\"requests own select\\" on public.service_requests for select to authenticated\n  using (client_id = auth.uid() or public.has_role(auth.uid(),'admin'))","create policy \\"requests insert own\\" on public.service_requests for insert to authenticated with check (client_id = auth.uid())","create policy \\"requests update own\\" on public.service_requests for update to authenticated using (client_id = auth.uid())","-- Matches\ncreate table public.matches (\n  id uuid primary key default gen_random_uuid(),\n  request_id uuid not null references public.service_requests(id) on delete cascade,\n  provider_id uuid not null references public.service_providers(id) on delete cascade,\n  score numeric(5,2) not null,\n  reason text,\n  created_at timestamptz not null default now()\n)","alter table public.matches enable row level security","create policy \\"matches client view\\" on public.matches for select to authenticated\n  using (\n    exists (select 1 from public.service_requests r where r.id = matches.request_id and r.client_id = auth.uid())\n    or exists (select 1 from public.service_providers p where p.id = matches.provider_id and p.user_id = auth.uid())\n    or public.has_role(auth.uid(),'admin')\n  )","-- inserts happen via server function with service role, no insert policy needed\n\n-- Ratings\ncreate table public.ratings (\n  id uuid primary key default gen_random_uuid(),\n  provider_id uuid not null references public.service_providers(id) on delete cascade,\n  client_id uuid not null references auth.users(id) on delete cascade,\n  rating integer not null check (rating between 1 and 5),\n  comment text,\n  created_at timestamptz not null default now(),\n  unique (provider_id, client_id)\n)","alter table public.ratings enable row level security","create policy \\"ratings public read\\" on public.ratings for select using (true)","create policy \\"ratings insert own\\" on public.ratings for insert to authenticated with check (client_id = auth.uid())","create policy \\"ratings update own\\" on public.ratings for update to authenticated using (client_id = auth.uid())","-- Recompute provider rating\ncreate or replace function public.recalc_provider_rating()\nreturns trigger language plpgsql security definer set search_path = public\nas $$\nbegin\n  update public.service_providers sp\n  set avg_rating = coalesce((select avg(rating)::numeric(3,2) from public.ratings where provider_id = sp.id),0),\n      rating_count = (select count(*) from public.ratings where provider_id = sp.id)\n  where sp.id = coalesce(new.provider_id, old.provider_id);\n  return null;\nend;\n$$","create trigger ratings_recalc after insert or update or delete on public.ratings\nfor each row execute function public.recalc_provider_rating()","-- Documents\ncreate table public.documents (\n  id uuid primary key default gen_random_uuid(),\n  provider_id uuid not null references public.service_providers(id) on delete cascade,\n  file_path text not null,\n  file_name text not null,\n  doc_type text,\n  status text not null default 'pending', -- pending | approved | rejected\n  reviewed_by uuid references auth.users(id),\n  review_notes text,\n  created_at timestamptz not null default now()\n)","alter table public.documents enable row level security","create policy \\"documents owner+admin read\\" on public.documents for select to authenticated\n  using (\n    exists (select 1 from public.service_providers p where p.id = documents.provider_id and p.user_id = auth.uid())\n    or public.has_role(auth.uid(),'admin')\n  )","create policy \\"documents owner insert\\" on public.documents for insert to authenticated\n  with check (exists (select 1 from public.service_providers p where p.id = documents.provider_id and p.user_id = auth.uid()))","create policy \\"documents admin update\\" on public.documents for update to authenticated\n  using (public.has_role(auth.uid(),'admin'))","-- Storage bucket for verification documents (private)\ninsert into storage.buckets (id, name, public) values ('provider-documents','provider-documents', false)\non conflict (id) do nothing","create policy \\"providers upload own docs\\" on storage.objects for insert to authenticated\n  with check (bucket_id = 'provider-documents' and (storage.foldername(name))[1] = auth.uid()::text)","create policy \\"providers read own docs\\" on storage.objects for select to authenticated\n  using (bucket_id = 'provider-documents' and ((storage.foldername(name))[1] = auth.uid()::text or public.has_role(auth.uid(),'admin')))","create policy \\"admins manage docs\\" on storage.objects for all to authenticated\n  using (bucket_id = 'provider-documents' and public.has_role(auth.uid(),'admin'))\n  with check (bucket_id = 'provider-documents' and public.has_role(auth.uid(),'admin'))"}	558e66fa-f251-4b4b-8f29-865965aec020
20260429144651	{"revoke execute on function public.has_role(uuid, public.app_role) from public, anon, authenticated","revoke execute on function public.handle_new_user() from public, anon, authenticated","revoke execute on function public.recalc_provider_rating() from public, anon, authenticated"}	9d7db9a3-36af-44a7-967c-0301d3fdfb82
20260803120000	{"-- Add inquiry fields to matches so clients can request a matched provider\nalter table public.matches\n  add column inquiry_status text not null default 'none',\n  add column inquiry_message text,\n  add column inquiry_preferred_date date,\n  add column inquiry_requested_at timestamptz","alter table public.matches\n  add constraint matches_inquiry_status_check\n  check (inquiry_status in ('none', 'requested', 'accepted', 'declined'))","-- Clients can submit inquiries on their own matches\ncreate policy \\"matches client update inquiry\\" on public.matches for update to authenticated\n  using (\n    exists (\n      select 1 from public.service_requests r\n      where r.id = matches.request_id and r.client_id = auth.uid()\n    )\n  )\n  with check (\n    exists (\n      select 1 from public.service_requests r\n      where r.id = matches.request_id and r.client_id = auth.uid()\n    )\n  )","-- Providers can accept or decline inquiries on their matches\ncreate policy \\"matches provider respond\\" on public.matches for update to authenticated\n  using (\n    exists (\n      select 1 from public.service_providers p\n      where p.id = matches.provider_id and p.user_id = auth.uid()\n    )\n  )\n  with check (\n    exists (\n      select 1 from public.service_providers p\n      where p.id = matches.provider_id and p.user_id = auth.uid()\n    )\n  )"}	provider_inquiries
20260803130000	{"-- Reset verification when a provider updates profile fields\ncreate or replace function public.reset_verification_on_profile_update()\nreturns trigger language plpgsql security definer set search_path = public\nas $$\nbegin\n  if (\n    old.business_name is distinct from new.business_name or\n    old.category is distinct from new.category or\n    old.bio is distinct from new.bio or\n    old.hourly_rate is distinct from new.hourly_rate or\n    old.location is distinct from new.location or\n    old.service_radius_km is distinct from new.service_radius_km or\n    old.status is distinct from new.status\n  ) then\n    new.verification_status := 'pending';\n  end if;\n  return new;\nend;\n$$","create trigger service_providers_reset_verification\nbefore update on public.service_providers\nfor each row execute function public.reset_verification_on_profile_update()"}	reset_verification_on_profile_update
20260805000000	{"-- Add messages table for chat functionality between providers and clients\n-- This should be added after the matches table in the schema\n\n-- Enable UUID extension if not already enabled\nCREATE EXTENSION IF NOT EXISTS \\"uuid-ossp\\"","-- Create the update_updated_at_column function if it doesn't exist\nCREATE OR REPLACE FUNCTION update_updated_at_column()\nRETURNS TRIGGER AS $$\nBEGIN\n    NEW.updated_at = NOW();\n    RETURN NEW;\nEND;\n$$ language 'plpgsql'","-- Messages table - chat messages between providers and clients\nCREATE TABLE IF NOT EXISTS messages (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,\n  sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,\n  message TEXT NOT NULL,\n  read BOOLEAN DEFAULT FALSE,\n  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),\n  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()\n)","-- Index for messages\nCREATE INDEX IF NOT EXISTS idx_messages_match_id ON messages(match_id)","CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id)","CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at)","-- Add updated_at trigger for messages\nDROP TRIGGER IF EXISTS update_messages_updated_at ON messages","CREATE TRIGGER update_messages_updated_at BEFORE UPDATE ON messages\n    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","-- Enable RLS\nALTER TABLE messages ENABLE ROW LEVEL SECURITY","-- Policy: Users can read messages for matches they are part of\nCREATE POLICY \\"Users can read messages in their matches\\" ON messages\n  FOR SELECT TO authenticated\n  USING (\n    EXISTS (\n      SELECT 1 FROM matches m\n      WHERE m.id = messages.match_id\n      AND (\n        EXISTS (\n          SELECT 1 FROM service_requests sr\n          WHERE sr.id = m.request_id AND sr.client_id = auth.uid()\n        )\n        OR EXISTS (\n          SELECT 1 FROM service_providers sp\n          WHERE sp.id = m.provider_id AND sp.user_id = auth.uid()\n        )\n      )\n    )\n  )","-- Policy: Users can insert messages for matches they are part of\nCREATE POLICY \\"Users can insert messages in their matches\\" ON messages\n  FOR INSERT TO authenticated\n  WITH CHECK (\n    EXISTS (\n      SELECT 1 FROM matches m\n      WHERE m.id = messages.match_id\n      AND (\n        EXISTS (\n          SELECT 1 FROM service_requests sr\n          WHERE sr.id = m.request_id AND sr.client_id = auth.uid()\n        )\n        OR EXISTS (\n          SELECT 1 FROM service_providers sp\n          WHERE sp.id = m.provider_id AND sp.user_id = auth.uid()\n        )\n      )\n    )\n    AND sender_id = auth.uid()\n  )","-- Policy: Users can update their own messages (e.g., mark as read)\nCREATE POLICY \\"Users can update their own messages\\" ON messages\n  FOR UPDATE TO authenticated\n  USING (\n    sender_id = auth.uid()\n  )\n  WITH CHECK (\n    sender_id = auth.uid()\n  )"}	messages_table
20260806000000	{"-- Add review_notes field to service_providers table for storing rejection reasons\nALTER TABLE public.service_providers \nADD COLUMN IF NOT EXISTS review_notes TEXT"}	add_review_notes
20260808000000	{"-- Add business registration number to service_providers table\nalter table public.service_providers \nadd column business_registration_number text"}	add_business_registration_number
20260808010000	{"-- Business registration verification is now handled via external Supabase database\n-- This migration is kept for reference but the actual verification is done using\n-- a separate Supabase client configured for the external business registration database"}	business_registration_verification
20260810000000	{"-- Add provider reports table for clients to report providers who become quiet after accepting jobs\n-- This should be added after the matches table in the schema\n\n-- Enable UUID extension if not already enabled\nCREATE EXTENSION IF NOT EXISTS \\"uuid-ossp\\"","-- Create the update_updated_at_column function if it doesn't exist\nCREATE OR REPLACE FUNCTION update_updated_at_column()\nRETURNS TRIGGER AS $$\nBEGIN\n    NEW.updated_at = NOW();\n    RETURN NEW;\nEND;\n$$ language 'plpgsql'","-- Provider reports table - reports filed by clients against providers\nCREATE TABLE IF NOT EXISTS provider_reports (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,\n  provider_id UUID NOT NULL REFERENCES service_providers(id) ON DELETE CASCADE,\n  client_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,\n  report_text TEXT NOT NULL,\n  status TEXT NOT NULL DEFAULT 'pending',\n  admin_notes TEXT,\n  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),\n  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()\n)","-- Index for provider reports\nCREATE INDEX IF NOT EXISTS idx_provider_reports_match_id ON provider_reports(match_id)","CREATE INDEX IF NOT EXISTS idx_provider_reports_provider_id ON provider_reports(provider_id)","CREATE INDEX IF NOT EXISTS idx_provider_reports_client_id ON provider_reports(client_id)","CREATE INDEX IF NOT EXISTS idx_provider_reports_status ON provider_reports(status)","CREATE INDEX IF NOT EXISTS idx_provider_reports_created_at ON provider_reports(created_at)","-- Add updated_at trigger for provider reports\nDROP TRIGGER IF EXISTS update_provider_reports_updated_at ON provider_reports","CREATE TRIGGER update_provider_reports_updated_at BEFORE UPDATE ON provider_reports\n    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","-- Enable RLS\nALTER TABLE provider_reports ENABLE ROW LEVEL SECURITY","-- Drop existing policies if they exist\nDROP POLICY IF EXISTS \\"Clients can create reports for their matches\\" ON provider_reports","DROP POLICY IF EXISTS \\"Clients can read their own reports\\" ON provider_reports","DROP POLICY IF EXISTS \\"Admins can read all reports\\" ON provider_reports","DROP POLICY IF EXISTS \\"Admins can update reports\\" ON provider_reports","-- Policy: Clients can create reports for their own matches\nCREATE POLICY \\"Clients can create reports for their matches\\" ON provider_reports\n  FOR INSERT TO authenticated\n  WITH CHECK (\n    EXISTS (\n      SELECT 1 FROM matches m\n      WHERE m.id = provider_reports.match_id\n      AND EXISTS (\n        SELECT 1 FROM service_requests sr\n        WHERE sr.id = m.request_id AND sr.client_id = auth.uid()\n      )\n    )\n    AND client_id = auth.uid()\n  )","-- Policy: Clients can read their own reports\nCREATE POLICY \\"Clients can read their own reports\\" ON provider_reports\n  FOR SELECT TO authenticated\n  USING (\n    client_id = auth.uid()\n  )","-- Policy: Admins can read all reports\nCREATE POLICY \\"Admins can read all reports\\" ON provider_reports\n  FOR SELECT TO authenticated\n  USING (\n    EXISTS (\n      SELECT 1 FROM user_roles\n      WHERE user_id = auth.uid() AND role = 'admin'\n    )\n  )","-- Policy: Admins can update report status and add notes\nCREATE POLICY \\"Admins can update reports\\" ON provider_reports\n  FOR UPDATE TO authenticated\n  USING (\n    EXISTS (\n      SELECT 1 FROM user_roles\n      WHERE user_id = auth.uid() AND role = 'admin'\n    )\n  )\n  WITH CHECK (\n    EXISTS (\n      SELECT 1 FROM user_roles\n      WHERE user_id = auth.uid() AND role = 'admin'\n    )\n  )","-- Add check constraint for report status\nALTER TABLE provider_reports\n  DROP CONSTRAINT IF EXISTS provider_reports_status_check","ALTER TABLE provider_reports\n  ADD CONSTRAINT provider_reports_status_check\n  CHECK (status in ('pending', 'reviewed', 'resolved', 'dismissed'))"}	provider_reports
20260905140000	{"-- Create email_logs table for tracking sent emails\nCREATE TABLE IF NOT EXISTS email_logs (\n  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\n  recipient TEXT NOT NULL,\n  subject TEXT NOT NULL,\n  status TEXT NOT NULL DEFAULT 'sent',\n  service TEXT NOT NULL,\n  error_message TEXT,\n  sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),\n  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()\n)","-- Add indexes for common queries\nCREATE INDEX IF NOT EXISTS idx_email_logs_recipient ON email_logs(recipient)","CREATE INDEX IF NOT EXISTS idx_email_logs_status ON email_logs(status)","CREATE INDEX IF NOT EXISTS idx_email_logs_sent_at ON email_logs(sent_at)","-- Add RLS policies\nALTER TABLE email_logs ENABLE ROW LEVEL SECURITY","-- Allow service role to insert email logs\nCREATE POLICY \\"Service role can insert email logs\\"\n  ON email_logs\n  FOR INSERT\n  TO service_role\n  WITH CHECK (true)","-- Allow service role to read email logs\nCREATE POLICY \\"Service role can read email logs\\"\n  ON email_logs\n  FOR SELECT\n  TO service_role\n  USING (true)","-- Allow authenticated users to read their own email logs\nCREATE POLICY \\"Users can read their own email logs\\"\n  ON email_logs\n  FOR SELECT\n  TO authenticated\n  USING (recipient = auth.email())"}	email_logs_table
20260905150000	{"-- Add cancelled status to service_requests and matches\n-- This allows clients to cancel their service requests and jobs\n\n-- Add check constraint for service_requests status (if it doesn't exist)\nALTER TABLE public.service_requests\n  DROP CONSTRAINT IF EXISTS service_requests_status_check","ALTER TABLE public.service_requests\n  ADD CONSTRAINT service_requests_status_check\n  CHECK (status in ('pending', 'matched', 'in_progress', 'complete', 'cancelled'))","-- Add cancelled status to matches inquiry_status\nALTER TABLE public.matches\n  DROP CONSTRAINT IF EXISTS matches_inquiry_status_check","ALTER TABLE public.matches\n  ADD CONSTRAINT matches_inquiry_status_check\n  CHECK (inquiry_status in ('none', 'requested', 'accepted', 'declined', 'cancelled'))"}	add_cancelled_status
20260906220000	{"-- Add completed status to matches inquiry_status\n-- This allows providers to mark requests as completed\n\n-- Drop existing constraint\nALTER TABLE public.matches\n  DROP CONSTRAINT IF EXISTS matches_inquiry_status_check","-- Add updated constraint with completed status\nALTER TABLE public.matches\n  ADD CONSTRAINT matches_inquiry_status_check\n  CHECK (inquiry_status in ('none', 'requested', 'accepted', 'declined', 'completed', 'cancelled'))"}	add_completed_status
20260909000000	{"-- Favorite providers table\ncreate table public.favorite_providers (\n  id uuid primary key default gen_random_uuid(),\n  client_id uuid not null references auth.users(id) on delete cascade,\n  provider_id uuid not null references public.service_providers(id) on delete cascade,\n  created_at timestamptz not null default now(),\n  unique (client_id, provider_id)\n)","alter table public.favorite_providers enable row level security","-- Policy: clients can view their own favorites\ncreate policy \\"clients view own favorites\\" on public.favorite_providers for select to authenticated\n  using (client_id = auth.uid())","-- Policy: clients can insert their own favorites\ncreate policy \\"clients insert own favorites\\" on public.favorite_providers for insert to authenticated\n  with check (client_id = auth.uid())","-- Policy: clients can delete their own favorites\ncreate policy \\"clients delete own favorites\\" on public.favorite_providers for delete to authenticated\n  using (client_id = auth.uid())","-- Policy: admins can manage all favorites\ncreate policy \\"admins manage favorites\\" on public.favorite_providers for all to authenticated\n  using (public.has_role(auth.uid(), 'admin'))\n  with check (public.has_role(auth.uid(), 'admin'))"}	favorite_providers
20260910000000	{"-- Enable Realtime for dashboard tables\n-- This allows the web app to receive instant updates without manual refresh\n\nalter publication supabase_realtime add table matches","alter publication supabase_realtime add table favorite_providers","alter publication supabase_realtime add table service_requests"}	enable_realtime
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 752, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_realtime_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 740, true);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_mfa_factor_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_mfa_factor_id_key UNIQUE (mfa_factor_id);


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_pkey PRIMARY KEY (id);


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_user_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_user_id_key UNIQUE (user_id);


--
-- Name: mfa_recovery_codes mfa_recovery_codes_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_codes
    ADD CONSTRAINT mfa_recovery_codes_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scim_tokens scim_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_tokens
    ADD CONSTRAINT scim_tokens_pkey PRIMARY KEY (id);


--
-- Name: scim_users scim_users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: email_logs email_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_logs
    ADD CONSTRAINT email_logs_pkey PRIMARY KEY (id);


--
-- Name: email_queue email_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_queue
    ADD CONSTRAINT email_queue_pkey PRIMARY KEY (id);


--
-- Name: favorite_providers favorite_providers_client_id_provider_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_providers
    ADD CONSTRAINT favorite_providers_client_id_provider_id_key UNIQUE (client_id, provider_id);


--
-- Name: favorite_providers favorite_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_providers
    ADD CONSTRAINT favorite_providers_pkey PRIMARY KEY (id);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: provider_reports provider_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_reports
    ADD CONSTRAINT provider_reports_pkey PRIMARY KEY (id);


--
-- Name: ratings ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: ratings ratings_provider_id_client_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_provider_id_client_id_key UNIQUE (provider_id, client_id);


--
-- Name: service_providers service_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_providers
    ADD CONSTRAINT service_providers_pkey PRIMARY KEY (id);


--
-- Name: service_providers service_providers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_providers
    ADD CONSTRAINT service_providers_user_id_key UNIQUE (user_id);


--
-- Name: service_requests service_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_pkey PRIMARY KEY (id);


--
-- Name: user_onboarding user_onboarding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_onboarding
    ADD CONSTRAINT user_onboarding_pkey PRIMARY KEY (id);


--
-- Name: user_onboarding user_onboarding_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_onboarding
    ADD CONSTRAINT user_onboarding_user_id_key UNIQUE (user_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_user_id_role_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_role_key UNIQUE (user_id, role);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_09_12 messages_2026_09_12_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_09_12
    ADD CONSTRAINT messages_2026_09_12_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_09_13 messages_2026_09_13_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_09_13
    ADD CONSTRAINT messages_2026_09_13_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_09_14 messages_2026_09_14_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_09_14
    ADD CONSTRAINT messages_2026_09_14_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_09_15 messages_2026_09_15_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_09_15
    ADD CONSTRAINT messages_2026_09_15_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_09_16 messages_2026_09_16_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_09_16
    ADD CONSTRAINT messages_2026_09_16_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_09_17 messages_2026_09_17_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_09_17
    ADD CONSTRAINT messages_2026_09_17_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_09_18 messages_2026_09_18_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_09_18
    ADD CONSTRAINT messages_2026_09_18_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: mfa_recovery_codes_set_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_recovery_codes_set_id_idx ON auth.mfa_recovery_codes USING btree (mfa_recovery_code_set_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: scim_tokens_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_tokens_expires_at_idx ON auth.scim_tokens USING btree (expires_at);


--
-- Name: scim_tokens_revoked_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_tokens_revoked_at_idx ON auth.scim_tokens USING btree (revoked_at);


--
-- Name: scim_tokens_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_tokens_sso_provider_id_idx ON auth.scim_tokens USING btree (sso_provider_id);


--
-- Name: scim_tokens_token_hash_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX scim_tokens_token_hash_key ON auth.scim_tokens USING btree (token_hash);


--
-- Name: scim_users_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_created_at_idx ON auth.scim_users USING btree (sso_provider_id, created_at, id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_deleted_at_idx ON auth.scim_users USING btree (deleted_at);


--
-- Name: scim_users_external_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX scim_users_external_id_key ON auth.scim_users USING btree (sso_provider_id, external_id) WHERE ((external_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: scim_users_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_id_idx ON auth.scim_users USING btree (sso_provider_id, id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_sso_provider_id_idx ON auth.scim_users USING btree (sso_provider_id);


--
-- Name: scim_users_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_updated_at_idx ON auth.scim_users USING btree (sso_provider_id, updated_at, id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_user_id_idx ON auth.scim_users USING btree (user_id);


--
-- Name: scim_users_user_name_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_user_name_idx ON auth.scim_users USING btree (sso_provider_id, user_name COLLATE "C", id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_user_name_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX scim_users_user_name_key ON auth.scim_users USING btree (sso_provider_id, user_name) WHERE (deleted_at IS NULL);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: email_queue_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX email_queue_status_idx ON public.email_queue USING btree (status);


--
-- Name: email_queue_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX email_queue_user_id_idx ON public.email_queue USING btree (user_id);


--
-- Name: idx_email_logs_recipient; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_email_logs_recipient ON public.email_logs USING btree (recipient);


--
-- Name: idx_email_logs_sent_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_email_logs_sent_at ON public.email_logs USING btree (sent_at);


--
-- Name: idx_email_logs_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_email_logs_status ON public.email_logs USING btree (status);


--
-- Name: idx_messages_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_created_at ON public.messages USING btree (created_at);


--
-- Name: idx_messages_match_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_match_id ON public.messages USING btree (match_id);


--
-- Name: idx_messages_sender_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_sender_id ON public.messages USING btree (sender_id);


--
-- Name: idx_provider_reports_client_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_provider_reports_client_id ON public.provider_reports USING btree (client_id);


--
-- Name: idx_provider_reports_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_provider_reports_created_at ON public.provider_reports USING btree (created_at);


--
-- Name: idx_provider_reports_match_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_provider_reports_match_id ON public.provider_reports USING btree (match_id);


--
-- Name: idx_provider_reports_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_provider_reports_provider_id ON public.provider_reports USING btree (provider_id);


--
-- Name: idx_provider_reports_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_provider_reports_status ON public.provider_reports USING btree (status);


--
-- Name: notifications_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_created_at_idx ON public.notifications USING btree (created_at DESC);


--
-- Name: notifications_read_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_read_idx ON public.notifications USING btree (read);


--
-- Name: notifications_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_user_id_idx ON public.notifications USING btree (user_id);


--
-- Name: notifications_user_read_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_user_read_idx ON public.notifications USING btree (user_id, read);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_09_12_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_09_12_inserted_at_topic_idx ON realtime.messages_2026_09_12 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_09_13_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_09_13_inserted_at_topic_idx ON realtime.messages_2026_09_13 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_09_14_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_09_14_inserted_at_topic_idx ON realtime.messages_2026_09_14 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_09_15_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_09_15_inserted_at_topic_idx ON realtime.messages_2026_09_15 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_09_16_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_09_16_inserted_at_topic_idx ON realtime.messages_2026_09_16 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_09_17_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_09_17_inserted_at_topic_idx ON realtime.messages_2026_09_17 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_09_18_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_09_18_inserted_at_topic_idx ON realtime.messages_2026_09_18 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_selec; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_selec ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: idx_objects_current_version; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_objects_current_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (archived_at IS NULL);


--
-- Name: idx_objects_delete_markers; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_delete_markers ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE is_delete_marker;


--
-- Name: idx_objects_null_version; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_objects_null_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (NOT is_versioned);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_name_version_key; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_name_version_key ON storage.objects USING btree (bucket_id, name COLLATE "C", version) NULLS NOT DISTINCT;


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: messages_2026_09_12_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_09_12_inserted_at_topic_idx;


--
-- Name: messages_2026_09_12_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_09_12_pkey;


--
-- Name: messages_2026_09_13_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_09_13_inserted_at_topic_idx;


--
-- Name: messages_2026_09_13_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_09_13_pkey;


--
-- Name: messages_2026_09_14_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_09_14_inserted_at_topic_idx;


--
-- Name: messages_2026_09_14_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_09_14_pkey;


--
-- Name: messages_2026_09_15_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_09_15_inserted_at_topic_idx;


--
-- Name: messages_2026_09_15_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_09_15_pkey;


--
-- Name: messages_2026_09_16_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_09_16_inserted_at_topic_idx;


--
-- Name: messages_2026_09_16_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_09_16_pkey;


--
-- Name: messages_2026_09_17_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_09_17_inserted_at_topic_idx;


--
-- Name: messages_2026_09_17_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_09_17_pkey;


--
-- Name: messages_2026_09_18_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_09_18_inserted_at_topic_idx;


--
-- Name: messages_2026_09_18_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_09_18_pkey;


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: notifications log_notification_email_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER log_notification_email_trigger AFTER INSERT ON public.notifications FOR EACH ROW EXECUTE FUNCTION public.log_notification_email();


--
-- Name: ratings ratings_recalc; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ratings_recalc AFTER INSERT OR DELETE OR UPDATE ON public.ratings FOR EACH ROW EXECUTE FUNCTION public.recalc_provider_rating();


--
-- Name: service_providers service_providers_reset_verification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER service_providers_reset_verification BEFORE UPDATE ON public.service_providers FOR EACH ROW EXECUTE FUNCTION public.reset_verification_on_profile_update();


--
-- Name: messages update_messages_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_messages_updated_at BEFORE UPDATE ON public.messages FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: notifications update_notifications_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON public.notifications FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: provider_reports update_provider_reports_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_provider_reports_updated_at BEFORE UPDATE ON public.provider_reports FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_bucket_control_insert; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_bucket_control_insert BEFORE INSERT ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_bucket_control_columns('service_role');


--
-- Name: buckets protect_bucket_control_update; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_bucket_control_update BEFORE UPDATE OF lifecycle_configuration, lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_bucket_control_columns();


--
-- Name: buckets protect_bucket_control_update_role; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_bucket_control_update_role AFTER UPDATE OF lifecycle_configuration, lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_lifecycle_service_role('service_role');


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_mfa_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_mfa_factor_id_fkey FOREIGN KEY (mfa_factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_recovery_codes mfa_recovery_codes_mfa_recovery_code_set_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_codes
    ADD CONSTRAINT mfa_recovery_codes_mfa_recovery_code_set_id_fkey FOREIGN KEY (mfa_recovery_code_set_id) REFERENCES auth.mfa_recovery_code_sets(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: scim_tokens scim_tokens_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_tokens
    ADD CONSTRAINT scim_tokens_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: scim_users scim_users_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: scim_users scim_users_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: documents documents_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.service_providers(id) ON DELETE CASCADE;


--
-- Name: documents documents_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES auth.users(id);


--
-- Name: favorite_providers favorite_providers_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_providers
    ADD CONSTRAINT favorite_providers_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: favorite_providers favorite_providers_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_providers
    ADD CONSTRAINT favorite_providers_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.service_providers(id) ON DELETE CASCADE;


--
-- Name: matches matches_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.service_providers(id) ON DELETE CASCADE;


--
-- Name: matches matches_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.service_requests(id) ON DELETE CASCADE;


--
-- Name: messages messages_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: provider_reports provider_reports_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_reports
    ADD CONSTRAINT provider_reports_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: provider_reports provider_reports_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_reports
    ADD CONSTRAINT provider_reports_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id) ON DELETE CASCADE;


--
-- Name: provider_reports provider_reports_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_reports
    ADD CONSTRAINT provider_reports_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.service_providers(id) ON DELETE CASCADE;


--
-- Name: ratings ratings_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: ratings ratings_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.service_providers(id) ON DELETE CASCADE;


--
-- Name: service_providers service_providers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_providers
    ADD CONSTRAINT service_providers_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: service_requests service_requests_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: user_onboarding user_onboarding_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_onboarding
    ADD CONSTRAINT user_onboarding_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: provider_reports Admins can read all reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can read all reports" ON public.provider_reports FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- Name: provider_reports Admins can update reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can update reports" ON public.provider_reports FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- Name: provider_reports Clients can create reports for their matches; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Clients can create reports for their matches" ON public.provider_reports FOR INSERT TO authenticated WITH CHECK (((EXISTS ( SELECT 1
   FROM public.matches m
  WHERE ((m.id = provider_reports.match_id) AND (EXISTS ( SELECT 1
           FROM public.service_requests sr
          WHERE ((sr.id = m.request_id) AND (sr.client_id = auth.uid()))))))) AND (client_id = auth.uid())));


--
-- Name: provider_reports Clients can read their own reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Clients can read their own reports" ON public.provider_reports FOR SELECT TO authenticated USING ((client_id = auth.uid()));


--
-- Name: email_logs Service role can insert email logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Service role can insert email logs" ON public.email_logs FOR INSERT TO service_role WITH CHECK (true);


--
-- Name: email_queue Service role can manage email queue; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Service role can manage email queue" ON public.email_queue TO service_role USING (true) WITH CHECK (true);


--
-- Name: email_logs Service role can read email logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Service role can read email logs" ON public.email_logs FOR SELECT TO service_role USING (true);


--
-- Name: notifications Users can delete own notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete own notifications" ON public.notifications FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: messages Users can insert messages in their matches; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert messages in their matches" ON public.messages FOR INSERT TO authenticated WITH CHECK (((EXISTS ( SELECT 1
   FROM public.matches m
  WHERE ((m.id = messages.match_id) AND ((EXISTS ( SELECT 1
           FROM public.service_requests sr
          WHERE ((sr.id = m.request_id) AND (sr.client_id = auth.uid())))) OR (EXISTS ( SELECT 1
           FROM public.service_providers sp
          WHERE ((sp.id = m.provider_id) AND (sp.user_id = auth.uid())))))))) AND (sender_id = auth.uid())));


--
-- Name: notifications Users can insert own notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own notifications" ON public.notifications FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: user_roles Users can insert own role; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own role" ON public.user_roles FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: messages Users can read messages in their matches; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can read messages in their matches" ON public.messages FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.matches m
  WHERE ((m.id = messages.match_id) AND ((EXISTS ( SELECT 1
           FROM public.service_requests sr
          WHERE ((sr.id = m.request_id) AND (sr.client_id = auth.uid())))) OR (EXISTS ( SELECT 1
           FROM public.service_providers sp
          WHERE ((sp.id = m.provider_id) AND (sp.user_id = auth.uid())))))))));


--
-- Name: notifications Users can read own notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can read own notifications" ON public.notifications FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: user_roles Users can read own role; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can read own role" ON public.user_roles FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: email_logs Users can read their own email logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can read their own email logs" ON public.email_logs FOR SELECT TO authenticated USING ((recipient = auth.email()));


--
-- Name: notifications Users can update own notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE USING ((auth.uid() = user_id));


--
-- Name: messages Users can update their own messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own messages" ON public.messages FOR UPDATE TO authenticated USING ((sender_id = auth.uid())) WITH CHECK ((sender_id = auth.uid()));


--
-- Name: service_providers admins delete providers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "admins delete providers" ON public.service_providers FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: favorite_providers admins manage favorites; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "admins manage favorites" ON public.favorite_providers TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: user_onboarding admins manage onboarding; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "admins manage onboarding" ON public.user_onboarding TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: user_roles admins manage roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "admins manage roles" ON public.user_roles TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: favorite_providers clients delete own favorites; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "clients delete own favorites" ON public.favorite_providers FOR DELETE TO authenticated USING ((client_id = auth.uid()));


--
-- Name: favorite_providers clients insert own favorites; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "clients insert own favorites" ON public.favorite_providers FOR INSERT TO authenticated WITH CHECK ((client_id = auth.uid()));


--
-- Name: favorite_providers clients view own favorites; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "clients view own favorites" ON public.favorite_providers FOR SELECT TO authenticated USING ((client_id = auth.uid()));


--
-- Name: documents; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;

--
-- Name: documents documents admin update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "documents admin update" ON public.documents FOR UPDATE TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: documents documents insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "documents insert" ON public.documents FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.service_providers p
  WHERE ((p.id = documents.provider_id) AND (p.user_id = auth.uid())))));


--
-- Name: documents documents read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "documents read" ON public.documents FOR SELECT TO authenticated USING (((EXISTS ( SELECT 1
   FROM public.service_providers p
  WHERE ((p.id = documents.provider_id) AND (p.user_id = auth.uid())))) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: email_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.email_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: email_queue; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.email_queue ENABLE ROW LEVEL SECURITY;

--
-- Name: favorite_providers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.favorite_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: matches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

--
-- Name: matches matches access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "matches access" ON public.matches FOR SELECT TO authenticated USING (((EXISTS ( SELECT 1
   FROM public.service_requests r
  WHERE ((r.id = matches.request_id) AND (r.client_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM public.service_providers p
  WHERE ((p.id = matches.provider_id) AND (p.user_id = auth.uid())))) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: matches matches client update inquiry; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "matches client update inquiry" ON public.matches FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.service_requests r
  WHERE ((r.id = matches.request_id) AND (r.client_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.service_requests r
  WHERE ((r.id = matches.request_id) AND (r.client_id = auth.uid())))));


--
-- Name: matches matches provider respond; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "matches provider respond" ON public.matches FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.service_providers p
  WHERE ((p.id = matches.provider_id) AND (p.user_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.service_providers p
  WHERE ((p.id = matches.provider_id) AND (p.user_id = auth.uid())))));


--
-- Name: messages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles profiles insert own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "profiles insert own" ON public.profiles FOR INSERT TO authenticated WITH CHECK ((id = auth.uid()));


--
-- Name: profiles profiles select all authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "profiles select all authenticated" ON public.profiles FOR SELECT TO authenticated USING (true);


--
-- Name: profiles profiles update own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "profiles update own" ON public.profiles FOR UPDATE TO authenticated USING ((id = auth.uid()));


--
-- Name: provider_reports; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.provider_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: service_providers providers insert own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "providers insert own" ON public.service_providers FOR INSERT TO authenticated WITH CHECK ((user_id = auth.uid()));


--
-- Name: service_providers providers public read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "providers public read" ON public.service_providers FOR SELECT USING (true);


--
-- Name: service_providers providers update own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "providers update own" ON public.service_providers FOR UPDATE TO authenticated USING (((user_id = auth.uid()) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: ratings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.ratings ENABLE ROW LEVEL SECURITY;

--
-- Name: ratings ratings insert own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "ratings insert own" ON public.ratings FOR INSERT TO authenticated WITH CHECK ((client_id = auth.uid()));


--
-- Name: ratings ratings read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "ratings read" ON public.ratings FOR SELECT USING (true);


--
-- Name: ratings ratings update own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "ratings update own" ON public.ratings FOR UPDATE TO authenticated USING ((client_id = auth.uid()));


--
-- Name: service_requests requests insert own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "requests insert own" ON public.service_requests FOR INSERT TO authenticated WITH CHECK ((client_id = auth.uid()));


--
-- Name: service_requests requests own select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "requests own select" ON public.service_requests FOR SELECT TO authenticated USING (((client_id = auth.uid()) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: service_requests requests update own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "requests update own" ON public.service_requests FOR UPDATE TO authenticated USING ((client_id = auth.uid()));


--
-- Name: service_providers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.service_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: service_requests; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.service_requests ENABLE ROW LEVEL SECURITY;

--
-- Name: user_onboarding; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_onboarding ENABLE ROW LEVEL SECURITY;

--
-- Name: user_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

--
-- Name: user_onboarding users insert own onboarding; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "users insert own onboarding" ON public.user_onboarding FOR INSERT TO authenticated WITH CHECK ((user_id = auth.uid()));


--
-- Name: user_onboarding users view own onboarding; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "users view own onboarding" ON public.user_onboarding FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: user_roles users view own roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "users view own roles" ON public.user_roles FOR SELECT TO authenticated USING (((user_id = auth.uid()) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Admins can read all documents; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Admins can read all documents" ON storage.objects FOR SELECT USING (((bucket_id = 'provider-documents'::text) AND (EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role))))));


--
-- Name: objects Providers can read own documents; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Providers can read own documents" ON storage.objects FOR SELECT USING (((bucket_id = 'provider-documents'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- Name: objects Providers can upload own documents; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Providers can upload own documents" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'provider-documents'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- Name: supabase_realtime favorite_providers; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.favorite_providers;


--
-- Name: supabase_realtime matches; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.matches;


--
-- Name: supabase_realtime messages; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.messages;


--
-- Name: supabase_realtime provider_reports; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.provider_reports;


--
-- Name: supabase_realtime service_providers; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.service_providers;


--
-- Name: supabase_realtime service_requests; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.service_requests;


--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION clear_all_notifications(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.clear_all_notifications() TO anon;
GRANT ALL ON FUNCTION public.clear_all_notifications() TO authenticated;
GRANT ALL ON FUNCTION public.clear_all_notifications() TO service_role;


--
-- Name: FUNCTION create_match_notification(p_match_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb, p_sender_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_match_notification(p_match_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb, p_sender_id uuid) TO anon;
GRANT ALL ON FUNCTION public.create_match_notification(p_match_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb, p_sender_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.create_match_notification(p_match_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb, p_sender_id uuid) TO service_role;


--
-- Name: FUNCTION create_notification(p_user_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_notification(p_user_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb) TO anon;
GRANT ALL ON FUNCTION public.create_notification(p_user_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.create_notification(p_user_id uuid, p_type text, p_title text, p_message text, p_metadata jsonb) TO service_role;


--
-- Name: FUNCTION delete_notification(notification_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.delete_notification(notification_id uuid) TO anon;
GRANT ALL ON FUNCTION public.delete_notification(notification_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.delete_notification(notification_id uuid) TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.handle_new_user() FROM PUBLIC;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;
GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;


--
-- Name: FUNCTION has_role(_user_id uuid, _role public.app_role); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) FROM PUBLIC;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO service_role;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO anon;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO authenticated;


--
-- Name: FUNCTION log_notification_email(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_notification_email() TO anon;
GRANT ALL ON FUNCTION public.log_notification_email() TO authenticated;
GRANT ALL ON FUNCTION public.log_notification_email() TO service_role;


--
-- Name: FUNCTION mark_all_notifications_as_read(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.mark_all_notifications_as_read() TO anon;
GRANT ALL ON FUNCTION public.mark_all_notifications_as_read() TO authenticated;
GRANT ALL ON FUNCTION public.mark_all_notifications_as_read() TO service_role;


--
-- Name: FUNCTION mark_notification_as_read(notification_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.mark_notification_as_read(notification_id uuid) TO anon;
GRANT ALL ON FUNCTION public.mark_notification_as_read(notification_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.mark_notification_as_read(notification_id uuid) TO service_role;


--
-- Name: FUNCTION recalc_provider_rating(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.recalc_provider_rating() FROM PUBLIC;
GRANT ALL ON FUNCTION public.recalc_provider_rating() TO service_role;
GRANT ALL ON FUNCTION public.recalc_provider_rating() TO anon;
GRANT ALL ON FUNCTION public.recalc_provider_rating() TO authenticated;


--
-- Name: FUNCTION request_provider_with_notification(p_match_id uuid, p_message text, p_client_user_id uuid, p_preferred_date text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.request_provider_with_notification(p_match_id uuid, p_message text, p_client_user_id uuid, p_preferred_date text) TO anon;
GRANT ALL ON FUNCTION public.request_provider_with_notification(p_match_id uuid, p_message text, p_client_user_id uuid, p_preferred_date text) TO authenticated;
GRANT ALL ON FUNCTION public.request_provider_with_notification(p_match_id uuid, p_message text, p_client_user_id uuid, p_preferred_date text) TO service_role;


--
-- Name: FUNCTION reset_verification_on_profile_update(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.reset_verification_on_profile_update() TO anon;
GRANT ALL ON FUNCTION public.reset_verification_on_profile_update() TO authenticated;
GRANT ALL ON FUNCTION public.reset_verification_on_profile_update() TO service_role;


--
-- Name: FUNCTION respond_to_inquiry_with_notification(p_match_id uuid, p_action text, p_provider_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.respond_to_inquiry_with_notification(p_match_id uuid, p_action text, p_provider_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.respond_to_inquiry_with_notification(p_match_id uuid, p_action text, p_provider_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.respond_to_inquiry_with_notification(p_match_id uuid, p_action text, p_provider_user_id uuid) TO service_role;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO service_role;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION send_binary(payload bytea, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION wal2json_escape_identifier(name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO postgres;
GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE mfa_recovery_code_sets; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_recovery_code_sets TO postgres;
GRANT ALL ON TABLE auth.mfa_recovery_code_sets TO dashboard_user;


--
-- Name: TABLE mfa_recovery_codes; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_recovery_codes TO postgres;
GRANT ALL ON TABLE auth.mfa_recovery_codes TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE scim_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.scim_tokens TO postgres;
GRANT ALL ON TABLE auth.scim_tokens TO dashboard_user;


--
-- Name: TABLE scim_users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.scim_users TO postgres;
GRANT ALL ON TABLE auth.scim_users TO dashboard_user;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE documents; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.documents TO anon;
GRANT ALL ON TABLE public.documents TO authenticated;
GRANT ALL ON TABLE public.documents TO service_role;


--
-- Name: TABLE email_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.email_logs TO anon;
GRANT ALL ON TABLE public.email_logs TO authenticated;
GRANT ALL ON TABLE public.email_logs TO service_role;


--
-- Name: TABLE email_queue; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.email_queue TO anon;
GRANT ALL ON TABLE public.email_queue TO authenticated;
GRANT ALL ON TABLE public.email_queue TO service_role;


--
-- Name: TABLE favorite_providers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.favorite_providers TO anon;
GRANT ALL ON TABLE public.favorite_providers TO authenticated;
GRANT ALL ON TABLE public.favorite_providers TO service_role;


--
-- Name: TABLE matches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.matches TO anon;
GRANT ALL ON TABLE public.matches TO authenticated;
GRANT ALL ON TABLE public.matches TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.messages TO anon;
GRANT ALL ON TABLE public.messages TO authenticated;
GRANT ALL ON TABLE public.messages TO service_role;


--
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notifications TO anon;
GRANT ALL ON TABLE public.notifications TO authenticated;
GRANT ALL ON TABLE public.notifications TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE provider_reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.provider_reports TO anon;
GRANT ALL ON TABLE public.provider_reports TO authenticated;
GRANT ALL ON TABLE public.provider_reports TO service_role;


--
-- Name: TABLE ratings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ratings TO anon;
GRANT ALL ON TABLE public.ratings TO authenticated;
GRANT ALL ON TABLE public.ratings TO service_role;


--
-- Name: TABLE service_providers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.service_providers TO anon;
GRANT ALL ON TABLE public.service_providers TO authenticated;
GRANT ALL ON TABLE public.service_providers TO service_role;


--
-- Name: TABLE service_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.service_requests TO anon;
GRANT ALL ON TABLE public.service_requests TO authenticated;
GRANT ALL ON TABLE public.service_requests TO service_role;


--
-- Name: TABLE user_onboarding; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_onboarding TO anon;
GRANT ALL ON TABLE public.user_onboarding TO authenticated;
GRANT ALL ON TABLE public.user_onboarding TO service_role;


--
-- Name: TABLE user_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_roles TO anon;
GRANT ALL ON TABLE public.user_roles TO authenticated;
GRANT ALL ON TABLE public.user_roles TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE realtime.messages TO postgres;
GRANT SELECT,INSERT ON TABLE realtime.messages TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2026_09_12; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_09_12 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_09_12 TO dashboard_user;


--
-- Name: TABLE messages_2026_09_13; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_09_13 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_09_13 TO dashboard_user;


--
-- Name: TABLE messages_2026_09_14; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_09_14 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_09_14 TO dashboard_user;


--
-- Name: TABLE messages_2026_09_15; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_09_15 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_09_15 TO dashboard_user;


--
-- Name: TABLE messages_2026_09_16; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_09_16 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_09_16 TO dashboard_user;


--
-- Name: TABLE messages_2026_09_17; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_09_17 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_09_17 TO dashboard_user;


--
-- Name: TABLE messages_2026_09_18; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages_2026_09_18 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_09_18 TO dashboard_user;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT SELECT,INSERT ON TABLES TO postgres WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict m63zohCVG30B9W0LFFzPDd5C6cJRHRLjjueoHCo5yiOTVKPGgKxTt6ODGgJ7F34

