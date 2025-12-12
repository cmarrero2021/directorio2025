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
    revista text NOT NULL,
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
    portada text DEFAULT ''::character varying,
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

