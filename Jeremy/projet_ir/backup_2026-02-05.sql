--
-- PostgreSQL database dump
--

\restrict VG7gbK4Nj7nn3vCi9Q9j6hBGGZAgKAtNoL9eifyLC4QRKnWZmPLyol1OQLTtRfe

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
-- Name: appareils; Type: TABLE; Schema: public; Owner: leo
--

CREATE TABLE public.appareils (
    id character varying(50) NOT NULL,
    batterie integer,
    frequence integer,
    derniere_vu timestamp without time zone,
    mode character varying(10) DEFAULT 'ENTREE'::character varying,
    sensibilite integer DEFAULT 50,
    role_f character varying(10) DEFAULT 'ENTREE'::character varying,
    role_b character varying(10) DEFAULT 'SORTIE'::character varying
);


ALTER TABLE public.appareils OWNER TO leo;

--
-- Name: log_passages; Type: TABLE; Schema: public; Owner: leo
--

CREATE TABLE public.log_passages (
    id integer NOT NULL,
    capteur_id character varying(50) NOT NULL,
    capteur character varying(50) NOT NULL,
    type_passage character varying(10) NOT NULL,
    mode_passage character varying(10),
    ts bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.log_passages OWNER TO leo;

--
-- Name: log_passages_id_seq; Type: SEQUENCE; Schema: public; Owner: leo
--

CREATE SEQUENCE public.log_passages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_passages_id_seq OWNER TO leo;

--
-- Name: log_passages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: leo
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
-- Name: ordres_mqtt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ordres_mqtt (
    id integer NOT NULL,
    topic character varying(255),
    message text
);


ALTER TABLE public.ordres_mqtt OWNER TO postgres;

--
-- Name: ordres_mqtt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ordres_mqtt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ordres_mqtt_id_seq OWNER TO postgres;

--
-- Name: ordres_mqtt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ordres_mqtt_id_seq OWNED BY public.ordres_mqtt.id;


--
-- Name: passages; Type: TABLE; Schema: public; Owner: leo
--

CREATE TABLE public.passages (
    id integer NOT NULL,
    appareil_id character varying(50),
    type character varying(20),
    date_heure timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    type_passage character varying(10)
);


ALTER TABLE public.passages OWNER TO leo;

--
-- Name: passages_id_seq; Type: SEQUENCE; Schema: public; Owner: leo
--

CREATE SEQUENCE public.passages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.passages_id_seq OWNER TO leo;

--
-- Name: passages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: leo
--

ALTER SEQUENCE public.passages_id_seq OWNED BY public.passages.id;


--
-- Name: log_passages id; Type: DEFAULT; Schema: public; Owner: leo
--

ALTER TABLE ONLY public.log_passages ALTER COLUMN id SET DEFAULT nextval('public.log_passages_id_seq'::regclass);


--
-- Name: login id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login ALTER COLUMN id SET DEFAULT nextval('public.login_id_seq'::regclass);


--
-- Name: ordres_mqtt id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordres_mqtt ALTER COLUMN id SET DEFAULT nextval('public.ordres_mqtt_id_seq'::regclass);


--
-- Name: passages id; Type: DEFAULT; Schema: public; Owner: leo
--

ALTER TABLE ONLY public.passages ALTER COLUMN id SET DEFAULT nextval('public.passages_id_seq'::regclass);


--
-- Data for Name: appareils; Type: TABLE DATA; Schema: public; Owner: leo
--

COPY public.appareils (id, batterie, frequence, derniere_vu, mode, sensibilite, role_f, role_b) FROM stdin;
porte	0	38	2026-02-05 09:44:19.013049	ENTREE	400	ENTREE	SORTIE
178.32.107.35	0	38	2026-02-05 09:44:20.76783	ENTREE	400	ENTREE	SORTIE
test	0	38	2026-02-05 09:27:15.622512	ENTREE	400	ENTREE	SORTIE
\.


--
-- Data for Name: log_passages; Type: TABLE DATA; Schema: public; Owner: leo
--

COPY public.log_passages (id, capteur_id, capteur, type_passage, mode_passage, ts, created_at) FROM stdin;
1	recpeteurr	FRONT	DEBUT	ENTREE	1768298056427	2026-01-13 10:08:23.045972
\.


--
-- Data for Name: login; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login (id, username, mdp) FROM stdin;
1	gauthier	talleux
\.


--
-- Data for Name: ordres_mqtt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ordres_mqtt (id, topic, message) FROM stdin;
\.


--
-- Data for Name: passages; Type: TABLE DATA; Schema: public; Owner: leo
--

COPY public.passages (id, appareil_id, type, date_heure, type_passage) FROM stdin;
14750	porte	ENTREE	2026-02-05 07:59:10.990088	\N
14751	porte	ENTREE	2026-02-05 07:59:33.66691	\N
14752	porte	ENTREE	2026-02-05 08:00:21.276637	\N
14753	porte	ENTREE	2026-02-05 08:00:25.705655	\N
14754	porte	ENTREE	2026-02-05 08:13:58.095322	\N
14755	porte	ENTREE	2026-02-05 08:14:06.83576	\N
14756	porte	ENTREE	2026-02-05 08:14:11.873103	\N
14757	porte	ENTREE	2026-02-05 08:14:12.98011	\N
14758	porte	ENTREE	2026-02-05 08:14:13.799614	\N
14759	porte	ENTREE	2026-02-05 08:14:16.01419	\N
14760	porte	ENTREE	2026-02-05 08:14:20.032353	\N
14761	porte	ENTREE	2026-02-05 08:14:24.178661	\N
14762	porte	ENTREE	2026-02-05 08:21:44.359306	\N
14763	porte	ENTREE	2026-02-05 08:21:58.05371	\N
14764	porte	ENTREE	2026-02-05 08:25:37.807784	\N
14765	porte	ENTREE	2026-02-05 08:28:41.840675	\N
14766	porte	ENTREE	2026-02-05 08:28:49.919147	\N
14767	porte	ENTREE	2026-02-05 08:31:59.569487	\N
14768	porte	ENTREE	2026-02-05 08:35:02.903577	\N
14769	porte	ENTREE	2026-02-05 08:35:28.779102	\N
14770	porte	ENTREE	2026-02-05 08:35:35.747472	\N
14771	porte	ENTREE	2026-02-05 08:35:36.690552	\N
14772	porte	ENTREE	2026-02-05 08:36:29.62775	\N
14773	porte	ENTREE	2026-02-05 08:36:31.67881	\N
14774	porte	ENTREE	2026-02-05 08:37:39.8863	\N
14775	porte	ENTREE	2026-02-05 08:38:41.66694	\N
14776	porte	ENTREE	2026-02-05 08:38:51.590776	\N
14777	porte	ENTREE	2026-02-05 08:44:59.078887	\N
14778	porte	ENTREE	2026-02-05 08:46:03.115903	\N
14779	porte	ENTREE	2026-02-05 08:46:05.717493	\N
14780	porte	ENTREE	2026-02-05 08:47:12.2615	\N
14781	porte	ENTREE	2026-02-05 08:48:25.949453	\N
14782	porte	ENTREE	2026-02-05 08:48:36.775112	\N
14783	porte	ENTREE	2026-02-05 08:48:39.284838	\N
14784	porte	ENTREE	2026-02-05 08:50:27.927237	\N
14785	porte	ENTREE	2026-02-05 08:56:23.475368	\N
14786	porte	ENTREE	2026-02-05 08:57:21.168123	\N
14787	porte	ENTREE	2026-02-05 09:00:29.640593	\N
14788	porte	ENTREE	2026-02-05 09:02:37.19061	\N
14789	porte	ENTREE	2026-02-05 09:03:32.013714	\N
14790	porte	ENTREE	2026-02-05 09:05:03.043696	\N
14791	porte	ENTREE	2026-02-05 09:06:41.008189	\N
14792	porte	ENTREE	2026-02-05 09:06:44.734378	\N
14793	porte	ENTREE	2026-02-05 09:07:06.509812	\N
14794	porte	ENTREE	2026-02-05 09:07:36.196813	\N
14795	porte	ENTREE	2026-02-05 09:09:07.757865	\N
14796	porte	ENTREE	2026-02-05 09:09:33.54833	\N
14797	porte	ENTREE	2026-02-05 09:09:40.230527	\N
14798	porte	ENTREE	2026-02-05 09:10:02.292116	\N
14799	porte	ENTREE	2026-02-05 09:10:17.730193	\N
14800	porte	ENTREE	2026-02-05 09:11:48.251185	\N
14801	porte	ENTREE	2026-02-05 09:12:40.264597	\N
14802	porte	ENTREE	2026-02-05 09:12:53.318024	\N
14803	porte	ENTREE	2026-02-05 09:13:11.80343	\N
14804	porte	ENTREE	2026-02-05 09:13:55.47987	\N
14805	porte	ENTREE	2026-02-05 09:14:30.687505	\N
14806	porte	ENTREE	2026-02-05 09:15:22.41341	\N
14807	porte	ENTREE	2026-02-05 09:15:40.341418	\N
14808	porte	ENTREE	2026-02-05 09:15:56.406518	\N
14809	porte	ENTREE	2026-02-05 09:16:19.54192	\N
14810	porte	ENTREE	2026-02-05 09:16:26.186505	\N
14811	porte	ENTREE	2026-02-05 09:16:29.128071	\N
14812	porte	ENTREE	2026-02-05 09:16:33.966526	\N
14813	porte	ENTREE	2026-02-05 09:16:42.824734	\N
14814	porte	ENTREE	2026-02-05 09:16:54.10183	\N
14815	porte	ENTREE	2026-02-05 09:16:56.274845	\N
14816	porte	ENTREE	2026-02-05 09:16:59.185743	\N
14817	porte	ENTREE	2026-02-05 09:17:21.658217	\N
14818	porte	ENTREE	2026-02-05 09:17:26.047839	\N
14819	porte	ENTREE	2026-02-05 09:17:52.399008	\N
14820	porte	ENTREE	2026-02-05 09:18:28.253623	\N
14821	porte	ENTREE	2026-02-05 09:18:29.852801	\N
14822	porte	ENTREE	2026-02-05 09:18:32.312821	\N
14823	porte	ENTREE	2026-02-05 09:18:42.892446	\N
14824	porte	ENTREE	2026-02-05 09:19:01.550728	\N
14825	porte	ENTREE	2026-02-05 09:19:11.53435	\N
14826	porte	ENTREE	2026-02-05 09:19:44.812549	\N
14827	porte	ENTREE	2026-02-05 09:19:49.239687	\N
14828	porte	ENTREE	2026-02-05 09:20:10.235332	\N
14829	porte	ENTREE	2026-02-05 09:20:48.411102	\N
14830	porte	ENTREE	2026-02-05 09:21:04.733621	\N
14831	porte	ENTREE	2026-02-05 09:21:15.516255	\N
14832	porte	ENTREE	2026-02-05 09:21:19.658734	\N
14833	porte	ENTREE	2026-02-05 09:21:39.136065	\N
14834	porte	ENTREE	2026-02-05 09:21:42.170342	\N
14835	porte	ENTREE	2026-02-05 09:22:33.100858	\N
14836	porte	ENTREE	2026-02-05 09:22:36.992802	\N
14837	porte	ENTREE	2026-02-05 09:23:08.444617	\N
14838	porte	ENTREE	2026-02-05 09:23:12.790868	\N
14839	porte	ENTREE	2026-02-05 09:23:13.406889	\N
14840	porte	ENTREE	2026-02-05 09:23:26.857581	\N
14841	porte	ENTREE	2026-02-05 09:23:28.332935	\N
14842	porte	ENTREE	2026-02-05 09:24:25.701244	\N
14843	porte	ENTREE	2026-02-05 09:24:26.767703	\N
14844	porte	ENTREE	2026-02-05 09:25:53.391691	\N
14845	porte	ENTREE	2026-02-05 09:26:07.396095	\N
14846	porte	ENTREE	2026-02-05 09:26:12.973405	\N
14847	porte	ENTREE	2026-02-05 09:27:57.536002	\N
\.


--
-- Name: log_passages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: leo
--

SELECT pg_catalog.setval('public.log_passages_id_seq', 1, true);


--
-- Name: login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_id_seq', 2, true);


--
-- Name: ordres_mqtt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ordres_mqtt_id_seq', 74, true);


--
-- Name: passages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: leo
--

SELECT pg_catalog.setval('public.passages_id_seq', 14847, true);


--
-- Name: appareils appareils_pkey; Type: CONSTRAINT; Schema: public; Owner: leo
--

ALTER TABLE ONLY public.appareils
    ADD CONSTRAINT appareils_pkey PRIMARY KEY (id);


--
-- Name: log_passages log_passages_pkey; Type: CONSTRAINT; Schema: public; Owner: leo
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
-- Name: ordres_mqtt ordres_mqtt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordres_mqtt
    ADD CONSTRAINT ordres_mqtt_pkey PRIMARY KEY (id);


--
-- Name: passages passages_pkey; Type: CONSTRAINT; Schema: public; Owner: leo
--

ALTER TABLE ONLY public.passages
    ADD CONSTRAINT passages_pkey PRIMARY KEY (id);


--
-- Name: passages passages_appareil_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: leo
--

ALTER TABLE ONLY public.passages
    ADD CONSTRAINT passages_appareil_id_fkey FOREIGN KEY (appareil_id) REFERENCES public.appareils(id);


--
-- Name: TABLE login; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.login TO leo;


--
-- Name: TABLE ordres_mqtt; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ordres_mqtt TO leo;


--
-- Name: SEQUENCE ordres_mqtt_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ordres_mqtt_id_seq TO leo;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO leo;


--
-- PostgreSQL database dump complete
--

\unrestrict VG7gbK4Nj7nn3vCi9Q9j6hBGGZAgKAtNoL9eifyLC4QRKnWZmPLyol1OQLTtRfe

