--
-- PostgreSQL database dump
--

\restrict qDWuuSKHQJYT6Wm7rEgKeuseMgyhhbyyHrTBhV02MrILrrqUZtNGLtQwTpZ0LLS

-- Dumped from database version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appareils; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appareils (
    id character varying(20) NOT NULL,
    batterie integer,
    sensibilite integer,
    frequence integer,
    role_f character varying(50),
    role_b character varying(50),
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.appareils OWNER TO postgres;

--
-- Name: log_passages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_passages (
    id integer NOT NULL,
    capteur_id character varying(50),
    capteur character varying(50),
    type_passage character varying(10) NOT NULL,
    mode_passage character varying(10) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT log_passages_mode_passage_check CHECK (((mode_passage)::text = ANY ((ARRAY['ENTREE'::character varying, 'SORTIE'::character varying])::text[]))),
    CONSTRAINT log_passages_type_passage_check CHECK (((type_passage)::text = ANY ((ARRAY['DEBUT'::character varying, 'FIN'::character varying])::text[])))
);


ALTER TABLE public.log_passages OWNER TO postgres;

--
-- Name: log_passages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_passages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_passages_id_seq OWNER TO postgres;

--
-- Name: log_passages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_passages_id_seq OWNED BY public.log_passages.id;


--
-- Name: login; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    mdp character varying(255) NOT NULL
);


ALTER TABLE public.login OWNER TO postgres;

--
-- Name: login_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.login_id_seq OWNER TO postgres;

--
-- Name: login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_id_seq OWNED BY public.login.id;


--
-- Name: logs_oscillo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs_oscillo (
    id integer NOT NULL,
    appareil_id character varying(20) NOT NULL,
    payload jsonb NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.logs_oscillo OWNER TO postgres;

--
-- Name: logs_oscillo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_oscillo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logs_oscillo_id_seq OWNER TO postgres;

--
-- Name: logs_oscillo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_oscillo_id_seq OWNED BY public.logs_oscillo.id;


--
-- Name: passages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passages (
    id integer NOT NULL,
    type character varying(10) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    appareil_id character varying(20) NOT NULL,
    CONSTRAINT passages_type_check CHECK (((type)::text = ANY ((ARRAY['ENTREE'::character varying, 'SORTIE'::character varying])::text[])))
);


ALTER TABLE public.passages OWNER TO postgres;

--
-- Name: passages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.passages_id_seq OWNER TO postgres;

--
-- Name: passages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passages_id_seq OWNED BY public.passages.id;


--
-- Name: log_passages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_passages ALTER COLUMN id SET DEFAULT nextval('public.log_passages_id_seq'::regclass);


--
-- Name: login id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login ALTER COLUMN id SET DEFAULT nextval('public.login_id_seq'::regclass);


--
-- Name: logs_oscillo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs_oscillo ALTER COLUMN id SET DEFAULT nextval('public.logs_oscillo_id_seq'::regclass);


--
-- Name: passages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passages ALTER COLUMN id SET DEFAULT nextval('public.passages_id_seq'::regclass);


--
-- Data for Name: appareils; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appareils (id, batterie, sensibilite, frequence, role_f, role_b, "timestamp") FROM stdin;
\.


--
-- Data for Name: log_passages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_passages (id, capteur_id, capteur, type_passage, mode_passage, "timestamp") FROM stdin;
\.


--
-- Data for Name: login; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login (id, username, mdp) FROM stdin;
1	gauthier	talleux
\.


--
-- Data for Name: logs_oscillo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs_oscillo (id, appareil_id, payload, "timestamp") FROM stdin;
\.


--
-- Data for Name: passages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passages (id, type, "timestamp", appareil_id) FROM stdin;
\.


--
-- Name: log_passages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_passages_id_seq', 1, false);


--
-- Name: login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_id_seq', 1, true);


--
-- Name: logs_oscillo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_oscillo_id_seq', 1, false);


--
-- Name: passages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passages_id_seq', 1, false);


--
-- Name: appareils appareils_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appareils
    ADD CONSTRAINT appareils_pkey PRIMARY KEY (id);


--
-- Name: log_passages log_passages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_passages
    ADD CONSTRAINT log_passages_pkey PRIMARY KEY (id);


--
-- Name: login login_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login
    ADD CONSTRAINT login_pkey PRIMARY KEY (id);


--
-- Name: login login_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login
    ADD CONSTRAINT login_username_key UNIQUE (username);


--
-- Name: logs_oscillo logs_oscillo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs_oscillo
    ADD CONSTRAINT logs_oscillo_pkey PRIMARY KEY (id);


--
-- Name: passages passages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passages
    ADD CONSTRAINT passages_pkey PRIMARY KEY (id);


--
-- Name: logs_oscillo fk_logs_oscillo_appareil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs_oscillo
    ADD CONSTRAINT fk_logs_oscillo_appareil FOREIGN KEY (appareil_id) REFERENCES public.appareils(id) ON DELETE CASCADE;


--
-- Name: passages fk_passages_appareil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passages
    ADD CONSTRAINT fk_passages_appareil FOREIGN KEY (appareil_id) REFERENCES public.appareils(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO jeremy;
GRANT ALL ON SCHEMA public TO leo;
GRANT ALL ON SCHEMA public TO gauthier;


--
-- Name: TABLE appareils; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.appareils TO gauthier;
GRANT ALL ON TABLE public.appareils TO jeremy;
GRANT ALL ON TABLE public.appareils TO leo;


--
-- Name: TABLE log_passages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.log_passages TO gauthier;
GRANT ALL ON TABLE public.log_passages TO jeremy;
GRANT ALL ON TABLE public.log_passages TO leo;


--
-- Name: SEQUENCE log_passages_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.log_passages_id_seq TO gauthier;
GRANT ALL ON SEQUENCE public.log_passages_id_seq TO jeremy;
GRANT ALL ON SEQUENCE public.log_passages_id_seq TO leo;


--
-- Name: TABLE login; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.login TO gauthier;
GRANT ALL ON TABLE public.login TO jeremy;
GRANT ALL ON TABLE public.login TO leo;


--
-- Name: SEQUENCE login_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.login_id_seq TO gauthier;
GRANT ALL ON SEQUENCE public.login_id_seq TO jeremy;
GRANT ALL ON SEQUENCE public.login_id_seq TO leo;


--
-- Name: TABLE logs_oscillo; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.logs_oscillo TO gauthier;
GRANT ALL ON TABLE public.logs_oscillo TO jeremy;
GRANT ALL ON TABLE public.logs_oscillo TO leo;


--
-- Name: SEQUENCE logs_oscillo_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.logs_oscillo_id_seq TO gauthier;
GRANT ALL ON SEQUENCE public.logs_oscillo_id_seq TO jeremy;
GRANT ALL ON SEQUENCE public.logs_oscillo_id_seq TO leo;


--
-- Name: TABLE passages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.passages TO gauthier;
GRANT ALL ON TABLE public.passages TO jeremy;
GRANT ALL ON TABLE public.passages TO leo;


--
-- Name: SEQUENCE passages_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.passages_id_seq TO gauthier;
GRANT ALL ON SEQUENCE public.passages_id_seq TO jeremy;
GRANT ALL ON SEQUENCE public.passages_id_seq TO leo;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO gauthier;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO jeremy;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO leo;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO gauthier;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO jeremy;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO leo;


--
-- PostgreSQL database dump complete
--

\unrestrict qDWuuSKHQJYT6Wm7rEgKeuseMgyhhbyyHrTBhV02MrILrrqUZtNGLtQwTpZ0LLS

