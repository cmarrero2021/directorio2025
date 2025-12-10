--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: check_row_limit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_row_limit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verificar el número de registros en la tabla
    IF (SELECT COUNT(*) FROM inicio) >= 2 THEN
        RAISE EXCEPTION 'No se pueden insertar más de 2 registros en la tabla inicio';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_row_limit() OWNER TO postgres;

--
-- Name: notify_revistas_data_changes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_revistas_data_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Trigger disparado para evento %', TG_OP; -- Agregar este registro
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        PERFORM pg_notify(
            'revistas_data_updates',
            json_build_object(
                'evento', TG_OP,
                'data', row_to_json(NEW)
            )::text
        );
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        PERFORM pg_notify(
            'revistas_data_updates',
            json_build_object(
                'evento', TG_OP,
                'data', row_to_json(OLD)
            )::text
        );
        RETURN OLD;
    END IF;
END;
$$;


ALTER FUNCTION public.notify_revistas_data_changes() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: areas_conocimiento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.areas_conocimiento (
    id integer NOT NULL,
    area_conocimiento character varying(50) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.areas_conocimiento OWNER TO postgres;

--
-- Name: areas_conocimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.areas_conocimiento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.areas_conocimiento_id_seq OWNER TO postgres;

--
-- Name: areas_conocimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.areas_conocimiento_id_seq OWNED BY public.areas_conocimiento.id;


--
-- Name: blacklisted_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blacklisted_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.blacklisted_tokens_id_seq OWNER TO postgres;

--
-- Name: blacklisted_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blacklisted_tokens (
    id integer DEFAULT nextval('public.blacklisted_tokens_id_seq'::regclass) NOT NULL,
    token character varying(255) NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE public.blacklisted_tokens OWNER TO postgres;

--
-- Name: editoriales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editoriales (
    id integer NOT NULL,
    editorial text NOT NULL,
    url character varying(50),
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.editoriales OWNER TO postgres;

--
-- Name: editoriales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.editoriales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.editoriales_id_seq OWNER TO postgres;

--
-- Name: editoriales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.editoriales_id_seq OWNED BY public.editoriales.id;


--
-- Name: email_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_verifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.email_verifications_id_seq OWNER TO postgres;

--
-- Name: email_verifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_verifications (
    id integer DEFAULT nextval('public.email_verifications_id_seq'::regclass) NOT NULL,
    user_id integer,
    token character varying(255) NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.email_verifications OWNER TO postgres;

--
-- Name: estados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estados (
    id integer NOT NULL,
    estado character varying(50) NOT NULL,
    iso_3166_2 character varying(4) NOT NULL
);


ALTER TABLE public.estados OWNER TO postgres;

--
-- Name: estados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.estados_id_seq OWNER TO postgres;

--
-- Name: estados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estados_id_seq OWNED BY public.estados.id;


--
-- Name: formatos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formatos (
    id integer NOT NULL,
    formato character varying(30) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.formatos OWNER TO postgres;

--
-- Name: formatos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.formatos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.formatos_id_seq OWNER TO postgres;

--
-- Name: formatos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formatos_id_seq OWNED BY public.formatos.id;


--
-- Name: idiomas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idiomas (
    id integer NOT NULL,
    idioma character varying(25) NOT NULL,
    iso character varying(3) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.idiomas OWNER TO postgres;

--
-- Name: idiomas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.idiomas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.idiomas_id_seq OWNER TO postgres;

--
-- Name: idiomas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.idiomas_id_seq OWNED BY public.idiomas.id;


--
-- Name: indices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.indices (
    id integer NOT NULL,
    indice character varying(100) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.indices OWNER TO postgres;

--
-- Name: indices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.indices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.indices_id_seq OWNER TO postgres;

--
-- Name: indices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.indices_id_seq OWNED BY public.indices.id;


--
-- Name: inicio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inicio (
    id integer NOT NULL,
    orden smallint NOT NULL,
    titulo character varying(100) NOT NULL,
    contenido text NOT NULL,
    imagen character(100) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at time(6) without time zone,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.inicio OWNER TO postgres;

--
-- Name: inicio_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inicio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.inicio_id_seq OWNER TO postgres;

--
-- Name: inicio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inicio_id_seq OWNED BY public.inicio.id;


--
-- Name: login_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.login_logs_id_seq OWNER TO postgres;

--
-- Name: login_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_logs (
    id integer DEFAULT nextval('public.login_logs_id_seq'::regclass) NOT NULL,
    user_id integer,
    username character varying(255) NOT NULL,
    ip_address inet NOT NULL,
    login_timestamp timestamp(6) without time zone DEFAULT now(),
    login_status character varying(50) NOT NULL,
    logout_type character varying(50),
    logout_timestamp timestamp(6) without time zone,
    session_token character varying(255)
);


ALTER TABLE public.login_logs OWNER TO postgres;

--
-- Name: menu_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu_categories (
    id integer NOT NULL,
    name text NOT NULL,
    icon text,
    display_order integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.menu_categories OWNER TO postgres;

--
-- Name: menu_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.menu_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_categories_id_seq OWNER TO postgres;

--
-- Name: menu_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.menu_categories_id_seq OWNED BY public.menu_categories.id;


--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu_items (
    id integer NOT NULL,
    category_id integer,
    title text NOT NULL,
    icon text NOT NULL,
    path text NOT NULL,
    permission_name text,
    parent_id integer,
    item_order integer DEFAULT 0 NOT NULL,
    is_divider boolean DEFAULT false,
    is_header boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.menu_items OWNER TO postgres;

--
-- Name: menu_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.menu_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_items_id_seq OWNER TO postgres;

--
-- Name: menu_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;


--
-- Name: password_resets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.password_resets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.password_resets_id_seq OWNER TO postgres;

--
-- Name: password_resets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_resets (
    id integer DEFAULT nextval('public.password_resets_id_seq'::regclass) NOT NULL,
    user_id integer,
    token character varying(255) NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.password_resets OWNER TO postgres;

--
-- Name: periodicidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periodicidad (
    id integer NOT NULL,
    periodicidad character varying(20) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now(),
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.periodicidad OWNER TO postgres;

--
-- Name: periodicidad_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.periodicidad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.periodicidad_id_seq OWNER TO postgres;

--
-- Name: periodicidad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.periodicidad_id_seq OWNED BY public.periodicidad.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    resource text NOT NULL,
    action text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq1 OWNER TO postgres;

--
-- Name: permissions_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq1 OWNED BY public.permissions.id;


--
-- Name: revistas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revistas (
    id integer NOT NULL,
    area_conocimiento_id integer NOT NULL,
    indice_id integer NOT NULL,
    idioma_id integer NOT NULL,
    revista character varying(50) NOT NULL,
    correo_revista character varying(100),
    editorial_id integer NOT NULL,
    periodicidad_id integer NOT NULL,
    formato_id integer NOT NULL,
    estado_id integer NOT NULL,
    nombres_editor character varying(20),
    apellidos_editor character varying(20),
    correo_editor character varying(100),
    deposito_legal_impreso character varying(100),
    deposito_legal_digital character varying(100),
    issn_impreso character varying(50),
    issn_digital character varying(50),
    url character varying(200),
    anio_inicial smallint,
    direccion text,
    telefono character varying(11),
    resumen text DEFAULT ''::text,
    portada character varying DEFAULT ''::character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.revistas OWNER TO postgres;

--
-- Name: revistas_data; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.revistas_data AS
 SELECT r.id,
    r.revista,
    ac.area_conocimiento,
    i.indice,
    id.idioma,
    e.editorial,
    p.periodicidad,
    f.formato,
    es.estado,
    r.nombres_editor,
    r.apellidos_editor,
    r.correo_editor,
    r.deposito_legal_impreso,
    r.deposito_legal_digital,
    r.issn_impreso,
    r.issn_digital,
    r.url,
    r.anio_inicial,
    r.direccion,
    r.telefono,
    r.resumen,
    r.portada
   FROM (((((((public.revistas r
     LEFT JOIN public.areas_conocimiento ac ON ((r.area_conocimiento_id = ac.id)))
     LEFT JOIN public.indices i ON ((r.indice_id = i.id)))
     LEFT JOIN public.idiomas id ON ((r.idioma_id = id.id)))
     LEFT JOIN public.editoriales e ON ((r.editorial_id = e.id)))
     LEFT JOIN public.periodicidad p ON ((r.periodicidad_id = p.id)))
     LEFT JOIN public.formatos f ON ((r.formato_id = f.id)))
     LEFT JOIN public.estados es ON ((r.estado_id = es.id)));


ALTER VIEW public.revistas_data OWNER TO postgres;

--
-- Name: revistas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.revistas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.revistas_id_seq OWNER TO postgres;

--
-- Name: revistas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.revistas_id_seq OWNED BY public.revistas.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    session_timeout_min integer
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq1 OWNER TO postgres;

--
-- Name: roles_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq1 OWNED BY public.roles.id;


--
-- Name: session_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_settings (
    id integer NOT NULL,
    global_timeout integer DEFAULT 120,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT single_global_setting CHECK ((id = 1))
);


ALTER TABLE public.session_settings OWNER TO postgres;

--
-- Name: session_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.session_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.session_settings_id_seq OWNER TO postgres;

--
-- Name: session_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.session_settings_id_seq OWNED BY public.session_settings.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    user_id integer,
    token text NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    is_revoked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sessions_id_seq OWNER TO postgres;

--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: suscriptores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suscriptores (
    id bigint NOT NULL,
    correo text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.suscriptores OWNER TO postgres;

--
-- Name: suscriptores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suscriptores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suscriptores_id_seq OWNER TO postgres;

--
-- Name: suscriptores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suscriptores_id_seq OWNED BY public.suscriptores.id;


--
-- Name: user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_permissions (
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.user_permissions OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    cedula integer NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    is_email_verified boolean DEFAULT false,
    status text DEFAULT 'active'::text,
    is_temporary_password boolean DEFAULT true,
    failed_attempts integer DEFAULT 0,
    lock_until timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    session_timeout_min integer,
    failed_login_attempts integer DEFAULT 0,
    last_failed_login timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT users_status_check CHECK ((status = ANY (ARRAY['active'::text, 'suspended'::text, 'deactivated'::text])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq1 OWNER TO postgres;

--
-- Name: users_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq1 OWNED BY public.users.id;


--
-- Name: vcantidades; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vcantidades AS
 SELECT ( SELECT DISTINCT count(*) AS cant_revistas
           FROM public.revistas) AS revistas,
    ( SELECT DISTINCT count(*) AS cant_area
           FROM ( SELECT DISTINCT revistas.area_conocimiento_id
                   FROM public.revistas) areas) AS cant_area,
    ( SELECT DISTINCT count(*) AS cant_indices
           FROM ( SELECT DISTINCT revistas.indice_id
                   FROM public.revistas) indices) AS cant_indices,
    ( SELECT DISTINCT count(*) AS cant_idiomas
           FROM ( SELECT DISTINCT revistas.idioma_id
                   FROM public.revistas) idiomas) AS cant_idiomas,
    ( SELECT DISTINCT count(*) AS cant_editoriales
           FROM ( SELECT DISTINCT revistas.editorial_id
                   FROM public.revistas) editoriales) AS cant_editoriales;


ALTER VIEW public.vcantidades OWNER TO postgres;

--
-- Name: vdata_estados; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vdata_estados AS
 SELECT b.estado,
    count(DISTINCT a.area_conocimiento_id) AS cantidad_area_conocimiento,
    count(DISTINCT a.indice_id) AS cantidad_indice,
    count(DISTINCT a.idioma_id) AS cantidad_idioma,
    count(DISTINCT a.revista) AS cantidad_revista,
    count(DISTINCT a.editorial_id) AS cantidad_editorial,
    count(DISTINCT a.periodicidad_id) AS cantidad_periodicidad,
    count(DISTINCT a.formato_id) AS cantidad_formato
   FROM (public.revistas a
     LEFT JOIN public.estados b ON ((b.id = a.estado_id)))
  GROUP BY b.estado;


ALTER VIEW public.vdata_estados OWNER TO postgres;

--
-- Name: vdata_nacional; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vdata_nacional AS
 SELECT 'TODOS'::text AS estado,
    count(DISTINCT area_conocimiento_id) AS cantidad_area_conocimiento,
    count(DISTINCT indice_id) AS cantidad_indice,
    count(DISTINCT idioma_id) AS cantidad_idioma,
    count(DISTINCT revista) AS cantidad_revista,
    count(DISTINCT editorial_id) AS cantidad_editorial,
    count(DISTINCT periodicidad_id) AS cantidad_periodicidad,
    count(DISTINCT formato_id) AS cantidad_formato
   FROM public.revistas a;


ALTER VIEW public.vdata_nacional OWNER TO postgres;

--
-- Name: vestados; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vestados AS
 SELECT id,
    estado
   FROM public.estados
  ORDER BY
        CASE
            WHEN (id = 24) THEN 1
            WHEN (id = 14) THEN 2
            ELSE 3
        END, estado;


ALTER VIEW public.vestados OWNER TO postgres;

--
-- Name: vroles_permissions; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vroles_permissions AS
 SELECT a.role_id,
    b.name AS rol,
    a.permission_id,
    c.name AS permission,
    c.description
   FROM ((public.role_permissions a
     LEFT JOIN public.roles b ON ((b.id = a.role_id)))
     LEFT JOIN public.permissions c ON ((c.id = a.permission_id)))
  ORDER BY b.name, c.name;


ALTER VIEW public.vroles_permissions OWNER TO postgres;

--
-- Name: areas_conocimiento id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas_conocimiento ALTER COLUMN id SET DEFAULT nextval('public.areas_conocimiento_id_seq'::regclass);


--
-- Name: editoriales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editoriales ALTER COLUMN id SET DEFAULT nextval('public.editoriales_id_seq'::regclass);


--
-- Name: estados id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados ALTER COLUMN id SET DEFAULT nextval('public.estados_id_seq'::regclass);


--
-- Name: formatos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formatos ALTER COLUMN id SET DEFAULT nextval('public.formatos_id_seq'::regclass);


--
-- Name: idiomas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idiomas ALTER COLUMN id SET DEFAULT nextval('public.idiomas_id_seq'::regclass);


--
-- Name: indices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indices ALTER COLUMN id SET DEFAULT nextval('public.indices_id_seq'::regclass);


--
-- Name: inicio id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inicio ALTER COLUMN id SET DEFAULT nextval('public.inicio_id_seq'::regclass);


--
-- Name: menu_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_categories ALTER COLUMN id SET DEFAULT nextval('public.menu_categories_id_seq'::regclass);


--
-- Name: menu_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);


--
-- Name: periodicidad id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodicidad ALTER COLUMN id SET DEFAULT nextval('public.periodicidad_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq1'::regclass);


--
-- Name: revistas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revistas ALTER COLUMN id SET DEFAULT nextval('public.revistas_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq1'::regclass);


--
-- Name: session_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_settings ALTER COLUMN id SET DEFAULT nextval('public.session_settings_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: suscriptores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suscriptores ALTER COLUMN id SET DEFAULT nextval('public.suscriptores_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq1'::regclass);


--
-- Data for Name: areas_conocimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.areas_conocimiento (id, area_conocimiento, created_at, updated_at, deleted_at) FROM stdin;
1	ARTES Y HUMANIDADES	2025-12-10 07:53:08.496222	\N	\N
2	CIENCIAS AGRICOLAS	2025-12-10 07:53:08.496222	\N	\N
3	CIENCIAS MEDICAS Y DE LA SALUD	2025-12-10 07:53:08.496222	\N	\N
4	CIENCIAS NATURALES	2025-12-10 07:53:08.496222	\N	\N
5	INGENIERÌA Y TECNOLOGÌA	2025-12-10 07:53:08.496222	\N	\N
\.


--
-- Data for Name: blacklisted_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blacklisted_tokens (id, token, expires_at, created_at) FROM stdin;
1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTczOTgwMDUzMCwiZXhwIjoxNzM5ODA0MTMwfQ.NKNcOd9ZM8dYnHaSb3LUbcQ-zs7iH3xho3zx7WVGLPI	2025-02-17 10:55:30	2025-02-17 09:56:46.873607
2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTczOTgxNTY1OSwiZXhwIjoxNzM5ODE5MjU5fQ.67kAtae1D51-wBB4169wE7GjB2Rxc4M_hoN6F-JzYPw	2025-02-17 15:07:39	2025-02-17 14:09:29.370066
3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTczOTgxNjgxNiwiZXhwIjoxNzM5ODIwNDE2fQ.2YnJ1-oouMAcrxDe7K3TVM_mH4BNLwotTdyAhaS2GSg	2025-02-17 15:26:56	2025-02-17 14:35:00.39816
4	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTczOTg4NjIxMywiZXhwIjoxNzM5ODg5ODEzfQ.DaiTVMmnU1vuMbEX3lebJb8tMDHMqEURa58VT9G2DKc	2025-02-18 10:43:33	2025-02-18 09:47:12.155295
5	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTczOTg4NjQzNSwiZXhwIjoxNzM5ODkwMDM1fQ.7518JQy1eCNnsCNijrisXN619sByoB-JaRvzhczzC6w	2025-02-18 10:47:15	2025-02-18 09:49:15.468867
6	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0MDAwMDExOCwiZXhwIjoxNzQwMDAzNzE4fQ.774yiEPqxngH4MRlFyqf254X6fyVK1LZm7I4ow8O4D0	2025-02-19 18:21:58	2025-02-19 17:22:35.822469
7	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0MDAwMDE4NywiZXhwIjoxNzQwMDAzNzg3fQ.z_bctxo-vb9HdLjEPrNeOJRwzzgFGBuiHLcVMuIbB94	2025-02-19 18:23:07	2025-02-19 18:14:43.592292
8	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0MDAwMzI5MCwiZXhwIjoxNzQwMDA2ODkwfQ.urxCI9uA5TJ_EnXHMsOrw-2TTVtGq7hjAFG7S_p7NvY	2025-02-19 19:14:50	2025-02-19 18:22:14.372216
9	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0MDAwMzk3OSwiZXhwIjoxNzQwMDA3NTc5fQ.TRoluw2FMeW_ghC2v-NqrDEquq3tX2XnzQnKsVX5pwY	2025-02-19 19:26:19	2025-02-19 18:26:26.618986
10	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0MDAwNjYyOSwiZXhwIjoxNzQwMDEwMjI5fQ.UdmEkgzSuBHnzsqqz6c9JUXLub1ZVY8LBmsznW4hrSw	2025-02-19 20:10:29	2025-02-19 19:11:36.650987
11	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0MDAwNjcwMiwiZXhwIjoxNzQwMDEwMzAyfQ.KfREOBiYyH34YSacLhi61Lyo_gg0s7MMgcmDEVb1Cww	2025-02-19 20:11:42	2025-02-19 19:13:33.499081
1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NjcyMjU3NiwiZXhwIjoxNzQ2NzI5Nzc2fQ.0NpK0jjkc_EzOfcne7v4PyMeuEdrNBEMZQqjGpFbYvs	2025-05-08 18:42:56	2025-05-08 16:43:23.781371
2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NjczNjczNCwiZXhwIjoxNzQ2NzQwMzM0fQ.x5XVzS5jJlsOgZLOFTe_L1-8qeNF19PYAIxwMb7wkIc	2025-05-08 21:38:54	2025-05-08 20:51:59.793847
3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NjczODA1NywiZXhwIjoxNzQ2NzQ1MjU3fQ._FgVN-GztD_O6sGi1D104OHSXJ3DPV_FjOSYtkupDGM	2025-05-08 23:00:57	2025-05-08 21:04:15.332506
4	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NjgzOTg0NiwiZXhwIjoxNzQ2ODQ3MDQ2fQ.4CmpXjR0PU77O0Aiq0CVH_rw0C5Ng8vBL3-F2GTctQQ	2025-05-10 03:17:26	2025-05-10 01:18:41.004969
5	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NjgzOTk0MywiZXhwIjoxNzQ2ODQ3MTQzfQ.FgTK3TtKOxz6G6vKztZYQrCrED7q9lgZGCwVuJ451cQ	2025-05-10 03:19:03	2025-05-10 01:20:31.089479
6	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njg0MDA5MSwiZXhwIjoxNzQ2ODQ3MjkxfQ.VmyLaj_ihjwf-wyyVJ41BxquACjsi8FxS-nojgh1tVM	2025-05-10 03:21:31	2025-05-10 01:22:16.562705
7	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njk4NDUxNCwiZXhwIjoxNzQ2OTkxNzE0fQ.rCISBlc7qW_HaxQmP5wz7PPWXG4h5PKZw5ZwQouDfbs	2025-05-11 19:28:34	2025-05-11 17:29:13.892544
8	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njk4NTA1NCwiZXhwIjoxNzQ2OTkyMjU0fQ.hOIIbkVkUC6qo80JE-Cw6oSX9tUrDVqLUjRHiyVJWP4	2025-05-11 19:37:34	2025-05-11 17:37:40.329699
9	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njk4NTA2NSwiZXhwIjoxNzQ2OTkyMjY1fQ.ja4MOmcm6gA52H91MWzqp3jRjPkW0BCtGTTojchd8ks	2025-05-11 19:37:45	2025-05-11 17:37:48.274858
10	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njk4NTg4NCwiZXhwIjoxNzQ2OTkzMDg0fQ.YGqstzOcN7Wy3jsWYfAxgGDS7KLKIpp1F2VSM8Atgp4	2025-05-11 19:51:24	2025-05-11 17:51:29.177089
11	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njk4NjExNSwiZXhwIjoxNzQ2OTkzMzE1fQ.ozz66LlcfXYdz_U2xx6ESUTQ09TPQmL2GDIkErO97hg	2025-05-11 19:55:15	2025-05-11 17:55:21.368482
12	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njk4NjEyNSwiZXhwIjoxNzQ2OTkzMzI1fQ.xftL7nn_RTe3mp43ioqzWO7y0nK4Q7sYej9ToIKpSkk	2025-05-11 19:55:25	2025-05-11 17:55:27.765873
13	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njk4NjI1MiwiZXhwIjoxNzQ2OTkzNDUyfQ.8DgeqeI5N9raZnCkd4Mrc-tXYmBRBXu82EmOUN02egM	2025-05-11 19:57:32	2025-05-11 18:36:28.759011
14	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njk4OTU4NSwiZXhwIjoxNzQ2OTk2Nzg1fQ.sdWNsxHbw1p1xyhjn62WXbbPc9rQf374_DjeQquwah8	2025-05-11 20:53:05	2025-05-11 18:53:11.487488
15	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0Njk5MDIzNiwiZXhwIjoxNzQ2OTk3NDM2fQ.LOiwc2JBs3lZfNu5pPZ3Yz4reJFdRGyt-H19mb75F5U	2025-05-11 21:03:56	2025-05-11 19:04:10.332124
16	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzAwMTYxMSwiZXhwIjoxNzQ3MDA4ODExfQ.ns8Cdoujy1PLxACwEirmZkbkisaivvch0ofdNRZ0AwE	2025-05-12 00:13:31	2025-05-11 22:13:40.201045
17	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzAzODkzNCwiZXhwIjoxNzQ3MDQ2MTM0fQ.9qIlJ8G6qyZGCD_IklBNO_7UYaCPU4ZGyJOgzZSHjKY	2025-05-12 10:35:34	2025-05-12 08:51:24.06498
18	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzA0MDQ4NiwiZXhwIjoxNzQ3MDQ3Njg2fQ.qa5aXMO34T_LZd4VcMZgVntOQP21G20anZhYQ8WESf0	2025-05-12 11:01:26	2025-05-12 09:06:38.799271
19	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzA0MDgwMiwiZXhwIjoxNzQ3MDQ4MDAyfQ.OwsGH3zSHPMrsq125sb-SqowgvIQpWyDajRw2EZIfyw	2025-05-12 11:06:42	2025-05-12 09:11:01.315866
20	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzA0MTA2NCwiZXhwIjoxNzQ3MDQ4MjY0fQ.4q29Gqgv7FkMhMXnpe3R7MhDk3HzCi2PtAmuZDy6OO8	2025-05-12 11:11:04	2025-05-12 09:11:28.512221
21	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzA0MTA5MSwiZXhwIjoxNzQ3MDQ4MjkxfQ.iFDLlFqo7M8a-nFwoyZGhUPR-aWWGmfJTM4XaHCkJno	2025-05-12 11:11:31	2025-05-12 09:11:57.872158
22	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzA0MTEyMSwiZXhwIjoxNzQ3MDQ4MzIxfQ.Dji5InMhyPj2MFeO3lRmqs5NCquQWCHtLJpambEpGjU	2025-05-12 11:12:01	2025-05-12 09:16:17.387298
23	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzA0MTM4MCwiZXhwIjoxNzQ3MDQ4NTgwfQ.w9GNDdeOLfQDKmerumgv68Ps9cssaXuAsre-005WCJc	2025-05-12 11:16:20	2025-05-12 09:17:23.436089
24	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzA0MTQ0NSwiZXhwIjoxNzQ3MDQ4NjQ1fQ.kFg76CQQo7k4YqoVJLCGKIC57s-AkiWCFOmltLdEkPU	2025-05-12 11:17:25	2025-05-12 10:07:13.896105
25	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzA0NDQ5MiwiZXhwIjoxNzQ3MDUxNjkyfQ.zK5nJzJYGZNTahsTSOM1A-LeHU-adZCqxnCoUMiyBas	2025-05-12 12:08:12	2025-05-12 10:18:26.569655
26	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzA0NTE1OCwiZXhwIjoxNzQ3MDUyMzU4fQ.3aG-iUIMBTvrOCLo9ezJUvTf28HrAUChfwLha4NVW-I	2025-05-12 12:19:18	2025-05-12 10:24:35.850327
27	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzE1NDg5MSwiZXhwIjoxNzQ3MTYyMDkxfQ.XSbIv2uM6rsJu5SYf8Rad0GE8EYynSsOdzbGUkHQ4ec	2025-05-13 18:48:11	2025-05-13 16:49:08.190139
28	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0NzE1NDk1NiwiZXhwIjoxNzQ3MTYyMTU2fQ.stBbSdLaiLyVecGpY4qNYVEf0q07hDvGSaygymTUEgU	2025-05-13 18:49:16	2025-05-13 16:49:21.990867
29	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDkxNiwiZXhwIjoxNzUwMTYxMTU2fQ.3dQXNSdm-SkUiE2wr6hXDoc0GbeZq95x0VlhhCRn7tc	2025-06-17 07:52:36	2025-06-17 07:52:31.720327
30	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTIxNiwiZXhwIjoxNzUwMTYxNDU2fQ.WuTCiAtu8M4ZTyU-4GDj69n7H_QwqLGeRB9qnBhFauw	2025-06-17 07:57:36	2025-06-17 07:54:15.248123
31	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTIxNiwiZXhwIjoxNzUwMTYxNDU2fQ.WuTCiAtu8M4ZTyU-4GDj69n7H_QwqLGeRB9qnBhFauw	2025-06-17 07:57:36	2025-06-17 07:58:15.120081
32	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTk0MSwiZXhwIjoxNzUwMTYyMTgxfQ.YsxFC_8FoJzVc1_Oi4q_UW1FKN6oBIOFlk3alH13o3E	2025-06-17 08:09:41	2025-06-17 08:06:06.908257
33	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4ODg5OCwiZXhwIjoxNzUwNjg5MTM4fQ.KQFsikGvcqbl9A2eIgwPErf2REkuGFqfBY8KDysXBkk	2025-06-23 10:32:18	2025-06-23 10:28:28.48921
34	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4OTIxMiwiZXhwIjoxNzUwNjg5NDUyfQ.KvCQmN-f0tfIK9AaUWGFor8f3A3BT7zRmhe4zbcuPxc	2025-06-23 10:37:32	2025-06-23 10:33:36.962895
35	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4OTgyMiwiZXhwIjoxNzUwNjkwMDYyfQ.WG81LACtPX5Hitb1ndvEP_dH1P3sbSRq_TAAaU93-cA	2025-06-23 10:47:42	2025-06-23 10:43:55.44751
36	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTEzNiwiZXhwIjoxNzUwNjkxMzc2fQ.2jkG_ALjL0LMcqMpohAzTXix2Elx0YlL8RmGuW-0GgU	2025-06-23 11:09:36	2025-06-23 11:05:49.898322
37	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTYxOSwiZXhwIjoxNzUwNjkxODU5fQ.ujaAPoTQylv6kJlZs99HRD8oCguaAHRbQs6iZt2mnU4	2025-06-23 11:17:39	2025-06-23 11:13:42.882239
38	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjE2OCwiZXhwIjoxNzUwNjkyMjg4fQ.TSnp8Oet2nAAS4Bp9THCBGjD88o3511AaqeKWPOLdbk	2025-06-23 11:24:48	2025-06-23 11:23:34.915173
39	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzU2NywiZXhwIjoxNzUwNjkzNjI3fQ.S9xRGO4l_azNs-IWk0r0Jd_-p_yBJK88kQ_RMEgHYbQ	2025-06-23 11:47:07	2025-06-23 11:46:24.487929
40	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mzk1OSwiZXhwIjoxNzUwNjk0MDE5fQ.SshMZBGveEbJM54WXPRAwQsa6v_Q8AmlnoNcSdNSc7s	2025-06-23 11:53:39	2025-06-23 11:52:51.71636
41	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NDU5NiwiZXhwIjoxNzUwNjk0NjU2fQ.P8OcVwDRaP6nEidHiCRvHNZgPZuhwyIAfcqKHO61-gY	2025-06-23 12:04:16	2025-06-23 12:04:06.912472
42	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NjMyMiwiZXhwIjoxNzUwNjk2MzgyfQ.gkHJsuYzJV6Jy6EMCxIqNc2jDXuDMAdUJq25ykBnlDA	2025-06-23 12:33:02	2025-06-23 12:32:52.221142
43	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzQwNCwiZXhwIjoxNzUwNzAzNDY0fQ.t4lYd14zEOvLnKmR-04Q7_-W8iKsohrCDEEH6QW9cKI	2025-06-23 14:31:04	2025-06-23 14:30:44.432094
44	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDA1MCwiZXhwIjoxNzUwNzA0NjUwfQ.VZjQoH_IPneHMOqA-eN6BW-sij-Ps3PbcY4wwuCau8k	2025-06-23 14:50:50	2025-06-23 14:41:01.635664
45	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDA4MiwiZXhwIjoxNzUwNzA0NjgyfQ.xmpFzxB545fRBxh9pbsJ1ytvCcIiX1jzK8OUCWzLknc	2025-06-23 14:51:22	2025-06-23 14:41:42.70627
46	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDM1NCwiZXhwIjoxNzUwNzA0NDc0fQ.74GK3SBhWhdX2Trf244_SpciAmQ4gOw0WIsgxqN9fvI	2025-06-23 14:47:54	2025-06-23 14:46:07.33076
47	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDM4NywiZXhwIjoxNzUwNzA0NTA3fQ.SaIRSlv4z7XaD-uP-ZyL54Ly8nL7LmeyI8PHG3Ojc3I	2025-06-23 14:48:27	2025-06-23 14:48:07.692917
48	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDg5OSwiZXhwIjoxNzUwNzA0OTU5fQ.VMy2czYxmuX1_Hh-Ne7cI2tMpFytXaH67a2RFa9gXBw	2025-06-23 14:55:59	2025-06-23 14:55:39.431526
49	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTExNSwiZXhwIjoxNzUwNzA1MTc1fQ.DhyYZLJ6YQDzrdYVTmqid6Ulq8TG4B0Q7LCB7G4vo9Q	2025-06-23 14:59:35	2025-06-23 14:59:25.51521
50	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTM0NywiZXhwIjoxNzUwNzA1NDA3fQ.ZBoNBDL1qSugb-k_k87Q_MIQI-sPeQ9j7txUp7mJaYA	2025-06-23 15:03:27	2025-06-23 15:03:17.481184
51	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTY2NCwiZXhwIjoxNzUwNzA1NzI0fQ.MPsPus4jkwLBiYN9stfAe_wfDCuGGSZjMEtqczJEdmk	2025-06-23 15:08:44	2025-06-23 15:08:34.358989
52	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTgyMiwiZXhwIjoxNzUwNzA1ODgyfQ.wSSk9MdfIirqc0AKy_uBMFIxaEYkQssnWspMMo6_HE0	2025-06-23 15:11:22	2025-06-23 15:11:12.726577
53	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTkzNiwiZXhwIjoxNzUwNzA1OTk2fQ.az2XkLqDg8ZUXP72awrgheTk-8c1XVe2QratK5yz2Q8	2025-06-23 15:13:16	2025-06-23 15:13:06.720553
54	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjUzOSwiZXhwIjoxNzUwNzA2NTk5fQ.LrD4V4Nt0sYgz0v6JYYsoKZM2taDuRRXn2-O1Z3O3_A	2025-06-23 15:23:19	2025-06-23 15:23:09.559745
55	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzA3OCwiZXhwIjoxNzUwNzA3MTM4fQ.hZQQ5nAiXoiYxXgkqxRGYDaOyHZvHrfBwW3tpwRfrKA	2025-06-23 15:32:18	2025-06-23 15:31:27.930806
56	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzI5MCwiZXhwIjoxNzUwNzA3MzUwfQ.G6QGf0ANrCRsQmziwgPhIaMaUecMuYC75nQXTGt3GDU	2025-06-23 15:35:50	2025-06-23 15:35:04.420411
57	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzQ2OSwiZXhwIjoxNzUwNzA3NTI5fQ.UeS8jRXjnND0iI_gCzlJkMgEX6f0M8BP-xfNm3RidfU	2025-06-23 15:38:49	2025-06-23 15:38:04.125412
58	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzU0MCwiZXhwIjoxNzUwNzA3NjAwfQ.yyclEfrtK2Y8N6mAQxr3UPRHrhhQBonu__KYvkHkThY	2025-06-23 15:40:00	2025-06-23 15:39:14.327283
59	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNDgwMiwiZXhwIjoxNzUxMzE0ODYyfQ.75rFJtNTA6JqLjDfq3ciouFnmc9ReZrdSz7Lgymvtb4	2025-06-30 16:21:02	2025-06-30 16:20:43.090718
60	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNTk1NCwiZXhwIjoxNzUxMzE2MDE0fQ.wKYEti891r7ywC978T9enbupxCDjDEvNpR7-RaV8X2k	2025-06-30 16:40:14	2025-06-30 16:39:54.82769
61	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjE1MywiZXhwIjoxNzUxMzE2MjEzfQ.cWelUvZFNvDleP60bZX6BFcBRrYBWrdWkJAk2G06oJU	2025-06-30 16:43:33	2025-06-30 16:43:13.340817
62	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjE5NywiZXhwIjoxNzUxMzE2MjU3fQ.2ZUqMgNHDQWlJq367w1FHZLr81zJhzzhOXzpVnfwPsc	2025-06-30 16:44:17	2025-06-30 16:43:57.590933
63	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjI0NCwiZXhwIjoxNzUxMzE2MzA0fQ.VMlnBUyllkii7bSzx39CD59Uym4I48FLn6WdK-V5zBw	2025-06-30 16:45:04	2025-06-30 16:44:44.619694
64	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjI4NywiZXhwIjoxNzUxMzE2MzQ3fQ.bWA3fvwg5xQd4uDOHfRcgkYv1KLgq_X_vsqI3NsP008	2025-06-30 16:45:47	2025-06-30 16:45:27.991944
65	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzcxNywiZXhwIjoxNzUxMzE3Nzc3fQ.81Nn1xbhzThNkLVd3BwNq0puLgGlGh6BgESt93dlL3o	2025-06-30 17:09:37	2025-06-30 17:09:18.02368
66	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzc2OCwiZXhwIjoxNzUxMzE3ODI4fQ.jJTa2unVjOapNHKNl6FHwTzG0hZbKj6pvUBqjatt4wk	2025-06-30 17:10:28	2025-06-30 17:10:08.645464
67	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzg3OSwiZXhwIjoxNzUxMzE3OTM5fQ.XcfJvqJkyNJvq80OwF3SylStO0IWKuGYFuGOPm5sJqw	2025-06-30 17:12:19	2025-06-30 17:11:59.697203
68	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzk0NywiZXhwIjoxNzUxMzE4MDA3fQ.jK26V7YAmzzFphkOX28c7JKaFIGybCzfs8MfdVYreNw	2025-06-30 17:13:27	2025-06-30 17:13:07.262602
69	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzk4OSwiZXhwIjoxNzUxMzE4MDQ5fQ.uiUXNAQx8pE-HwegLBlMO5BwEgwKO-qpkTX144mvJRE	2025-06-30 17:14:09	2025-06-30 17:13:52.407655
70	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODExNiwiZXhwIjoxNzUxMzE4MTc2fQ.l11eqbH1d2lynEr34E6zzFoPZ881Mlne11GOrgVCgRc	2025-06-30 17:16:16	2025-06-30 17:15:56.559049
71	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODE2OCwiZXhwIjoxNzUxMzE4MjI4fQ.7r4YKUGKt0I7mO0ZB8eun9IJrAtXhX1nXL6rdbUiOtM	2025-06-30 17:17:08	2025-06-30 17:16:48.337258
72	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODMyMCwiZXhwIjoxNzUxMzE4MzgwfQ.s4dSSfyCMwKE6Kn0xpLlVRoRDsqevJimNl39WEDrraQ	2025-06-30 17:19:40	2025-06-30 17:19:20.82084
73	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODQwMywiZXhwIjoxNzUxMzE4NDYzfQ.XxrMQawLdPV71h1rh_KajiNOnBQVxKOQVhY_3W_UKyk	2025-06-30 17:21:03	2025-06-30 17:20:45.392207
74	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODQ1OSwiZXhwIjoxNzUxMzE4NTE5fQ.EFhNIepqAy9tuhib0pzF9GZBJ97CQ3XQw58hNMl3IoM	2025-06-30 17:21:59	2025-06-30 17:21:39.399836
75	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODUwOSwiZXhwIjoxNzUxMzE4NTY5fQ.WgRX4U275gTELTSYK_PHMU75xg5cyBt_9JkoaetXgFE	2025-06-30 17:22:49	2025-06-30 17:22:29.364577
76	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODY3MiwiZXhwIjoxNzUxMzE4NzMyfQ.H4Dgk8nt4MXw1D_ayJhpir4qHYJcaZLfrdZKv6DSm-c	2025-06-30 17:25:32	2025-06-30 17:25:13.094518
77	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODc0MCwiZXhwIjoxNzUxMzE4ODAwfQ.97nWCqR5x36DovD4UolvqGMfNs-uidUx4nFn7cLz4dk	2025-06-30 17:26:40	2025-06-30 17:26:20.944155
78	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODgxOCwiZXhwIjoxNzUxMzE4ODc4fQ.ZONdl_TRL4HneFkJsOpzd8nnnSdCp1aLCitPJayPVrA	2025-06-30 17:27:58	2025-06-30 17:27:39.284607
79	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODg5NSwiZXhwIjoxNzUxMzE4OTU1fQ.119BgmLGy2QVemRY6uSmEO4WbjJfn0Pd1keTZwfuE3M	2025-06-30 17:29:15	2025-06-30 17:28:56.438333
80	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTE0NywiZXhwIjoxNzUxMzE5MjA3fQ.9uD8nHhDEhcvIohJMTo3Ko8L9O8W8g47r1-Ikjpzg3w	2025-06-30 17:33:27	2025-06-30 17:33:07.510502
81	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTIxMiwiZXhwIjoxNzUxMzE5MjcyfQ.0uLYS1jyXgCgPRb5dKj9icJc8vzCBZn-D1wo4elvf98	2025-06-30 17:34:32	2025-06-30 17:34:12.95088
82	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTI2MCwiZXhwIjoxNzUxMzE5MzIwfQ.Xz9ZOL1u7ctgW3wKkqc-6g4LnlluTcD3r10kAv0OBdk	2025-06-30 17:35:20	2025-06-30 17:35:00.796247
83	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTQ2MywiZXhwIjoxNzUxMzE5NTIzfQ.mWqlgYLeM_s7Dkv3WymGRbqNv1UjiFPgs8qk-8aoBlk	2025-06-30 17:38:43	2025-06-30 17:38:23.849145
84	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTU0NCwiZXhwIjoxNzUxMzE5NjA0fQ.KxM0U59tGcuM8d5Wk4dRXerl0LeMsXbANK5s9QT-yeU	2025-06-30 17:40:04	2025-06-30 17:39:44.613659
85	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTYyNywiZXhwIjoxNzUxMzE5Njg3fQ.SZHVfn_WlJBn7C4yAc2O2HOK41GQsqR7iq5RBZu6pUA	2025-06-30 17:41:27	2025-06-30 17:40:54.194205
86	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTY1NSwiZXhwIjoxNzUxMzE5NzE1fQ.hkp8zPeb4txDulAFl9EEwCjEKu7peCRGpdOQN1O8yRU	2025-06-30 17:41:55	2025-06-30 17:41:36.336116
87	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTcwNSwiZXhwIjoxNzUxMzE5NzY1fQ.TJWngcjTGAUAeV7_qICu6zpIuxmLCPx_N-e0MaBW1X8	2025-06-30 17:42:45	2025-06-30 17:42:25.791653
88	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTg2MiwiZXhwIjoxNzUxMzE5OTIyfQ.nq5DDeAJf0E9ZjLv5qfX1aaAyWJGoTfYMWMuY4q6VMU	2025-06-30 17:45:22	2025-06-30 17:45:02.358892
89	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTkzMiwiZXhwIjoxNzUxMzE5OTkyfQ.UPznqj7R1VFqwhyLMsPA_Edbg1A9qFt52ESDgI_Su5E	2025-06-30 17:46:32	2025-06-30 17:46:12.462861
90	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDAwNiwiZXhwIjoxNzUxMzIwMDY2fQ.7EKr8270lo4LQV7YszrmDOA6Q7SQZ-6jiEtB451E7zc	2025-06-30 17:47:46	2025-06-30 17:47:26.588823
91	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDA2MywiZXhwIjoxNzUxMzIwMTIzfQ.RuTlGIZpaqZXf0cVwnOmuBhcaz4qVr0DvzW19yBF3Kw	2025-06-30 17:48:43	2025-06-30 17:48:24.085887
92	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDEwNiwiZXhwIjoxNzUxMzIwMTY2fQ.irqSS5f-RDn1SapPdATHAXGM0D_GJJhhfrfB8bacr3g	2025-06-30 17:49:26	2025-06-30 17:49:06.561494
93	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDE2NSwiZXhwIjoxNzUxMzIwMjI1fQ.j3En3wc-e5K9TaB0m4DpyEIt4E03Weo7Q-yxxvz_J6Y	2025-06-30 17:50:25	2025-06-30 17:50:06.046837
94	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDM1MSwiZXhwIjoxNzUxMzIwNDExfQ.rxC3UzSz0ZoBKtPWAuNfIHxEGJQgaZqYcMhQhX3dj1w	2025-06-30 17:53:31	2025-06-30 17:53:11.679779
95	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDQwNywiZXhwIjoxNzUxMzIwNDY3fQ.awLqYbNU6Xyl42VzOdePGB4tCUbR2duX0nZX90Iwu7o	2025-06-30 17:54:27	2025-06-30 17:54:07.713948
96	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDUwNiwiZXhwIjoxNzUxMzIwNTY2fQ.YZBa5w9e7N26T9e6Zb2zgOYjutOSuOKyKf7D7Rav0SI	2025-06-30 17:56:06	2025-06-30 17:55:46.306799
97	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDU3MywiZXhwIjoxNzUxMzIwNjMzfQ.9Lowr40VIhnysXqEnP_XmW-mMvyOXYZsil-ipyu1aio	2025-06-30 17:57:13	2025-06-30 17:56:54.155632
98	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDYxNiwiZXhwIjoxNzUxMzIwNjc2fQ.futTxHhwiPWgF0-S9x2e_ylpPZy4WtJcNJer5U_bJGM	2025-06-30 17:57:56	2025-06-30 17:57:36.231917
99	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDgxNiwiZXhwIjoxNzUxMzIwODc2fQ.U2cVDyteG09RSwXm51BPP-9I9ScPQfFQZ-ftVY_FIlk	2025-06-30 18:01:16	2025-06-30 18:00:56.879682
100	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDg3MCwiZXhwIjoxNzUxMzIwOTMwfQ.k2OK35KbHTyRXmS3S8kXpFQNJ7ub5xwfyr_I7PPVBPQ	2025-06-30 18:02:10	2025-06-30 18:01:52.551682
101	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDk5MiwiZXhwIjoxNzUxMzIxMDUyfQ.1Sm81hMklZNmPDfyiNd1RiRhrhfYRaf23OAnRp9-eXQ	2025-06-30 18:04:12	2025-06-30 18:03:52.35804
102	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTA3MSwiZXhwIjoxNzUxMzIxMTMxfQ.9ImUixMTAlpM3j7hRPq8E6bd8Ly8b5cob5hHf87VzwQ	2025-06-30 18:05:31	2025-06-30 18:05:11.456834
103	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTE1MSwiZXhwIjoxNzUxMzIxMjExfQ.QjcOVEHU2M1CPyAVUr8pfzQnMHX5tfUDKydlq74mIh4	2025-06-30 18:06:51	2025-06-30 18:06:31.677146
104	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTI0MCwiZXhwIjoxNzUxMzIxMzAwfQ.xeQdBHBqfFNzjfIYyuPhssvQe8bhEZ8fNbftwthH4oY	2025-06-30 18:08:20	2025-06-30 18:08:00.432098
105	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTMxNSwiZXhwIjoxNzUxMzIxMzc1fQ.Ygrv8uSvLwKdmCCIBb2z3I8W65jdiKBwKoKQdZPGrGw	2025-06-30 18:09:35	2025-06-30 18:09:15.936143
106	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTM3NiwiZXhwIjoxNzUxMzIxNDM2fQ.Svf4CGfMKTNu1hQnyBjPM151Mr2JsSqLQfvgSSlzCCY	2025-06-30 18:10:36	2025-06-30 18:10:16.793985
107	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTYzNywiZXhwIjoxNzUxMzIxNjk3fQ.Pfoh3GWmvk1fdkHldAKfgatcshKdOk_cfM-CvEa72to	2025-06-30 18:14:57	2025-06-30 18:14:37.831661
108	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3NzY3NSwiZXhwIjoxNzUxMzc3NzM1fQ._TjrYAAWIgNAuUlut0vBxgEEK2m3LkJ9DJiUCBuW8hU	2025-07-01 09:48:55	2025-07-01 09:48:35.519202
109	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3Nzg4MiwiZXhwIjoxNzUxMzc3OTQyfQ.uo-4NwBd0w749jnIoCuUugz0c0VEcyxB3WtZWkLNOaI	2025-07-01 09:52:22	2025-07-01 09:52:03.144896
110	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDMyMiwiZXhwIjoxNzUxMzg3NTIyfQ.IHqK0RWLcwWzypbQhUmaiDIN-9FmPO-DifwulO8kFtg	2025-07-01 12:32:02	2025-07-01 11:59:15.919811
111	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4NTU1OCwiZXhwIjoxNzUxMzkyNzU4fQ.nUH-FmrwqvWKHd4heXvzI4go2ONjn5RZAh_3No7W1_E	2025-07-01 13:59:18	2025-07-01 12:00:01.045074
112	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4NTYwMiwiZXhwIjoxNzUxMzkyODAyfQ.6e3WETi2babUgtKOyEc9b-Cay6bp0uyqrNGHeKgJij8	2025-07-01 14:00:02	2025-07-01 12:00:37.248375
113	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM5NDA1MywiZXhwIjoxNzUxNDAxMjUzfQ.y7CJ6-IF-5i4oDBjZNyK5baUeUr-nTQJ-wqVzowDZkw	2025-07-01 16:20:53	2025-07-01 16:20:33.771902
114	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYwMjA5NCwiZXhwIjoxNzY0NjA5Mjk0fQ.Nfe7I8GrYbCOslBx6-rWpLQQf28zmI9Dx-LDg4SvwEA	2025-12-01 13:14:54	2025-12-01 17:54:43.024276
115	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYyNjIxNiwiZXhwIjoxNzY0NjMzNDE2fQ.2pVgVaEBlmEOEwCcnwVIDoWo5K3lEjggxOB4yYsbc5Q	2025-12-01 19:56:56	2025-12-01 18:00:30.524625
116	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYyNzA0MCwiZXhwIjoxNzY0NjM0MjQwfQ.o_8YUoHADHF6xIN7gT2nlh3iQnhc4aNHyP7csOqD0zk	2025-12-01 20:10:40	2025-12-01 18:31:56.456837
117	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYyODMyNywiZXhwIjoxNzY0NjM1NTI3fQ.M04Nu_zNFJY3gZ7GSWqvY_WEKjqM6hyICfhlSbiu2Fg	2025-12-01 20:32:07	2025-12-01 19:04:21.211352
118	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc2NDYzMDI3NywiZXhwIjoxNzY0NjM3NDc3fQ.XjFHCr66ezB98HCAau7tjiQXYmIpy4u2BwRauqgUgdM	2025-12-01 21:04:37	2025-12-01 19:04:46.734529
119	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMDI5MSwiZXhwIjoxNzY0NjM3NDkxfQ._D4qchvprWJbi0BIsTdSCVM4zovY-IubfHtAQ6BChuI	2025-12-01 21:04:51	2025-12-01 19:12:34.038847
120	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMDc2MCwiZXhwIjoxNzY0NjM3OTYwfQ.HRV9c5Uvp2jFwgcpWYJGBWJvzf0AwCaPuqkuJc0K2iI	2025-12-01 21:12:40	2025-12-01 19:13:00.112153
121	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMDc4NCwiZXhwIjoxNzY0NjM3OTg0fQ.FJzjmTJuzK21iyaQ29os1uYtR9jlFuPsgykemRO64zY	2025-12-01 21:13:04	2025-12-01 19:13:39.160793
122	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMDgyMywiZXhwIjoxNzY0NjM4MDIzfQ.JOSDhHMy30TWxAybeHG_JwU8X7sTNXeEd0JsDKZUyhQ	2025-12-01 21:13:43	2025-12-01 19:13:59.304822
123	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMDg0NCwiZXhwIjoxNzY0NjM4MDQ0fQ.Y5tYbqmGemftHDpGo_GAkFWDNeZmdIF2aTPwNjOFPuE	2025-12-01 21:14:04	2025-12-01 19:29:43.565381
124	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMTc5MiwiZXhwIjoxNzY0NjM4OTkyfQ.JIYWkS17loh_A-bBhtoMsT3szIUE1FvGtzAo_t3HzgA	2025-12-01 21:29:52	2025-12-01 19:30:01.00042
125	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMTk0MCwiZXhwIjoxNzY0NjM5MTQwfQ.pnfAef0g0_0N9085UETpzFPUkzhEd4l_SvF4-qL9SpY	2025-12-01 21:32:20	2025-12-01 19:32:35.11558
126	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMTk1OSwiZXhwIjoxNzY0NjM5MTU5fQ.9MxsI42ZJPVemxg5cpPSlrZoqO4jhltj3AaAoaMYSP0	2025-12-01 21:32:39	2025-12-01 19:32:42.445709
127	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMTk4MSwiZXhwIjoxNzY0NjM5MTgxfQ.mgZs7O4bygiAGVgPM8IEMQY6GqfgefhruExlcGH9C14	2025-12-01 21:33:01	2025-12-01 19:33:15.891367
128	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMjA2NCwiZXhwIjoxNzY0NjM5MjY0fQ.E3DCpF1Qreb3qSh1nWEGc5gU7DZhwD6lOUPyoKXls2w	2025-12-01 21:34:24	2025-12-01 19:34:30.652984
129	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMjA3NCwiZXhwIjoxNzY0NjM5Mjc0fQ.lAMh167cMnTrJHSA81bHzyxLic9Y9hnVPvsE9JXW9wQ	2025-12-01 21:34:34	2025-12-01 19:34:47.323918
130	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMjA5MCwiZXhwIjoxNzY0NjM5MjkwfQ.oW_tj8cQ6kqgUUlEvBmgLRdY_p5KHTonUNUoqs2dfJU	2025-12-01 21:34:50	2025-12-01 19:35:45.170281
131	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMjIwNCwiZXhwIjoxNzY0NjM5NDA0fQ.JDIrc6451JcvNLQ32bcZsTGok0ve7opbDOUFnoXCyHU	2025-12-01 21:36:44	2025-12-01 19:40:42.128395
132	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDg2Mzc0OSwiZXhwIjoxNzY0ODcwOTQ5fQ.qr1Kr1TpKyJcpsOWHZwXZp3bzQCR0WPqETM7vJr2xpw	2025-12-04 13:55:49	2025-12-08 07:56:46.440049
133	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NTE5NzMwMSwiZXhwIjoxNzY1MjA0NTAxfQ.Wv_iWjqjz-VzXsuLt6lvSuHMITbcHhSSCZju_7puy8g	2025-12-08 10:35:01	2025-12-08 08:36:11.399061
134	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NTE5NzcxNSwiZXhwIjoxNzY1MjA0OTE1fQ.mAeqztb0VZg-TbTXpcYdNzRP0E1OsRXS-lKYWH7hUQY	2025-12-08 10:41:55	2025-12-08 09:31:53.664297
135	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NTIxODI5NSwiZXhwIjoxNzY1MjI1NDk1fQ.-vu-WxmausFjXv2cVdkM8wuq1SxhqWF4UY3J-FogB78	2025-12-08 16:24:55	2025-12-08 15:37:40.177982
\.


--
-- Data for Name: editoriales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editoriales (id, editorial, url, created_at, updated_at, deleted_at) FROM stdin;
2	ACADEMIA IBEROAMERICANA DE LÁSER MÉDICO	\N	2025-12-10 08:46:09.649146	\N	\N
3	ASOCIACIÓN LATINOAMERICANA DE ODONTOPEDIATRÍA (ALOP)	\N	2025-12-10 08:46:09.649146	\N	\N
4	CAPÍTULO VENEZOLANO DE LA SOCIEDAD LATINOAMERICANA DE NUTRICIÓN (ALAN)	\N	2025-12-10 08:46:09.649146	\N	\N
5	CENTRO DE INVESTIGACIONES AGROALIMENTARIAS (CIAAL) DE LA UNIVERSIDAD DE LOS ANDES(ULA)	\N	2025-12-10 08:46:09.649146	\N	\N
6	CENTRO NACIONAL DE TECNOLOGÍA QUÍMICA (CNTQ)	\N	2025-12-10 08:46:09.649146	\N	\N
7	COMITÉ INTERAMERICANO DE SOCIEDADES DE MICROSCOPÍA ELECTRÓNICA (CIASEM)	\N	2025-12-10 08:46:09.649146	\N	\N
8	FACULTAD DE MEDICINA, UNIVERSIDAD CENTRAL DE VENEZUELA (UCV)	\N	2025-12-10 08:46:09.649146	\N	\N
9	FUNDACIÓN BENGOA PARA LA ALIMENTACIÓN Y NUTRICIÓN	\N	2025-12-10 08:46:09.649146	\N	\N
10	FUNDACIÓN KOINONÍA	\N	2025-12-10 08:46:09.649146	\N	\N
11	GRUPO DE INVESTIGACIONES SOBRE HISTORIA DE LAS IDEAS EN AMÉRICA LATINA (GRHIAL) , UNIVERSIDAD DE LOS ANDES (ULA)	\N	2025-12-10 08:46:09.649146	\N	\N
12	INSTITUTO NACIONAL DE INVESTIGACIONES AGRÍCOLAS (INIA) 	\N	2025-12-10 08:46:09.649146	\N	\N
13	LABORATORIO DE INVESTIGACIONES SEMIÓTICAS Y LITERARIAS (LISYL), NÚCLEO RAFAEL RANGEL, TRUJILLO, ULA	\N	2025-12-10 08:46:09.649146	\N	\N
14	OBSERVATORIO NACIONAL DE CIENCIA, TECNOLOGÍA E INNOVACIÓN (ONCTI)	\N	2025-12-10 08:46:09.649146	\N	\N
15	SOCIEDAD DE GINECOLOGÍA REGENERATIVA DE VENEZUELA	\N	2025-12-10 08:46:09.649146	\N	\N
16	SOCIEDAD DE NEUMONOLOGÍA Y CIRUGÍA TORÁCICA (SOVETORAX)	\N	2025-12-10 08:46:09.649146	\N	\N
17	SOCIEDAD VENEZOLANA DE ENTOMOLOGÍA	\N	2025-12-10 08:46:09.649146	\N	\N
18	SOCIEDAD VENEZOLANA DE PUERICULTURA Y PEDIATRÍA (SVPP)	\N	2025-12-10 08:46:09.649146	\N	\N
19	SOCIEDAD VENEZOLANA DE RADIOLOGÍA E IMAGENOLOGÍA DENTOMAXILOFACIAL	\N	2025-12-10 08:46:09.649146	\N	\N
20	UNIVERSIDAD CATÒLICA ANDRÉS BELLO (UCAB)	\N	2025-12-10 08:46:09.649146	\N	\N
21	UNIVERSIDAD CENTRAL DE VENEZUELA (UCV)	\N	2025-12-10 08:46:09.649146	\N	\N
22	UNIVERSIDAD CENTRAL DE VENEZUELA (UCV) FACULTAD DE MEDICINA / SOCIEDAD CIENTÍFICA DE ESTUDIANTES DE MEDICINA	\N	2025-12-10 08:46:09.649146	\N	\N
23	UNIVERSIDAD CENTROOCCIDENTAL LISANDRO ALVARADO (UCLA)	\N	2025-12-10 08:46:09.649146	\N	\N
24	UNIVERSIDAD DE LOS ANDES	\N	2025-12-10 08:46:09.649146	\N	\N
25	UNIVERSIDAD DE LOS ANDES (ULA)	\N	2025-12-10 08:46:09.649146	\N	\N
26	UNIVERSIDAD DE LOS ANDES (ULA) -DIRECCIÓN GENERAL DE CULTURA	\N	2025-12-10 08:46:09.649146	\N	\N
27	UNIVERSIDAD DE LOS ANDES (ULA) -DIRECCIÓN GENERAL DE CULTURA Y EXTENSIÓN	\N	2025-12-10 08:46:09.649146	\N	\N
28	UNIVERSIDAD DE ORIENTE (UDO)	\N	2025-12-10 08:46:09.649146	\N	\N
29	UNIVERSIDAD DEL ZULIA (LUZ)	\N	2025-12-10 08:46:09.649146	\N	\N
30	UNIVERSIDAD NACIONAL EXPERIMENTAL DE LOS LLANOS OCCIDENTALES EZEQUIEL ZAMORA (UNELLEZ)	\N	2025-12-10 08:46:09.649146	\N	\N
31	UNIVERSIDAD PEDAGÓGICA EXPERIMENTAL LIBERTADOR INSTITUTO PEDAGÓGICO RAFAEL ALBERTO ESCOBAR LARA- CENTRO DE INVESTIGACIÓN Y ESTUDIOS EN EDUCACIÓN FÍSICA SALUD DEPORTE RECREACIÓN Y DANZA	\N	2025-12-10 08:46:09.649146	\N	\N
\.


--
-- Data for Name: email_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_verifications (id, user_id, token, expires_at, created_at, updated_at, deleted_at) FROM stdin;
3	4	41215c1cf30f66a78ae05d7d531e51a630cb18313a4c5fb71af4b967de27726d	2025-02-15 14:08:47.209	2025-02-14 14:08:47.20864	\N	\N
\.


--
-- Data for Name: estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados (id, estado, iso_3166_2) FROM stdin;
1	AMAZONAS	VE-X
2	ANZOÁTEGUI	VE-B
3	APURE	VE-C
4	ARAGUA	VE-D
5	BARINAS	VE-E
6	BOLÍVAR	VE-F
7	CARABOBO	VE-G
8	COJEDES	VE-H
9	DELTA AMACURO	VE-Y
10	FALCÓN	VE-I
11	GUÁRICO	VE-J
12	LARA	VE-K
13	MÉRIDA	VE-L
14	MIRANDA	VE-M
15	MONAGAS	VE-N
16	NUEVA ESPARTA	VE-O
17	PORTUGUESA	VE-P
18	SUCRE	VE-R
19	TÁCHIRA	VE-S
20	TRUJILLO	VE-T
21	LA GUAIRA	VE-W
22	YARACUY	VE-U
23	ZULIA	VE-V
24	DISTRITO CAPITAL	VE-A
25	DEPENDENCIAS FEDERALES	VE-Z
26	GUAYANA ESEQUIBA	VE-Q
\.


--
-- Data for Name: formatos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.formatos (id, formato, created_at, updated_at, deleted_at) FROM stdin;
1	IMPRESO	2021-11-04 00:00:00	\N	\N
2	DIGITAL	2021-12-08 11:06:05.990771	\N	\N
3	MIXTO	2021-12-08 11:06:05.990771	\N	\N
\.


--
-- Data for Name: idiomas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.idiomas (id, idioma, iso, created_at, updated_at, deleted_at) FROM stdin;
1	ESPAÑOL	ES	2021-11-04 12:40:38.575845	\N	\N
2	INGLÉS	EN	2021-11-04 12:40:38.575845	\N	\N
3	AZERÍ	AZ	2021-11-04 12:40:38.575845	\N	\N
4	AFRIKAANS	AF	2021-11-04 12:40:38.575845	\N	\N
5	ALBANÉS	SQ	2021-11-04 12:40:38.575845	\N	\N
6	ALEMÁN	DE	2021-11-04 12:40:38.575845	\N	\N
7	ALSACIANO	ALS	2021-11-04 12:40:38.575845	\N	\N
8	AMÁRICO	AM	2021-11-04 12:40:38.575845	\N	\N
9	ANGLOSAJÓN	ANG	2021-11-04 12:40:38.575845	\N	\N
10	ÁRABE	AR	2021-11-04 12:40:38.575845	\N	\N
11	ARAGONÉS	AN	2021-11-04 12:40:38.575845	\N	\N
12	ARMENIO	HY	2021-11-04 12:40:38.575845	\N	\N
13	ASTURIANO	AST	2021-11-04 12:40:38.575845	\N	\N
14	AYMARA	AY	2021-11-04 12:40:38.575845	\N	\N
15	BAJO SAJÓN	NDS	2021-11-04 12:40:38.575845	\N	\N
16	BENGALÍ	BN	2021-11-04 12:40:38.575845	\N	\N
17	BIELORRUSO	BE	2021-11-04 12:40:38.575845	\N	\N
18	BIRMANO	MY	2021-11-04 12:40:38.575845	\N	\N
19	BOSNIO	BS	2021-11-04 12:40:38.575845	\N	\N
20	BRETÓN	BR	2021-11-04 12:40:38.575845	\N	\N
21	BÚLGARO	BG	2021-11-04 12:40:38.575845	\N	\N
22	CANARÉS	KN	2021-11-04 12:40:38.575845	\N	\N
23	CATALÁN	CA	2021-11-04 12:40:38.575845	\N	\N
24	CHAMORRO	CH	2021-11-04 12:40:38.575845	\N	\N
25	CHECO	CS	2021-11-04 12:40:38.575845	\N	\N
26	CHEROQUI	CHR	2021-11-04 12:40:38.575845	\N	\N
27	CHINO MANDARÍN	ZH	2021-11-04 12:40:38.575845	\N	\N
28	COREANO	KO	2021-11-04 12:40:38.575845	\N	\N
29	CORSO	CO	2021-11-04 12:40:38.575845	\N	\N
30	CROATA	HR	2021-11-04 12:40:38.575845	\N	\N
31	CURDO	KU	2021-11-04 12:40:38.575845	\N	\N
32	DANÉS	DA	2021-11-04 12:40:38.575845	\N	\N
33	ESLOVACO	SK	2021-11-04 12:40:38.575845	\N	\N
34	ESLOVENO	SL	2021-11-04 12:40:38.575845	\N	\N
35	ESPERANTO	EO	2021-11-04 12:40:38.575845	\N	\N
36	ESTONIO	ET	2021-11-04 12:40:38.575845	\N	\N
37	EUSKERA	EU	2021-11-04 12:40:38.575845	\N	\N
38	FEROÉS	FO	2021-11-04 12:40:38.575845	\N	\N
39	FIYIANO	FJ	2021-11-04 12:40:38.575845	\N	\N
40	FINLANDÉS	FI	2021-11-04 12:40:38.575845	\N	\N
41	FRANCÉS	FR	2021-11-04 12:40:38.575845	\N	\N
42	FRISÓN	FY	2021-11-04 12:40:38.575845	\N	\N
43	GALÉS	CY	2021-11-04 12:40:38.575845	\N	\N
44	GALLEGO	GL	2021-11-04 12:40:38.575845	\N	\N
45	GEORGIANO	KA	2021-11-04 12:40:38.575845	\N	\N
46	GRIEGO MODERNO	EL	2021-11-04 12:40:38.575845	\N	\N
47	GUARANÍ	GN	2021-11-04 12:40:38.575845	\N	\N
48	GUJARATÍ	GU	2021-11-04 12:40:38.575845	\N	\N
49	HEBREO ISRAELÍ	HE	2021-11-04 12:40:38.575845	\N	\N
50	HINDI	HI	2021-11-04 12:40:38.575845	\N	\N
51	HOLANDÉS	NL	2021-11-04 12:40:38.575845	\N	\N
52	HÚNGARO	HU	2021-11-04 12:40:38.575845	\N	\N
53	IDO	IO	2021-11-04 12:40:38.575845	\N	\N
54	IGBO	IG	2021-11-04 12:40:38.575845	\N	\N
55	INDONESIO	ID	2021-11-04 12:40:38.575845	\N	\N
56	INGLÉS SIMPLIFICADO	PLE	2021-11-04 12:40:38.575845	\N	\N
57	INTERLINGUA	IA	2021-11-04 12:40:38.575845	\N	\N
58	IRLANDÉS	GA	2021-11-04 12:40:38.575845	\N	\N
59	ISLANDÉS	IS	2021-11-04 12:40:38.575845	\N	\N
60	ITALIANO	IT	2021-11-04 12:40:38.575845	\N	\N
61	JAPONÉS	JA	2021-11-04 12:40:38.575845	\N	\N
62	JAVANÉS	JV	2021-11-04 12:40:38.575845	\N	\N
63	KAZAKO	KK	2021-11-04 12:40:38.575845	\N	\N
64	LAOSIANO	LO	2021-11-04 12:40:38.575845	\N	\N
65	LATÍN	LA	2021-11-04 12:40:38.575845	\N	\N
66	LETÓN	LV	2021-11-04 12:40:38.575845	\N	\N
67	LINGALA	LN	2021-11-04 12:40:38.575845	\N	\N
68	LITUANO	LT	2021-11-04 12:40:38.575845	\N	\N
69	LUXEMBURGUÉS	LB	2021-11-04 12:40:38.575845	\N	\N
70	MACEDONIO	MK	2021-11-04 12:40:38.575845	\N	\N
71	MALABAR	ML	2021-11-04 12:40:38.575845	\N	\N
72	MALAYO	MS	2021-11-04 12:40:38.575845	\N	\N
73	MALGACHE	MG	2021-11-04 12:40:38.575845	\N	\N
74	MALTÉS	MT	2021-11-04 12:40:38.575845	\N	\N
75	MANÉS	GV	2021-11-04 12:40:38.575845	\N	\N
76	MAORÍ	MI	2021-11-04 12:40:38.575845	\N	\N
77	MARATI	MR	2021-11-04 12:40:38.575845	\N	\N
78	MOLDAVO	MO	2021-11-04 12:40:38.575845	\N	\N
79	MONGOL	MN	2021-11-04 12:40:38.575845	\N	\N
80	NÁHUATL	NAH	2021-11-04 12:40:38.575845	\N	\N
81	NAURUANO	NA	2021-11-04 12:40:38.575845	\N	\N
82	NORUEGO	NO	2021-11-04 12:40:38.575845	\N	\N
83	OCCITANO	OC	2021-11-04 12:40:38.575845	\N	\N
84	PAPIAMENTO	PAP	2021-11-04 12:40:38.575845	\N	\N
85	PERSA MODERNO	FA	2021-11-04 12:40:38.575845	\N	\N
86	POLACO	PL	2021-11-04 12:40:38.575845	\N	\N
87	PORTUGUÉS	PT	2021-11-04 12:40:38.575845	\N	\N
88	PUNJABÍ	PA	2021-11-04 12:40:38.575845	\N	\N
89	QUECHUA	QU	2021-11-04 12:40:38.575845	\N	\N
90	QUIRGUIZ	KY	2021-11-04 12:40:38.575845	\N	\N
91	ROMANCHE	RM	2021-11-04 12:40:38.575845	\N	\N
92	RUMANO	RO	2021-11-04 12:40:38.575845	\N	\N
93	RUSO	RU	2021-11-04 12:40:38.575845	\N	\N
94	SARDO	SC	2021-11-04 12:40:38.575845	\N	\N
95	SERBIO	SR	2021-11-04 12:40:38.575845	\N	\N
96	SESOTHO	ST	2021-11-04 12:40:38.575845	\N	\N
97	SICILIANO	SCN	2021-11-04 12:40:38.575845	\N	\N
98	SOMALÍ	SO	2021-11-04 12:40:38.575845	\N	\N
99	SUECO	SV	2021-11-04 12:40:38.575845	\N	\N
100	SWAHILI	SW	2021-11-04 12:40:38.575845	\N	\N
101	TAGALO	TL	2021-11-04 12:40:38.575845	\N	\N
102	TAILANDÉS	TH	2021-11-04 12:40:38.575845	\N	\N
103	TAMIL	TA	2021-11-04 12:40:38.575845	\N	\N
104	TÁRTARO	TT	2021-11-04 12:40:38.575845	\N	\N
105	TÁRTARO DE CRIMEA	CRH	2021-11-04 12:40:38.575845	\N	\N
106	TEGULÚ	TE	2021-11-04 12:40:38.575845	\N	\N
107	TIBETANO	BO	2021-11-04 12:40:38.575845	\N	\N
108	TURCO	TR	2021-11-04 12:40:38.575845	\N	\N
109	TURCOMANO	TK	2021-11-04 12:40:38.575845	\N	\N
110	UCRANIANO	UK	2021-11-04 12:40:38.575845	\N	\N
111	URDU	UR	2021-11-04 12:40:38.575845	\N	\N
112	UZBEKO	UZ	2021-11-04 12:40:38.575845	\N	\N
113	VALÓN	WA	2021-11-04 12:40:38.575845	\N	\N
114	VIETNAMITA	VI	2021-11-04 12:40:38.575845	\N	\N
115	VOLAPUK	VO	2021-11-04 12:40:38.575845	\N	\N
116	XHOSA	XH	2021-11-04 12:40:38.575845	\N	\N
117	YIDISH	YI	2021-11-04 12:40:38.575845	\N	\N
118	YORUBA	YO	2021-11-04 12:40:38.575845	\N	\N
119	ZULÚ	ZU	2021-11-04 12:40:38.575845	\N	\N
\.


--
-- Data for Name: indices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.indices (id, indice, created_at, updated_at, deleted_at) FROM stdin;
99999	NO DISPONIBLE	2025-12-10 07:54:35.347016	\N	\N
\.


--
-- Data for Name: inicio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inicio (id, orden, titulo, contenido, imagen, created_at, updated_at, deleted_at) FROM stdin;
1	1	¿Qué es?	El «Directorio Venezolano de Revistas Científicas» es un sistema de información constituido por el inventario de todas las revistas científicas venezolanas; capaz de proporcionar los datos de sus características editoriales, incluyendo su nombre, área temática, datos de contacto y otra información relevante para las y los usuarios. El sistema se distingue por su capacidad de actuar en función de los criterios de búsqueda y acceso, facilitando así la localización de revistas especializadas en áreas específicas de conocimiento, posibilitando a las y los usuarios el acceso de manera más eficiente y efectiva.	directorio2.png                                                                                     	2025-03-10 02:14:24.658185	\N	\N
4	2	Objetivo	Exhibir, en un mismo espacio, todas las revistas científicas venezolanas para aumentar su visibilidad para la comunidad del Sistema Nacional de Ciencia, Tecnología e Innovación, facilitando el acceso libre a los resultados de la investigación científica y tecnológica y consolidar la información pertinente de las revistas creando un espacio de divulgación bajo los criterios de reconocimiento de «acceso abierto», respetando las particularidades editoriales de cada revista.	directorio3.png                                                                                     	2025-03-10 02:15:50.187318	\N	\N
\.


--
-- Data for Name: login_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_logs (id, user_id, username, ip_address, login_timestamp, login_status, logout_type, logout_timestamp, session_token) FROM stdin;
390	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 10:32:02.676175	success	logout	2025-07-01 11:59:15.918717	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDMyMiwiZXhwIjoxNzUxMzg3NTIyfQ.IHqK0RWLcwWzypbQhUmaiDIN-9FmPO-DifwulO8kFtg
391	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 10:32:02.67677	success	logout	2025-07-01 11:59:15.918717	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDMyMiwiZXhwIjoxNzUxMzg3NTIyfQ.IHqK0RWLcwWzypbQhUmaiDIN-9FmPO-DifwulO8kFtg
392	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 11:59:18.1573	success	logout	2025-07-01 12:00:01.043413	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4NTU1OCwiZXhwIjoxNzUxMzkyNzU4fQ.nUH-FmrwqvWKHd4heXvzI4go2ONjn5RZAh_3No7W1_E
393	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 11:59:18.158142	success	logout	2025-07-01 12:00:01.043413	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4NTU1OCwiZXhwIjoxNzUxMzkyNzU4fQ.nUH-FmrwqvWKHd4heXvzI4go2ONjn5RZAh_3No7W1_E
394	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 12:00:02.815225	success	logout	2025-07-01 12:00:37.246919	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4NTYwMiwiZXhwIjoxNzUxMzkyODAyfQ.6e3WETi2babUgtKOyEc9b-Cay6bp0uyqrNGHeKgJij8
395	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 12:00:02.815745	success	logout	2025-07-01 12:00:37.246919	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4NTYwMiwiZXhwIjoxNzUxMzkyODAyfQ.6e3WETi2babUgtKOyEc9b-Cay6bp0uyqrNGHeKgJij8
169	\N	admin@example.com	::1	2025-06-23 10:05:34.936926	failed	\N	\N	\N
396	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 14:20:53.682861	success	logout	2025-07-01 16:20:33.76878	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM5NDA1MywiZXhwIjoxNzUxNDAxMjUzfQ.y7CJ6-IF-5i4oDBjZNyK5baUeUr-nTQJ-wqVzowDZkw
397	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 14:20:53.685681	success	logout	2025-07-01 16:20:33.76878	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM5NDA1MywiZXhwIjoxNzUxNDAxMjUzfQ.y7CJ6-IF-5i4oDBjZNyK5baUeUr-nTQJ-wqVzowDZkw
243	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:40:50.983294	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDA1MCwiZXhwIjoxNzUwNzA0NjUwfQ.VZjQoH_IPneHMOqA-eN6BW-sij-Ps3PbcY4wwuCau8k
172	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:28:18.16522	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4ODg5OCwiZXhwIjoxNzUwNjg5MTM4fQ.KQFsikGvcqbl9A2eIgwPErf2REkuGFqfBY8KDysXBkk
258	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:10:22.648223	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTgyMiwiZXhwIjoxNzUwNzA1ODgyfQ.wSSk9MdfIirqc0AKy_uBMFIxaEYkQssnWspMMo6_HE0
259	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:10:22.648806	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTgyMiwiZXhwIjoxNzUwNzA1ODgyfQ.wSSk9MdfIirqc0AKy_uBMFIxaEYkQssnWspMMo6_HE0
250	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:54:59.352226	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDg5OSwiZXhwIjoxNzUwNzA0OTU5fQ.VMy2czYxmuX1_Hh-Ne7cI2tMpFytXaH67a2RFa9gXBw
251	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:54:59.353132	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDg5OSwiZXhwIjoxNzUwNzA0OTU5fQ.VMy2czYxmuX1_Hh-Ne7cI2tMpFytXaH67a2RFa9gXBw
137	1	admin@example.com	::1	2025-06-16 12:29:22.48807	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5MTM2MiwiZXhwIjoxNzUwMDkxNjAyfQ.59I8Vn9DT4oSIsfVlBXDwgOSf-BBhkitjjknJRuLPGs
138	1	admin@example.com	::1	2025-06-16 12:34:24.245632	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5MTY2NCwiZXhwIjoxNzUwMDkxOTA0fQ.Ds2IMMcQ8BqIksWLsP2kR61jqp18cvSPqFLBJUsO8nI
139	1	admin@example.com	::1	2025-06-16 13:38:38.942884	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NTUxOCwiZXhwIjoxNzUwMDk1NzU4fQ.iPU85tEVV1-GQL6hqVxiAtSBieV810qiEEPaMX_sIv4
140	1	admin@example.com	::1	2025-06-16 13:49:24.461453	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjE2NCwiZXhwIjoxNzUwMDk2NDA0fQ.JIK18yKg6oSj2K4A4cmfdTbXeeFJNQRUwhAP-9Rtahw
141	1	admin@example.com	::1	2025-06-16 13:50:04.084837	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjIwNCwiZXhwIjoxNzUwMDk2NDQ0fQ.OUrVmZ1dBkJsrwr4hThM2LX5VlbHmuit7OX5CPHinrk
180	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:47:10.027265	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDAzMCwiZXhwIjoxNzUwNjkwMjcwfQ.bfWlP9keY5XBLMoabc0LDiUAWq5-zJs88kUeRviJqp0
264	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:22:19.478677	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjUzOSwiZXhwIjoxNzUwNzA2NTk5fQ.LrD4V4Nt0sYgz0v6JYYsoKZM2taDuRRXn2-O1Z3O3_A
265	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:22:19.479635	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjUzOSwiZXhwIjoxNzUwNzA2NTk5fQ.LrD4V4Nt0sYgz0v6JYYsoKZM2taDuRRXn2-O1Z3O3_A
181	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:47:10.027918	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDAzMCwiZXhwIjoxNzUwNjkwMjcwfQ.bfWlP9keY5XBLMoabc0LDiUAWq5-zJs88kUeRviJqp0
240	1	admin@example.com	::1	2025-06-23 14:39:07.446036	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzk0NywiZXhwIjoxNzUwNzA0NTQ3fQ.JLsmJActs5kRPx6fiOGYQSIfM9jPv2evgU1BDB237BQ
241	1	admin@example.com	::1	2025-06-23 14:39:07.446583	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzk0NywiZXhwIjoxNzUwNzA0NTQ3fQ.JLsmJActs5kRPx6fiOGYQSIfM9jPv2evgU1BDB237BQ
151	1	admin@example.com	::1	2025-06-16 14:25:06.954942	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5ODMwNiwiZXhwIjoxNzUwMDk4NTQ2fQ.0mDJaY1_7u0vThWZ1IAEYcWiHI9VaI4HoK8lUkfMlgw
152	1	admin@example.com	::1	2025-06-16 14:25:06.955413	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5ODMwNiwiZXhwIjoxNzUwMDk4NTQ2fQ.0mDJaY1_7u0vThWZ1IAEYcWiHI9VaI4HoK8lUkfMlgw
177	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:33:32.873805	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4OTIxMiwiZXhwIjoxNzUwNjg5NDUyfQ.KvCQmN-f0tfIK9AaUWGFor8f3A3BT7zRmhe4zbcuPxc
159	1	admin@example.com	::1	2025-06-17 07:43:25.889059	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDYwNSwiZXhwIjoxNzUwMTYwODQ1fQ.H3pLLA6325lkpqGoFehLmvyua-tXIBPmfxNATWKH5sI
242	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:40:50.982637	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDA1MCwiZXhwIjoxNzUwNzA0NjUwfQ.VZjQoH_IPneHMOqA-eN6BW-sij-Ps3PbcY4wwuCau8k
183	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:48:14.248623	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDA5NCwiZXhwIjoxNzUwNjkwMzM0fQ.KjUWmxT5q-_q7qFOPlMwWSG4MbVwAscLVi0lLcWUtsM
184	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:51:44.550088	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDMwNCwiZXhwIjoxNzUwNjkwNTQ0fQ.3WhKoRUxYRBh-gtIuQ-ci9bppGQ38lKUstr-ZDfxTM8
144	1	admin@example.com	::1	2025-06-16 13:57:41.53016	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjY2MSwiZXhwIjoxNzUwMDk2OTAxfQ.BOHwMS1Crhec0ZtqrNpb3A5Gl8LE2DWVrYZ4hsxHGfo
145	1	admin@example.com	::1	2025-06-16 13:59:19.1297	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5Njc1OSwiZXhwIjoxNzUwMDk2OTk5fQ.SvOmLa3WewLbnQ_5I6kfkLkS1mCGRcuoQfGJ7Mh6Wfg
146	1	admin@example.com	::1	2025-06-16 13:59:19.130145	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5Njc1OSwiZXhwIjoxNzUwMDk2OTk5fQ.SvOmLa3WewLbnQ_5I6kfkLkS1mCGRcuoQfGJ7Mh6Wfg
147	1	admin@example.com	::1	2025-06-16 14:00:26.631973	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjgyNiwiZXhwIjoxNzUwMDk3MDY2fQ.PCJbfZK3W8rDPH9MjhqHLE2C1vRHrAW2lC6ZhC9H3s4
148	1	admin@example.com	::1	2025-06-16 14:00:26.63255	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjgyNiwiZXhwIjoxNzUwMDk3MDY2fQ.PCJbfZK3W8rDPH9MjhqHLE2C1vRHrAW2lC6ZhC9H3s4
149	1	admin@example.com	::1	2025-06-16 14:20:08.322237	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5ODAwOCwiZXhwIjoxNzUwMDk4MjQ4fQ.YtGQXCbCA5QitiIi1nX1mWQeMNkKATvvgTtDfzabKLI
150	1	admin@example.com	::1	2025-06-16 14:20:08.323085	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5ODAwOCwiZXhwIjoxNzUwMDk4MjQ4fQ.YtGQXCbCA5QitiIi1nX1mWQeMNkKATvvgTtDfzabKLI
197	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:05:36.541517	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTEzNiwiZXhwIjoxNzUwNjkxMzc2fQ.2jkG_ALjL0LMcqMpohAzTXix2Elx0YlL8RmGuW-0GgU
198	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:07:49.399482	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTI2OSwiZXhwIjoxNzUwNjkxNTA5fQ.OSDjCZUd36VFz285jmPuK3lpMO0zcJGtb0_Z0gPOTjA
268	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:28:01.8384	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjg4MSwiZXhwIjoxNzUwNzA2OTQxfQ.bvNtGhN_hTkkDjsHNnL1X9COPR8H12H8QoRndIQ3RLI
384	1	admin@example.com	::1	2025-07-01 10:22:22.277891	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3OTc0MiwiZXhwIjoxNzUxMzc5ODAyfQ.nddTnOTjsA1wSSD-z0KWJAmbsa7i0mlIZhzlURKe8kE
385	1	admin@example.com	::1	2025-07-01 10:22:22.28008	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3OTc0MiwiZXhwIjoxNzUxMzc5ODAyfQ.nddTnOTjsA1wSSD-z0KWJAmbsa7i0mlIZhzlURKe8kE
252	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:58:35.435292	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTExNSwiZXhwIjoxNzUwNzA1MTc1fQ.DhyYZLJ6YQDzrdYVTmqid6Ulq8TG4B0Q7LCB7G4vo9Q
253	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:58:35.436016	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTExNSwiZXhwIjoxNzUwNzA1MTc1fQ.DhyYZLJ6YQDzrdYVTmqid6Ulq8TG4B0Q7LCB7G4vo9Q
269	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:28:01.839035	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjg4MSwiZXhwIjoxNzUwNzA2OTQxfQ.bvNtGhN_hTkkDjsHNnL1X9COPR8H12H8QoRndIQ3RLI
280	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:20:02.886714	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNDgwMiwiZXhwIjoxNzUxMzE0ODYyfQ.75rFJtNTA6JqLjDfq3ciouFnmc9ReZrdSz7Lgymvtb4
281	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:20:02.89435	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNDgwMiwiZXhwIjoxNzUxMzE0ODYyfQ.75rFJtNTA6JqLjDfq3ciouFnmc9ReZrdSz7Lgymvtb4
296	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:11:19.53867	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzg3OSwiZXhwIjoxNzUxMzE3OTM5fQ.XcfJvqJkyNJvq80OwF3SylStO0IWKuGYFuGOPm5sJqw
297	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:11:19.539741	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzg3OSwiZXhwIjoxNzUxMzE3OTM5fQ.XcfJvqJkyNJvq80OwF3SylStO0IWKuGYFuGOPm5sJqw
312	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:21:49.297582	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODUwOSwiZXhwIjoxNzUxMzE4NTY5fQ.WgRX4U275gTELTSYK_PHMU75xg5cyBt_9JkoaetXgFE
313	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:21:49.300203	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODUwOSwiZXhwIjoxNzUxMzE4NTY5fQ.WgRX4U275gTELTSYK_PHMU75xg5cyBt_9JkoaetXgFE
328	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:37:43.783444	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTQ2MywiZXhwIjoxNzUxMzE5NTIzfQ.mWqlgYLeM_s7Dkv3WymGRbqNv1UjiFPgs8qk-8aoBlk
329	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:37:43.784319	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTQ2MywiZXhwIjoxNzUxMzE5NTIzfQ.mWqlgYLeM_s7Dkv3WymGRbqNv1UjiFPgs8qk-8aoBlk
344	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:47:43.872662	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDA2MywiZXhwIjoxNzUxMzIwMTIzfQ.RuTlGIZpaqZXf0cVwnOmuBhcaz4qVr0DvzW19yBF3Kw
345	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:47:43.873479	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDA2MywiZXhwIjoxNzUxMzIwMTIzfQ.RuTlGIZpaqZXf0cVwnOmuBhcaz4qVr0DvzW19yBF3Kw
185	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:51:44.551121	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDMwNCwiZXhwIjoxNzUwNjkwNTQ0fQ.3WhKoRUxYRBh-gtIuQ-ci9bppGQ38lKUstr-ZDfxTM8
186	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:53:34.092884	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDQxNCwiZXhwIjoxNzUwNjkwNjU0fQ.nJUXx-hKDnk36Knef1kkbDsLoDc1xQnWBasPVMHRtuI
187	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:53:34.094533	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDQxNCwiZXhwIjoxNzUwNjkwNjU0fQ.nJUXx-hKDnk36Knef1kkbDsLoDc1xQnWBasPVMHRtuI
202	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:17:59.327076	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTg3OSwiZXhwIjoxNzUwNjkxOTk5fQ.InliaHEr_Y-hNkDuPuop5-97CsFP4dS0ErPky8SiLW8
203	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:17:59.328639	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTg3OSwiZXhwIjoxNzUwNjkxOTk5fQ.InliaHEr_Y-hNkDuPuop5-97CsFP4dS0ErPky8SiLW8
204	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:22:48.889678	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjE2OCwiZXhwIjoxNzUwNjkyMjg4fQ.TSnp8Oet2nAAS4Bp9THCBGjD88o3511AaqeKWPOLdbk
205	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:22:48.890417	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjE2OCwiZXhwIjoxNzUwNjkyMjg4fQ.TSnp8Oet2nAAS4Bp9THCBGjD88o3511AaqeKWPOLdbk
206	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:24:20.365496	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjI2MCwiZXhwIjoxNzUwNjkyMzgwfQ.7EhOk46fpEDCQrlEGVe6cdIiHyNaYSZUxffCo8PVEZo
207	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:24:20.366189	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjI2MCwiZXhwIjoxNzUwNjkyMzgwfQ.7EhOk46fpEDCQrlEGVe6cdIiHyNaYSZUxffCo8PVEZo
208	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:27:59.843307	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjQ3OSwiZXhwIjoxNzUwNjkyNTM5fQ._0ti7cD6sdzNUvX6vJLoPY8QkiXpdZM8T0PkWZYvcxw
214	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:39:19.072994	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzE1OSwiZXhwIjoxNzUwNjkzMjE5fQ.pghlLPVVuqcE_KQloEwmRyXB6gEh9kqRE4WeMtYG58Q
215	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:39:19.074006	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzE1OSwiZXhwIjoxNzUwNjkzMjE5fQ.pghlLPVVuqcE_KQloEwmRyXB6gEh9kqRE4WeMtYG58Q
220	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:46:07.48036	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzU2NywiZXhwIjoxNzUwNjkzNjI3fQ.S9xRGO4l_azNs-IWk0r0Jd_-p_yBJK88kQ_RMEgHYbQ
221	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:46:07.480888	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzU2NywiZXhwIjoxNzUwNjkzNjI3fQ.S9xRGO4l_azNs-IWk0r0Jd_-p_yBJK88kQ_RMEgHYbQ
222	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:46:47.572458	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzYwNywiZXhwIjoxNzUwNjkzNjY3fQ.pVc88d4cWkqk0LXLZFsu_paLsVi_sT-TFdfirHF-B8c
360	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:00:16.774096	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDgxNiwiZXhwIjoxNzUxMzIwODc2fQ.U2cVDyteG09RSwXm51BPP-9I9ScPQfFQZ-ftVY_FIlk
361	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:00:16.774918	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDgxNiwiZXhwIjoxNzUxMzIwODc2fQ.U2cVDyteG09RSwXm51BPP-9I9ScPQfFQZ-ftVY_FIlk
248	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:46:27.612478	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDM4NywiZXhwIjoxNzUwNzA0NTA3fQ.SaIRSlv4z7XaD-uP-ZyL54Ly8nL7LmeyI8PHG3Ojc3I
249	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:46:27.614456	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDM4NywiZXhwIjoxNzUwNzA0NTA3fQ.SaIRSlv4z7XaD-uP-ZyL54Ly8nL7LmeyI8PHG3Ojc3I
223	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:46:47.573259	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzYwNywiZXhwIjoxNzUwNjkzNjY3fQ.pVc88d4cWkqk0LXLZFsu_paLsVi_sT-TFdfirHF-B8c
224	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:52:39.513144	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mzk1OSwiZXhwIjoxNzUwNjk0MDE5fQ.SshMZBGveEbJM54WXPRAwQsa6v_Q8AmlnoNcSdNSc7s
225	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:52:39.513985	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mzk1OSwiZXhwIjoxNzUwNjk0MDE5fQ.SshMZBGveEbJM54WXPRAwQsa6v_Q8AmlnoNcSdNSc7s
190	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:00:26.727505	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDgyNiwiZXhwIjoxNzUwNjkxMDY2fQ.p1QGiwDuuBVoN70h9E52YPqrQJ1fqN_YJ671kK8Qhp0
191	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:00:26.728245	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDgyNiwiZXhwIjoxNzUwNjkxMDY2fQ.p1QGiwDuuBVoN70h9E52YPqrQJ1fqN_YJ671kK8Qhp0
142	1	admin@example.com	::1	2025-06-16 13:50:04.085965	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjIwNCwiZXhwIjoxNzUwMDk2NDQ0fQ.OUrVmZ1dBkJsrwr4hThM2LX5VlbHmuit7OX5CPHinrk
174	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:29:12.094765	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4ODk1MiwiZXhwIjoxNzUwNjg5MTkyfQ.6fUSKAGQoNg-xbBRnOWZc3Ik7GtCvyiZegMJ_WwClFo
175	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:29:12.095762	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4ODk1MiwiZXhwIjoxNzUwNjg5MTkyfQ.6fUSKAGQoNg-xbBRnOWZc3Ik7GtCvyiZegMJ_WwClFo
173	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:28:18.166962	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4ODg5OCwiZXhwIjoxNzUwNjg5MTM4fQ.KQFsikGvcqbl9A2eIgwPErf2REkuGFqfBY8KDysXBkk
182	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:48:14.247416	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDA5NCwiZXhwIjoxNzUwNjkwMzM0fQ.KjUWmxT5q-_q7qFOPlMwWSG4MbVwAscLVi0lLcWUtsM
254	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:02:27.240246	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTM0NywiZXhwIjoxNzUwNzA1NDA3fQ.ZBoNBDL1qSugb-k_k87Q_MIQI-sPeQ9j7txUp7mJaYA
255	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:02:27.241034	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTM0NywiZXhwIjoxNzUwNzA1NDA3fQ.ZBoNBDL1qSugb-k_k87Q_MIQI-sPeQ9j7txUp7mJaYA
270	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:29:49.190532	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjk4OSwiZXhwIjoxNzUwNzA3MDQ5fQ.EntG645JXyhysW2K9q4FMhCsr5Mc0S-NG3nI0aDZZig
271	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:29:49.191436	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjk4OSwiZXhwIjoxNzUwNzA3MDQ5fQ.EntG645JXyhysW2K9q4FMhCsr5Mc0S-NG3nI0aDZZig
282	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:39:14.740928	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNTk1NCwiZXhwIjoxNzUxMzE2MDE0fQ.wKYEti891r7ywC978T9enbupxCDjDEvNpR7-RaV8X2k
283	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:39:14.741827	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNTk1NCwiZXhwIjoxNzUxMzE2MDE0fQ.wKYEti891r7ywC978T9enbupxCDjDEvNpR7-RaV8X2k
298	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:12:27.146311	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzk0NywiZXhwIjoxNzUxMzE4MDA3fQ.jK26V7YAmzzFphkOX28c7JKaFIGybCzfs8MfdVYreNw
299	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:12:27.147251	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzk0NywiZXhwIjoxNzUxMzE4MDA3fQ.jK26V7YAmzzFphkOX28c7JKaFIGybCzfs8MfdVYreNw
314	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:24:32.986378	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODY3MiwiZXhwIjoxNzUxMzE4NzMyfQ.H4Dgk8nt4MXw1D_ayJhpir4qHYJcaZLfrdZKv6DSm-c
315	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:24:32.987351	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODY3MiwiZXhwIjoxNzUxMzE4NzMyfQ.H4Dgk8nt4MXw1D_ayJhpir4qHYJcaZLfrdZKv6DSm-c
330	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:39:04.550123	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTU0NCwiZXhwIjoxNzUxMzE5NjA0fQ.KxM0U59tGcuM8d5Wk4dRXerl0LeMsXbANK5s9QT-yeU
331	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:39:04.551529	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTU0NCwiZXhwIjoxNzUxMzE5NjA0fQ.KxM0U59tGcuM8d5Wk4dRXerl0LeMsXbANK5s9QT-yeU
346	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:48:26.471267	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDEwNiwiZXhwIjoxNzUxMzIwMTY2fQ.irqSS5f-RDn1SapPdATHAXGM0D_GJJhhfrfB8bacr3g
347	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:48:26.47269	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDEwNiwiZXhwIjoxNzUxMzIwMTY2fQ.irqSS5f-RDn1SapPdATHAXGM0D_GJJhhfrfB8bacr3g
362	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:01:10.892888	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDg3MCwiZXhwIjoxNzUxMzIwOTMwfQ.k2OK35KbHTyRXmS3S8kXpFQNJ7ub5xwfyr_I7PPVBPQ
363	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:01:10.893785	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDg3MCwiZXhwIjoxNzUxMzIwOTMwfQ.k2OK35KbHTyRXmS3S8kXpFQNJ7ub5xwfyr_I7PPVBPQ
374	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:09:36.653093	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTM3NiwiZXhwIjoxNzUxMzIxNDM2fQ.Svf4CGfMKTNu1hQnyBjPM151Mr2JsSqLQfvgSSlzCCY
375	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:09:36.654404	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTM3NiwiZXhwIjoxNzUxMzIxNDM2fQ.Svf4CGfMKTNu1hQnyBjPM151Mr2JsSqLQfvgSSlzCCY
256	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:07:44.29014	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTY2NCwiZXhwIjoxNzUwNzA1NzI0fQ.MPsPus4jkwLBiYN9stfAe_wfDCuGGSZjMEtqczJEdmk
257	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:07:44.291278	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTY2NCwiZXhwIjoxNzUwNzA1NzI0fQ.MPsPus4jkwLBiYN9stfAe_wfDCuGGSZjMEtqczJEdmk
272	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:31:18.052742	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzA3OCwiZXhwIjoxNzUwNzA3MTM4fQ.hZQQ5nAiXoiYxXgkqxRGYDaOyHZvHrfBwW3tpwRfrKA
273	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:31:18.053554	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzA3OCwiZXhwIjoxNzUwNzA3MTM4fQ.hZQQ5nAiXoiYxXgkqxRGYDaOyHZvHrfBwW3tpwRfrKA
284	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:42:33.255329	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjE1MywiZXhwIjoxNzUxMzE2MjEzfQ.cWelUvZFNvDleP60bZX6BFcBRrYBWrdWkJAk2G06oJU
285	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:42:33.25651	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjE1MywiZXhwIjoxNzUxMzE2MjEzfQ.cWelUvZFNvDleP60bZX6BFcBRrYBWrdWkJAk2G06oJU
143	1	admin@example.com	::1	2025-06-16 13:57:41.529578	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjY2MSwiZXhwIjoxNzUwMDk2OTAxfQ.BOHwMS1Crhec0ZtqrNpb3A5Gl8LE2DWVrYZ4hsxHGfo
160	1	admin@example.com	::1	2025-06-17 07:43:25.889751	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDYwNSwiZXhwIjoxNzUwMTYwODQ1fQ.H3pLLA6325lkpqGoFehLmvyua-tXIBPmfxNATWKH5sI
238	1	admin@example.com	::1	2025-06-23 14:38:39.566728	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzkxOSwiZXhwIjoxNzUwNzA0MDM5fQ.UYLJwi7S9IsOQTWThzCkGfhgFri4FlfX6MCj28Jl1rk
239	1	admin@example.com	::1	2025-06-23 14:38:39.567538	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzkxOSwiZXhwIjoxNzUwNzA0MDM5fQ.UYLJwi7S9IsOQTWThzCkGfhgFri4FlfX6MCj28Jl1rk
161	1	admin@example.com	::1	2025-06-17 07:48:36.656784	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDkxNiwiZXhwIjoxNzUwMTYxMTU2fQ.3dQXNSdm-SkUiE2wr6hXDoc0GbeZq95x0VlhhCRn7tc
162	1	admin@example.com	::1	2025-06-17 07:48:36.657455	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDkxNiwiZXhwIjoxNzUwMTYxMTU2fQ.3dQXNSdm-SkUiE2wr6hXDoc0GbeZq95x0VlhhCRn7tc
163	1	admin@example.com	::1	2025-06-17 07:53:36.172679	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTIxNiwiZXhwIjoxNzUwMTYxNDU2fQ.WuTCiAtu8M4ZTyU-4GDj69n7H_QwqLGeRB9qnBhFauw
164	1	admin@example.com	::1	2025-06-17 07:53:36.173622	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTIxNiwiZXhwIjoxNzUwMTYxNDU2fQ.WuTCiAtu8M4ZTyU-4GDj69n7H_QwqLGeRB9qnBhFauw
165	1	admin@example.com	::1	2025-06-17 07:58:20.932238	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTUwMCwiZXhwIjoxNzUwMTYxNzQwfQ.wBDoQsQU28yOjLhuhkagKFbr3-CxG7FcJrQXDtE3i3U
166	1	admin@example.com	::1	2025-06-17 07:58:20.932849	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTUwMCwiZXhwIjoxNzUwMTYxNzQwfQ.wBDoQsQU28yOjLhuhkagKFbr3-CxG7FcJrQXDtE3i3U
167	1	admin@example.com	::1	2025-06-17 08:05:41.713837	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTk0MSwiZXhwIjoxNzUwMTYyMTgxfQ.YsxFC_8FoJzVc1_Oi4q_UW1FKN6oBIOFlk3alH13o3E
168	1	admin@example.com	::1	2025-06-17 08:05:41.714563	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTk0MSwiZXhwIjoxNzUwMTYyMTgxfQ.YsxFC_8FoJzVc1_Oi4q_UW1FKN6oBIOFlk3alH13o3E
178	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:43:42.908422	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4OTgyMiwiZXhwIjoxNzUwNjkwMDYyfQ.WG81LACtPX5Hitb1ndvEP_dH1P3sbSRq_TAAaU93-cA
179	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:43:42.909154	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4OTgyMiwiZXhwIjoxNzUwNjkwMDYyfQ.WG81LACtPX5Hitb1ndvEP_dH1P3sbSRq_TAAaU93-cA
300	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:13:09.075942	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzk4OSwiZXhwIjoxNzUxMzE4MDQ5fQ.uiUXNAQx8pE-HwegLBlMO5BwEgwKO-qpkTX144mvJRE
301	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:13:09.076979	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzk4OSwiZXhwIjoxNzUxMzE4MDQ5fQ.uiUXNAQx8pE-HwegLBlMO5BwEgwKO-qpkTX144mvJRE
316	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:25:40.075602	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODc0MCwiZXhwIjoxNzUxMzE4ODAwfQ.97nWCqR5x36DovD4UolvqGMfNs-uidUx4nFn7cLz4dk
317	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:25:40.078257	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODc0MCwiZXhwIjoxNzUxMzE4ODAwfQ.97nWCqR5x36DovD4UolvqGMfNs-uidUx4nFn7cLz4dk
332	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:40:27.749353	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTYyNywiZXhwIjoxNzUxMzE5Njg3fQ.SZHVfn_WlJBn7C4yAc2O2HOK41GQsqR7iq5RBZu6pUA
333	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:40:27.751036	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTYyNywiZXhwIjoxNzUxMzE5Njg3fQ.SZHVfn_WlJBn7C4yAc2O2HOK41GQsqR7iq5RBZu6pUA
348	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:49:25.942611	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDE2NSwiZXhwIjoxNzUxMzIwMjI1fQ.j3En3wc-e5K9TaB0m4DpyEIt4E03Weo7Q-yxxvz_J6Y
349	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:49:25.944803	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDE2NSwiZXhwIjoxNzUxMzIwMjI1fQ.j3En3wc-e5K9TaB0m4DpyEIt4E03Weo7Q-yxxvz_J6Y
386	1	admin@example.com	::1	2025-07-01 10:28:14.117052	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDA5NCwiZXhwIjoxNzUxMzgwMTU0fQ.m7Oue-RQS2t0r-ukDJrH3RqH9DtPQ_XLX3H9OpMfgmM
387	1	admin@example.com	::1	2025-07-01 10:28:14.11919	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDA5NCwiZXhwIjoxNzUxMzgwMTU0fQ.m7Oue-RQS2t0r-ukDJrH3RqH9DtPQ_XLX3H9OpMfgmM
194	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:04:04.252972	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTA0NCwiZXhwIjoxNzUwNjkxMjg0fQ.vkrk6D4-sfid7Y53pkETbbuHNqH4w5zYXOAD5VEu9Ow
195	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:04:04.254399	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTA0NCwiZXhwIjoxNzUwNjkxMjg0fQ.vkrk6D4-sfid7Y53pkETbbuHNqH4w5zYXOAD5VEu9Ow
196	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:05:36.540329	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTEzNiwiZXhwIjoxNzUwNjkxMzc2fQ.2jkG_ALjL0LMcqMpohAzTXix2Elx0YlL8RmGuW-0GgU
211	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:33:35.045117	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjgxNSwiZXhwIjoxNzUwNjkyODc1fQ.KexRNukAm7FnRPG1eSrptKlrt1xwx-yzY6NXNEU6aKw
212	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:35:57.107853	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mjk1NywiZXhwIjoxNzUwNjkzMDE3fQ.I4GNVNx_pPmsodO_5TPIv5CZAdAblw6qHFVftklNaHI
213	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:35:57.109378	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mjk1NywiZXhwIjoxNzUwNjkzMDE3fQ.I4GNVNx_pPmsodO_5TPIv5CZAdAblw6qHFVftklNaHI
274	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:34:51.0051	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzI5MCwiZXhwIjoxNzUwNzA3MzUwfQ.G6QGf0ANrCRsQmziwgPhIaMaUecMuYC75nQXTGt3GDU
275	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:34:51.006051	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzI5MCwiZXhwIjoxNzUwNzA3MzUwfQ.G6QGf0ANrCRsQmziwgPhIaMaUecMuYC75nQXTGt3GDU
286	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:43:17.532918	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjE5NywiZXhwIjoxNzUxMzE2MjU3fQ.2ZUqMgNHDQWlJq367w1FHZLr81zJhzzhOXzpVnfwPsc
287	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:43:17.533902	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjE5NywiZXhwIjoxNzUxMzE2MjU3fQ.2ZUqMgNHDQWlJq367w1FHZLr81zJhzzhOXzpVnfwPsc
302	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:15:16.050079	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODExNiwiZXhwIjoxNzUxMzE4MTc2fQ.l11eqbH1d2lynEr34E6zzFoPZ881Mlne11GOrgVCgRc
303	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:15:16.050759	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODExNiwiZXhwIjoxNzUxMzE4MTc2fQ.l11eqbH1d2lynEr34E6zzFoPZ881Mlne11GOrgVCgRc
318	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:26:58.858172	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODgxOCwiZXhwIjoxNzUxMzE4ODc4fQ.ZONdl_TRL4HneFkJsOpzd8nnnSdCp1aLCitPJayPVrA
319	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:26:58.870073	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODgxOCwiZXhwIjoxNzUxMzE4ODc4fQ.ZONdl_TRL4HneFkJsOpzd8nnnSdCp1aLCitPJayPVrA
334	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:40:55.621494	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTY1NSwiZXhwIjoxNzUxMzE5NzE1fQ.hkp8zPeb4txDulAFl9EEwCjEKu7peCRGpdOQN1O8yRU
335	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:40:55.623204	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTY1NSwiZXhwIjoxNzUxMzE5NzE1fQ.hkp8zPeb4txDulAFl9EEwCjEKu7peCRGpdOQN1O8yRU
350	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:52:31.152414	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDM1MSwiZXhwIjoxNzUxMzIwNDExfQ.rxC3UzSz0ZoBKtPWAuNfIHxEGJQgaZqYcMhQhX3dj1w
351	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:52:31.153252	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDM1MSwiZXhwIjoxNzUxMzIwNDExfQ.rxC3UzSz0ZoBKtPWAuNfIHxEGJQgaZqYcMhQhX3dj1w
364	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:03:12.270513	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDk5MiwiZXhwIjoxNzUxMzIxMDUyfQ.1Sm81hMklZNmPDfyiNd1RiRhrhfYRaf23OAnRp9-eXQ
365	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:03:12.272494	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDk5MiwiZXhwIjoxNzUxMzIxMDUyfQ.1Sm81hMklZNmPDfyiNd1RiRhrhfYRaf23OAnRp9-eXQ
376	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:13:57.726143	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTYzNywiZXhwIjoxNzUxMzIxNjk3fQ.Pfoh3GWmvk1fdkHldAKfgatcshKdOk_cfM-CvEa72to
377	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:13:57.726836	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTYzNywiZXhwIjoxNzUxMzIxNjk3fQ.Pfoh3GWmvk1fdkHldAKfgatcshKdOk_cfM-CvEa72to
388	1	admin@example.com	::1	2025-07-01 10:29:41.610827	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDE4MSwiZXhwIjoxNzUxMzg3MzgxfQ.topSCBuTtLs6kA5HlemY5oMl4IM6j01MyWgl1mFZZJY
389	1	admin@example.com	::1	2025-07-01 10:29:41.611605	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDE4MSwiZXhwIjoxNzUxMzg3MzgxfQ.topSCBuTtLs6kA5HlemY5oMl4IM6j01MyWgl1mFZZJY
199	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:07:49.400455	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTI2OSwiZXhwIjoxNzUwNjkxNTA5fQ.OSDjCZUd36VFz285jmPuK3lpMO0zcJGtb0_Z0gPOTjA
200	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:13:39.933447	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTYxOSwiZXhwIjoxNzUwNjkxODU5fQ.ujaAPoTQylv6kJlZs99HRD8oCguaAHRbQs6iZt2mnU4
201	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:13:39.934158	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTYxOSwiZXhwIjoxNzUwNjkxODU5fQ.ujaAPoTQylv6kJlZs99HRD8oCguaAHRbQs6iZt2mnU4
229	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:57:42.459492	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NDI2MiwiZXhwIjoxNzUwNjk0MzIyfQ.e8JCFTk98M7dZWOl9drN9P8jpa8xDVocEgXTZBM1uec
230	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 12:03:16.567009	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NDU5NiwiZXhwIjoxNzUwNjk0NjU2fQ.P8OcVwDRaP6nEidHiCRvHNZgPZuhwyIAfcqKHO61-gY
231	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 12:03:16.568429	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NDU5NiwiZXhwIjoxNzUwNjk0NjU2fQ.P8OcVwDRaP6nEidHiCRvHNZgPZuhwyIAfcqKHO61-gY
260	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:12:16.640528	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTkzNiwiZXhwIjoxNzUwNzA1OTk2fQ.az2XkLqDg8ZUXP72awrgheTk-8c1XVe2QratK5yz2Q8
261	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:12:16.641283	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTkzNiwiZXhwIjoxNzUwNzA1OTk2fQ.az2XkLqDg8ZUXP72awrgheTk-8c1XVe2QratK5yz2Q8
276	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:37:49.149608	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzQ2OSwiZXhwIjoxNzUwNzA3NTI5fQ.UeS8jRXjnND0iI_gCzlJkMgEX6f0M8BP-xfNm3RidfU
277	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:37:49.150431	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzQ2OSwiZXhwIjoxNzUwNzA3NTI5fQ.UeS8jRXjnND0iI_gCzlJkMgEX6f0M8BP-xfNm3RidfU
288	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:44:04.465528	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjI0NCwiZXhwIjoxNzUxMzE2MzA0fQ.VMlnBUyllkii7bSzx39CD59Uym4I48FLn6WdK-V5zBw
289	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:44:04.467079	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjI0NCwiZXhwIjoxNzUxMzE2MzA0fQ.VMlnBUyllkii7bSzx39CD59Uym4I48FLn6WdK-V5zBw
232	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 12:32:02.134756	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NjMyMiwiZXhwIjoxNzUwNjk2MzgyfQ.gkHJsuYzJV6Jy6EMCxIqNc2jDXuDMAdUJq25ykBnlDA
233	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 12:32:02.136641	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NjMyMiwiZXhwIjoxNzUwNjk2MzgyfQ.gkHJsuYzJV6Jy6EMCxIqNc2jDXuDMAdUJq25ykBnlDA
234	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:30:04.348423	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzQwNCwiZXhwIjoxNzUwNzAzNDY0fQ.t4lYd14zEOvLnKmR-04Q7_-W8iKsohrCDEEH6QW9cKI
176	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:33:32.872619	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4OTIxMiwiZXhwIjoxNzUwNjg5NDUyfQ.KvCQmN-f0tfIK9AaUWGFor8f3A3BT7zRmhe4zbcuPxc
170	1	admin@example.com	::1	2025-06-23 10:05:48.210447	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4NzU0OCwiZXhwIjoxNzUwNjg3Nzg4fQ.GP5PE7m0KiTcqjm0zdaBLhB6WzDwKKWZnxTSystXX1E
171	1	admin@example.com	::1	2025-06-23 10:05:48.210936	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4NzU0OCwiZXhwIjoxNzUwNjg3Nzg4fQ.GP5PE7m0KiTcqjm0zdaBLhB6WzDwKKWZnxTSystXX1E
304	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:16:08.274023	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODE2OCwiZXhwIjoxNzUxMzE4MjI4fQ.7r4YKUGKt0I7mO0ZB8eun9IJrAtXhX1nXL6rdbUiOtM
305	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:16:08.275591	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODE2OCwiZXhwIjoxNzUxMzE4MjI4fQ.7r4YKUGKt0I7mO0ZB8eun9IJrAtXhX1nXL6rdbUiOtM
320	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:28:15.936462	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODg5NSwiZXhwIjoxNzUxMzE4OTU1fQ.119BgmLGy2QVemRY6uSmEO4WbjJfn0Pd1keTZwfuE3M
321	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:28:15.937174	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODg5NSwiZXhwIjoxNzUxMzE4OTU1fQ.119BgmLGy2QVemRY6uSmEO4WbjJfn0Pd1keTZwfuE3M
336	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:41:45.682885	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTcwNSwiZXhwIjoxNzUxMzE5NzY1fQ.TJWngcjTGAUAeV7_qICu6zpIuxmLCPx_N-e0MaBW1X8
337	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:41:45.683364	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTcwNSwiZXhwIjoxNzUxMzE5NzY1fQ.TJWngcjTGAUAeV7_qICu6zpIuxmLCPx_N-e0MaBW1X8
352	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:53:27.630847	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDQwNywiZXhwIjoxNzUxMzIwNDY3fQ.awLqYbNU6Xyl42VzOdePGB4tCUbR2duX0nZX90Iwu7o
353	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:53:27.631921	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDQwNywiZXhwIjoxNzUxMzIwNDY3fQ.awLqYbNU6Xyl42VzOdePGB4tCUbR2duX0nZX90Iwu7o
366	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:04:31.338563	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTA3MSwiZXhwIjoxNzUxMzIxMTMxfQ.9ImUixMTAlpM3j7hRPq8E6bd8Ly8b5cob5hHf87VzwQ
367	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:04:31.339376	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTA3MSwiZXhwIjoxNzUxMzIxMTMxfQ.9ImUixMTAlpM3j7hRPq8E6bd8Ly8b5cob5hHf87VzwQ
235	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:30:04.349349	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzQwNCwiZXhwIjoxNzUwNzAzNDY0fQ.t4lYd14zEOvLnKmR-04Q7_-W8iKsohrCDEEH6QW9cKI
236	1	admin@example.com	::1	2025-06-23 14:32:43.358447	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzU2MywiZXhwIjoxNzUwNzAzNjIzfQ.DWy0lrdMT8XDWe36acJ77Fj5l8KZwrGxuF7dZdvYne4
237	1	admin@example.com	::1	2025-06-23 14:32:43.359804	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzU2MywiZXhwIjoxNzUwNzAzNjIzfQ.DWy0lrdMT8XDWe36acJ77Fj5l8KZwrGxuF7dZdvYne4
209	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:27:59.843799	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjQ3OSwiZXhwIjoxNzUwNjkyNTM5fQ._0ti7cD6sdzNUvX6vJLoPY8QkiXpdZM8T0PkWZYvcxw
210	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:33:35.044057	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjgxNSwiZXhwIjoxNzUwNjkyODc1fQ.KexRNukAm7FnRPG1eSrptKlrt1xwx-yzY6NXNEU6aKw
226	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:53:14.504168	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mzk5NCwiZXhwIjoxNzUwNjk0MDU0fQ.PJwSoJQ0LKkt_tuFrldtmvHh9T_NJlJWwOObThQX7BQ
227	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:53:14.505215	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mzk5NCwiZXhwIjoxNzUwNjk0MDU0fQ.PJwSoJQ0LKkt_tuFrldtmvHh9T_NJlJWwOObThQX7BQ
228	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 11:57:42.458717	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NDI2MiwiZXhwIjoxNzUwNjk0MzIyfQ.e8JCFTk98M7dZWOl9drN9P8jpa8xDVocEgXTZBM1uec
188	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:58:22.333931	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDcwMiwiZXhwIjoxNzUwNjkwOTQyfQ.IT4bHKiJlKxx5jc8aa6jeSpZOlkFS234OmSneuFuz3E
189	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 10:58:22.336269	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDcwMiwiZXhwIjoxNzUwNjkwOTQyfQ.IT4bHKiJlKxx5jc8aa6jeSpZOlkFS234OmSneuFuz3E
262	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:17:33.241708	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjI1MywiZXhwIjoxNzUwNzA2MzEzfQ.9V6qFrdIWrz1HSmgpzYWd5Rm0BUURYv8si2607yGZww
263	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:17:33.242579	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjI1MywiZXhwIjoxNzUwNzA2MzEzfQ.9V6qFrdIWrz1HSmgpzYWd5Rm0BUURYv8si2607yGZww
278	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:39:00.620485	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzU0MCwiZXhwIjoxNzUwNzA3NjAwfQ.yyclEfrtK2Y8N6mAQxr3UPRHrhhQBonu__KYvkHkThY
279	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:39:00.657919	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzU0MCwiZXhwIjoxNzUwNzA3NjAwfQ.yyclEfrtK2Y8N6mAQxr3UPRHrhhQBonu__KYvkHkThY
290	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:44:47.639569	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjI4NywiZXhwIjoxNzUxMzE2MzQ3fQ.bWA3fvwg5xQd4uDOHfRcgkYv1KLgq_X_vsqI3NsP008
291	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 16:44:47.641365	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjI4NywiZXhwIjoxNzUxMzE2MzQ3fQ.bWA3fvwg5xQd4uDOHfRcgkYv1KLgq_X_vsqI3NsP008
306	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:18:40.71568	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODMyMCwiZXhwIjoxNzUxMzE4MzgwfQ.s4dSSfyCMwKE6Kn0xpLlVRoRDsqevJimNl39WEDrraQ
307	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:18:40.716563	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODMyMCwiZXhwIjoxNzUxMzE4MzgwfQ.s4dSSfyCMwKE6Kn0xpLlVRoRDsqevJimNl39WEDrraQ
322	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:32:27.454416	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTE0NywiZXhwIjoxNzUxMzE5MjA3fQ.9uD8nHhDEhcvIohJMTo3Ko8L9O8W8g47r1-Ikjpzg3w
323	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:32:27.455136	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTE0NywiZXhwIjoxNzUxMzE5MjA3fQ.9uD8nHhDEhcvIohJMTo3Ko8L9O8W8g47r1-Ikjpzg3w
338	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:44:22.254504	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTg2MiwiZXhwIjoxNzUxMzE5OTIyfQ.nq5DDeAJf0E9ZjLv5qfX1aaAyWJGoTfYMWMuY4q6VMU
339	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:44:22.255338	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTg2MiwiZXhwIjoxNzUxMzE5OTIyfQ.nq5DDeAJf0E9ZjLv5qfX1aaAyWJGoTfYMWMuY4q6VMU
354	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:55:06.208457	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDUwNiwiZXhwIjoxNzUxMzIwNTY2fQ.YZBa5w9e7N26T9e6Zb2zgOYjutOSuOKyKf7D7Rav0SI
355	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:55:06.210287	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDUwNiwiZXhwIjoxNzUxMzIwNTY2fQ.YZBa5w9e7N26T9e6Zb2zgOYjutOSuOKyKf7D7Rav0SI
368	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:05:51.601036	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTE1MSwiZXhwIjoxNzUxMzIxMjExfQ.QjcOVEHU2M1CPyAVUr8pfzQnMHX5tfUDKydlq74mIh4
369	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:05:51.601672	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTE1MSwiZXhwIjoxNzUxMzIxMjExfQ.QjcOVEHU2M1CPyAVUr8pfzQnMHX5tfUDKydlq74mIh4
378	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 09:47:55.400291	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3NzY3NSwiZXhwIjoxNzUxMzc3NzM1fQ._TjrYAAWIgNAuUlut0vBxgEEK2m3LkJ9DJiUCBuW8hU
379	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 09:47:55.401962	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3NzY3NSwiZXhwIjoxNzUxMzc3NzM1fQ._TjrYAAWIgNAuUlut0vBxgEEK2m3LkJ9DJiUCBuW8hU
292	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:08:37.945108	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzcxNywiZXhwIjoxNzUxMzE3Nzc3fQ.81Nn1xbhzThNkLVd3BwNq0puLgGlGh6BgESt93dlL3o
293	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:08:37.946126	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzcxNywiZXhwIjoxNzUxMzE3Nzc3fQ.81Nn1xbhzThNkLVd3BwNq0puLgGlGh6BgESt93dlL3o
153	1	admin@example.com	::1	2025-06-17 07:21:23.772893	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE1OTI4MywiZXhwIjoxNzUwMTU5NTIzfQ.tWxxXXQeC6geOw6ROQbzuX6kekchjlv-MMEHkmXzBtE
154	1	admin@example.com	::1	2025-06-17 07:21:23.774698	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE1OTI4MywiZXhwIjoxNzUwMTU5NTIzfQ.tWxxXXQeC6geOw6ROQbzuX6kekchjlv-MMEHkmXzBtE
155	1	admin@example.com	::1	2025-06-17 07:37:36.753074	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDI1NiwiZXhwIjoxNzUwMTYwNDk2fQ.CKRFTwNoLdwMTRrKGKiI6tf8HakztWBxa_o8XlAvXRA
156	1	admin@example.com	::1	2025-06-17 07:37:36.754218	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDI1NiwiZXhwIjoxNzUwMTYwNDk2fQ.CKRFTwNoLdwMTRrKGKiI6tf8HakztWBxa_o8XlAvXRA
157	1	admin@example.com	::1	2025-06-17 07:40:51.897167	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDQ1MSwiZXhwIjoxNzUwMTYwNjkxfQ.WUjpKtrHM_nPse49Pp7hUKWzsvVXP-rlixsGb5xYmmY
158	1	admin@example.com	::1	2025-06-17 07:40:51.897856	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDQ1MSwiZXhwIjoxNzUwMTYwNjkxfQ.WUjpKtrHM_nPse49Pp7hUKWzsvVXP-rlixsGb5xYmmY
244	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:41:22.409289	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDA4MiwiZXhwIjoxNzUwNzA0NjgyfQ.xmpFzxB545fRBxh9pbsJ1ytvCcIiX1jzK8OUCWzLknc
245	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:41:22.409673	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDA4MiwiZXhwIjoxNzUwNzA0NjgyfQ.xmpFzxB545fRBxh9pbsJ1ytvCcIiX1jzK8OUCWzLknc
308	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:20:03.733439	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODQwMywiZXhwIjoxNzUxMzE4NDYzfQ.XxrMQawLdPV71h1rh_KajiNOnBQVxKOQVhY_3W_UKyk
309	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:20:03.734093	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODQwMywiZXhwIjoxNzUxMzE4NDYzfQ.XxrMQawLdPV71h1rh_KajiNOnBQVxKOQVhY_3W_UKyk
324	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:33:32.878443	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTIxMiwiZXhwIjoxNzUxMzE5MjcyfQ.0uLYS1jyXgCgPRb5dKj9icJc8vzCBZn-D1wo4elvf98
325	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:33:32.879437	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTIxMiwiZXhwIjoxNzUxMzE5MjcyfQ.0uLYS1jyXgCgPRb5dKj9icJc8vzCBZn-D1wo4elvf98
340	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:45:32.279625	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTkzMiwiZXhwIjoxNzUxMzE5OTkyfQ.UPznqj7R1VFqwhyLMsPA_Edbg1A9qFt52ESDgI_Su5E
341	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:45:32.28071	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTkzMiwiZXhwIjoxNzUxMzE5OTkyfQ.UPznqj7R1VFqwhyLMsPA_Edbg1A9qFt52ESDgI_Su5E
356	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:56:13.999791	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDU3MywiZXhwIjoxNzUxMzIwNjMzfQ.9Lowr40VIhnysXqEnP_XmW-mMvyOXYZsil-ipyu1aio
357	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:56:14.000617	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDU3MywiZXhwIjoxNzUxMzIwNjMzfQ.9Lowr40VIhnysXqEnP_XmW-mMvyOXYZsil-ipyu1aio
370	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:07:20.334584	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTI0MCwiZXhwIjoxNzUxMzIxMzAwfQ.xeQdBHBqfFNzjfIYyuPhssvQe8bhEZ8fNbftwthH4oY
371	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:07:20.3352	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTI0MCwiZXhwIjoxNzUxMzIxMzAwfQ.xeQdBHBqfFNzjfIYyuPhssvQe8bhEZ8fNbftwthH4oY
380	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 09:51:22.95067	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3Nzg4MiwiZXhwIjoxNzUxMzc3OTQyfQ.uo-4NwBd0w749jnIoCuUugz0c0VEcyxB3WtZWkLNOaI
381	1	admin@example.com	::ffff:127.0.0.1	2025-07-01 09:51:22.95136	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3Nzg4MiwiZXhwIjoxNzUxMzc3OTQyfQ.uo-4NwBd0w749jnIoCuUugz0c0VEcyxB3WtZWkLNOaI
246	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:45:54.444856	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDM1NCwiZXhwIjoxNzUwNzA0NDc0fQ.74GK3SBhWhdX2Trf244_SpciAmQ4gOw0WIsgxqN9fvI
247	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 14:45:54.445257	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDM1NCwiZXhwIjoxNzUwNzA0NDc0fQ.74GK3SBhWhdX2Trf244_SpciAmQ4gOw0WIsgxqN9fvI
266	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:25:07.930097	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjcwNywiZXhwIjoxNzUwNzA2NzY3fQ.lf39MfrcHs9KWH90HdzYw7NzamyULovwnBxsCcjjMkY
267	1	admin@example.com	::ffff:127.0.0.1	2025-06-23 15:25:07.931095	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjcwNywiZXhwIjoxNzUwNzA2NzY3fQ.lf39MfrcHs9KWH90HdzYw7NzamyULovwnBxsCcjjMkY
294	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:09:28.582211	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzc2OCwiZXhwIjoxNzUxMzE3ODI4fQ.jJTa2unVjOapNHKNl6FHwTzG0hZbKj6pvUBqjatt4wk
295	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:09:28.583188	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzc2OCwiZXhwIjoxNzUxMzE3ODI4fQ.jJTa2unVjOapNHKNl6FHwTzG0hZbKj6pvUBqjatt4wk
310	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:20:59.32461	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODQ1OSwiZXhwIjoxNzUxMzE4NTE5fQ.EFhNIepqAy9tuhib0pzF9GZBJ97CQ3XQw58hNMl3IoM
311	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:20:59.326229	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODQ1OSwiZXhwIjoxNzUxMzE4NTE5fQ.EFhNIepqAy9tuhib0pzF9GZBJ97CQ3XQw58hNMl3IoM
326	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:34:20.643625	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTI2MCwiZXhwIjoxNzUxMzE5MzIwfQ.Xz9ZOL1u7ctgW3wKkqc-6g4LnlluTcD3r10kAv0OBdk
327	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:34:20.644125	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTI2MCwiZXhwIjoxNzUxMzE5MzIwfQ.Xz9ZOL1u7ctgW3wKkqc-6g4LnlluTcD3r10kAv0OBdk
342	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:46:46.398756	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDAwNiwiZXhwIjoxNzUxMzIwMDY2fQ.7EKr8270lo4LQV7YszrmDOA6Q7SQZ-6jiEtB451E7zc
343	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:46:46.399241	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDAwNiwiZXhwIjoxNzUxMzIwMDY2fQ.7EKr8270lo4LQV7YszrmDOA6Q7SQZ-6jiEtB451E7zc
358	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:56:56.139091	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDYxNiwiZXhwIjoxNzUxMzIwNjc2fQ.futTxHhwiPWgF0-S9x2e_ylpPZy4WtJcNJer5U_bJGM
359	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 17:56:56.140911	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDYxNiwiZXhwIjoxNzUxMzIwNjc2fQ.futTxHhwiPWgF0-S9x2e_ylpPZy4WtJcNJer5U_bJGM
372	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:08:35.682912	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTMxNSwiZXhwIjoxNzUxMzIxMzc1fQ.Ygrv8uSvLwKdmCCIBb2z3I8W65jdiKBwKoKQdZPGrGw
373	1	admin@example.com	::ffff:127.0.0.1	2025-06-30 18:08:35.684067	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTMxNSwiZXhwIjoxNzUxMzIxMzc1fQ.Ygrv8uSvLwKdmCCIBb2z3I8W65jdiKBwKoKQdZPGrGw
382	1	admin@example.com	::1	2025-07-01 10:18:59.492707	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3OTUzOSwiZXhwIjoxNzUxMzc5NTk5fQ.hA7NGZ0zDKrZEzYoZntZy_hI5mjF5k-RJk04XboW3F4
383	1	admin@example.com	::1	2025-07-01 10:18:59.493421	success	force logout	2025-07-01 10:31:36.34078	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3OTUzOSwiZXhwIjoxNzUxMzc5NTk5fQ.hA7NGZ0zDKrZEzYoZntZy_hI5mjF5k-RJk04XboW3F4
400	\N	cmarrero@correo.com	::ffff:127.0.0.1	2025-08-07 13:53:06.420272	failed	\N	\N	\N
401	\N	cmarrero@correo.com	::ffff:127.0.0.1	2025-08-07 13:53:13.37291	failed	\N	\N	\N
402	\N	admin@example.com	::ffff:127.0.0.1	2025-08-07 13:54:46.224591	failed	\N	\N	\N
403	\N	admin@example.com	::ffff:127.0.0.1	2025-08-07 13:54:55.518745	failed	\N	\N	\N
404	\N	admin@example.com	::ffff:127.0.0.1	2025-08-07 13:55:45.038845	failed	\N	\N	\N
405	\N	admin@example.com	::ffff:127.0.0.1	2025-08-07 14:06:10.681007	blocked	\N	\N	\N
406	\N	admin@example.com	::ffff:127.0.0.1	2025-08-07 14:06:24.80986	failed	\N	\N	\N
407	\N	cmarrero@correo.com	::ffff:127.0.0.1	2025-08-07 14:06:46.790734	failed	\N	\N	\N
408	\N	admin@example.com	::ffff:127.0.0.1	2025-08-07 14:10:00.213431	failed	\N	\N	\N
409	\N	admin@example.com	::ffff:127.0.0.1	2025-08-07 14:10:11.496292	failed	\N	\N	\N
410	\N	admin@example.com	::ffff:127.0.0.1	2025-08-07 14:10:30.907313	failed	\N	\N	\N
411	\N	admin@example.com	::ffff:127.0.0.1	2025-08-07 14:11:49.75403	failed	\N	\N	\N
414	\N	admin	::ffff:43.153.5.160	2025-10-24 00:42:24.362847	failed	\N	\N	\N
419	\N	admin	::ffff:43.153.5.160	2025-10-30 16:31:21.968804	failed	\N	\N	\N
424	\N	admin	::ffff:170.106.81.52	2025-11-03 01:26:31.574187	failed	\N	\N	\N
429	\N	admin	::ffff:43.153.5.160	2025-11-03 02:07:46.854109	failed	\N	\N	\N
432	\N	admin@correo.com	::ffff:127.0.0.1	2025-12-01 17:55:42.222032	failed	\N	\N	\N
433	\N	admin@correo.com	::ffff:127.0.0.1	2025-12-01 17:55:57.389839	failed	\N	\N	\N
434	\N	admin@correo.com	::ffff:127.0.0.1	2025-12-01 17:56:13.752387	failed	\N	\N	\N
435	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 17:56:56.257824	success	logout	2025-12-01 18:00:30.522317	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYyNjIxNiwiZXhwIjoxNzY0NjMzNDE2fQ.2pVgVaEBlmEOEwCcnwVIDoWo5K3lEjggxOB4yYsbc5Q
436	\N	pedro@perez.com	::ffff:127.0.0.1	2025-12-01 18:10:28.59602	failed	\N	\N	\N
437	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 18:10:40.36064	success	logout	2025-12-01 18:31:56.454027	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYyNzA0MCwiZXhwIjoxNzY0NjM0MjQwfQ.o_8YUoHADHF6xIN7gT2nlh3iQnhc4aNHyP7csOqD0zk
438	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 18:32:07.857243	success	logout	2025-12-01 19:04:21.207204	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYyODMyNywiZXhwIjoxNzY0NjM1NTI3fQ.M04Nu_zNFJY3gZ7GSWqvY_WEKjqM6hyICfhlSbiu2Fg
439	2	marrero.c@gmail.com	::ffff:127.0.0.1	2025-12-01 19:04:37.947061	success	logout	2025-12-01 19:04:46.733087	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc2NDYzMDI3NywiZXhwIjoxNzY0NjM3NDc3fQ.XjFHCr66ezB98HCAau7tjiQXYmIpy4u2BwRauqgUgdM
440	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 19:04:51.67825	success	logout	2025-12-01 19:12:34.036718	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMDI5MSwiZXhwIjoxNzY0NjM3NDkxfQ._D4qchvprWJbi0BIsTdSCVM4zovY-IubfHtAQ6BChuI
441	3	marrero.c@gmail.com	::ffff:127.0.0.1	2025-12-01 19:12:40.023748	success	logout	2025-12-01 19:13:00.109955	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMDc2MCwiZXhwIjoxNzY0NjM3OTYwfQ.HRV9c5Uvp2jFwgcpWYJGBWJvzf0AwCaPuqkuJc0K2iI
442	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 19:13:04.506846	success	logout	2025-12-01 19:13:39.158312	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMDc4NCwiZXhwIjoxNzY0NjM3OTg0fQ.FJzjmTJuzK21iyaQ29os1uYtR9jlFuPsgykemRO64zY
443	3	marrero.c@gmail.com	::ffff:127.0.0.1	2025-12-01 19:13:43.558379	success	logout	2025-12-01 19:13:59.300141	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMDgyMywiZXhwIjoxNzY0NjM4MDIzfQ.JOSDhHMy30TWxAybeHG_JwU8X7sTNXeEd0JsDKZUyhQ
444	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 19:14:04.868643	success	logout	2025-12-01 19:29:43.562917	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMDg0NCwiZXhwIjoxNzY0NjM4MDQ0fQ.Y5tYbqmGemftHDpGo_GAkFWDNeZmdIF2aTPwNjOFPuE
445	3	marrero.c@gmail.com	::ffff:127.0.0.1	2025-12-01 19:29:52.139358	success	logout	2025-12-01 19:30:00.999028	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMTc5MiwiZXhwIjoxNzY0NjM4OTkyfQ.JIYWkS17loh_A-bBhtoMsT3szIUE1FvGtzAo_t3HzgA
446	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 19:32:20.840581	success	logout	2025-12-01 19:32:35.113245	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMTk0MCwiZXhwIjoxNzY0NjM5MTQwfQ.pnfAef0g0_0N9085UETpzFPUkzhEd4l_SvF4-qL9SpY
447	3	marrero.c@gmail.com	::ffff:127.0.0.1	2025-12-01 19:32:39.991521	success	logout	2025-12-01 19:32:42.444828	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMTk1OSwiZXhwIjoxNzY0NjM5MTU5fQ.9MxsI42ZJPVemxg5cpPSlrZoqO4jhltj3AaAoaMYSP0
448	\N	estadal@example.com	::ffff:127.0.0.1	2025-12-01 19:32:51.100901	failed	\N	\N	\N
449	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 19:33:01.724183	success	logout	2025-12-01 19:33:15.889193	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMTk4MSwiZXhwIjoxNzY0NjM5MTgxfQ.mgZs7O4bygiAGVgPM8IEMQY6GqfgefhruExlcGH9C14
450	3	marrero.c@gmail.com	::ffff:127.0.0.1	2025-12-01 19:34:24.128341	success	logout	2025-12-01 19:34:30.651582	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMjA2NCwiZXhwIjoxNzY0NjM5MjY0fQ.E3DCpF1Qreb3qSh1nWEGc5gU7DZhwD6lOUPyoKXls2w
451	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 19:34:34.771524	success	logout	2025-12-01 19:34:47.321514	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMjA3NCwiZXhwIjoxNzY0NjM5Mjc0fQ.lAMh167cMnTrJHSA81bHzyxLic9Y9hnVPvsE9JXW9wQ
452	3	marrero.c@gmail.com	::ffff:127.0.0.1	2025-12-01 19:34:50.856684	success	logout	2025-12-01 19:35:45.167761	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMjA5MCwiZXhwIjoxNzY0NjM5MjkwfQ.oW_tj8cQ6kqgUUlEvBmgLRdY_p5KHTonUNUoqs2dfJU
453	1	admin@example.com	::ffff:127.0.0.1	2025-12-01 19:36:44.810063	success	logout	2025-12-01 19:40:42.122629	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMjIwNCwiZXhwIjoxNzY0NjM5NDA0fQ.JDIrc6451JcvNLQ32bcZsTGok0ve7opbDOUFnoXCyHU
454	1	admin@example.com	::ffff:127.0.0.1	2025-12-04 11:55:49.35939	success	logout	2025-12-08 07:56:46.429869	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDg2Mzc0OSwiZXhwIjoxNzY0ODcwOTQ5fQ.qr1Kr1TpKyJcpsOWHZwXZp3bzQCR0WPqETM7vJr2xpw
455	1	admin@example.com	::ffff:127.0.0.1	2025-12-08 08:35:01.358979	success	logout	2025-12-08 08:36:11.396219	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NTE5NzMwMSwiZXhwIjoxNzY1MjA0NTAxfQ.Wv_iWjqjz-VzXsuLt6lvSuHMITbcHhSSCZju_7puy8g
456	1	admin@example.com	::ffff:127.0.0.1	2025-12-08 08:41:55.672988	success	logout	2025-12-08 09:31:53.657326	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NTE5NzcxNSwiZXhwIjoxNzY1MjA0OTE1fQ.mAeqztb0VZg-TbTXpcYdNzRP0E1OsRXS-lKYWH7hUQY
457	1	admin@example.com	::ffff:127.0.0.1	2025-12-08 14:24:55.1174	success	logout	2025-12-08 15:37:40.175187	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NTIxODI5NSwiZXhwIjoxNzY1MjI1NDk1fQ.-vu-WxmausFjXv2cVdkM8wuq1SxhqWF4UY3J-FogB78
\.


--
-- Data for Name: menu_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu_categories (id, name, icon, display_order, created_at, updated_at, deleted_at) FROM stdin;
1	Administración	settings	1	2025-05-11 21:53:42.925935	2025-05-11 21:53:42.925935	2025-05-11 21:53:42.925935
2	Contenido	book	2	2025-05-11 21:53:42.925935	2025-05-11 21:53:42.925935	2025-05-11 21:53:42.925935
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu_items (id, category_id, title, icon, path, permission_name, parent_id, item_order, is_divider, is_header, created_at, updated_at, deleted_at) FROM stdin;
5	1	Usuarios	people	/admin/users	list_users	\N	1	f	f	2025-05-11 21:56:38.458977	2025-05-11 21:56:38.458977	2025-05-11 21:56:38.458977
6	1	Roles	admin_panel_settings	/admin/roles	list_roles	\N	2	f	f	2025-05-11 21:56:38.458977	2025-05-11 21:56:38.458977	2025-05-11 21:56:38.458977
\.


--
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_resets (id, user_id, token, expires_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: periodicidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periodicidad (id, periodicidad, created_at, updated_at, deleted_at) FROM stdin;
1	DIARIO	2021-11-04 12:43:25.103102	\N	\N
2	SEMANAL	2021-11-04 12:43:25.103102	\N	\N
3	QUINCENAL	2021-11-04 12:43:25.103102	\N	\N
4	MENSUAL	2021-11-04 12:43:25.103102	\N	\N
5	BIMENSUAL	2021-11-04 12:43:25.103102	\N	\N
6	TRIMESTRAL	2021-11-04 12:43:25.103102	\N	\N
7	CUATRIMESTRAL	2021-11-04 12:43:25.103102	\N	\N
8	SEMESTRAL	2021-11-04 12:43:25.103102	\N	\N
9	ANUAL	2021-11-04 12:43:25.103102	\N	\N
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name, description, resource, action, created_at, updated_at) FROM stdin;
17	get_global_session_settings	Ver configuración global de sesión	session_settings	read	2025-05-08 17:01:59.893239	2025-05-08 17:01:59.893239
18	update_global_session_settings	Modificar configuración global de sesión	session_settings	update	2025-05-08 17:01:59.893239	2025-05-08 17:01:59.893239
19	update_user_session_timeout	Modificar duración de sesión de usuario	user	update	2025-05-08 17:01:59.893239	2025-05-08 17:01:59.893239
20	update_role_session_timeout	Modificar duración de sesión de rol	role	update	2025-05-08 17:01:59.893239	2025-05-08 17:01:59.893239
21	force-logout	Cierre forzoso de la sesión de un usuario	session_setings	forced_logout	2025-05-08 20:04:16.210516	2025-05-08 20:04:16.210516
22	assign-permission	Asignar permiso	permission	assign	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
23	assign-role	Asignar rol	role	assign	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
24	change-password	Cambiar clave	password	update	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
25	delete_permission_permanently	Eliminar permiso permanentemente	permission	delete	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
26	delete_role_permanently	Eliminar rol permanentemente	role	delete	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
27	delete_user_permanently	Eliminar usuario permanentemente	user	delete	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
28	list_permissions	Listar permisos	permission	read	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
29	list_roles	Listar roles	role	read	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
30	list_users	Listar usuarios	user	read	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
31	logout	Cerrar sesión	session	logout	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
32	remove-permission	Borrar permiso lógicamente	permission	delete	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
33	remove-role	Borrar rol lógicamente	role	delete	2025-05-08 23:27:45.266077	2025-05-08 23:27:45.266077
1	create_user	Crear usuarios	user	create	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
2	read_user	Ver usuarios	user	read	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
3	update_user	Actualizar usuarios	user	update	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
4	delete_user	Eliminar usuario	user	delete	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
5	create_role	Crear roles	role	create	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
6	read_role	Ver roles	role	read	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
7	update_role	Actualizar roles	role	update	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
8	delete_role	Eliminar roles	role	delete	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
9	create_permission	Crear permisos	permission	create	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
10	read_permission	Leer permisos	permission	read	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
11	update_permission	Actualizar permisos	permission	update	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
12	delete_permission	Eliminar permisos	permission	delete	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
13	create_revista	Crear revistas	revista	create	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
14	read_revista	Ver revistas	revista	read	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
15	update_revista	Actualizar revistas	revista	update	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
16	delete_revista	Eliminar revistas	revista	delete	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768
34	view_admin	Administrar publicaciones	revista	read	2025-05-12 08:33:41.504158	2025-05-12 08:33:41.504158
35	permission_test	Prueba de permisos	permission	read	2025-06-30 17:08:23.624822	2025-06-30 17:08:23.624822
\.


--
-- Data for Name: revistas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revistas (id, area_conocimiento_id, indice_id, idioma_id, revista, correo_revista, editorial_id, periodicidad_id, formato_id, estado_id, nombres_editor, apellidos_editor, correo_editor, deposito_legal_impreso, deposito_legal_digital, issn_impreso, issn_digital, url, anio_inicial, direccion, telefono, resumen, portada, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
1	1
1	2
1	3
1	4
1	5
1	6
1	7
1	8
1	9
1	10
1	11
1	12
1	13
1	14
1	15
1	16
1	20
1	19
1	18
1	17
1	21
1	22
1	23
1	24
1	25
1	26
1	27
1	29
1	30
1	31
1	32
1	33
1	34
1	28
2	13
2	14
2	15
2	31
2	34
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description, created_at, updated_at, session_timeout_min) FROM stdin;
1	Admin	Rol con todos los permisos	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768	120
2	usuario	Rol de usuario estándard	2025-07-01 15:49:27.752629	2025-07-01 15:49:27.752629	\N
\.


--
-- Data for Name: session_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session_settings (id, global_timeout, created_at, updated_at) FROM stdin;
1	120	2025-05-08 11:53:57.361184	2025-05-08 11:53:57.361184
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, token, expires_at, is_revoked, created_at) FROM stdin;
130	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDMyMiwiZXhwIjoxNzUxMzg3NTIyfQ.IHqK0RWLcwWzypbQhUmaiDIN-9FmPO-DifwulO8kFtg	2025-07-01 12:32:02.670808	t	2025-07-01 10:32:02.670808
58	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDM1NCwiZXhwIjoxNzUwNzA0NDc0fQ.74GK3SBhWhdX2Trf244_SpciAmQ4gOw0WIsgxqN9fvI	2025-06-23 14:47:54.441275	t	2025-06-23 14:45:54.441275
54	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzkxOSwiZXhwIjoxNzUwNzA0MDM5fQ.UYLJwi7S9IsOQTWThzCkGfhgFri4FlfX6MCj28Jl1rk	2025-06-23 14:40:39.56219	t	2025-06-23 14:38:39.56219
21	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4ODg5OCwiZXhwIjoxNzUwNjg5MTM4fQ.KQFsikGvcqbl9A2eIgwPErf2REkuGFqfBY8KDysXBkk	2025-06-23 10:32:18.151143	t	2025-06-23 10:28:18.151143
1	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5MTM2MiwiZXhwIjoxNzUwMDkxNjAyfQ.59I8Vn9DT4oSIsfVlBXDwgOSf-BBhkitjjknJRuLPGs	2025-06-16 12:33:22.486615	t	2025-06-16 12:29:22.486615
2	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5MTY2NCwiZXhwIjoxNzUwMDkxOTA0fQ.Ds2IMMcQ8BqIksWLsP2kR61jqp18cvSPqFLBJUsO8nI	2025-06-16 12:38:24.244474	t	2025-06-16 12:34:24.244474
3	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NTUxOCwiZXhwIjoxNzUwMDk1NzU4fQ.iPU85tEVV1-GQL6hqVxiAtSBieV810qiEEPaMX_sIv4	2025-06-16 13:42:38.941232	t	2025-06-16 13:38:38.941232
131	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4NTU1OCwiZXhwIjoxNzUxMzkyNzU4fQ.nUH-FmrwqvWKHd4heXvzI4go2ONjn5RZAh_3No7W1_E	2025-07-01 13:59:18.153979	t	2025-07-01 11:59:18.153979
32	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTA0NCwiZXhwIjoxNzUwNjkxMjg0fQ.vkrk6D4-sfid7Y53pkETbbuHNqH4w5zYXOAD5VEu9Ow	2025-06-23 11:08:04.245068	t	2025-06-23 11:04:04.245068
35	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTYxOSwiZXhwIjoxNzUwNjkxODU5fQ.ujaAPoTQylv6kJlZs99HRD8oCguaAHRbQs6iZt2mnU4	2025-06-23 11:17:39.928249	t	2025-06-23 11:13:39.928249
56	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDA1MCwiZXhwIjoxNzUwNzA0NjUwfQ.VZjQoH_IPneHMOqA-eN6BW-sij-Ps3PbcY4wwuCau8k	2025-06-23 14:50:50.978642	t	2025-06-23 14:40:50.978642
25	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDAzMCwiZXhwIjoxNzUwNjkwMjcwfQ.bfWlP9keY5XBLMoabc0LDiUAWq5-zJs88kUeRviJqp0	2025-06-23 10:51:10.022326	t	2025-06-23 10:47:10.022326
28	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDQxNCwiZXhwIjoxNzUwNjkwNjU0fQ.nJUXx-hKDnk36Knef1kkbDsLoDc1xQnWBasPVMHRtuI	2025-06-23 10:57:34.082671	t	2025-06-23 10:53:34.082671
60	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDg5OSwiZXhwIjoxNzUwNzA0OTU5fQ.VMy2czYxmuX1_Hh-Ne7cI2tMpFytXaH67a2RFa9gXBw	2025-06-23 14:55:59.348	t	2025-06-23 14:54:59.348
65	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTkzNiwiZXhwIjoxNzUwNzA1OTk2fQ.az2XkLqDg8ZUXP72awrgheTk-8c1XVe2QratK5yz2Q8	2025-06-23 15:13:16.63604	t	2025-06-23 15:12:16.63604
70	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjk4OSwiZXhwIjoxNzUwNzA3MDQ5fQ.EntG645JXyhysW2K9q4FMhCsr5Mc0S-NG3nI0aDZZig	2025-06-23 15:30:49.186528	t	2025-06-23 15:29:49.186528
31	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDk3NSwiZXhwIjoxNzUwNjkxMjE1fQ.B2t2DCYjtvDZAwpwGONyncFFGBTxD5reaHl2-IR2Eig	2025-06-23 11:06:55.835019	t	2025-06-23 11:02:55.835019
34	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTI2OSwiZXhwIjoxNzUwNjkxNTA5fQ.OSDjCZUd36VFz285jmPuK3lpMO0zcJGtb0_Z0gPOTjA	2025-06-23 11:11:49.395137	t	2025-06-23 11:07:49.395137
22	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4ODk1MiwiZXhwIjoxNzUwNjg5MTkyfQ.6fUSKAGQoNg-xbBRnOWZc3Ik7GtCvyiZegMJ_WwClFo	2025-06-23 10:33:12.090382	t	2025-06-23 10:29:12.090382
75	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNDgwMiwiZXhwIjoxNzUxMzE0ODYyfQ.75rFJtNTA6JqLjDfq3ciouFnmc9ReZrdSz7Lgymvtb4	2025-06-30 16:21:02.868934	t	2025-06-30 16:20:02.868934
80	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjI4NywiZXhwIjoxNzUxMzE2MzQ3fQ.bWA3fvwg5xQd4uDOHfRcgkYv1KLgq_X_vsqI3NsP008	2025-06-30 16:45:47.632421	t	2025-06-30 16:44:47.632421
85	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzk4OSwiZXhwIjoxNzUxMzE4MDQ5fQ.uiUXNAQx8pE-HwegLBlMO5BwEgwKO-qpkTX144mvJRE	2025-06-30 17:14:09.07176	t	2025-06-30 17:13:09.07176
90	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODQ1OSwiZXhwIjoxNzUxMzE4NTE5fQ.EFhNIepqAy9tuhib0pzF9GZBJ97CQ3XQw58hNMl3IoM	2025-06-30 17:21:59.318929	t	2025-06-30 17:20:59.318929
95	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODg5NSwiZXhwIjoxNzUxMzE4OTU1fQ.119BgmLGy2QVemRY6uSmEO4WbjJfn0Pd1keTZwfuE3M	2025-06-30 17:29:15.931286	t	2025-06-30 17:28:15.931286
59	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDM4NywiZXhwIjoxNzUwNzA0NTA3fQ.SaIRSlv4z7XaD-uP-ZyL54Ly8nL7LmeyI8PHG3Ojc3I	2025-06-23 14:48:27.608235	t	2025-06-23 14:46:27.608235
132	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4NTYwMiwiZXhwIjoxNzUxMzkyODAyfQ.6e3WETi2babUgtKOyEc9b-Cay6bp0uyqrNGHeKgJij8	2025-07-01 14:00:02.811968	t	2025-07-01 12:00:02.811968
100	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTU0NCwiZXhwIjoxNzUxMzE5NjA0fQ.KxM0U59tGcuM8d5Wk4dRXerl0LeMsXbANK5s9QT-yeU	2025-06-30 17:40:04.545671	t	2025-06-30 17:39:04.545671
105	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTkzMiwiZXhwIjoxNzUxMzE5OTkyfQ.UPznqj7R1VFqwhyLMsPA_Edbg1A9qFt52ESDgI_Su5E	2025-06-30 17:46:32.27576	t	2025-06-30 17:45:32.27576
110	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDM1MSwiZXhwIjoxNzUxMzIwNDExfQ.rxC3UzSz0ZoBKtPWAuNfIHxEGJQgaZqYcMhQhX3dj1w	2025-06-30 17:53:31.148378	t	2025-06-30 17:52:31.148378
62	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTM0NywiZXhwIjoxNzUwNzA1NDA3fQ.ZBoNBDL1qSugb-k_k87Q_MIQI-sPeQ9j7txUp7mJaYA	2025-06-23 15:03:27.23478	t	2025-06-23 15:02:27.23478
67	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjUzOSwiZXhwIjoxNzUwNzA2NTk5fQ.LrD4V4Nt0sYgz0v6JYYsoKZM2taDuRRXn2-O1Z3O3_A	2025-06-23 15:23:19.473719	t	2025-06-23 15:22:19.473719
133	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM5NDA1MywiZXhwIjoxNzUxNDAxMjUzfQ.y7CJ6-IF-5i4oDBjZNyK5baUeUr-nTQJ-wqVzowDZkw	2025-07-01 16:20:53.663805	t	2025-07-01 14:20:53.663805
115	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDgxNiwiZXhwIjoxNzUxMzIwODc2fQ.U2cVDyteG09RSwXm51BPP-9I9ScPQfFQZ-ftVY_FIlk	2025-06-30 18:01:16.768891	t	2025-06-30 18:00:16.768891
120	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTI0MCwiZXhwIjoxNzUxMzIxMzAwfQ.xeQdBHBqfFNzjfIYyuPhssvQe8bhEZ8fNbftwthH4oY	2025-06-30 18:08:20.330079	t	2025-06-30 18:07:20.330079
125	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3Nzg4MiwiZXhwIjoxNzUxMzc3OTQyfQ.uo-4NwBd0w749jnIoCuUugz0c0VEcyxB3WtZWkLNOaI	2025-07-01 09:52:22.944457	t	2025-07-01 09:51:22.944457
61	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTExNSwiZXhwIjoxNzUwNzA1MTc1fQ.DhyYZLJ6YQDzrdYVTmqid6Ulq8TG4B0Q7LCB7G4vo9Q	2025-06-23 14:59:35.43114	t	2025-06-23 14:58:35.43114
66	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjI1MywiZXhwIjoxNzUwNzA2MzEzfQ.9V6qFrdIWrz1HSmgpzYWd5Rm0BUURYv8si2607yGZww	2025-06-23 15:18:33.236682	t	2025-06-23 15:17:33.236682
71	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzA3OCwiZXhwIjoxNzUwNzA3MTM4fQ.hZQQ5nAiXoiYxXgkqxRGYDaOyHZvHrfBwW3tpwRfrKA	2025-06-23 15:32:18.047449	t	2025-06-23 15:31:18.047449
76	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNTk1NCwiZXhwIjoxNzUxMzE2MDE0fQ.wKYEti891r7ywC978T9enbupxCDjDEvNpR7-RaV8X2k	2025-06-30 16:40:14.735277	t	2025-06-30 16:39:14.735277
81	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzcxNywiZXhwIjoxNzUxMzE3Nzc3fQ.81Nn1xbhzThNkLVd3BwNq0puLgGlGh6BgESt93dlL3o	2025-06-30 17:09:37.940726	t	2025-06-30 17:08:37.940726
86	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODExNiwiZXhwIjoxNzUxMzE4MTc2fQ.l11eqbH1d2lynEr34E6zzFoPZ881Mlne11GOrgVCgRc	2025-06-30 17:16:16.045817	t	2025-06-30 17:15:16.045817
33	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTEzNiwiZXhwIjoxNzUwNjkxMzc2fQ.2jkG_ALjL0LMcqMpohAzTXix2Elx0YlL8RmGuW-0GgU	2025-06-23 11:09:36.534987	t	2025-06-23 11:05:36.534987
36	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MTg3OSwiZXhwIjoxNzUwNjkxOTk5fQ.InliaHEr_Y-hNkDuPuop5-97CsFP4dS0ErPky8SiLW8	2025-06-23 11:19:59.32195	t	2025-06-23 11:17:59.32195
39	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjQ3OSwiZXhwIjoxNzUwNjkyNTM5fQ._0ti7cD6sdzNUvX6vJLoPY8QkiXpdZM8T0PkWZYvcxw	2025-06-23 11:28:59.839759	t	2025-06-23 11:27:59.839759
4	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjE2NCwiZXhwIjoxNzUwMDk2NDA0fQ.JIK18yKg6oSj2K4A4cmfdTbXeeFJNQRUwhAP-9Rtahw	2025-06-16 13:53:24.460464	t	2025-06-16 13:49:24.460464
5	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjIwNCwiZXhwIjoxNzUwMDk2NDQ0fQ.OUrVmZ1dBkJsrwr4hThM2LX5VlbHmuit7OX5CPHinrk	2025-06-16 13:54:04.081828	t	2025-06-16 13:50:04.081828
91	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODUwOSwiZXhwIjoxNzUxMzE4NTY5fQ.WgRX4U275gTELTSYK_PHMU75xg5cyBt_9JkoaetXgFE	2025-06-30 17:22:49.291862	t	2025-06-30 17:21:49.291862
64	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTgyMiwiZXhwIjoxNzUwNzA1ODgyfQ.wSSk9MdfIirqc0AKy_uBMFIxaEYkQssnWspMMo6_HE0	2025-06-23 15:11:22.644989	t	2025-06-23 15:10:22.644989
69	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjg4MSwiZXhwIjoxNzUwNzA2OTQxfQ.bvNtGhN_hTkkDjsHNnL1X9COPR8H12H8QoRndIQ3RLI	2025-06-23 15:29:01.834955	t	2025-06-23 15:28:01.834955
74	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzU0MCwiZXhwIjoxNzUwNzA3NjAwfQ.yyclEfrtK2Y8N6mAQxr3UPRHrhhQBonu__KYvkHkThY	2025-06-23 15:40:00.602819	t	2025-06-23 15:39:00.602819
79	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjI0NCwiZXhwIjoxNzUxMzE2MzA0fQ.VMlnBUyllkii7bSzx39CD59Uym4I48FLn6WdK-V5zBw	2025-06-30 16:45:04.462215	t	2025-06-30 16:44:04.462215
84	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzk0NywiZXhwIjoxNzUxMzE4MDA3fQ.jK26V7YAmzzFphkOX28c7JKaFIGybCzfs8MfdVYreNw	2025-06-30 17:13:27.143103	t	2025-06-30 17:12:27.143103
89	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODQwMywiZXhwIjoxNzUxMzE4NDYzfQ.XxrMQawLdPV71h1rh_KajiNOnBQVxKOQVhY_3W_UKyk	2025-06-30 17:21:03.729706	t	2025-06-30 17:20:03.729706
94	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODgxOCwiZXhwIjoxNzUxMzE4ODc4fQ.ZONdl_TRL4HneFkJsOpzd8nnnSdCp1aLCitPJayPVrA	2025-06-30 17:27:58.846363	t	2025-06-30 17:26:58.846363
99	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTQ2MywiZXhwIjoxNzUxMzE5NTIzfQ.mWqlgYLeM_s7Dkv3WymGRbqNv1UjiFPgs8qk-8aoBlk	2025-06-30 17:38:43.779266	t	2025-06-30 17:37:43.779266
37	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjE2OCwiZXhwIjoxNzUwNjkyMjg4fQ.TSnp8Oet2nAAS4Bp9THCBGjD88o3511AaqeKWPOLdbk	2025-06-23 11:24:48.886228	t	2025-06-23 11:22:48.886228
40	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjgxNSwiZXhwIjoxNzUwNjkyODc1fQ.KexRNukAm7FnRPG1eSrptKlrt1xwx-yzY6NXNEU6aKw	2025-06-23 11:34:35.040212	t	2025-06-23 11:33:35.040212
41	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mjk1NywiZXhwIjoxNzUwNjkzMDE3fQ.I4GNVNx_pPmsodO_5TPIv5CZAdAblw6qHFVftklNaHI	2025-06-23 11:36:57.104052	t	2025-06-23 11:35:57.104052
44	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzQ1MywiZXhwIjoxNzUwNjkzNTEzfQ.GvOS9AujK-7vLn7Hjazrj2kfntupekp3zvdELG8YUn8	2025-06-23 11:45:13.456373	t	2025-06-23 11:44:13.456373
47	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mzk1OSwiZXhwIjoxNzUwNjk0MDE5fQ.SshMZBGveEbJM54WXPRAwQsa6v_Q8AmlnoNcSdNSc7s	2025-06-23 11:53:39.510086	t	2025-06-23 11:52:39.510086
6	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjY2MSwiZXhwIjoxNzUwMDk2OTAxfQ.BOHwMS1Crhec0ZtqrNpb3A5Gl8LE2DWVrYZ4hsxHGfo	2025-06-16 14:01:41.527012	t	2025-06-16 13:57:41.527012
24	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4OTgyMiwiZXhwIjoxNzUwNjkwMDYyfQ.WG81LACtPX5Hitb1ndvEP_dH1P3sbSRq_TAAaU93-cA	2025-06-23 10:47:42.902876	t	2025-06-23 10:43:42.902876
96	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTE0NywiZXhwIjoxNzUxMzE5MjA3fQ.9uD8nHhDEhcvIohJMTo3Ko8L9O8W8g47r1-Ikjpzg3w	2025-06-30 17:33:27.44986	t	2025-06-30 17:32:27.44986
27	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDMwNCwiZXhwIjoxNzUwNjkwNTQ0fQ.3WhKoRUxYRBh-gtIuQ-ci9bppGQ38lKUstr-ZDfxTM8	2025-06-23 10:55:44.54625	t	2025-06-23 10:51:44.54625
30	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDgyNiwiZXhwIjoxNzUwNjkxMDY2fQ.p1QGiwDuuBVoN70h9E52YPqrQJ1fqN_YJ671kK8Qhp0	2025-06-23 11:04:26.723344	t	2025-06-23 11:00:26.723344
101	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTYyNywiZXhwIjoxNzUxMzE5Njg3fQ.SZHVfn_WlJBn7C4yAc2O2HOK41GQsqR7iq5RBZu6pUA	2025-06-30 17:41:27.743686	t	2025-06-30 17:40:27.743686
106	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDAwNiwiZXhwIjoxNzUxMzIwMDY2fQ.7EKr8270lo4LQV7YszrmDOA6Q7SQZ-6jiEtB451E7zc	2025-06-30 17:47:46.39565	t	2025-06-30 17:46:46.39565
111	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDQwNywiZXhwIjoxNzUxMzIwNDY3fQ.awLqYbNU6Xyl42VzOdePGB4tCUbR2duX0nZX90Iwu7o	2025-06-30 17:54:27.627074	t	2025-06-30 17:53:27.627074
116	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDg3MCwiZXhwIjoxNzUxMzIwOTMwfQ.k2OK35KbHTyRXmS3S8kXpFQNJ7ub5xwfyr_I7PPVBPQ	2025-06-30 18:02:10.889016	t	2025-06-30 18:01:10.889016
121	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTMxNSwiZXhwIjoxNzUxMzIxMzc1fQ.Ygrv8uSvLwKdmCCIBb2z3I8W65jdiKBwKoKQdZPGrGw	2025-06-30 18:09:35.678125	t	2025-06-30 18:08:35.678125
126	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3OTUzOSwiZXhwIjoxNzUxMzc5NTk5fQ.hA7NGZ0zDKrZEzYoZntZy_hI5mjF5k-RJk04XboW3F4	2025-07-01 10:19:59.489258	t	2025-07-01 10:18:59.489258
72	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzI5MCwiZXhwIjoxNzUwNzA3MzUwfQ.G6QGf0ANrCRsQmziwgPhIaMaUecMuYC75nQXTGt3GDU	2025-06-23 15:35:51.001117	t	2025-06-23 15:34:51.001117
77	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjE1MywiZXhwIjoxNzUxMzE2MjEzfQ.cWelUvZFNvDleP60bZX6BFcBRrYBWrdWkJAk2G06oJU	2025-06-30 16:43:33.250839	t	2025-06-30 16:42:33.250839
7	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjY4MSwiZXhwIjoxNzUwMDk2OTIxfQ.THyoxy7gnAa8bKZrJKWeF7p_SMArsF08CtZe3avf_nU	2025-06-16 14:02:01.810979	t	2025-06-16 13:58:01.810979
8	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5Njc1OSwiZXhwIjoxNzUwMDk2OTk5fQ.SvOmLa3WewLbnQ_5I6kfkLkS1mCGRcuoQfGJ7Mh6Wfg	2025-06-16 14:03:19.125628	t	2025-06-16 13:59:19.125628
82	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzc2OCwiZXhwIjoxNzUxMzE3ODI4fQ.jJTa2unVjOapNHKNl6FHwTzG0hZbKj6pvUBqjatt4wk	2025-06-30 17:10:28.57889	t	2025-06-30 17:09:28.57889
9	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5NjgyNiwiZXhwIjoxNzUwMDk3MDY2fQ.PCJbfZK3W8rDPH9MjhqHLE2C1vRHrAW2lC6ZhC9H3s4	2025-06-16 14:04:26.628155	t	2025-06-16 14:00:26.628155
87	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODE2OCwiZXhwIjoxNzUxMzE4MjI4fQ.7r4YKUGKt0I7mO0ZB8eun9IJrAtXhX1nXL6rdbUiOtM	2025-06-30 17:17:08.269287	t	2025-06-30 17:16:08.269287
92	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODY3MiwiZXhwIjoxNzUxMzE4NzMyfQ.H4Dgk8nt4MXw1D_ayJhpir4qHYJcaZLfrdZKv6DSm-c	2025-06-30 17:25:32.979605	t	2025-06-30 17:24:32.979605
10	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5ODAwOCwiZXhwIjoxNzUwMDk4MjQ4fQ.YtGQXCbCA5QitiIi1nX1mWQeMNkKATvvgTtDfzabKLI	2025-06-16 14:24:08.317246	t	2025-06-16 14:20:08.317246
11	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDA5ODMwNiwiZXhwIjoxNzUwMDk4NTQ2fQ.0mDJaY1_7u0vThWZ1IAEYcWiHI9VaI4HoK8lUkfMlgw	2025-06-16 14:29:06.951807	t	2025-06-16 14:25:06.951807
12	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE1OTI4MywiZXhwIjoxNzUwMTU5NTIzfQ.tWxxXXQeC6geOw6ROQbzuX6kekchjlv-MMEHkmXzBtE	2025-06-17 07:25:23.760791	t	2025-06-17 07:21:23.760791
13	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDI1NiwiZXhwIjoxNzUwMTYwNDk2fQ.CKRFTwNoLdwMTRrKGKiI6tf8HakztWBxa_o8XlAvXRA	2025-06-17 07:41:36.747654	t	2025-06-17 07:37:36.747654
43	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzI2MiwiZXhwIjoxNzUwNjkzMzIyfQ.sbS-MmJUD1QALiZjmpjGHplc4DbqB4TI1ehftuURoyE	2025-06-23 11:42:02.995648	t	2025-06-23 11:41:02.995648
46	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzYwNywiZXhwIjoxNzUwNjkzNjY3fQ.pVc88d4cWkqk0LXLZFsu_paLsVi_sT-TFdfirHF-B8c	2025-06-23 11:47:47.568076	t	2025-06-23 11:46:47.568076
49	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NDI2MiwiZXhwIjoxNzUwNjk0MzIyfQ.e8JCFTk98M7dZWOl9drN9P8jpa8xDVocEgXTZBM1uec	2025-06-23 11:58:42.455805	t	2025-06-23 11:57:42.455805
52	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzQwNCwiZXhwIjoxNzUwNzAzNDY0fQ.t4lYd14zEOvLnKmR-04Q7_-W8iKsohrCDEEH6QW9cKI	2025-06-23 14:31:04.344578	t	2025-06-23 14:30:04.344578
14	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDQ1MSwiZXhwIjoxNzUwMTYwNjkxfQ.WUjpKtrHM_nPse49Pp7hUKWzsvVXP-rlixsGb5xYmmY	2025-06-17 07:44:51.892131	t	2025-06-17 07:40:51.892131
15	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDYwNSwiZXhwIjoxNzUwMTYwODQ1fQ.H3pLLA6325lkpqGoFehLmvyua-tXIBPmfxNATWKH5sI	2025-06-17 07:47:25.885137	t	2025-06-17 07:43:25.885137
19	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTk0MSwiZXhwIjoxNzUwMTYyMTgxfQ.YsxFC_8FoJzVc1_Oi4q_UW1FKN6oBIOFlk3alH13o3E	2025-06-17 08:09:41.708344	t	2025-06-17 08:05:41.708344
20	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4NzU0OCwiZXhwIjoxNzUwNjg3Nzg4fQ.GP5PE7m0KiTcqjm0zdaBLhB6WzDwKKWZnxTSystXX1E	2025-06-23 10:09:48.188871	t	2025-06-23 10:05:48.188871
23	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY4OTIxMiwiZXhwIjoxNzUwNjg5NDUyfQ.KvCQmN-f0tfIK9AaUWGFor8f3A3BT7zRmhe4zbcuPxc	2025-06-23 10:37:32.858467	t	2025-06-23 10:33:32.858467
26	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDA5NCwiZXhwIjoxNzUwNjkwMzM0fQ.KjUWmxT5q-_q7qFOPlMwWSG4MbVwAscLVi0lLcWUtsM	2025-06-23 10:52:14.24066	t	2025-06-23 10:48:14.24066
29	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MDcwMiwiZXhwIjoxNzUwNjkwOTQyfQ.IT4bHKiJlKxx5jc8aa6jeSpZOlkFS234OmSneuFuz3E	2025-06-23 11:02:22.326653	t	2025-06-23 10:58:22.326653
97	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTIxMiwiZXhwIjoxNzUxMzE5MjcyfQ.0uLYS1jyXgCgPRb5dKj9icJc8vzCBZn-D1wo4elvf98	2025-06-30 17:34:32.874163	t	2025-06-30 17:33:32.874163
102	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTY1NSwiZXhwIjoxNzUxMzE5NzE1fQ.hkp8zPeb4txDulAFl9EEwCjEKu7peCRGpdOQN1O8yRU	2025-06-30 17:41:55.61781	t	2025-06-30 17:40:55.61781
107	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDA2MywiZXhwIjoxNzUxMzIwMTIzfQ.RuTlGIZpaqZXf0cVwnOmuBhcaz4qVr0DvzW19yBF3Kw	2025-06-30 17:48:43.868468	t	2025-06-30 17:47:43.868468
112	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDUwNiwiZXhwIjoxNzUxMzIwNTY2fQ.YZBa5w9e7N26T9e6Zb2zgOYjutOSuOKyKf7D7Rav0SI	2025-06-30 17:56:06.204369	t	2025-06-30 17:55:06.204369
117	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDk5MiwiZXhwIjoxNzUxMzIxMDUyfQ.1Sm81hMklZNmPDfyiNd1RiRhrhfYRaf23OAnRp9-eXQ	2025-06-30 18:04:12.266958	t	2025-06-30 18:03:12.266958
122	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTM3NiwiZXhwIjoxNzUxMzIxNDM2fQ.Svf4CGfMKTNu1hQnyBjPM151Mr2JsSqLQfvgSSlzCCY	2025-06-30 18:10:36.648482	t	2025-06-30 18:09:36.648482
127	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3OTc0MiwiZXhwIjoxNzUxMzc5ODAyfQ.nddTnOTjsA1wSSD-z0KWJAmbsa7i0mlIZhzlURKe8kE	2025-07-01 10:23:22.274338	t	2025-07-01 10:22:22.274338
42	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzE1OSwiZXhwIjoxNzUwNjkzMjE5fQ.pghlLPVVuqcE_KQloEwmRyXB6gEh9kqRE4WeMtYG58Q	2025-06-23 11:40:19.067946	t	2025-06-23 11:39:19.067946
45	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MzU2NywiZXhwIjoxNzUwNjkzNjI3fQ.S9xRGO4l_azNs-IWk0r0Jd_-p_yBJK88kQ_RMEgHYbQ	2025-06-23 11:47:07.476883	t	2025-06-23 11:46:07.476883
48	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5Mzk5NCwiZXhwIjoxNzUwNjk0MDU0fQ.PJwSoJQ0LKkt_tuFrldtmvHh9T_NJlJWwOObThQX7BQ	2025-06-23 11:54:14.499337	t	2025-06-23 11:53:14.499337
51	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NjMyMiwiZXhwIjoxNzUwNjk2MzgyfQ.gkHJsuYzJV6Jy6EMCxIqNc2jDXuDMAdUJq25ykBnlDA	2025-06-23 12:33:02.124093	t	2025-06-23 12:32:02.124093
16	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MDkxNiwiZXhwIjoxNzUwMTYxMTU2fQ.3dQXNSdm-SkUiE2wr6hXDoc0GbeZq95x0VlhhCRn7tc	2025-06-17 07:52:36.652253	t	2025-06-17 07:48:36.652253
17	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTIxNiwiZXhwIjoxNzUwMTYxNDU2fQ.WuTCiAtu8M4ZTyU-4GDj69n7H_QwqLGeRB9qnBhFauw	2025-06-17 07:57:36.167383	t	2025-06-17 07:53:36.167383
57	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNDA4MiwiZXhwIjoxNzUwNzA0NjgyfQ.xmpFzxB545fRBxh9pbsJ1ytvCcIiX1jzK8OUCWzLknc	2025-06-23 14:51:22.405944	t	2025-06-23 14:41:22.405944
18	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDE2MTUwMCwiZXhwIjoxNzUwMTYxNzQwfQ.wBDoQsQU28yOjLhuhkagKFbr3-CxG7FcJrQXDtE3i3U	2025-06-17 08:02:20.928639	t	2025-06-17 07:58:20.928639
38	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5MjI2MCwiZXhwIjoxNzUwNjkyMzgwfQ.7EhOk46fpEDCQrlEGVe6cdIiHyNaYSZUxffCo8PVEZo	2025-06-23 11:26:20.360912	t	2025-06-23 11:24:20.360912
63	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNTY2NCwiZXhwIjoxNzUwNzA1NzI0fQ.MPsPus4jkwLBiYN9stfAe_wfDCuGGSZjMEtqczJEdmk	2025-06-23 15:08:44.285386	t	2025-06-23 15:07:44.285386
68	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNjcwNywiZXhwIjoxNzUwNzA2NzY3fQ.lf39MfrcHs9KWH90HdzYw7NzamyULovwnBxsCcjjMkY	2025-06-23 15:26:07.924446	t	2025-06-23 15:25:07.924446
73	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwNzQ2OSwiZXhwIjoxNzUwNzA3NTI5fQ.UeS8jRXjnND0iI_gCzlJkMgEX6f0M8BP-xfNm3RidfU	2025-06-23 15:38:49.145257	t	2025-06-23 15:37:49.145257
78	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNjE5NywiZXhwIjoxNzUxMzE2MjU3fQ.2ZUqMgNHDQWlJq367w1FHZLr81zJhzzhOXzpVnfwPsc	2025-06-30 16:44:17.528526	t	2025-06-30 16:43:17.528526
83	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxNzg3OSwiZXhwIjoxNzUxMzE3OTM5fQ.XcfJvqJkyNJvq80OwF3SylStO0IWKuGYFuGOPm5sJqw	2025-06-30 17:12:19.535391	t	2025-06-30 17:11:19.535391
88	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODMyMCwiZXhwIjoxNzUxMzE4MzgwfQ.s4dSSfyCMwKE6Kn0xpLlVRoRDsqevJimNl39WEDrraQ	2025-06-30 17:19:40.710476	t	2025-06-30 17:18:40.710476
93	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxODc0MCwiZXhwIjoxNzUxMzE4ODAwfQ.97nWCqR5x36DovD4UolvqGMfNs-uidUx4nFn7cLz4dk	2025-06-30 17:26:40.060324	t	2025-06-30 17:25:40.060324
98	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTI2MCwiZXhwIjoxNzUxMzE5MzIwfQ.Xz9ZOL1u7ctgW3wKkqc-6g4LnlluTcD3r10kAv0OBdk	2025-06-30 17:35:20.640627	t	2025-06-30 17:34:20.640627
103	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTcwNSwiZXhwIjoxNzUxMzE5NzY1fQ.TJWngcjTGAUAeV7_qICu6zpIuxmLCPx_N-e0MaBW1X8	2025-06-30 17:42:45.68003	t	2025-06-30 17:41:45.68003
108	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDEwNiwiZXhwIjoxNzUxMzIwMTY2fQ.irqSS5f-RDn1SapPdATHAXGM0D_GJJhhfrfB8bacr3g	2025-06-30 17:49:26.464781	t	2025-06-30 17:48:26.464781
113	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDU3MywiZXhwIjoxNzUxMzIwNjMzfQ.9Lowr40VIhnysXqEnP_XmW-mMvyOXYZsil-ipyu1aio	2025-06-30 17:57:13.996632	t	2025-06-30 17:56:13.996632
118	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTA3MSwiZXhwIjoxNzUxMzIxMTMxfQ.9ImUixMTAlpM3j7hRPq8E6bd8Ly8b5cob5hHf87VzwQ	2025-06-30 18:05:31.335303	t	2025-06-30 18:04:31.335303
123	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTYzNywiZXhwIjoxNzUxMzIxNjk3fQ.Pfoh3GWmvk1fdkHldAKfgatcshKdOk_cfM-CvEa72to	2025-06-30 18:14:57.722763	t	2025-06-30 18:13:57.722763
128	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDA5NCwiZXhwIjoxNzUxMzgwMTU0fQ.m7Oue-RQS2t0r-ukDJrH3RqH9DtPQ_XLX3H9OpMfgmM	2025-07-01 10:29:14.113039	t	2025-07-01 10:28:14.113039
50	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDY5NDU5NiwiZXhwIjoxNzUwNjk0NjU2fQ.P8OcVwDRaP6nEidHiCRvHNZgPZuhwyIAfcqKHO61-gY	2025-06-23 12:04:16.561029	t	2025-06-23 12:03:16.561029
53	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzU2MywiZXhwIjoxNzUwNzAzNjIzfQ.DWy0lrdMT8XDWe36acJ77Fj5l8KZwrGxuF7dZdvYne4	2025-06-23 14:33:43.351827	t	2025-06-23 14:32:43.351827
55	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MDcwMzk0NywiZXhwIjoxNzUwNzA0NTQ3fQ.JLsmJActs5kRPx6fiOGYQSIfM9jPv2evgU1BDB237BQ	2025-06-23 14:49:07.442817	t	2025-06-23 14:39:07.442817
104	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMxOTg2MiwiZXhwIjoxNzUxMzE5OTIyfQ.nq5DDeAJf0E9ZjLv5qfX1aaAyWJGoTfYMWMuY4q6VMU	2025-06-30 17:45:22.250312	t	2025-06-30 17:44:22.250312
109	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDE2NSwiZXhwIjoxNzUxMzIwMjI1fQ.j3En3wc-e5K9TaB0m4DpyEIt4E03Weo7Q-yxxvz_J6Y	2025-06-30 17:50:25.938486	t	2025-06-30 17:49:25.938486
114	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMDYxNiwiZXhwIjoxNzUxMzIwNjc2fQ.futTxHhwiPWgF0-S9x2e_ylpPZy4WtJcNJer5U_bJGM	2025-06-30 17:57:56.131755	t	2025-06-30 17:56:56.131755
119	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTMyMTE1MSwiZXhwIjoxNzUxMzIxMjExfQ.QjcOVEHU2M1CPyAVUr8pfzQnMHX5tfUDKydlq74mIh4	2025-06-30 18:06:51.596033	t	2025-06-30 18:05:51.596033
124	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM3NzY3NSwiZXhwIjoxNzUxMzc3NzM1fQ._TjrYAAWIgNAuUlut0vBxgEEK2m3LkJ9DJiUCBuW8hU	2025-07-01 09:48:55.395293	t	2025-07-01 09:47:55.395293
129	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc1MTM4MDE4MSwiZXhwIjoxNzUxMzg3MzgxfQ.topSCBuTtLs6kA5HlemY5oMl4IM6j01MyWgl1mFZZJY	2025-07-01 12:29:41.606745	t	2025-07-01 10:29:41.606745
134	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYyNjIxNiwiZXhwIjoxNzY0NjMzNDE2fQ.2pVgVaEBlmEOEwCcnwVIDoWo5K3lEjggxOB4yYsbc5Q	2025-12-01 19:56:56.252097	t	2025-12-01 17:56:56.252097
135	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYyNzA0MCwiZXhwIjoxNzY0NjM0MjQwfQ.o_8YUoHADHF6xIN7gT2nlh3iQnhc4aNHyP7csOqD0zk	2025-12-01 20:10:40.354576	t	2025-12-01 18:10:40.354576
136	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYyODMyNywiZXhwIjoxNzY0NjM1NTI3fQ.M04Nu_zNFJY3gZ7GSWqvY_WEKjqM6hyICfhlSbiu2Fg	2025-12-01 20:32:07.85168	t	2025-12-01 18:32:07.85168
138	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMDI5MSwiZXhwIjoxNzY0NjM3NDkxfQ._D4qchvprWJbi0BIsTdSCVM4zovY-IubfHtAQ6BChuI	2025-12-01 21:04:51.675479	t	2025-12-01 19:04:51.675479
139	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMDc2MCwiZXhwIjoxNzY0NjM3OTYwfQ.HRV9c5Uvp2jFwgcpWYJGBWJvzf0AwCaPuqkuJc0K2iI	2025-12-01 21:12:40.020433	t	2025-12-01 19:12:40.020433
140	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMDc4NCwiZXhwIjoxNzY0NjM3OTg0fQ.FJzjmTJuzK21iyaQ29os1uYtR9jlFuPsgykemRO64zY	2025-12-01 21:13:04.502214	t	2025-12-01 19:13:04.502214
141	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMDgyMywiZXhwIjoxNzY0NjM4MDIzfQ.JOSDhHMy30TWxAybeHG_JwU8X7sTNXeEd0JsDKZUyhQ	2025-12-01 21:13:43.554089	t	2025-12-01 19:13:43.554089
142	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMDg0NCwiZXhwIjoxNzY0NjM4MDQ0fQ.Y5tYbqmGemftHDpGo_GAkFWDNeZmdIF2aTPwNjOFPuE	2025-12-01 21:14:04.86137	t	2025-12-01 19:14:04.86137
143	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMTc5MiwiZXhwIjoxNzY0NjM4OTkyfQ.JIYWkS17loh_A-bBhtoMsT3szIUE1FvGtzAo_t3HzgA	2025-12-01 21:29:52.134134	t	2025-12-01 19:29:52.134134
144	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMTk0MCwiZXhwIjoxNzY0NjM5MTQwfQ.pnfAef0g0_0N9085UETpzFPUkzhEd4l_SvF4-qL9SpY	2025-12-01 21:32:20.834876	t	2025-12-01 19:32:20.834876
145	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMTk1OSwiZXhwIjoxNzY0NjM5MTU5fQ.9MxsI42ZJPVemxg5cpPSlrZoqO4jhltj3AaAoaMYSP0	2025-12-01 21:32:39.986671	t	2025-12-01 19:32:39.986671
146	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMTk4MSwiZXhwIjoxNzY0NjM5MTgxfQ.mgZs7O4bygiAGVgPM8IEMQY6GqfgefhruExlcGH9C14	2025-12-01 21:33:01.719001	t	2025-12-01 19:33:01.719001
147	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMjA2NCwiZXhwIjoxNzY0NjM5MjY0fQ.E3DCpF1Qreb3qSh1nWEGc5gU7DZhwD6lOUPyoKXls2w	2025-12-01 21:34:24.124514	t	2025-12-01 19:34:24.124514
148	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMjA3NCwiZXhwIjoxNzY0NjM5Mjc0fQ.lAMh167cMnTrJHSA81bHzyxLic9Y9hnVPvsE9JXW9wQ	2025-12-01 21:34:34.768636	t	2025-12-01 19:34:34.768636
149	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc2NDYzMjA5MCwiZXhwIjoxNzY0NjM5MjkwfQ.oW_tj8cQ6kqgUUlEvBmgLRdY_p5KHTonUNUoqs2dfJU	2025-12-01 21:34:50.85264	t	2025-12-01 19:34:50.85264
150	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDYzMjIwNCwiZXhwIjoxNzY0NjM5NDA0fQ.JDIrc6451JcvNLQ32bcZsTGok0ve7opbDOUFnoXCyHU	2025-12-01 21:36:44.803824	t	2025-12-01 19:36:44.803824
151	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NDg2Mzc0OSwiZXhwIjoxNzY0ODcwOTQ5fQ.qr1Kr1TpKyJcpsOWHZwXZp3bzQCR0WPqETM7vJr2xpw	2025-12-04 13:55:49.345743	t	2025-12-04 11:55:49.345743
152	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NTE5NzMwMSwiZXhwIjoxNzY1MjA0NTAxfQ.Wv_iWjqjz-VzXsuLt6lvSuHMITbcHhSSCZju_7puy8g	2025-12-08 10:35:01.340305	t	2025-12-08 08:35:01.340305
153	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NTE5NzcxNSwiZXhwIjoxNzY1MjA0OTE1fQ.mAeqztb0VZg-TbTXpcYdNzRP0E1OsRXS-lKYWH7hUQY	2025-12-08 10:41:55.669311	t	2025-12-08 08:41:55.669311
154	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc2NTIxODI5NSwiZXhwIjoxNzY1MjI1NDk1fQ.-vu-WxmausFjXv2cVdkM8wuq1SxhqWF4UY3J-FogB78	2025-12-08 16:24:55.110587	t	2025-12-08 14:24:55.110587
\.


--
-- Data for Name: suscriptores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suscriptores (id, correo, created_at) FROM stdin;
\.


--
-- Data for Name: user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_permissions (user_id, permission_id) FROM stdin;
1	1
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_id, role_id) FROM stdin;
1	1
3	2
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, cedula, email, password_hash, is_email_verified, status, is_temporary_password, failed_attempts, lock_until, created_at, updated_at, session_timeout_min, failed_login_attempts, last_failed_login, deleted_at) FROM stdin;
3	Carlos	Marrero	7920566	marrero.c@gmail.com	$2a$10$Jjng.P34n4cND0w6w8x2s.Uof7o9XDODs1bGYp9EMGdsgKRE.QGNe	f	active	t	0	\N	2025-12-01 19:11:45.720954	2025-12-01 19:39:41.271349	\N	0	\N	\N
1	Admin	Principal	12345678	admin@example.com	$2a$10$0rSQhU9EE7mXK1DfE4gm0.E3lFg1TGuBvxhVz5buiItNLNo6b/uN2	t	active	t	0	\N	2025-05-08 11:03:25.475768	2025-05-08 11:03:25.475768	120	0	\N	\N
\.


--
-- Name: areas_conocimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.areas_conocimiento_id_seq', 5, true);


--
-- Name: blacklisted_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blacklisted_tokens_id_seq', 135, true);


--
-- Name: editoriales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.editoriales_id_seq', 31, true);


--
-- Name: email_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_verifications_id_seq', 1, false);


--
-- Name: estados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estados_id_seq', 1, false);


--
-- Name: formatos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formatos_id_seq', 1, false);


--
-- Name: idiomas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.idiomas_id_seq', 1, false);


--
-- Name: indices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.indices_id_seq', 1, false);


--
-- Name: inicio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inicio_id_seq', 7, true);


--
-- Name: login_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_logs_id_seq', 457, true);


--
-- Name: menu_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menu_categories_id_seq', 2, true);


--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menu_items_id_seq', 6, true);


--
-- Name: password_resets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.password_resets_id_seq', 1, false);


--
-- Name: periodicidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.periodicidad_id_seq', 1, false);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 1, false);


--
-- Name: permissions_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq1', 35, true);


--
-- Name: revistas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.revistas_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- Name: roles_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq1', 2, true);


--
-- Name: session_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.session_settings_id_seq', 1, false);


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sessions_id_seq', 154, true);


--
-- Name: suscriptores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suscriptores_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: users_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq1', 3, true);


--
-- Name: areas_conocimiento areas_conocimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas_conocimiento
    ADD CONSTRAINT areas_conocimiento_pkey PRIMARY KEY (id);


--
-- Name: estados estados_copy1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT estados_copy1_pkey PRIMARY KEY (id);


--
-- Name: inicio inicio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inicio
    ADD CONSTRAINT inicio_pkey PRIMARY KEY (id);


--
-- Name: menu_categories menu_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_categories
    ADD CONSTRAINT menu_categories_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_key UNIQUE (name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: editoriales pkey_editoriales_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editoriales
    ADD CONSTRAINT pkey_editoriales_id PRIMARY KEY (id);


--
-- Name: formatos pkey_formatos_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formatos
    ADD CONSTRAINT pkey_formatos_id PRIMARY KEY (id);


--
-- Name: idiomas pkey_idiomas_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idiomas
    ADD CONSTRAINT pkey_idiomas_id PRIMARY KEY (id);


--
-- Name: indices pkey_indices_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indices
    ADD CONSTRAINT pkey_indices_id PRIMARY KEY (id);


--
-- Name: periodicidad pkey_perdiocidad_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodicidad
    ADD CONSTRAINT pkey_perdiocidad_id PRIMARY KEY (id);


--
-- Name: suscriptores pkey_suscriptores_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suscriptores
    ADD CONSTRAINT pkey_suscriptores_id PRIMARY KEY (id);


--
-- Name: revistas revistas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revistas
    ADD CONSTRAINT revistas_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: session_settings session_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_settings
    ADD CONSTRAINT session_settings_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: user_permissions user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_pkey PRIMARY KEY (user_id, permission_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_cedula_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_cedula_key UNIQUE (cedula);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_revistas_anio_inicial; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_anio_inicial ON public.revistas USING btree (anio_inicial);


--
-- Name: idx_revistas_area_conocimiento_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_area_conocimiento_id ON public.revistas USING btree (area_conocimiento_id);


--
-- Name: idx_revistas_deposito_legal_digital; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_deposito_legal_digital ON public.revistas USING btree (deposito_legal_digital);


--
-- Name: idx_revistas_deposito_legal_impreso; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_deposito_legal_impreso ON public.revistas USING btree (deposito_legal_impreso);


--
-- Name: idx_revistas_editorial_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_editorial_id ON public.revistas USING btree (editorial_id);


--
-- Name: idx_revistas_estado_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_estado_id ON public.revistas USING btree (estado_id);


--
-- Name: idx_revistas_formato_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_formato_id ON public.revistas USING btree (formato_id);


--
-- Name: idx_revistas_idioma_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_idioma_id ON public.revistas USING btree (idioma_id);


--
-- Name: idx_revistas_indice_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_indice_id ON public.revistas USING btree (indice_id);


--
-- Name: idx_revistas_issn_digital; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_issn_digital ON public.revistas USING btree (issn_digital);


--
-- Name: idx_revistas_issn_impreso; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_issn_impreso ON public.revistas USING btree (issn_impreso);


--
-- Name: idx_revistas_periodicidad_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_periodicidad_id ON public.revistas USING btree (periodicidad_id);


--
-- Name: idx_revistas_revista; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revistas_revista ON public.revistas USING btree (revista);


--
-- Name: inicio enforce_row_limit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER enforce_row_limit BEFORE INSERT ON public.inicio FOR EACH ROW EXECUTE FUNCTION public.check_row_limit();


--
-- Name: inicio inicio_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER inicio_trigger AFTER INSERT OR DELETE OR UPDATE ON public.inicio FOR EACH ROW EXECUTE FUNCTION public.notify_revistas_data_changes();


--
-- Name: revistas revistas_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER revistas_trigger AFTER INSERT OR DELETE OR UPDATE ON public.revistas FOR EACH ROW EXECUTE FUNCTION public.notify_revistas_data_changes();


--
-- Name: menu_items menu_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.menu_categories(id) ON DELETE CASCADE;


--
-- Name: menu_items menu_items_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: menu_items menu_items_permission_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_permission_name_fkey FOREIGN KEY (permission_name) REFERENCES public.permissions(name) ON DELETE SET NULL;


--
-- Name: revistas revistas_area_conocimiento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revistas
    ADD CONSTRAINT revistas_area_conocimiento_id_fkey FOREIGN KEY (area_conocimiento_id) REFERENCES public.areas_conocimiento(id);


--
-- Name: revistas revistas_editorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revistas
    ADD CONSTRAINT revistas_editorial_id_fkey FOREIGN KEY (editorial_id) REFERENCES public.editoriales(id);


--
-- Name: revistas revistas_estado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revistas
    ADD CONSTRAINT revistas_estado_id_fkey FOREIGN KEY (estado_id) REFERENCES public.estados(id);


--
-- Name: revistas revistas_formato_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revistas
    ADD CONSTRAINT revistas_formato_id_fkey FOREIGN KEY (formato_id) REFERENCES public.formatos(id);


--
-- Name: revistas revistas_idioma_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revistas
    ADD CONSTRAINT revistas_idioma_id_fkey FOREIGN KEY (idioma_id) REFERENCES public.idiomas(id);


--
-- Name: revistas revistas_indice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revistas
    ADD CONSTRAINT revistas_indice_id_fkey FOREIGN KEY (indice_id) REFERENCES public.indices(id);


--
-- Name: revistas revistas_periodicidad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revistas
    ADD CONSTRAINT revistas_periodicidad_id_fkey FOREIGN KEY (periodicidad_id) REFERENCES public.periodicidad(id);


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_permissions user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: user_permissions user_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

