--
-- PostgreSQL database dump
--

\restrict fm52Xudcb9xe99orCvDa0tHwAyexmOvNn7hvzVTE5eLSeFn3WSQ7DF8AwVXqlq9

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
-- Name: alertes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alertes (
    id integer NOT NULL,
    appareil_id character varying(50) NOT NULL,
    status character varying(20) NOT NULL,
    "position" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    duree_totale double precision NOT NULL,
    timestamp_esp timestamp without time zone NOT NULL,
    date_reception timestamp without time zone DEFAULT now()
);


ALTER TABLE public.alertes OWNER TO postgres;

--
-- Name: alertes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alertes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alertes_id_seq OWNER TO postgres;

--
-- Name: alertes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alertes_id_seq OWNED BY public.alertes.id;


--
-- Name: appareils; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appareils (
    id character varying(20) NOT NULL,
    batterie integer,
    sensibilite integer DEFAULT 100,
    frequence integer,
    role_f character varying(50),
    role_b character varying(50),
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    derniere_vu timestamp without time zone DEFAULT now(),
    temps_bloque integer DEFAULT 2
);


ALTER TABLE public.appareils OWNER TO postgres;

--
-- Name: dashboard_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_settings (
    id integer NOT NULL,
    max_people integer NOT NULL,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dashboard_settings OWNER TO postgres;

--
-- Name: door_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.door_settings (
    door_id text NOT NULL,
    is_pmr boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.door_settings OWNER TO postgres;

--
-- Name: led_battery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.led_battery (
    id integer NOT NULL,
    appareil_id character varying(20),
    batterie integer NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now()
);


ALTER TABLE public.led_battery OWNER TO postgres;

--
-- Name: led_battery_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.led_battery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.led_battery_id_seq OWNER TO postgres;

--
-- Name: led_battery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.led_battery_id_seq OWNED BY public.led_battery.id;


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
-- Name: ndns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ndns (
    id character varying(20) NOT NULL,
    url text NOT NULL,
    type character varying(20) NOT NULL,
    status character varying(20),
    "timestamp" timestamp without time zone DEFAULT now()
);


ALTER TABLE public.ndns OWNER TO postgres;

--
-- Name: passages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passages (
    id integer NOT NULL,
    type character varying(10) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    appareil_id character varying(20) NOT NULL,
    faisceau character varying(1),
    duree numeric,
    date_heure timestamp without time zone DEFAULT now(),
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
-- Name: qr_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qr_tokens (
    token text NOT NULL,
    scope text NOT NULL,
    revoked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.qr_tokens OWNER TO postgres;

--
-- Name: alertes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertes ALTER COLUMN id SET DEFAULT nextval('public.alertes_id_seq'::regclass);


--
-- Name: led_battery id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.led_battery ALTER COLUMN id SET DEFAULT nextval('public.led_battery_id_seq'::regclass);


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
-- Data for Name: alertes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alertes (id, appareil_id, status, "position", type, duree_totale, timestamp_esp, date_reception) FROM stdin;
1	PORTE_02	LIBERE	FRONT	SORTIE	6.2	2026-02-12 10:58:57.708	2026-02-12 09:58:57.720714
2	PORTE_01	LIBERE	FRONT	ENTREE	990.6	2026-02-12 11:01:46.19	2026-02-12 10:01:46.202279
3	PORTE_02	LIBERE	FRONT	SORTIE	12.7	2026-02-12 11:02:29.479	2026-02-12 10:02:29.491214
4	PORTE_02	LIBERE	FRONT	SORTIE	4.2	2026-02-12 11:04:37.08	2026-02-12 10:04:37.093089
\.


--
-- Data for Name: appareils; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appareils (id, batterie, sensibilite, frequence, role_f, role_b, "timestamp", derniere_vu, temps_bloque) FROM stdin;
emetteur	94	\N	\N	\N	\N	2026-03-05 10:01:25.13158	2026-03-05 10:01:25.132709	2
emetteur1	87	100	\N	\N	\N	2026-03-05 10:01:25.831615	2026-03-05 10:01:25.832507	2
PORTE_02	92	45	\N	SORTIE	SORTIE	2026-03-05 10:01:28.29893	2026-03-05 10:01:27.16705	2
PORTE_01	49	50	\N	ENTREE	ENTREE	2026-02-10 10:26:08.526773	2026-03-03 10:44:16.023756	2
emetteur2	100	\N	\N	\N	\N	2026-03-05 09:56:26.361582	2026-03-05 09:56:26.362793	2
\.


--
-- Data for Name: dashboard_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboard_settings (id, max_people, updated_at) FROM stdin;
1	200	2026-02-13 08:28:10.952345
\.


--
-- Data for Name: door_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.door_settings (door_id, is_pmr, updated_at) FROM stdin;
PORTE_02	f	2026-03-02 09:56:15.348247
PORTE_01	f	2026-03-03 08:08:27.411943
\.


--
-- Data for Name: led_battery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.led_battery (id, appareil_id, batterie, "timestamp") FROM stdin;
7	PORTE_01	78	2026-03-05 10:01:19.766047
8	PORTE_01	78	2026-03-05 10:01:22.800277
9	PORTE_01	78	2026-03-05 10:01:25.779263
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
3408	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:30:54.019486
3409	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:30:55.021037
3410	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:30:57.634509
3411	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:30:59.172922
3412	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:31:22.040144
3413	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:31:22.052979
3414	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:31:36.339845
3415	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:31:41.497296
3416	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:31:43.800899
3417	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:31:45.623279
3418	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:31:48.055893
3419	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:31:50.634228
3420	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:32:44.348385
3421	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:32:44.404827
3422	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:32:44.411353
3423	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:32:45.07645
3424	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:33:28.410755
3425	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:33:59.703227
3426	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:33:59.726043
3427	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:35:50.343478
3428	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:35:50.366186
3429	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:36:29.890145
3430	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:36:56.162365
3431	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:36:56.169377
3432	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:36:59.378707
3433	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:36:59.435989
3434	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:37:17.618656
3435	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:37:17.646844
3436	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:37:17.699887
3437	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:37:18.063442
3438	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:37:18.756718
3439	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:37:18.779139
3440	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:37:20.69413
3441	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:37:21.01939
3442	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:37:42.287158
3443	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:37:42.301944
3444	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-12 10:37:45.572514
3445	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-12 10:37:45.595498
3446	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:07.017657
3447	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:07.637464
3448	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:07.79609
3449	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:07.883256
3450	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:10.490818
3451	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:10.855439
3452	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:11.941409
3453	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:12.343982
3454	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:14.976226
3455	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:15.910351
3456	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:16.841609
3457	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:17.245593
3458	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:17.299205
3459	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:17.899244
3460	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:18.161463
3461	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:18.241392
3462	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:19.06874
3463	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:19.339309
3464	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:19.6242
3465	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:19.660449
3466	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:20.787237
3467	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:20.831329
3468	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:20.851848
3469	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:21.401859
3470	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:21.626728
3471	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:21.639212
3472	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:21.646034
3473	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:21.668436
3474	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:21.679814
3475	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:21.920962
3476	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:38:37.154742
3477	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:38:38.055384
3478	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:08.483301
3479	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:39:08.956248
3480	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:28.225972
3481	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:39:28.447292
3482	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:31.229856
3483	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:39:31.241816
3484	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:50.170958
3485	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:39:50.247691
3486	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:50.333021
3487	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:39:50.678624
3488	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:55.097923
3489	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:39:55.775865
3490	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:56.060028
3491	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:39:56.074818
3492	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:56.08909
3493	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:39:56.100968
3494	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:56.114734
3495	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:39:56.127083
3496	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:39:59.413353
3497	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:00.118824
3498	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:08.225698
3499	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:09.018626
3500	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:14.009706
3501	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:14.865183
3502	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:23.574531
3503	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:23.647926
3504	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:23.72944
3505	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:24.108273
3506	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:24.148394
3507	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:24.240625
3508	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:32.411057
3509	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:33.134257
3510	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:40.664441
3511	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:40.777118
3512	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:40.842385
3513	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:41.429633
3514	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:41.869121
3515	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:42.468623
3516	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:51.416158
3517	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:51.810034
3518	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:40:54.750037
3519	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:40:54.785798
3520	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:41:40.576415
3521	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:41:41.394628
3522	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:41:50.371199
3523	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:41:52.962503
3524	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:41:53.133337
3525	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:41:53.498523
3526	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:42:41.228724
3527	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:42:41.23519
3528	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:43:18.007293
3529	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:43:18.023308
3530	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:43:18.143335
3531	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:43:18.336659
3532	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:43:20.110584
3533	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:43:32.823222
3534	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:43:32.829664
3535	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:43:32.861805
3536	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:43:32.862988
3537	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:43:40.092435
3538	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:43:40.918265
3539	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:43:41.013081
3540	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:43:41.304161
3541	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:43:42.778356
3542	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:43:45.68801
3543	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:43:45.710829
3544	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:43:50.510379
3545	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:43:52.483081
3546	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:43:52.52165
3547	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:43:52.532572
3548	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:43:52.53425
3549	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:43:52.563662
3550	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:43:52.579114
3551	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:43:52.894474
3552	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:43:52.959068
3553	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:44:09.332883
3554	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:09.463303
3555	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:09.904749
3556	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:44:10.060979
3557	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:15.813357
3558	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:44:15.973114
3559	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:16.348394
3560	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:44:16.432827
3561	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:31.794326
3562	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:31.815878
3563	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:44:31.829183
3564	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:44:31.845364
3565	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:31.940204
3566	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:44:31.980423
3567	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:32.14641
3568	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:44:32.206376
3569	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:43.985138
3570	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:44.102922
3571	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:45.489923
3572	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:45.582792
3573	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:46.970768
3574	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:47.031323
3575	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:48.075912
3576	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:48.154218
3577	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:49.501304
3578	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:49.62172
3579	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:50.286485
3580	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:50.301403
3581	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:50.306745
3582	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:50.329032
3583	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:50.379251
3584	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:50.492144
3585	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:51.786104
3586	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:51.865843
3587	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:51.878098
3588	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:51.889911
3589	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:44:52.203618
3590	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:52.275415
3591	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:44:52.572102
3592	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:52.676998
3593	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:52.756814
3594	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:52.769108
3595	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:53.869874
3596	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:53.946553
3597	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:54.814118
3598	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:44:54.927995
3599	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:44:55.713332
3600	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:55.938104
3601	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:56.632925
3602	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:56.645336
4640	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:28:49.378154
4641	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:28:49.460591
4642	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:28:52.645102
4643	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:28:52.680684
4644	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:28:57.74776
4645	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:28:57.761402
4646	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:28:57.979377
4647	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:06.122154
4847	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:46:17.689374
4848	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:46:17.740428
5064	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:18.775368
5065	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:18.834242
5192	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:11:55.377505
5193	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:11:55.428082
5417	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:22:17.714673
5418	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:22:17.7269
5419	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:22:39.225453
5420	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:22:39.282439
5421	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:22:42.815401
5422	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:22:42.827713
5423	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:22:42.829005
5426	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:22:43.656186
5427	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:22:47.741738
5428	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:22:47.754236
5429	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:23:24.847933
5430	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:23:24.904457
5431	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:23:26.879304
5432	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:23:26.89228
5708	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:06.076452
5709	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:06.089096
5710	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:06.720807
5711	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:06.821278
5712	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:07.454657
5713	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:07.561937
5714	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:08.382558
5715	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:08.507934
5716	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:09.224276
5717	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:09.359258
5718	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:10.216179
5719	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:10.330242
5720	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:11.077727
5722	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:11.088822
5723	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:11.13898
5724	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:13.760404
5726	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:13.773502
5727	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:14.263706
5728	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:14.27538
5729	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:17.531435
5730	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:18.488995
5731	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:18.651385
5732	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:19.129997
5733	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:19.23913
5734	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:20.052145
5735	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:20.219806
5736	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:20.828386
5737	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:20.901577
5738	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:22.472308
5739	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:22.494983
5741	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:22.508225
5742	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:25.838725
5743	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:25.862375
5744	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:25.867886
5745	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:25.923261
5746	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:27.253181
5747	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:27.806717
5748	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:27.807882
5749	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:27.819133
5750	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:27.820389
5751	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:30.849269
3603	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:56.645643
3604	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:44:56.954474
3605	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:44:57.949392
3606	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:44:58.169852
3607	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:44:59.025984
3608	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:44:59.281677
3609	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:00.051054
3610	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:00.288184
3611	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:00.356042
3612	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:00.368789
3613	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:00.379842
3614	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:01.431651
3615	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:02.079549
3616	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:02.275684
3617	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:02.30245
3618	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:02.32478
3619	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:07.218656
3620	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:07.230486
3621	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:07.352718
3622	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:07.364633
3623	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:07.897194
3624	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:07.910999
3625	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:10.63848
3626	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:18.622504
3627	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:19.47628
3628	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:19.480324
3629	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:19.494022
3630	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:20.540077
3631	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:21.82002
3632	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:21.878292
3633	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:21.884256
3634	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:21.894434
3635	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:21.896738
3636	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:22.097043
3637	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:22.111315
3638	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:22.123305
3639	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:22.123452
3640	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:22.409188
3641	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:23.923901
3642	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:24.48626
3643	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:24.524254
3644	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:24.555432
3645	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:25.512926
3646	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:25.527142
3647	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:25.549666
3648	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:25.76092
3649	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:27.846748
3650	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:28.362644
3651	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:28.432984
3652	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:28.445443
3653	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:28.445551
3654	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:28.445687
3655	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:28.474698
3656	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:28.48655
3657	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:28.487506
3658	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:29.326057
3659	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:29.697757
3660	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:29.710637
3661	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:31.393929
3662	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:31.661431
3663	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:31.684469
3664	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:31.94059
3665	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:31.96701
3666	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:31.997939
3667	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:32.594327
3668	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:32.626026
3669	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:32.674174
3670	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:32.838149
3671	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:32.912907
3672	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:32.926071
3673	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:32.938123
3674	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:33.185913
3675	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:33.843284
3676	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:33.855272
3677	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:34.448364
3678	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:34.601364
3679	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:34.827423
3680	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:34.857341
3681	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:34.955005
3682	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:34.967383
3683	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:35.689682
3684	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:35.701501
3685	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:35.713913
3686	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:36.109179
3687	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:36.155979
3688	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:36.169138
3689	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:37.018395
3690	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:37.561364
3691	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:37.867339
3694	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:37.881483
3697	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:38.705985
3698	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:39.143074
3699	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:40.095749
3700	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:40.62525
3701	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:41.109629
3702	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:41.121366
3703	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:41.326967
3704	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:41.340057
3717	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:44.235803
3718	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:44.760835
3719	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:45.134831
3720	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:45.698622
3721	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:45.752326
4648	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:29:06.197846
4849	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:38.239864
4850	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:39.019796
4853	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:39.074945
4855	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:39.304461
4856	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:39.415052
4858	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:39.582321
4860	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:39.820721
4862	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:39.936937
4865	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:40.149765
4867	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:40.430118
4869	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:40.482994
4871	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:40.59661
4872	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:40.652927
4874	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:41.151887
4877	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:41.205128
4878	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:41.532307
4881	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:41.858046
4883	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:45.759096
4885	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:46.66097
4887	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:46.825388
4888	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:46.881248
4889	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:47.212108
4891	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:47.674646
4893	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:48.59539
4896	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:48.980722
4897	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:49.39648
4900	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:50.510036
4902	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:51.397122
4903	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:54.906213
4905	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:57.949016
4907	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:59.812945
4910	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:50:00.631403
4912	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:50:01.331946
5066	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:18.845003
5194	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:12:05.803368
5195	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:12:05.809566
5424	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:22:42.833986
5425	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:22:43.599163
5721	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:11.086944
5725	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:13.772686
5740	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:22.507771
5756	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:31:32.473471
6003	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:35:20.349269
6004	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:35:20.411405
6005	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:35:25.380439
6006	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:35:25.501002
6007	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:35:39.945787
6008	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:35:39.966482
6009	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:36:05.531299
6078	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:47:54.658405
6079	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:47:55.174171
6080	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:47:57.675869
6081	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:47:59.432329
6082	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:48:03.779592
6083	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:48:03.836444
6084	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:48:04.435537
6138	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:48:36.335582
6142	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 10:48:48.455072
6143	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 10:48:48.508877
6362	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:22.067857
6375	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:26.751832
6459	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:14:08.579111
6461	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:14:13.589901
6462	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:14:15.5508
6463	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:14:15.562745
6465	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:14:23.5735
6466	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:14:33.578409
6468	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:14:38.575337
6470	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:14:43.579217
6472	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:14:53.57627
6507	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:17:57.159788
6510	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:18:02.201716
3692	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:37.880086
4649	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:29:06.199616
4650	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:15.308144
4651	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:15.322598
4652	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:15.336711
4851	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:39.026032
4852	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:39.074691
4854	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:39.304426
4857	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:39.415222
4859	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:39.582499
4861	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:39.82086
4863	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:39.937085
4864	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:40.149486
4866	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:40.429948
4868	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:40.482839
4870	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:40.596454
4873	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:40.653066
4875	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:41.152028
4876	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:41.205091
4879	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:41.533393
4880	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:41.857861
4882	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:45.75894
4884	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:46.660832
4886	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:46.825248
4890	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:47.212891
4892	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:47.674657
4894	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:48.595536
4895	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:48.980588
4898	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:49.396695
4899	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:50.509877
4901	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:51.396981
4904	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:49:54.906376
4906	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:57.949155
4908	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:49:59.813085
4909	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:50:00.631302
4911	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:50:01.331802
5067	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:18.84556
5196	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:12:16.455334
5197	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:12:16.505358
5433	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:23:26.90098
5752	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:30.865671
5753	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:31:31.805432
5754	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:31:31.818029
5755	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:31:32.46004
5757	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:32.474331
6010	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:36:21.954874
6011	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:36:21.967923
6013	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:36:21.990476
6085	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:48:16.000927
6139	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:48:36.393259
6140	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:48:46.262865
6144	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 10:48:48.517654
6363	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:22.06942
6364	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:22.632272
6365	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:22.78541
6366	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:22.878488
6367	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:22.890407
6368	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:24.088032
6369	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:24.35447
6370	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:25.29249
6371	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:26.648837
6372	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:26.662653
6373	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:26.704029
6376	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:26.75434
6392	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:31.496931
6467	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:14:33.585514
6469	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:14:38.575364
6471	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:14:43.579364
6473	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:14:53.576429
6508	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:17:57.160004
6509	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:18:02.201494
6511	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:18:07.261257
6513	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:18:12.24561
6553	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:19:44.412749
6554	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:19:49.310746
6556	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:19:49.410739
6557	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:19:54.354148
6627	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:23:17.804117
6664	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:30:35.725262
6665	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:30:35.780413
6666	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:30:45.953556
6667	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:30:45.966003
6702	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:32:58.849133
6703	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:32:59.178696
6704	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:33:11.004229
6705	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:33:11.016396
6706	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:34:10.954137
6707	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:34:10.970027
3693	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:37.880244
3695	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:37.887109
3696	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:38.692925
3705	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:41.340166
3706	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:41.978361
3707	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:42.752058
3708	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:42.763873
3709	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:42.863315
3710	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:43.344412
3711	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:43.923927
3712	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:43.935823
3713	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:44.115696
3714	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:44.128016
3715	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:44.219281
3716	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:44.235757
3722	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:45.752463
3723	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:45.756529
3724	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:46.237505
3725	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:47.130944
3726	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:47.173032
3727	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:47.189534
3728	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:47.204664
3729	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:47.217311
3730	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:47.309342
3731	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:47.322228
3732	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:47.569741
3733	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:48.462667
3734	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:48.538475
3735	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:48.566169
3736	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:48.828184
3737	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:48.844729
3738	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:48.916483
3739	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:49.934389
3740	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:45:50.006531
3741	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:45:50.02666
3742	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:50.191847
3743	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:50.64334
3744	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:50.655339
3745	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:50.695477
3746	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:50.70649
3747	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:50.720291
3748	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:45:50.720408
3749	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:45:50.736281
3750	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:46:28.990084
3751	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:46:29.872938
3752	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:46:30.248461
3753	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:46:30.795372
3754	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:46:30.808333
3755	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:46:30.817293
3756	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:46:30.817912
3757	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:46:30.81946
3758	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:46:31.646835
3759	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:46:31.727405
3760	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:46:31.741759
3761	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:46:31.800468
3762	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:46:31.813071
3763	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:46:31.813222
3764	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:46:31.814344
3765	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:46:31.819821
3766	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:46:31.824918
3767	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:46:31.82527
3768	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:46:34.69681
3769	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:46:34.708804
3770	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:46:55.864811
3771	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:46:55.876826
3772	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:47:12.492882
3773	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:47:12.504872
3774	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:47:31.5668
3775	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:47:31.579454
3776	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:47:47.841531
3777	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:47:47.853922
3778	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:47:51.28393
3779	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:47:51.296127
3780	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:47:53.811161
3781	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:47:53.82326
3782	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:48:15.181089
3783	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:48:15.188431
3784	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:30.013585
3785	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:30.070344
3786	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:30.103349
3787	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:30.138868
3788	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:30.153449
3789	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:30.154026
3790	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:30.153219
3791	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:30.159341
3792	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:31.227585
3793	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:31.261917
3794	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:31.308414
3795	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:31.327368
3796	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:31.339494
3797	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:31.360272
3798	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:31.374545
3803	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:32.50634
3804	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:32.564973
3805	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:32.57713
3806	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:33.864238
3807	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:33.878205
3808	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:33.921388
3809	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:33.975314
3810	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:33.987558
3811	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:34.000053
3812	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:48:34.768452
3813	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:48:34.784861
3814	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:35.077892
3815	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:35.10104
3816	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:35.127083
3817	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:35.234362
3818	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:35.246196
3819	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:35.287007
3820	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:35.298711
3821	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:35.318159
3822	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:35.330795
3827	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:36.475707
3829	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:36.489218
4653	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:15.342057
4654	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:16.335612
4655	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:16.363039
4656	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:16.954435
4657	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:16.978028
4658	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:17.341028
4659	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:17.353394
4660	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:18.509442
4661	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:18.585068
4662	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:18.992894
4663	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:19.038679
4664	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:19.588949
4665	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:19.606379
4666	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:20.158456
4667	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:20.169769
4668	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:21.405491
4669	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:21.419317
4670	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:21.885485
4671	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:21.897494
4672	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:22.289103
4673	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:22.351347
4674	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:22.644273
4675	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:22.675201
4676	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:25.124343
4677	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:25.137118
4678	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:26.225232
4679	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:26.238919
4680	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:26.888797
4681	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:26.901805
4682	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:32.650161
4913	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:51:20.17163
4914	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:51:20.220131
5068	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:18.851389
5069	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:19.746306
5070	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:23.272172
5071	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:23.28426
5072	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:23.535005
5073	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:24.132623
5074	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:26.046475
5075	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:26.532408
5076	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:29.220793
5077	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:29.237595
5078	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:29.48093
5079	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:29.562735
5080	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:32.593946
5081	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:32.669785
5198	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:12:31.452754
5199	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:12:31.516622
5200	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:12:34.187713
5201	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:12:34.199821
5434	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:23:26.903214
5435	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:23:37.714679
5436	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:23:37.727947
5441	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:23:39.948812
5758	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:32.479511
5759	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:39.806766
5760	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:39.82184
5761	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:31:42.151248
5762	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:31:42.209227
5763	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:47.585743
6012	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:36:21.988468
6086	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:48:16.12069
3799	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:31.374665
3800	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:32.48124
3801	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:32.495792
3802	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:32.505794
3823	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:35.330919
3824	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:36.283601
3825	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:36.462524
3826	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:36.475593
3832	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:36.489805
3833	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:36.500708
3834	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:48:50.478168
3835	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:48:50.497715
3836	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:48:59.344798
3837	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:48:59.360692
3838	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:49:01.2015
3839	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:49:01.256007
4683	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:32.655599
4684	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:35.197967
4685	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:35.210436
4686	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:38.249499
4687	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:38.263403
4688	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:39.096957
4689	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:39.15135
4690	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:39.381435
4691	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:39.393945
4692	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:41.886655
4693	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:41.898564
4694	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:49.710908
4695	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:50.154503
4696	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:29:52.538991
4697	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:29:52.553883
4698	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:03.79298
4699	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:03.851651
4700	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:03.91719
4701	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:04.046357
4702	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:04.095221
4703	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:05.466628
4915	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:54:29.316835
4916	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:54:29.620401
5082	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:32.67823
5083	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:32.885292
5084	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:36.67995
5085	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:36.692075
5086	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:36.981818
5087	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:37.080755
5088	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:41.034676
5089	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:41.396462
5090	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:46.760712
5091	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:46.774195
5092	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:46.934475
5093	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:46.9918
5202	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:12:58.394546
5437	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:23:37.736853
5440	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:23:39.948639
5764	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:31:47.731585
5765	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:31:47.740983
5766	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:49.241499
5767	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:49.253262
5768	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:50.821264
5769	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:50.876664
6014	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:36:21.992553
6087	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:48:20.811866
6088	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:48:20.909782
6089	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:48:21.105476
6090	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:48:21.853436
6141	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:48:46.282436
6145	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:47:20.12513
6146	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:47:20.497892
6377	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:26.760229
6378	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:27.277481
6379	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:27.291233
6380	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:27.303584
6381	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:28.343421
6382	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:28.425336
6383	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:28.438926
6384	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:28.476112
6385	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:28.934745
6386	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:29.251375
6387	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:29.268634
6388	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:29.303422
6389	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:29.315909
6390	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:29.328385
6391	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:31.482047
6393	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:31.499344
6394	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:31.850982
6395	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:34.366883
6396	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:34.381629
6397	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:34.404992
3828	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:36.476076
3830	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:48:36.489375
4704	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:05.47722
4917	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:54:40.956742
4918	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:54:41.367327
5094	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:46.997298
5095	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:47.059467
5096	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:02.863138
5097	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:02.929845
5098	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:05.447065
5203	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:13:10.490568
5438	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:23:37.739844
5439	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:23:39.891429
5442	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:23:39.949128
5443	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:23:50.286839
5444	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:23:50.298865
5445	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:24:17.713561
5446	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:24:17.727948
5447	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:24:26.379803
5448	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:24:32.246402
5770	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:50.88519
5778	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:52.145758
5781	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:52.156292
5782	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:52.172772
5783	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:52.280369
5784	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:52.633487
5785	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:52.64675
5786	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:31:52.724573
5787	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:31:52.787038
5788	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:52.93185
5789	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:53.016447
5790	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:53.351302
5791	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:53.431769
5792	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:54.26185
5793	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:54.422041
5794	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:54.542055
5795	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:54.554279
5796	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:54.576281
5798	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:54.610239
5799	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:54.622669
5804	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:02.237742
5805	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:02.254245
5806	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:02.371255
5807	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:02.443799
5808	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:02.54173
5809	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:02.55351
5810	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:02.730676
5811	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:02.743273
5812	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:02.766706
5813	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:02.779211
5814	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:03.551028
5815	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:03.576503
5816	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:05.173878
5817	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:05.292498
5818	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:05.305745
5819	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:05.720307
5820	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:09.148779
5821	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:09.50079
5822	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:10.166973
5823	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:10.17908
5824	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:10.180242
5830	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:10.906731
5836	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:13.202564
5842	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:13.215298
6015	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:36:21.993292
6091	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:48:23.145252
6092	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:48:23.246294
6093	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:48:24.324463
6094	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:48:24.670962
6147	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:30.58967
6148	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:30.668204
6149	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:31.778483
6150	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:31.849281
6151	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:32.981406
6152	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:33.063229
6153	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:33.733729
6154	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:33.803366
6155	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:35.501927
6156	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:35.544944
6157	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:36.242267
6158	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:36.279897
6159	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:37.770886
6160	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:37.827112
6161	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:38.304264
6162	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:38.34433
6163	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:47:39.719851
6164	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:47:39.761134
6165	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:39.893962
3831	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:48:36.489519
3840	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:49:15.196296
3841	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:49:15.209662
3842	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:49:31.344645
3843	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:49:31.350511
3844	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:49:41.283561
3845	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:49:41.700668
3846	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:49:41.780682
3847	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:49:42.929715
3848	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:49:42.943806
3849	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:49:42.956871
3850	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:49:42.97
3851	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:49:42.974714
3852	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:49:52.364012
3853	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:49:52.377169
3854	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:01.147473
3855	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:01.401971
3856	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:01.535944
3857	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:02.816329
3858	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:02.878856
3859	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:03.217644
3860	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:03.23693
3861	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:03.252566
3862	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:03.333964
3863	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:03.398599
3864	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:03.41059
3865	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:03.424769
3866	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:03.43143
3867	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:03.431449
3868	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:05.810439
3869	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:05.822374
3870	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:10.069865
3871	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:10.082415
3872	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:12.670828
3873	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:12.682732
3874	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:19.342457
3875	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:19.587872
3876	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:19.683214
3877	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:19.687013
3878	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:19.79926
3879	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:19.818572
3880	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:19.825107
3881	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:20.637558
3882	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:20.678878
3883	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:20.746145
3884	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:20.871078
3885	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:22.433136
3886	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:22.464105
3887	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:22.464318
3888	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:22.472045
3889	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:22.472606
3890	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:28.181791
3891	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:33.328576
3892	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:33.477903
3893	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:33.587801
3894	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:33.615888
3895	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:33.629527
3896	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:33.630925
3897	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-12 10:50:33.632688
3898	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:33.633338
3899	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-12 10:50:33.635303
3900	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:34.175941
3901	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:35.165708
3902	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:35.436019
3903	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-12 10:50:35.449999
3904	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-12 10:50:36.04719
3905	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-12 10:51:53.141483
3906	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-12 10:51:53.153799
3907	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 07:41:15.119447
3908	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 07:41:15.14066
3909	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:56.133105
3910	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:05:56.134392
3911	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:05:56.172826
3912	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:05:56.172971
3913	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.395951
3914	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.407714
3915	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.420089
3916	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.429727
3917	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.433509
3918	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.433624
3919	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.445478
3920	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.445607
3921	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.459233
3922	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.459379
3923	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.472891
3924	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.47305
3925	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.485562
3926	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.485714
3927	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.497645
3930	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.511453
3931	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.523384
3933	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.536173
3935	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.548832
3938	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.562527
3940	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.574724
3941	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.586392
3944	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.59872
3945	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.612112
3948	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.625328
3949	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.638817
3951	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.653671
3954	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.666936
3955	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.679868
3958	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.70161
3960	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.71549
3962	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.729287
3963	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.741903
3965	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.76215
3967	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.781472
3970	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.796616
3971	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.811586
3974	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.825246
3976	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.83942
3978	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.852615
3979	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.864628
3984	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:00.513729
3985	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:03.315435
3988	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:04.971184
3989	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:04.982819
3994	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:06.136631
3996	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:09.119295
3998	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:09.131873
3999	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:12.077784
4000	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:12.187743
4705	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:05.477781
4706	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:07.815272
4707	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:07.85778
4708	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:08.120606
4709	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:08.434319
4919	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:55:48.993761
4920	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:55:49.048353
5099	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:05.46344
5204	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:13:42.729699
5205	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:13:42.780078
5206	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:13:47.703223
5207	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:13:47.717852
5208	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:13:52.612902
5209	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:13:52.687949
5210	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:13:55.657279
5449	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:24:32.408874
5450	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:24:36.302749
5451	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:24:36.314762
5452	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:24:59.22415
5453	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:24:59.284071
5454	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:25:24.97799
5455	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:25:27.000933
5456	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:25:27.096357
5457	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:25:32.519405
5771	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:50.887008
5772	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:51.261567
5773	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:51.303347
5774	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:51.317172
5775	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:51.329065
5776	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:51.685472
5777	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:52.131371
5779	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:52.146041
5780	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:52.155744
5797	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:54.610155
5800	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:54.62282
5801	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:31:55.294527
5802	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:31:55.35405
5803	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:01.275211
6016	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:36:21.995475
6018	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:36:27.748433
6019	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:36:27.768532
6095	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:52:55.915744
6096	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:52:56.110779
6166	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:39.94264
6167	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:40.520168
6168	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:40.550746
6169	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:42.064405
6170	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:42.117813
6171	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:43.058208
6172	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:43.140188
6173	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:45.482734
6174	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:45.499335
3928	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.498816
3929	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.510857
3932	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.523919
3934	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.536404
3936	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.548954
3937	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.562279
3939	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.574709
3942	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.586831
3943	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.598291
3946	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.612245
3947	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.624766
3950	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.639274
3952	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.65379
3953	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.666473
3956	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.680459
3957	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.701218
3959	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.715366
3961	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.729164
3964	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.742775
3966	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.76229
3968	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.781602
3969	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.796418
3972	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.811712
3973	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:05:58.825121
3975	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.839294
3977	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.852496
3980	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:05:58.864944
3981	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:00.485359
3982	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:00.500211
3983	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:00.512492
3986	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:03.327417
3987	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:04.958867
3990	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:04.983423
3991	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:05.316303
3992	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:05.328694
3993	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:06.12527
3995	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:09.107651
3997	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:09.131856
4001	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:12.188639
4002	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:12.194469
4003	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:12.244629
4004	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:12.292103
4005	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:06:16.12575
4006	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:06:16.141197
4007	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:07:44.96779
4008	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:44.968399
4009	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:07:45.013071
4010	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:07:45.013248
4011	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:45.092479
4012	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:45.112444
4013	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:45.607993
4014	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:45.629226
4015	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:47.221004
4016	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:47.324526
4017	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:47.702585
4018	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:47.715149
4019	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:48.005098
4020	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:48.017675
4021	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:50.723176
4022	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:50.734813
4023	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:51.907303
4024	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:51.92571
4025	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:52.53685
4026	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:52.604575
4027	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:52.951092
4028	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:52.992127
4029	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:07:54.538951
4030	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:07:54.560179
4031	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:14.869251
4032	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:14.888069
4033	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:28.201852
4034	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:28.227396
4035	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:28.233943
4036	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:28.237932
4037	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:28.995215
4038	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:29.031372
4039	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:29.944047
4040	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:29.965644
4041	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.508647
4042	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.513811
4043	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.897973
4044	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.898494
4045	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.900022
4046	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.902433
4047	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.906952
4048	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.907109
4049	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.916077
4050	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.916237
4051	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.92013
4052	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.924371
4053	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.924899
4055	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.934382
4058	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.934847
4065	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.975354
4066	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.975468
4067	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.994282
4068	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.994436
4069	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.010105
4071	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.022208
4073	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.032186
4075	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.044949
4078	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.059983
4079	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.074251
4080	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.074427
4083	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.086208
4084	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.086423
4085	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.098398
4086	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.09852
4087	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.11076
4088	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.11092
4089	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.12386
4090	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.123985
4091	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.13688
4092	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.136996
4093	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.165745
4095	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.169865
4096	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.185648
4097	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.205882
4100	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.225553
4101	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.246408
4103	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.268866
4106	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.295519
4107	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.307856
4108	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.307962
4112	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.320524
4114	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.333702
4116	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.346571
4118	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.363742
4120	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.371525
4122	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.386362
4124	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.395809
4126	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.407833
4128	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.419983
4129	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.824278
4130	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.840998
4131	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:46.478921
4132	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:46.50137
4133	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:46.931564
4134	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:46.951184
4135	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:47.165529
4142	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:49.908153
4154	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:52.589881
4155	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:52.644731
4158	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:52.683491
4159	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:52.758879
4160	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:52.786853
4161	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:52.824234
4162	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:52.83752
4163	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:53.24272
4164	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:53.25525
4165	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:53.400176
4166	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:53.411691
4167	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:53.522471
4168	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:53.53342
4169	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:53.545879
4170	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:53.558449
4171	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:53.708913
4172	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:53.72206
4176	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:53.75689
4177	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:53.776674
4186	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:54.742853
4187	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:54.839063
4188	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:54.85096
4189	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:56.202827
4191	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:57.130329
4192	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:57.145999
4193	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:58.264214
4194	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:58.282612
4195	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:58.319548
4196	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:58.33213
4197	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:58.346629
4199	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:58.360098
4200	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:58.378357
4201	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:59.540363
4202	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:59.595413
4203	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:00.123831
4056	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.934431
4061	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.963236
4064	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.975137
4070	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.010582
4072	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.022377
4074	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.032344
4076	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.045078
4077	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.059807
4081	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.078051
4082	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.086102
4094	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.165877
4098	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.206029
4099	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.22543
4102	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.24715
4104	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.269078
4105	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.295169
4110	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.308288
4111	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:45.320501
4113	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.333646
4115	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.346443
4117	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.361518
4119	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.371404
4121	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.386233
4123	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.395693
4125	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.407711
4127	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.419866
4136	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:47.178517
4137	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:48.298595
4138	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:48.318583
4139	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:49.135908
4140	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:49.147397
4141	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:49.896915
4143	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:50.271057
4144	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:50.284597
4145	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:51.495069
4146	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:51.513876
4147	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:52.176184
4148	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:52.195168
4149	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:52.307665
4150	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:52.319018
4151	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:52.440806
4152	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:52.468017
4153	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:52.589629
4156	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:52.683234
4206	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:00.140926
4208	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:00.182477
4209	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:00.86832
4210	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:00.888481
4211	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:01.176303
4212	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:01.191456
4213	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:01.822881
4214	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:01.838212
4215	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:02.538859
4216	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:02.578457
4217	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:02.973699
4218	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:03.006773
4219	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:03.127899
4220	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:03.139328
4221	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:03.211902
4222	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:03.223784
4223	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:03.286889
4224	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:03.301914
4257	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:12.45797
4259	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:12.543295
4260	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:12.563187
4261	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:09:14.004991
4262	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:09:14.016531
4710	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:29.099016
4711	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:29.114411
4921	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:59:47.68664
4922	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:59:47.740102
5100	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:05.463978
5211	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:14:08.970634
5458	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:25:32.774371
5459	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:25:32.795298
5460	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:25:33.343906
5461	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:25:33.356352
5462	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:25:36.341589
5463	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:25:36.353733
5464	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:25:42.546798
5465	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:25:42.72495
5466	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:26:02.243775
5467	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:26:02.786337
5468	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:26:07.115018
5825	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:10.188106
5829	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:10.905832
5837	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:13.20352
5843	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:13.215516
4057	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.934575
4054	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.931862
4059	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.946192
4060	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:08:44.946342
4062	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.963373
4063	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:08:44.974983
4109	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:45.308056
4157	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:52.68336
4173	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:53.722464
4174	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:53.741911
4175	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:53.756742
4178	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:53.778075
4179	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:53.836513
4180	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:53.861003
4181	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:54.176307
4182	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:54.195841
4183	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:54.718798
4184	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:54.730665
4185	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:54.742127
4190	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:08:56.214092
4198	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:08:58.359434
4205	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:00.140062
4225	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:03.302041
4234	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:05.262818
4238	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:06.907967
4239	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:08.195357
4241	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:09.463848
4242	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:09.488515
4243	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:10.586692
4244	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:10.598154
4245	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:10.937172
4246	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:10.948836
4247	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:10.976475
4248	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:10.990306
4249	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:11.014653
4250	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:11.027546
4251	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:11.593748
4252	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:11.608876
4253	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:11.618428
4256	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:12.457321
4263	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:14.030263
4282	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:19.446173
4287	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:09:21.653401
4304	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:24.935403
4305	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:25.465072
4306	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:25.479374
4307	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:25.491108
4712	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:44.350553
4923	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:05.428792
4924	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:05.483934
5101	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:05.46447
5212	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:14:09.196032
5213	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:14:18.980641
5469	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:26:07.98986
5470	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:26:13.215239
5826	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:10.188301
5827	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:10.191219
5828	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:10.893715
5831	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:10.907062
5832	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:12.238514
5833	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:12.250881
5834	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:13.178154
5835	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:13.190544
5838	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:13.203936
5841	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:13.215238
6017	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:36:22.000087
6097	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:53:18.87972
6098	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:53:19.129694
6175	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:45.510472
6176	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:45.539215
6177	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:45.886252
6178	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:45.908183
6179	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:50.659528
6180	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:50.672183
6181	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:50.684585
6182	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:50.732753
6183	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:51.214168
6184	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:51.277282
6185	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:52.659952
6186	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:52.712953
6187	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:53.285836
6188	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:53.335052
6189	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:54.881256
6190	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:54.923255
6191	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:47:55.556305
6192	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:47:55.595395
6193	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:47:55.61542
6398	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:34.4198
4204	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:00.139854
4207	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:00.182332
4226	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:03.302459
4227	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:04.19438
4228	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:04.209353
4229	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:04.240249
4230	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:04.252594
4231	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:04.645827
4232	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:04.666101
4233	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:05.25073
4235	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:06.856615
4236	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:06.884707
4237	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:06.907824
4240	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:08.207578
4254	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:11.61854
4255	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:12.435008
4258	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:12.458145
4264	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:14.030392
4265	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:15.116077
4266	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:15.13218
4267	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:09:15.384376
4268	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:09:15.398524
4269	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:16.077589
4270	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:16.093937
4271	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:16.151086
4272	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:16.163473
4273	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:16.217619
4274	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:16.232555
4275	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:16.416007
4276	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:16.428974
4277	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:16.471042
4278	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:16.482638
4279	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:17.819828
4280	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:17.833758
4281	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:19.435009
4283	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:20.733014
4284	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:20.74632
4285	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:21.626992
4286	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:21.638533
4288	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:21.653539
4289	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:21.660556
4290	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:09:21.660631
4291	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:21.667761
4292	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:21.667958
4293	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:21.727863
4294	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:21.743155
4295	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:22.311389
4296	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:22.323338
4297	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:23.16065
4298	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:23.174318
4299	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:23.3133
4300	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:23.351446
4301	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:24.909405
4302	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:24.93167
4303	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:24.935243
4308	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:25.49159
4309	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:26.912622
4310	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:26.93508
4311	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:09:27.033125
4312	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:09:27.052861
4313	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.054053
4314	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.055203
4315	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.10114
4316	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.101317
4317	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.113233
4318	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.113568
4319	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.125992
4320	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.131723
4321	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.139123
4322	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.139028
4323	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.151842
4324	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.151997
4325	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.164686
4326	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.164797
4327	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.179557
4328	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.179694
4329	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.19223
4330	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.192907
4331	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.205566
4332	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.205694
4333	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.228511
4334	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.228644
4335	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.24276
4336	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.242892
4337	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.255349
4338	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.255467
4339	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.268616
4340	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.268737
4341	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.281275
4343	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.294126
4345	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.309524
4347	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.328037
4349	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.34884
4352	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.369775
4353	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.390807
4356	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.411767
4357	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.433361
4360	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.455935
4361	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.477875
4364	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.501409
4382	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.677641
4383	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.698427
4386	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.717702
4387	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.738281
4391	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.798493
4395	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.812183
4398	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.824352
4405	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.870725
4479	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:28.721251
4484	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:29.966867
4506	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:32.492517
4713	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:44.777826
4714	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:48.226696
4715	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:48.564076
4716	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:54.101109
4717	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:54.117855
4718	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:55.509724
4719	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:55.881469
4720	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:59.387065
4721	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:59.417261
4722	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:30:59.727849
4723	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:30:59.752005
4724	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:09.724687
4725	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:09.806809
4925	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:17.061972
5102	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:05.483513
5214	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:14:19.20444
5215	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:14:28.982497
5471	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:26:15.575532
5472	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:26:15.953814
5473	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:26:37.53995
5474	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:26:37.596111
5475	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:26:43.238735
5839	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:13.20851
5840	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:13.215173
5844	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:13.227156
5845	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:13.508841
5846	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:14.124744
5847	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:15.052389
5848	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:16.041749
5850	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:16.054535
5851	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:16.156106
5852	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:19.572648
5853	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:19.586647
5854	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:19.611964
5856	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:19.62511
5857	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:20.420406
5858	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:22.394639
5859	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:22.407236
5872	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:27.726059
5885	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:32.644914
6020	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:37:10.137485
6099	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:55:25.200134
6100	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:55:25.256623
6194	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:47:55.621908
6195	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:03.664054
6196	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:03.734431
6197	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:04.293731
6198	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:04.347585
6199	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:05.492621
6200	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:05.55052
6201	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:06.067168
6202	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:06.12098
6203	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:12.673133
6204	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:12.707324
6205	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:12.727158
6215	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:19.891918
6216	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:20.268571
6217	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:23.166043
6218	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:23.403316
6219	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:49.005983
6220	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:49.383236
6399	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:34.433691
6400	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:36.040982
6401	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:37.379307
6402	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:37.396134
4363	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.500193
4392	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.798656
4394	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.812101
4397	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.824151
4406	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.870886
4444	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:22.230062
4446	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:22.244733
4447	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:22.264103
4452	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:23.892277
4453	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:23.930596
4454	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:23.939769
4455	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:23.992321
4456	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:24.004523
4457	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:26.046775
4458	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:26.060458
4459	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:26.074728
4470	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:26.875242
4471	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:27.249743
4473	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:28.126969
4475	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:28.693469
4476	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:28.706535
4477	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:28.720078
4482	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:29.966553
4505	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:32.492407
4544	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:23:41.998374
4545	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:23:42.011324
4726	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:32.611441
4727	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:32.631464
4728	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:32.686638
4729	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:42.627198
4926	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:30.273271
5103	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:05.484057
5216	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:14:29.20804
5217	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:14:38.990658
5476	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:26:43.29798
5477	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:27:13.964185
5849	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:16.054098
5855	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:19.624498
5860	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:22.407693
5861	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:22.663171
5862	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:22.725642
5863	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:22.738279
5864	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:26.364297
5865	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:26.721878
5866	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:26.84081
5867	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:27.251291
5868	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:27.539873
5869	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:27.55163
5870	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:27.631795
5871	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:27.643754
5873	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:27.72569
5874	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:27.737042
5875	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:27.738235
5876	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:27.766573
5877	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:27.77843
5878	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:27.808853
5879	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:27.82061
5880	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:28.924694
5881	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:29.553862
5882	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:29.698169
5883	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:30.027128
5884	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:32.632424
5886	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:32.645443
5897	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:41.25281
5898	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:41.30884
5899	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:42.238091
5900	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:42.253025
5901	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:42.540399
5902	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:42.552984
5903	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:44.726148
5904	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:44.739138
5906	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:44.751961
5907	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:44.764479
5910	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:44.777753
6021	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:37:23.388906
6101	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:56:35.274883
6102	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:56:35.607229
6103	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:56:41.340541
6104	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:56:41.699386
6105	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:56:50.291156
6106	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:56:50.750398
6206	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:12.734666
6207	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:13.232366
6208	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:13.287708
6209	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:14.368274
6210	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:14.414902
6211	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:15.050648
6212	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:15.06581
4366	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.508921
4367	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.519474
4369	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.539749
4371	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.560115
4373	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.582496
4376	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.603209
4377	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.63423
4379	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.654474
4546	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:00.284134
4730	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:42.698932
4731	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:31:46.83975
4927	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:00:30.412393
4929	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:39.375606
4930	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:00:40.001263
5104	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:05.483392
5218	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:14:39.213532
5219	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:14:48.812071
5478	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:27:13.971822
5479	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:27:15.292669
5480	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:27:15.34965
5481	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:27:15.889531
5482	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:27:15.910214
5483	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:27:16.894404
5484	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:27:16.907163
5887	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:32.650924
5888	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:32.730576
5889	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:32.743691
5890	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:33.248988
5891	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:33.261183
5892	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:34.175441
5893	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:32:34.490418
5894	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:32:35.741959
5895	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:41.197602
5896	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:41.252437
5905	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:44.751824
5908	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:44.764959
5909	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:44.777296
6022	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:38:09.340358
6023	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:38:09.352752
6024	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:38:24.476061
6107	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:57:15.350867
6108	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:57:15.405639
6213	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:48:15.875203
6214	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:48:16.188329
6403	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:37.41377
6404	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:37.430469
6405	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:37.493675
6406	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:37.52878
6407	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:37.588354
6408	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:42.093421
6474	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:15:03.600551
6512	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:18:07.266942
6561	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:04.419301
6562	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:09.325382
6564	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:09.429337
6565	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:14.415988
6567	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:19.431668
6628	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:23:17.872713
6668	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:31:25.378301
6669	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:31:25.448032
6677	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:31:34.775289
6708	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:35:15.772838
6709	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:35:15.798765
6736	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:37:50.397952
6737	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:38:10.149439
6746	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:44:37.707297
6747	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:44:37.989849
6756	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:25.86394
6757	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:26.168692
6758	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:29.567341
6759	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:29.707655
6760	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:30.98285
6761	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:31.123753
6780	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:47.168382
6781	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:47.20871
6782	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:48.568328
6783	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:48.661886
6784	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:49.559616
6785	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:49.620651
6786	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:57.111988
6787	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:57.12962
6796	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:48:33.103998
6797	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:48:33.775754
6802	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:49:50.333112
6803	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:49:50.965649
6837	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.137064
6838	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.142426
6839	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.151593
4396	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.821945
4399	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.833791
4402	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.846388
4404	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.858754
4408	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.876035
4409	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.891018
4412	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.897712
4413	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.755442
4414	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.767158
4415	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.790563
4418	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.810937
4420	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.831991
4421	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.843132
4424	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.866775
4426	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.888542
4427	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.907054
4429	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.923233
4432	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.937212
4434	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.947263
4436	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.959699
4437	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:22.179538
4438	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:22.191721
4440	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:22.203704
4441	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:22.216784
4445	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:22.244599
4448	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:22.264538
4449	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:23.859529
4450	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:23.877305
4451	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:23.892148
4460	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:26.074857
4461	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:26.109614
4462	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:26.125068
4463	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:26.201297
4464	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:26.212815
4465	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:26.243231
4466	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:26.254783
4467	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:26.282058
4468	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:26.293024
4469	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:26.850305
4547	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:28.058945
4732	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:31:47.451312
4733	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:31:47.479643
4734	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:31:47.544696
4735	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:49.153825
4928	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:00:30.413174
5105	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:05.48455
5220	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:14:53.411343
5221	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:14:53.467788
5222	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:15:19.701787
5223	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:15:21.727235
5224	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:15:21.820154
5225	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:15:27.24061
5485	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:27:45.53143
5487	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:28:00.003917
5488	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:28:00.060514
5489	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:28:05.748484
5490	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:28:05.761537
5491	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:28:05.784151
5492	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:28:06.432823
5911	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:44.78415
5912	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:45.056295
6025	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:38:48.840367
6026	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:38:48.847934
6027	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:38:48.849491
6029	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:38:49.916901
6030	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:38:49.936745
6031	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:38:50.590772
6032	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:38:50.604395
6109	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:57:52.278246
6110	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:57:52.495511
6221	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:06.435306
6222	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:06.784378
6223	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:23.702998
6224	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:24.162231
6229	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:34.250517
6230	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:34.360963
6231	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:34.379465
6232	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:34.408837
6233	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:35.143747
6234	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:35.216993
6235	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:35.862824
6236	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:35.903204
6237	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:35.916023
6238	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:35.935912
6239	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:36.451074
6240	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:36.518888
6241	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:37.261554
6242	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:37.323958
4478	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:28.720917
4483	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:29.966691
4491	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:31.132054
4494	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:31.191286
4495	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:31.547885
4496	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:31.558968
4497	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:32.09114
4500	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:32.15314
4501	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:32.190992
4507	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:32.492631
4512	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:34.074662
4513	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:34.427519
4514	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:34.47501
4515	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:35.040564
4516	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:35.072904
4517	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:35.111667
4548	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:28.176063
4549	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:29.57762
4550	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:31.490374
4551	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:31.533269
4556	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:32.734187
4558	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:32.785706
4736	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:49.396568
4737	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:49.460932
4738	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:50.200908
4739	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:50.221315
4740	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:51.16774
4741	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:51.204677
4742	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:52.25173
4743	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:55.669882
4744	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:59.060475
4745	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:59.56437
4746	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:31:59.725686
4747	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:31:59.749164
4748	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:32:00.201563
4749	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:32:00.261873
4931	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:00:40.021314
4932	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:40.038981
5106	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:05.48483
5226	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:15:42.485702
5227	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:15:42.547262
5486	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:27:45.532679
5913	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:47.079151
5914	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:47.091158
5915	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:48.380298
5918	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:48.399045
5926	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:51.313538
6028	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:38:48.854822
6111	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:58:27.805793
6112	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:58:27.859721
6113	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:58:27.901248
6114	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:58:28.146595
6225	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:31.161135
6226	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:31.353652
6227	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:32.686953
6228	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:32.868037
6243	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:37.346304
6249	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:40.125232
6250	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:40.637234
6255	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:44.080955
6256	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:44.536081
6258	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:44.588946
6259	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:45.45305
6260	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:46.213495
6265	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:54.811544
6266	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:55.239556
6409	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:44.160785
6410	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:45.689424
6411	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:46.920743
6412	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:48.769057
6413	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:50.476098
6414	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:50.494032
6415	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:50.507105
6416	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:50.525482
6417	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:50.741515
6418	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:51.232352
6475	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:15:03.602879
6476	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:15:16.121933
6478	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:15:18.597988
6514	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:18:12.258613
6570	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:29.501583
6571	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:20:33.651669
6629	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:25:00.576948
6630	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:25:00.872664
6670	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:31:25.454381
6671	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:31:25.773319
6672	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:31:28.267499
6673	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:31:28.670084
4486	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:29.973133
4487	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:30.006906
4490	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:31.131689
4499	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:32.152894
4502	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:32.191205
4503	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:32.434403
4508	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:32.493274
4509	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:34.015603
4510	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:34.045324
4511	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:34.074517
4518	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:35.111813
4519	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:36.066113
4520	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:36.079943
4521	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:36.102022
4522	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:36.117008
4523	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:37.245431
4524	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:37.259199
4525	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:37.80553
4526	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:37.817358
4552	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:31.538722
4553	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:31.608441
4554	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:32.59755
4555	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:32.692738
4557	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:32.734691
4559	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:32.785879
4750	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:32:26.904748
4751	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:32:26.964123
4752	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:32:30.208359
4753	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:32:30.221965
4933	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:50.558615
4934	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:50.612685
4935	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:50.624491
4936	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:50.643038
4937	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:50.655105
4938	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:51.809737
4939	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:51.889596
4940	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:52.262435
4941	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:53.811948
4942	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:53.824564
4947	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:54.4008
4948	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:54.974753
4949	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:57.976552
4950	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:58.09784
4951	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:58.256758
4952	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:58.73792
4953	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:58.754504
4954	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:58.836701
4955	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:01:00.894352
4956	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:01:01.423344
5107	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:05.487305
5108	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:06.0226
5109	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:06.040665
5110	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:06.483773
5111	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:06.49603
5112	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:07:34.200214
5113	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:07:34.212096
5114	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:38.858877
5115	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:07:38.874723
5228	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:15:42.556368
5493	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:28:24.730822
5916	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:48.39886
6033	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:38:50.612644
6115	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 10:01:50.803391
6116	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 10:01:50.851005
6244	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:37.346539
6245	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:37.842926
6246	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:37.91572
6247	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:39.286922
6248	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:39.956354
6251	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:41.125437
6252	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:41.6636
6253	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:42.512551
6254	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:43.129598
6257	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:44.58823
6261	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:49.749806
6262	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:50.073953
6263	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:49:50.897976
6264	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:49:51.170568
6419	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:07:19.588816
6420	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:07:19.908177
6421	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:07:34.091778
6422	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:07:34.149838
6477	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:15:16.128101
6479	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:15:18.598001
6515	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:18:12.260079
6518	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:18:22.26048
6520	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:18:27.246859
6574	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:34.496062
4527	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 08:10:59.330548
4560	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:32.797061
4754	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:22.457105
4755	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:22.535062
4756	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:22.653449
4757	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:22.665206
4758	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:24.392174
4759	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:24.409419
4760	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:26.902192
4761	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:26.915259
4762	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:28.058983
4763	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:28.070597
4764	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:29.099524
4765	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:29.130034
4766	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:34.069959
4767	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:34.088339
4768	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:37.554245
4769	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:37.612034
4770	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:39.097787
4771	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:39.112993
4943	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:53.831347
4944	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:53.887083
4945	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:00:54.38593
4946	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:00:54.400369
5116	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:38.8822
5229	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:15:42.556937
5230	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:15:43.477754
5231	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:15:43.493881
5494	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:28:24.732146
5495	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:28:50.188137
5917	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:48.398924
5925	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:51.313537
5927	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:01.551334
5928	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:09.619795
6034	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:38:50.613404
6117	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 10:08:32.612419
6267	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:50:51.7198
6268	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:50:51.783741
6269	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:51:40.964477
6270	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:51:41.038853
6271	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:51:55.555121
6272	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:51:55.622578
6273	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:21.814416
6274	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:22.155104
6275	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:34.806799
6276	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:35.279823
6277	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:38.506568
6278	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:39.009133
6423	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:07:55.539591
6424	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:07:55.595886
6425	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:08:15.933542
6426	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:08:15.948993
6429	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:08:16.766584
6480	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:15:33.601346
6516	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:18:12.265543
6517	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:18:22.260307
6519	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:18:27.246673
6575	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:39.467787
6631	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:26:01.853892
6634	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:26:01.880249
6636	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:26:06.874047
6638	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:26:11.86881
6674	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:31:34.715273
6675	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:31:34.772862
6676	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:31:34.774249
6710	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:35:15.807157
6738	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:39:00.962679
6739	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:39:01.01664
6748	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:46:04.629916
6763	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:31.137778
6794	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:48:11.697724
6798	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:48:46.239325
6799	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:48:46.774074
6804	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:09.693379
6805	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:11.888032
6806	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:12.864592
6807	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:14.286706
6808	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:15.06932
6809	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:15.459902
6810	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:16.15865
6811	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:16.505909
6812	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:17.419221
6813	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:17.526776
6814	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:18.569816
6815	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:19.0364
6816	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:20.090645
6817	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:20.430167
6818	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:21.40871
4528	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 08:10:59.335416
4561	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:32.799073
4772	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:56.910442
4773	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:56.987379
4774	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:57.550271
4775	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:57.584196
4776	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:57.650348
4777	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:57.748668
4778	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:33:59.729754
4779	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:33:59.748547
4780	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:00.212663
4781	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:00.224663
4782	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:01.899417
4783	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:01.910909
4784	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:03.230281
4785	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:03.517733
4786	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:03.557698
4787	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:03.595294
4957	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:01:50.464562
5117	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:07:38.884438
5118	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:07:39.195531
5119	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:07:39.207996
5120	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:07:40.288578
5121	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:07:40.300135
5122	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:07:41.172552
5123	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:07:41.185208
5124	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:07:44.242248
5125	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:07:44.25444
5232	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:15:55.509335
5233	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:15:55.574502
5496	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:28:50.806811
5497	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:28:50.860068
5498	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:28:51.665874
5499	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:28:51.724491
5500	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:28:52.684686
5501	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:28:52.760482
5502	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:28:53.553773
5503	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:28:53.626408
5509	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:02.385841
5510	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:02.398385
5511	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.21925
5512	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.232283
5513	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.258493
5514	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.338227
5516	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.352431
5919	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:48.404824
5920	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:48.713054
5921	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:32:49.870062
5922	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:32:49.882931
5923	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:32:51.300261
5924	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:32:51.31301
6035	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:39:51.466103
6036	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:39:51.537797
6037	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:39:51.550444
6118	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:22:47.636226
6119	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:22:47.912227
6279	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:41.418825
6280	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:42.240941
6281	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:45.5281
6282	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:46.186224
6283	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:51.787538
6284	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:51.79955
6285	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:51.846832
6286	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:51.858773
6287	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:51.882227
6288	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:52.504382
6289	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:53.283635
6290	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:53.295793
6291	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:53.322725
6292	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:53.814371
6293	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:55.740058
6294	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:57.604253
6295	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:58.283495
6296	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:58.295291
6297	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:58.316493
6298	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:58.756606
6305	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:00.480025
6306	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:00.494732
6309	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:00.508172
6310	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:00.980918
6311	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:01.547111
6312	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:02.031704
6317	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:02.848059
6318	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:02.970694
6319	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:05.289492
6320	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:05.610361
6323	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:08.149264
6324	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:08.537067
4529	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:11:21.98673
4562	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:32.801707
4563	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:33.085985
4564	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:34.378811
4565	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:34.401688
4566	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:34.875682
4788	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:19.108959
4789	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:19.191466
4790	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:24.391306
4791	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:24.459603
4792	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:28.26702
4793	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:28.324081
4794	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:28.571591
4795	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:28.61764
4796	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:29.269835
4797	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:29.297578
4798	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:32.289116
4799	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:32.335018
4958	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:01:51.438394
4959	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:01:51.443247
4966	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:01:57.780315
4967	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:03.086973
4968	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:03.143943
4969	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:03.210922
4970	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:03.90263
4971	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:02:03.95833
5126	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:07:47.542844
5128	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:47.597974
5234	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:18:21.271134
5235	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:23.972195
5238	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:24.090909
5239	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:24.177916
5242	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:24.573582
5243	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:24.686153
5246	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:24.743183
5248	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:24.867858
5250	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:25.068222
5251	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:25.229998
5254	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:25.905676
5255	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:26.013398
5258	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:26.068769
5260	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:26.202027
5262	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:26.388903
5263	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:26.444269
5265	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:26.661201
5268	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:26.731716
5270	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:27.378175
5272	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:28.347309
5273	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:28.401493
5276	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:29.583349
5278	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:29.812055
5279	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:30.065347
5282	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:30.120279
5284	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:30.650661
5285	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:31.091423
5287	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:31.703445
5290	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:31.986354
5291	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:32.063268
5294	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:32.32589
5296	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:32.415515
5297	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:32.510856
5300	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:33.102681
5301	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:33.37871
5302	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:33.476357
5304	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:33.587111
5306	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:33.710438
5308	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:34.071377
5311	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:34.14188
5312	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:35.569326
5314	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:35.987952
5317	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:38.064785
5319	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:38.117802
5321	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:38.796131
5323	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:38.847868
5325	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:39.363333
5326	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:39.471931
5328	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:39.584885
5330	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:39.759791
5333	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:40.018867
5335	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:40.525644
5337	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:40.586534
5338	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:40.692161
5342	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:40.883261
5343	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:40.936055
5346	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:41.228613
5347	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:41.548543
5349	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:42.304895
5350	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:42.480255
4530	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:11:21.989016
4567	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:46.253507
4568	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:24:52.50669
4569	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:24:52.897968
4570	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:02.738629
4571	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:03.089248
4572	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:07.538798
4573	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:07.939614
4574	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:12.370588
4575	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:12.408717
4576	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:12.456521
4577	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:12.698855
4578	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:19.72944
4579	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:20.51953
4580	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:22.349929
4581	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:22.742612
4582	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:22.910483
4583	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:23.815398
4584	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:24.019604
4585	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:24.046425
4586	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:26.3575
4587	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:26.726705
4800	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:42.563518
4801	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:42.67766
4802	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:34:49.729976
4803	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:34:49.805736
4960	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:01:51.449155
4961	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:01:52.316957
4962	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:01:52.843223
4963	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:01:52.948396
4964	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:01:57.765764
4965	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:01:57.780169
4972	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:02:03.988764
4974	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:02:04.001877
5127	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:47.596913
5236	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:23.977673
5237	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:24.090545
5240	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:24.17898
5241	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:24.572798
5244	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:24.686524
5245	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:24.742801
5247	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:24.86774
5249	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:25.068059
5252	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:25.230311
5253	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:25.905385
5256	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:26.013971
5257	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:26.068403
5259	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:26.201872
5261	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:26.388784
5264	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:26.44442
5266	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:26.661202
5267	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:26.731581
5269	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:27.377987
5271	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:28.347154
5274	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:28.401505
5275	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:29.583211
5277	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:29.811903
5280	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:30.065588
5281	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:30.120246
5283	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:30.650548
5286	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:31.091716
5288	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:31.703585
5289	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:31.986034
5292	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:32.063403
5293	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:32.325545
5295	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:32.415349
5298	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:32.511179
5299	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:33.10249
5303	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:33.476499
5305	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:33.58822
5307	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:33.710581
5309	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:34.071425
5310	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:34.141693
5313	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:35.569963
5315	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:35.988019
5316	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:38.06464
5318	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:38.117427
5320	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:38.796057
5322	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:38.847726
5324	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:39.363199
5327	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:39.472019
5329	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:39.585026
5331	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:39.759937
5332	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:40.018669
5334	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:40.524053
5336	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:40.586452
5339	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:40.693003
5340	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:40.830389
4531	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:12:04.863185
4588	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:25:45.425879
4589	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:25:45.705522
4804	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:35:19.398829
4805	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:35:19.464528
4806	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:35:29.393748
4807	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:35:29.406306
4808	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:35:31.900198
4809	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:35:31.920725
4810	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:35:39.729934
4811	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:35:39.783559
4812	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:35:47.652204
4813	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:35:47.665023
4973	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:02:03.995041
4975	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:02:04.002001
4976	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:04.00394
5129	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:07:47.598092
5130	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:07:47.630957
5131	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:07:47.644529
5132	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:57.539407
5133	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:57.553422
5134	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:07:59.800554
5135	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:07:59.814336
5136	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:08:05.358106
5137	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:08:05.416203
5138	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:08:05.429987
5143	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:08:07.713509
5341	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:40.882883
5344	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:40.936429
5345	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:41.227625
5348	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:42.304723
5351	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:42.480388
5353	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:42.68937
5355	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:42.875018
5357	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:43.356614
5358	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:43.649225
5359	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:43.713826
5362	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:44.308737
5363	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:44.527071
5365	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:44.579781
5368	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:44.75074
5369	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:45.320922
5371	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:45.375581
5504	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:28:53.632777
5505	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:28:53.680739
5506	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:28:53.737669
5507	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:28:54.042926
5508	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:28:58.550525
5929	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:09.710535
5930	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:10.197442
5931	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:12.238384
5932	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:12.294294
5933	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:33:17.633786
5934	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:33:17.646846
5935	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:17.814877
5936	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:17.879111
5937	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:17.893379
5938	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:18.257532
5939	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:20.700584
5940	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:20.998207
5941	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:33:22.725015
5942	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:33:22.737393
5943	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:23.086981
5944	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:23.392783
5945	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:25.295822
5946	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:25.352728
5947	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:33:26.579713
5948	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:33:26.944962
5949	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:33:29.458929
5950	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:33:29.831631
5951	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:33:31.808837
5952	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:33:31.82162
5953	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:32.1292
5954	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:32.55351
5955	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:34.248873
5956	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:34.289436
5957	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:34.874157
5958	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:34.887868
5959	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:33:37.247537
5960	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:33:37.259556
5961	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:33:41.884307
6038	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:39:51.556543
6039	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:39:51.591498
6040	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:39:51.937873
6041	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:39:55.779374
6042	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:39:56.09375
6043	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:40:04.726168
6044	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:40:05.025786
4532	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:12:04.865756
4533	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:13:05.424057
4590	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:26:33.479779
4591	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:26:33.537027
4592	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:26:33.810441
4593	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:26:33.838936
4594	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:26:34.391093
4595	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:26:34.413793
4596	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:26:37.529706
4597	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:26:37.542537
4598	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:26:39.09212
4599	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:26:39.104043
4814	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:35:57.705895
4815	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:36:06.011146
4816	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:36:06.022784
4977	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:04.010583
4981	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:02:08.791724
5139	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:08:05.436399
5140	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:08:07.339231
5141	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:08:07.351707
5142	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:08:07.700216
5144	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:08:07.713627
5352	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:42.689004
5354	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:42.874734
5356	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:43.356451
5360	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:43.714138
5361	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:44.308538
5364	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:44.527556
5366	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:44.580007
5367	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:44.750001
5370	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:45.32108
5372	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:45.375722
5515	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.349028
5517	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.353224
5546	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:11.3584
5547	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:13.335076
5548	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:13.354208
5551	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:13.377536
5552	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:13.687572
5553	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:14.975547
5554	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:15.236609
5555	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:29:19.826952
5556	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:29:19.850281
5557	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:31.608311
5558	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:29:31.802443
5962	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:33:41.950291
5963	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:34:09.748132
5973	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:34:17.26502
6045	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:44:10.974405
6046	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:44:11.390438
6120	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:23:27.173035
6121	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:23:27.419907
6299	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:59.441244
6300	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:59.452499
6301	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:59.469563
6302	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:59.482889
6303	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:52:59.499848
6304	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:52:59.892772
6307	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:00.494856
6308	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:00.507943
6313	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:02.517756
6314	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:02.529216
6315	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:02.541227
6316	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:02.815477
6321	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:08.137093
6322	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:08.149149
6325	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:09.54652
6326	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:09.559089
6427	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:08:15.959759
6431	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:08:16.766843
6481	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:15:33.607833
6521	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:18:27.261525
6523	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:18:39.334454
6525	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:18:44.344009
6532	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:18:46.927212
6534	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:18:49.338402
6537	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:18:54.342376
6538	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:18:59.301569
6539	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:19:04.366236
6542	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:19:14.313934
6578	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:49.584245
6579	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:54.582754
6581	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:59.549163
6584	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:21:04.469137
6632	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:26:01.85715
6633	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:26:01.879932
6635	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:26:06.873176
6637	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:26:11.868809
4534	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:13:05.443731
4600	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:02.985774
4601	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:03.036049
4602	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:03.084446
4603	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:03.520597
4604	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:04.907485
4605	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:05.349119
4606	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:06.948847
4607	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:07.648859
4608	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:09.256839
4609	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:09.747159
4610	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:09.883707
4611	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:09.896097
4817	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:39:16.142957
4818	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:39:16.419685
4978	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:04.011134
4979	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:04.04088
4980	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:02:08.779187
4982	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:02:08.792089
4983	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:10.554654
4984	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:02:11.418379
4985	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:12.364416
4986	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:14.925381
4987	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:14.937623
4988	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:14.95107
4989	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:15.327575
4990	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:32.689805
4991	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:32.744218
4992	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:35.470157
4993	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:36.185486
4994	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:37.036969
4995	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:02:38.596428
4996	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:02:38.924424
4997	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:02:48.217824
4998	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:48.411139
5145	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:08:07.719654
5146	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:08:24.816182
5147	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:08:24.829732
5148	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:08:31.541904
5149	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:08:31.555527
5373	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:45.54573
5376	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:45.952519
5377	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:46.460263
5380	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:46.657639
5382	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:47.116197
5383	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:47.175681
5386	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:47.339119
5388	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:47.523505
5389	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:47.604237
5392	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:48.007926
5393	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:48.062263
5395	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:48.115243
5518	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.368125
5542	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:11.356818
5964	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:34:09.753853
5965	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:34:09.897117
5966	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:34:09.918803
5967	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:34:13.292013
5968	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:34:13.363429
5969	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:34:15.541863
5970	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:34:15.577532
5971	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:34:17.050034
5972	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:34:17.194355
5974	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:34:17.265208
5975	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:34:21.425817
5976	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:34:21.438542
5977	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:34:49.260151
5978	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:34:49.371907
5979	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:34:54.041333
5980	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:34:54.254428
5981	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:34:54.331772
6047	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:46:29.105233
6048	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:46:29.396645
6049	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:46:29.555737
6050	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:46:36.494077
6051	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:46:36.806312
6052	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:46:39.400667
6122	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:23:46.120196
6123	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:23:46.13266
6124	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:23:46.172091
6125	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:23:46.30575
6126	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:23:46.323751
6127	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:23:46.634544
6327	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:53:09.559224
6328	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:53:09.869118
6329	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:53:15.464465
6330	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:53:15.479281
6428	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:08:15.959964
4535	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:13:42.175368
4612	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:09.902809
4613	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:09.927823
4614	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:11.138462
4615	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:11.378788
4616	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:20.188094
4617	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:20.272632
4618	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:22.576643
4619	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:22.910487
4620	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:29.098168
4621	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:29.113438
4622	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:31.88353
4623	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:31.896066
4819	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:40:00.996833
4820	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:40:01.619282
4821	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:40:10.705321
4822	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:40:15.11243
4999	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:02:48.44159
5000	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:48.816307
5001	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:49.94369
5002	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:02:52.671425
5003	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:02:52.687257
5006	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:02:52.700762
5007	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:02:53.140429
5008	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:03:22.694378
5009	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:03:22.748
5010	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:03:52.373993
5011	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:03:52.794311
5012	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:04:00.95859
5150	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:08:31.560335
5374	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:45.546606
5375	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:45.951537
5378	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:46.460493
5379	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:46.657499
5381	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:47.116054
5384	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:47.175853
5385	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:47.338326
5387	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:47.523361
5390	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:47.604384
5391	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:18:48.007741
5394	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:18:48.115066
5519	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.369651
5529	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.970812
5533	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:29:05.399057
5535	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:05.413999
5537	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:05.433465
5538	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:05.44548
5545	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:11.358288
5549	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:13.354753
5550	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:13.377333
5982	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:34:54.336956
6053	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:46:39.486317
6054	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:46:49.40439
6128	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:24:17.419132
6129	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:24:17.726749
6331	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:54:19.605419
6332	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:54:19.660503
6333	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:54:55.527272
6334	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:54:55.585255
6335	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:55:06.570811
6336	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:55:07.134721
6430	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:08:16.76677
6432	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:08:17.100882
6433	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:08:38.937144
6482	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:15:53.618173
6522	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:18:27.261734
6585	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:29.782887
6588	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:36.824109
6589	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:21:39.45343
6590	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:21:39.594218
6591	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:41.097783
6639	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:26:51.066416
6678	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:31:34.78995
6679	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:31:35.121588
6680	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:31:36.866516
6681	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:31:37.464506
6682	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:31:55.654911
6683	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:31:55.709259
6684	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:31:55.950742
6685	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:31:55.978667
6686	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:32:04.445666
6687	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:32:04.509645
6691	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:32:06.967636
6711	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:35:15.809505
6712	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:35:21.007545
6713	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:35:41.021499
6740	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:40:26.043621
6741	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:40:26.100719
4536	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:13:42.175926
4624	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:42.569765
4625	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:42.813368
4626	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:42.894529
4627	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:43.177372
4628	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:43.292966
4629	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:43.40221
4630	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:27:44.90836
4631	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:27:45.110991
4823	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:40:23.519048
4824	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:40:24.30962
4825	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:40:25.197131
4826	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:40:25.503569
4827	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:40:25.518159
4828	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:40:26.542324
4829	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:40:27.388253
4830	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:40:27.52614
4831	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:40:27.67348
4832	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:40:29.743028
4833	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:40:30.696256
5004	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:02:52.69314
5005	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:02:52.700449
5151	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:08:31.56606
5152	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:08:34.208326
5153	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:08:34.219648
5154	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:09:15.472956
5155	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:09:17.430942
5158	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:09:25.702989
5159	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:09:25.789628
5160	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:09:25.822643
5161	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:09:26.285718
5396	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:19:13.692109
5399	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:19:18.838358
5520	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.370026
5522	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.44933
5523	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.691481
5524	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.910976
5525	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.925439
5526	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.937676
5527	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:03.950596
5528	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.970114
5532	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:05.398949
5543	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:11.357011
5983	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:35:04.398603
5985	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:35:11.295318
6055	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:46:49.485834
6056	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:46:52.70231
6057	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:46:52.85196
6058	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:46:52.88537
6059	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:46:53.227534
6060	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:46:59.40752
6130	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:24:31.76021
6131	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:24:32.004953
6337	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:55:35.476786
6338	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:55:35.53496
6339	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:55:53.739479
6340	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:55:53.79387
6341	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:56:45.945598
6342	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 09:56:46.434839
6434	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-03-03 10:08:38.944356
6435	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:09:49.981917
6483	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:15:53.624754
6524	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:18:39.340008
6526	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:18:44.344409
6527	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:18:46.641457
6528	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:18:46.654412
6529	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:18:46.669645
6530	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:18:46.703501
6531	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:18:46.914562
6533	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:18:46.927365
6535	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:18:49.338848
6536	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:18:54.341536
6586	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-03-03 10:21:29.793302
6587	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:36.367776
6640	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-03-03 10:26:51.069138
6688	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:32:04.51556
6689	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:32:05.019013
6690	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:32:06.954695
6692	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:32:06.967933
6693	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:32:07.666675
6694	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:32:35.675799
6695	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:32:35.733982
6714	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:35:56.611454
6715	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:35:56.675579
6720	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:36:01.7467
6721	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:36:02.140091
6722	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:36:13.105835
6723	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:36:13.52911
4537	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:14:31.695447
4632	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:28:07.289274
4633	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:28:07.343963
4634	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:28:16.885605
4635	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:28:16.897912
4834	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:40:46.158013
5013	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:04:01.327383
5014	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:04:08.487944
5156	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:09:17.523279
5157	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:09:22.946946
5397	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:19:13.696124
5398	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:19:18.837453
5400	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:19:23.72061
5402	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:19:28.715521
5404	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:19:38.716288
5521	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.370212
5530	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:03.970943
5531	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:05.372515
5534	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:29:05.399106
5536	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:05.4143
5539	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:05.446353
5540	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:07.523421
5541	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:11.235013
5544	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:11.357122
5984	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:35:04.400222
5986	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:35:11.693578
5987	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:35:12.301484
6061	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:46:59.492257
6062	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:47:09.412391
6132	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 10:28:33.580167
6343	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:57:45.72592
6344	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:57:45.78216
6436	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:10:04.943507
6439	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:10:09.907655
6441	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:10:14.939007
6442	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:10:19.895325
6444	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:10:24.931344
6484	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:16:10.210521
6486	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:16:10.239733
6489	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:16:15.232823
6493	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:16:20.233186
6494	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:22.157644
6495	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:16:22.17015
6497	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:25.229828
6498	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:38.000729
6500	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:16:42.996567
6503	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:16:48.001983
6540	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:19:04.37586
6541	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:19:09.304588
6592	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:42.751318
6593	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:43.533262
6594	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:44.372493
6595	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:45.262599
6596	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:45.984528
6597	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:46.317716
6598	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-03-03 10:21:46.902439
6641	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:27:50.952222
6642	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:27:51.01821
6696	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:32:35.74197
6716	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:35:56.681367
6717	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:35:56.922899
6718	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:36:01.72219
6719	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:36:01.746491
6742	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-03-03 10:42:48.242805
6743	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-03-03 10:42:48.252313
6749	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:46:23.927565
6764	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:31.138173
6795	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:48:31.31955
6800	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:49:05.711427
6801	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:49:06.370443
6819	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:22.027055
6820	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:22.88794
6821	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:23.436361
6822	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:24.252958
6823	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:24.694967
6824	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:25.565176
6825	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:25.933958
6826	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:26.764216
6827	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:27.067024
6828	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:27.955266
6829	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:28.405253
6830	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:29.183235
6831	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:29.645471
6832	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:30.442156
6833	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:30.718867
6834	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:31.61635
6835	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:31.745468
6836	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.123863
4538	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:14:31.700813
4636	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:28:32.435794
4637	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:28:32.461147
4835	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:40:48.089384
4836	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:40:49.798638
5015	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:04:08.553499
5162	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:09:55.294846
5163	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:09:55.376799
5164	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:09:58.500999
5165	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:09:58.519768
5401	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:19:23.727196
5403	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:19:28.715703
5405	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:19:38.71651
5406	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:19:48.725527
5559	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:29:31.811073
5564	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:29:35.042822
5565	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:37.758024
5566	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:37.769779
5567	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:38.739434
5568	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:38.755493
5569	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:39.241517
5570	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:39.254545
5571	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:41.721352
5572	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:41.776506
5573	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:41.931197
5575	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:29:41.944607
5583	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:44.8748
5988	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:35:12.333387
5989	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:35:12.440386
5990	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:35:12.476746
5991	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:35:12.585568
5992	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:35:12.854033
5993	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:35:19.043335
5998	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:35:19.297518
6063	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:47:09.495195
6064	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:47:19.418335
6133	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:30:55.97603
6345	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 09:58:06.509946
6346	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:58:13.249708
6347	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:58:13.562931
6348	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:58:40.737176
6349	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:58:41.156194
6350	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:58:55.597086
6351	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:58:55.681088
6352	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 09:58:55.908331
6353	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 09:58:55.920796
6354	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:01:07.122535
6437	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:10:04.944119
6438	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:10:09.907499
6440	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:10:14.938829
6443	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:10:19.896833
6445	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:10:24.931527
6485	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:10.215469
6487	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:10.240175
6488	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:15.23277
6490	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:17.528558
6491	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:16:17.542301
6492	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:20.231741
6496	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:16:25.229682
6543	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:19:14.325689
6544	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:19:19.350729
6546	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:19:24.437918
6548	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:19:24.524742
6599	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:46.970853
6600	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-03-03 10:21:47.00527
6601	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:47.923393
6602	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-03-03 10:21:48.922285
6603	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:48.976229
6604	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-03-03 10:21:49.012318
6605	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-03-03 10:21:49.459229
6606	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:49.521213
6607	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:50.077242
6608	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:50.946668
6609	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:52.001107
6610	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:52.061423
6611	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:52.131945
6612	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-03-03 10:21:53.177417
6613	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:53.197129
6614	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:53.977379
6615	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:54.0086
6616	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:54.010264
6617	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:54.015413
6623	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:56.891553
6643	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:29:44.346516
6697	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:32:35.743721
6698	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:32:55.953706
6699	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:32:56.008747
6700	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:32:58.829418
4539	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:15:59.895426
4638	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:28:42.544839
4639	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:28:42.644653
4837	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:43:47.56347
4838	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:43:47.679129
5016	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:04:08.554315
5017	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:04:08.681156
5018	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:04:09.19646
5019	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:04:09.581101
5020	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:04:09.64469
5166	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:09:58.531294
5407	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:19:48.727498
5560	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:31.811272
5561	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:34.247877
5562	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:34.260303
5563	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:29:35.042642
5574	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:41.944448
5994	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:35:19.053131
5999	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:35:19.297665
6065	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:47:19.497359
6066	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:47:24.419019
6067	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:47:25.048565
6068	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:47:26.617464
6069	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:47:27.092088
6070	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:47:29.41983
6134	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 10:31:09.410349
6355	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:01:07.143929
6356	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:01:55.493175
6357	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:01:55.548244
6358	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:02:15.58632
6359	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:02:15.598621
6446	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:13:15.48956
6447	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:13:15.544359
6499	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:16:38.00655
6501	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:42.996736
6502	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:16:48.00176
6545	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:19:19.350935
6547	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:19:24.524547
6549	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:19:34.338425
6618	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:54.019092
6624	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:56.891818
6644	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:29:52.972297
6645	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:29:54.614326
6646	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:30:02.338046
6647	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:30:02.387853
6701	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:32:58.842437
6724	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:36:30.963943
6725	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:36:31.030481
6726	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:36:35.672357
6727	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:36:35.742323
6728	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:36:37.168214
6729	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:36:40.878781
6730	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:36:48.011415
6731	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:36:48.450761
6732	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:36:50.221683
6733	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:37:01.533786
6734	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:37:02.001563
6735	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:37:09.972726
6744	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:44:37.639508
6745	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:44:37.697057
6750	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:17.772583
6751	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:18.161178
6752	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:20.977052
6753	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:21.287322
6754	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:25.841328
6755	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:25.857482
6762	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:31.123948
6765	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:31.140224
6766	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:32.484967
6767	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:32.616184
6768	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:41.193484
6769	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:41.250948
6770	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:42.165968
6771	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:42.210465
6772	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:43.966455
6773	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:44.069249
6774	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:44.800979
6775	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:44.881009
6776	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:45.572219
6777	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:45.603137
6778	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:47.128815
6779	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:47.16286
6788	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:47:57.13004
6789	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:47:57.4923
6790	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:48:03.549659
6791	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:48:04.008712
6792	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:48:04.041705
6793	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:48:04.925902
4540	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:15:59.950328
4839	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:44:13.367512
5021	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:05:23.522361
5167	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:09:58.531375
5168	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:09:59.178214
5169	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:09:59.190122
5170	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:09:59.321071
5171	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:09:59.333757
5172	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:10:07.140859
5173	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:10:07.195742
5174	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:10:07.448455
5175	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:10:07.461888
5176	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:10:19.028497
5177	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:10:19.041305
5178	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:10:19.579829
5179	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:10:19.593319
5180	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:10:20.309271
5181	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:10:20.321164
5182	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:10:26.502409
5183	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:10:26.555797
5408	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:20:20.065679
5576	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:29:41.949577
5577	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:42.517462
5578	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:42.529296
5579	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:42.677456
5580	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:42.689857
5581	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:44.861955
5582	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:29:44.873994
5584	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:29:44.875408
5585	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:44.92501
5586	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:44.94038
5587	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:45.642436
5588	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:45.654899
5589	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:29:47.635587
5590	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:29:47.648115
5591	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:49.238673
5592	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:49.251273
5593	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:52.53972
5594	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:52.554636
5595	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:29:54.238512
5596	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:29:54.253954
5597	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:29:54.661967
5598	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:29:54.675773
5599	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:29:57.632357
5600	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:29:57.688795
5601	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:30:01.078974
5602	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:30:01.091177
5603	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:30:12.066641
5604	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:30:12.125706
5605	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:30:19.249487
5606	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:30:19.271128
5607	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:30:25.672669
5608	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:30:25.731759
5609	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:30:34.239839
5610	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:30:34.259235
5611	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:30:40.337853
5995	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:35:19.054885
6000	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:35:19.297672
6071	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:47:29.502137
6072	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:47:33.263385
6073	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:47:33.351169
6074	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:47:37.589992
6075	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:47:37.663454
6076	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:47:39.423969
6135	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 10:31:09.537464
6136	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 10:31:18.197672
6360	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:21.904214
6448	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:13:33.51704
6450	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:13:33.559146
6453	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:13:43.551857
6455	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:13:48.545839
6456	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:13:55.660569
6457	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:13:55.671925
6458	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:14:08.570478
6460	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:14:13.589899
6464	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:14:23.573342
6504	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:17:06.909571
6550	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:19:39.332974
6551	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:19:44.316101
6619	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:54.019899
6622	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:56.891086
6648	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:30:02.397755
6649	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:30:02.761761
6650	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:30:04.198295
6651	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:30:04.21299
6652	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:30:05.418996
6653	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:30:05.430565
6654	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:30:05.431886
4541	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:23:36.01468
4840	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:44:26.599901
5022	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:05:23.752655
5023	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:05:23.768813
5024	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:05:26.333361
5025	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:05:26.400726
5026	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:05:29.644851
5027	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:05:30.05077
5028	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:33.719606
5029	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:33.775851
5030	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:33.91146
5031	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:33.988363
5032	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:37.057888
5033	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:37.360888
5034	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:40.194644
5035	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:40.284922
5036	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:42.431318
5037	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:42.444487
5040	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:42.456451
5041	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:42.753535
5042	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:49.442752
5043	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:49.495719
5044	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:49.654545
5045	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:49.749248
5046	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:52.531592
5047	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:52.544007
5048	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:52.561564
5049	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:53.092953
5050	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:56.749844
5051	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:56.763824
5052	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:56.992426
5053	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:57.075108
5054	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:03.649989
5055	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:03.705238
5062	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:07.773769
5063	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:07.856028
5184	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:10:47.431028
5185	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:10:47.484641
5409	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:20:20.071575
5410	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:20:49.63963
5612	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:30:40.477567
5613	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:30:41.078267
5614	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:30:41.132434
5615	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:30:42.761809
5616	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:30:42.774502
5617	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:44.827996
5996	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:35:19.055543
5997	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:35:19.249038
6001	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:35:19.298087
6077	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:47:39.47623
6137	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 10:31:30.275126
6361	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:05:22.062078
6374	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:05:26.751916
6449	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:13:33.522968
6451	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:13:33.55916
6452	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:13:43.551474
6454	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:13:48.545811
6505	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:17:11.43944
6506	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:17:11.78269
6552	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:19:44.408686
6555	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:19:49.410172
6558	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:19:59.380447
6559	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:04.312271
6560	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:04.413637
6563	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:09.429159
6566	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:14.416138
6568	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:19.431915
6569	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:29.491753
6572	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:20:33.685365
6573	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:34.490297
6576	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:39.467804
6577	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:20:49.578618
6580	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:54.582769
6582	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:20:59.549225
6583	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:21:04.469106
6620	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:54.020458
6621	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-03-03 10:21:56.80928
6625	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:56.891959
6626	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-03-03 10:21:56.91984
6655	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:30:05.918476
6656	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:30:08.116623
6657	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:30:08.128744
6658	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:30:08.141638
6659	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:30:08.714068
6660	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:30:10.987386
6661	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:30:11.00134
6662	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:30:11.017297
6663	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:30:11.691087
4542	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:23:36.074086
4543	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:23:41.492644
4841	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:44:26.61243
5038	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:05:42.450469
5039	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:05:42.455855
5186	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:11:29.189633
5187	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:11:29.240348
5411	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:20:49.867759
5412	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:21:22.114914
5618	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:45.997311
5619	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:46.002678
5620	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:46.01493
5621	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:46.470372
5629	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:47.407168
5633	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:47.433412
5634	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:48.015607
5635	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:48.070511
5636	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:48.082631
5637	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:48.094658
5638	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:48.653195
5639	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:48.665715
5640	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:48.67742
5641	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:48.727472
5642	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:49.306875
5643	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:49.51853
5644	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:50.55722
5645	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:50.717387
5646	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:51.635095
5647	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:51.74486
5648	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:51.761341
5649	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:51.787481
5650	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:52.600845
5651	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:52.6215
5652	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:52.633931
5653	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:30:52.723098
5654	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:30:52.734945
5655	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:52.790284
5656	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:53.598986
5657	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:53.792932
5659	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:53.873945
5660	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:54.692704
5661	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:54.707863
5662	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:54.735505
5663	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:54.812329
5664	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:55.412733
5665	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:55.605045
5666	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:55.621768
5667	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:55.671969
5668	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:56.687034
5669	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:56.707729
5670	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:56.757201
5671	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:56.841042
5672	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:57.401091
5673	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:57.521816
5674	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:57.541549
5675	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:57.635534
5676	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:58.55959
5677	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:58.572534
5678	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:58.586908
5679	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:58.667832
5680	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:59.263334
5681	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:59.378638
5682	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:00.220616
5683	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:00.233355
5684	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:00.262964
5685	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-02-13 09:31:00.293918
5686	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:00.302652
5687	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-02-13 09:31:00.306081
5688	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:00.877933
5689	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:00.940343
5690	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:00.95224
5691	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:00.984146
5692	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:01.523385
5693	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:01.799872
5694	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:02.711957
5695	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:02.726104
5696	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:02.763243
5697	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:02.767714
5698	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-02-13 09:31:03.068025
5699	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:31:03.080674
5700	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:03.272492
5701	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:03.469752
5702	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:04.146914
5703	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:04.269984
5704	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:05.091082
5705	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:05.216806
5706	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:31:05.860828
5707	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:31:05.965184
4342	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.281366
4344	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.294245
4346	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.309643
4348	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.328165
4350	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.348968
4351	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.369646
4354	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.390929
4355	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.411641
4358	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.433486
4359	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.455717
4362	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.478053
4365	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.499501
4368	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.519919
4370	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.539948
4372	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.560343
4374	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.582652
4375	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.605797
4378	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.634373
4380	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.654562
4381	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.67751
4384	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.698583
4385	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:17.717577
4388	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:17.738415
4389	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.785084
4390	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.798401
4393	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.811968
4400	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.837656
4401	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.846041
4403	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.85863
4407	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.875902
4410	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:19.8914
4411	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:19.897593
4416	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.790688
4417	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.810804
4419	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.831865
4422	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.843345
4423	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.865279
4425	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.888408
4428	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.907178
4430	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.923361
4431	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:21.936843
4433	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.947138
4435	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:21.959541
4439	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:22.203579
4442	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:22.217265
4443	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:22.229077
4472	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:27.261281
4474	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:28.13853
4480	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:28.721347
4481	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:29.926422
4485	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:29.967375
4488	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:30.006984
4489	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:31.08379
4492	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:31.133552
4493	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:31.191152
4498	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:10:32.152751
4504	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:10:32.49227
4842	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 08:44:26.629658
4843	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:44:30.507591
4844	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:44:30.563934
4845	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 08:44:34.518999
4846	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 08:44:34.540223
5056	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:03.710499
5057	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:04.056665
5058	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:07.412604
5059	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:07.425259
5060	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:06:07.754563
5061	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:06:07.773454
5188	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:11:40.864652
5189	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:11:40.916047
5190	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:11:45.099297
5191	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:11:45.11337
5413	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:21:34.613019
5414	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:21:34.667528
5415	PORTE_01	{"b": 1, "id": "PORTE_01"}	2026-02-13 09:22:00.288555
5416	PORTE_01	{"b": 0, "id": "PORTE_01"}	2026-02-13 09:22:00.34472
5622	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:46.490898
5623	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:46.498101
5624	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:47.344511
5625	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:47.358823
5626	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:47.371027
5627	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:47.382743
5628	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:47.395184
5630	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:47.407334
5631	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:47.420083
5632	PORTE_01	{"f": 1, "id": "PORTE_01"}	2026-02-13 09:30:47.432644
5658	PORTE_01	{"f": 0, "id": "PORTE_01"}	2026-02-13 09:30:53.873791
6002	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-02-13 09:35:19.306806
6840	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.15206
6841	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.164493
6847	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.254883
6852	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.703338
6856	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.829489
6857	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.848009
6858	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:33.175842
6859	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:33.202899
6860	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:33.39255
6862	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:33.467697
6872	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:34.816652
6842	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.165233
6843	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.176841
6844	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.211011
6845	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.227915
6846	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.240274
6848	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.258211
6849	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.273362
6850	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.605566
6851	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.641969
6853	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.703485
6854	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:32.796762
6855	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:32.829007
6861	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:33.467557
6863	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:33.473294
6864	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:33.815223
6865	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:33.878088
6866	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:34.011508
6867	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:34.071594
6868	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:34.506387
6869	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:34.556011
6870	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:34.751413
6871	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:34.816518
6873	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:34.81738
6874	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:34.818679
6875	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:34.829442
6876	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:34.830546
6877	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:34.83072
6878	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:51:35.227206
6879	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:51:35.325401
6880	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:53.527403
6881	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:53.580122
6882	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:53.927499
6883	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:53.94573
6884	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:54.689589
6885	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:54.701354
6886	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:55.094232
6887	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:55.116472
6888	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:55.884398
6889	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:55.898745
6890	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:55.903834
6891	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:55.911441
6892	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:56.327729
6893	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:56.340766
6894	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:57.400535
6895	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:57.491823
6896	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:57.719076
6897	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:57.804141
6898	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:58.240857
6899	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:58.252405
6900	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:58.379035
6901	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:58.403342
6902	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:58.635005
6903	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:58.819105
6904	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:58.955022
6905	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:58.968291
6906	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:59.034384
6907	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:59.118494
6908	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:59.203299
6909	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:59.220122
6910	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:59.329129
6911	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:59.431036
6912	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:59.492224
6913	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:59.508462
6914	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:59.577656
6915	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:59.599971
6916	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:59.68338
6917	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:59.743066
6918	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:59.85194
6919	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:51:59.917698
6920	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:51:59.993759
6921	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.1221
6922	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.189225
6923	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.209838
6924	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.311333
6925	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.324745
6926	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.324876
6927	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.345429
6928	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.346181
6929	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.364425
6930	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.377656
6931	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.377811
6932	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.390734
6933	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.490995
6934	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.522773
6935	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.639401
6936	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.700937
6937	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.730301
6938	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.74245
6939	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.804886
6940	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:00.856293
6941	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:00.953623
6942	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:01.03559
6943	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:01.184308
6944	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:01.238914
6945	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:01.259476
6946	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:01.335806
6947	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:01.586845
6948	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:01.701653
6949	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:01.758137
6950	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:01.770376
6951	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:01.950875
6952	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:01.994507
6953	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:02.167167
6954	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:02.897836
6955	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:02.990503
6956	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:03.229089
6957	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:03.351873
6958	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:04.362425
6959	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:04.455233
6960	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:04.704865
6961	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:04.797254
6962	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:05.959351
6964	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:05.979084
6965	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:06.094252
6966	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:06.113401
6967	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:52:07.720687
6968	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:52:09.966608
6969	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:10.837756
6970	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:12.882471
6971	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:12.894991
6972	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:12.909608
6973	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:15.163017
6974	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:15.852545
6975	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:52:16.749963
6963	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:52:05.978697
6976	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:53:21.183898
6977	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:53:21.237297
6978	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:53:21.242513
6979	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:53:21.462025
6980	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:53:27.659375
6981	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:53:28.09692
6982	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:53:35.758702
6983	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:53:35.816899
6984	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:53:38.074253
6985	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:53:38.594277
6986	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:53:41.802683
6987	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:53:41.815581
6988	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:53:41.821531
6989	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:54:01.872718
6990	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:54:42.159235
6991	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:54:42.589364
6992	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:54:44.91591
6993	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:54:45.275338
6994	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:54:47.250072
6995	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:54:47.668044
6996	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:54:50.279048
6997	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:54:50.66533
6998	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:03.307726
6999	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:03.31548
7000	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:03.328553
7001	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:03.809889
7002	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:05.875311
7003	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:05.888547
7004	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:05.894644
7005	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:06.826098
7006	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:12.838168
7007	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:13.39314
7008	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:14.784935
7009	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:14.797457
7010	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:14.810089
7011	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:15.225197
7012	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:26.582776
7013	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:26.653806
7014	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:26.660276
7015	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:27.461297
7016	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:55:29.150305
7017	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:55:29.283276
7018	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:55:29.320227
7019	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:55:30.614185
7020	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:55:30.640581
7021	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:55:30.667307
7022	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:55:31.477173
7023	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:55:31.505793
7024	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:55:31.534262
7025	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:55:31.562281
7026	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:55:31.590831
7027	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:55:32.156166
7028	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:55:32.187118
7029	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-03 10:55:32.227172
7030	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:32.99139
7031	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:33.022718
7032	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:55:33.022857
7033	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-03 10:55:33.322344
7034	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-03 10:56:36.687766
7035	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-03 10:56:45.339017
7036	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:39:34.994696
7037	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:39:35.075114
7038	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:39:49.508579
7039	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:39:49.539966
7040	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:40:04.131586
7041	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:40:12.421619
7042	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:40:12.50398
7043	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:40:21.349789
7044	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:40:21.404953
7045	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:40:21.478235
7046	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:40:24.377288
7047	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:40:24.620539
7048	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:40:28.198742
7049	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:40:28.213924
7050	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:40:47.614219
7051	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:40:47.626033
7052	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:40:53.729149
7053	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:40:53.866561
7054	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:41:30.771296
7055	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:41:31.121564
7056	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:41:38.764405
7057	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:41:39.349151
7058	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:42:24.414171
7059	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:42:24.461009
7060	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:42:54.777767
7061	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:42:54.86441
7062	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:43:39.742975
7063	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:43:39.796531
7064	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:43:45.444658
7065	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:43:45.45669
7066	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:43:56.238987
7067	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:43:56.326593
7068	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:44:25.453608
7069	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:44:25.51122
7070	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:44:40.399549
7071	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:44:40.75627
7072	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:44:49.09811
7073	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:44:49.10966
7074	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:44:51.59848
7075	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:44:51.655196
7076	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 08:45:04.191258
7077	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 08:45:04.203226
7078	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:46:21.514806
7079	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:46:21.573958
7080	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:46:25.105975
7081	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:46:25.117386
7082	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:46:25.13122
7083	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 08:46:25.136304
7084	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 08:46:31.139484
7085	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 09:56:20.63851
7086	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 09:56:20.694772
7087	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 09:56:23.048174
7088	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 09:56:23.055617
7089	PORTE_02	{"b": 1, "id": "PORTE_02"}	2026-03-05 09:56:30.615792
7090	PORTE_02	{"b": 0, "id": "PORTE_02"}	2026-03-05 09:56:30.623412
7091	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 10:01:20.219843
7092	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 10:01:20.377191
7093	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 10:01:21.518467
7094	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 10:01:21.679652
7095	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 10:01:22.819747
7096	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 10:01:22.956044
7097	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 10:01:24.119231
7098	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 10:01:24.284074
7099	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 10:01:25.418992
7100	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 10:01:25.579853
7101	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 10:01:26.723135
7102	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 10:01:26.883693
7103	PORTE_02	{"f": 0, "id": "PORTE_02"}	2026-03-05 10:01:28.022873
7104	PORTE_02	{"f": 1, "id": "PORTE_02"}	2026-03-05 10:01:28.299774
\.


--
-- Data for Name: ndns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ndns (id, url, type, status, "timestamp") FROM stdin;
emetteur2	http://emetteur2.local	emeteur	\N	2026-03-05 09:56:14.72465
emetteur	http://emetteur.local	emeteur	\N	2026-03-05 10:01:19.486471
PORTE_02	http://PORTE_02.local	recepteur	online	2026-03-05 10:01:19.486754
\.


--
-- Data for Name: passages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passages (id, type, "timestamp", appareil_id, faisceau, duree, date_heure) FROM stdin;
487	SORTIE	2026-02-12 10:39:55.786882	PORTE_02	f	0.698	2026-02-12 10:39:55.786882
488	SORTIE	2026-02-12 10:40:00.13196	PORTE_02	f	0.713	2026-02-12 10:40:00.13196
489	SORTIE	2026-02-12 10:40:09.030725	PORTE_02	f	0.795	2026-02-12 10:40:09.030725
490	SORTIE	2026-02-12 10:40:14.876173	PORTE_02	f	0.855	2026-02-12 10:40:14.876173
491	SORTIE	2026-02-12 10:40:33.14602	PORTE_02	f	0.724	2026-02-12 10:40:33.14602
492	SORTIE	2026-02-12 10:40:40.787693	PORTE_02	f	0.113	2026-02-12 10:40:40.787693
493	SORTIE	2026-02-12 10:40:41.440428	PORTE_02	f	0.587	2026-02-12 10:40:41.440428
494	SORTIE	2026-02-12 10:40:42.479214	PORTE_02	f	0.585	2026-02-12 10:40:42.479214
495	SORTIE	2026-02-12 10:40:51.820141	PORTE_02	f	0.393	2026-02-12 10:40:51.820141
496	SORTIE	2026-02-12 10:41:41.406487	PORTE_02	f	0.818	2026-02-12 10:41:41.406487
497	SORTIE	2026-02-12 10:41:52.973518	PORTE_02	f	2.591	2026-02-12 10:41:52.973518
498	SORTIE	2026-02-12 10:43:18.347686	PORTE_02	f	0.193	2026-02-12 10:43:18.347686
499	SORTIE	2026-02-12 10:43:41.024717	PORTE_02	f	0.1	2026-02-12 10:43:41.024717
500	SORTIE	2026-02-12 10:43:42.789412	PORTE_02	f	1.474	2026-02-12 10:43:42.789412
501	ENTREE	2026-02-12 10:43:52.905224	PORTE_01	f	0.35	2026-02-12 10:43:52.905224
502	SORTIE	2026-02-12 10:43:52.969768	PORTE_02	f	0.367	2026-02-12 10:43:52.969768
503	ENTREE	2026-02-12 10:44:09.915419	PORTE_01	f	0.441	2026-02-12 10:44:09.915419
504	SORTIE	2026-02-12 10:44:10.071768	PORTE_02	f	0.728	2026-02-12 10:44:10.071768
505	ENTREE	2026-02-12 10:44:16.359335	PORTE_01	f	0.535	2026-02-12 10:44:16.359335
506	SORTIE	2026-02-12 10:44:16.443616	PORTE_02	f	0.46	2026-02-12 10:44:16.443616
507	ENTREE	2026-02-12 10:44:32.157007	PORTE_01	f	0.206	2026-02-12 10:44:32.157007
508	SORTIE	2026-02-12 10:44:32.217219	PORTE_02	f	0.225	2026-02-12 10:44:32.217219
509	ENTREE	2026-02-12 10:44:44.111827	PORTE_01	f	0.115	2026-02-12 10:44:44.111827
510	ENTREE	2026-02-12 10:44:49.63262	PORTE_01	f	0.12	2026-02-12 10:44:49.63262
511	ENTREE	2026-02-12 10:44:50.502848	PORTE_01	f	0.113	2026-02-12 10:44:50.502848
512	SORTIE	2026-02-12 10:44:52.582949	PORTE_02	f	0.369	2026-02-12 10:44:52.582949
513	ENTREE	2026-02-12 10:44:52.687752	PORTE_01	f	0.402	2026-02-12 10:44:52.687752
514	SORTIE	2026-02-12 10:44:55.724268	PORTE_02	f	0.785	2026-02-12 10:44:55.724268
515	ENTREE	2026-02-12 10:44:55.948857	PORTE_01	f	1.124	2026-02-12 10:44:55.948857
516	SORTIE	2026-02-12 10:44:57.960132	PORTE_02	f	0.995	2026-02-12 10:44:57.960132
517	ENTREE	2026-02-12 10:44:58.180861	PORTE_01	f	1.513	2026-02-12 10:44:58.180861
518	SORTIE	2026-02-12 10:45:00.06165	PORTE_02	f	0.769	2026-02-12 10:45:00.06165
519	ENTREE	2026-02-12 10:45:00.299206	PORTE_01	f	1.262	2026-02-12 10:45:00.299206
520	SORTIE	2026-02-12 10:45:02.090019	PORTE_02	f	0.648	2026-02-12 10:45:02.090019
521	ENTREE	2026-02-12 10:45:02.285919	PORTE_01	f	1.862	2026-02-12 10:45:02.285919
522	ENTREE	2026-02-12 10:45:20.551426	PORTE_01	f	1.018	2026-02-12 10:45:20.551426
523	ENTREE	2026-02-12 10:45:22.107504	PORTE_01	f	0.186	2026-02-12 10:45:22.107504
524	ENTREE	2026-02-12 10:45:24.496504	PORTE_01	f	0.562	2026-02-12 10:45:24.496504
525	ENTREE	2026-02-12 10:45:25.771926	PORTE_01	f	0.211	2026-02-12 10:45:25.771926
526	ENTREE	2026-02-12 10:45:28.373513	PORTE_01	f	0.516	2026-02-12 10:45:28.373513
527	ENTREE	2026-02-12 10:45:29.336427	PORTE_01	f	0.788	2026-02-12 10:45:29.336427
528	ENTREE	2026-02-12 10:45:31.951336	PORTE_01	f	0.547	2026-02-12 10:45:31.951336
529	ENTREE	2026-02-12 10:45:32.848779	PORTE_01	f	0.164	2026-02-12 10:45:32.848779
530	ENTREE	2026-02-12 10:45:34.611797	PORTE_01	f	0.153	2026-02-12 10:45:34.611797
531	ENTREE	2026-02-12 10:45:36.119504	PORTE_01	f	0.374	2026-02-12 10:45:36.119504
532	ENTREE	2026-02-12 10:45:37.572198	PORTE_01	f	0.543	2026-02-12 10:45:37.572198
533	ENTREE	2026-02-12 10:45:38.705642	PORTE_01	f	0.753	2026-02-12 10:45:38.705642
534	ENTREE	2026-02-12 10:45:40.636214	PORTE_01	f	0.529	2026-02-12 10:45:40.636214
535	ENTREE	2026-02-12 10:45:41.989265	PORTE_01	f	0.627	2026-02-12 10:45:41.989265
536	ENTREE	2026-02-12 10:45:43.355495	PORTE_01	f	0.481	2026-02-12 10:45:43.355495
537	ENTREE	2026-02-12 10:45:44.769917	PORTE_01	f	0.513	2026-02-12 10:45:44.769917
538	ENTREE	2026-02-12 10:45:46.248626	PORTE_01	f	1.103	2026-02-12 10:45:46.248626
539	ENTREE	2026-02-12 10:45:47.580837	PORTE_01	f	0.439	2026-02-12 10:45:47.580837
540	ENTREE	2026-02-12 10:45:48.930241	PORTE_01	f	0.454	2026-02-12 10:45:48.930241
541	ENTREE	2026-02-12 10:45:50.202253	PORTE_01	f	0.258	2026-02-12 10:45:50.202253
542	ENTREE	2026-02-12 10:46:30.259157	PORTE_01	f	0.384	2026-02-12 10:46:30.259157
543	ENTREE	2026-02-12 10:46:31.657766	PORTE_01	f	0.778	2026-02-12 10:46:31.657766
544	ENTREE	2026-02-12 10:48:31.239126	PORTE_01	f	1.032	2026-02-12 10:48:31.239126
545	ENTREE	2026-02-12 10:48:32.492529	PORTE_01	f	1.096	2026-02-12 10:48:32.492529
546	ENTREE	2026-02-12 10:48:33.875113	PORTE_01	f	1.286	2026-02-12 10:48:33.875113
547	ENTREE	2026-02-12 10:48:35.088512	PORTE_01	f	1.078	2026-02-12 10:48:35.088512
548	ENTREE	2026-02-12 10:48:36.290738	PORTE_01	f	0.939	2026-02-12 10:48:36.290738
549	SORTIE	2026-02-12 10:49:41.785525	PORTE_02	f	0.492	2026-02-12 10:49:41.785525
550	SORTIE	2026-02-12 10:50:01.542448	PORTE_02	f	0.382	2026-02-12 10:50:01.542448
551	SORTIE	2026-02-12 10:50:03.228606	PORTE_02	f	0.401	2026-02-12 10:50:03.228606
552	ENTREE	2026-02-12 10:50:03.344545	PORTE_01	f	0.455	2026-02-12 10:50:03.344545
553	SORTIE	2026-02-12 10:50:19.594202	PORTE_02	f	0.241	2026-02-12 10:50:19.594202
554	ENTREE	2026-02-12 10:50:20.648468	PORTE_01	f	0.792	2026-02-12 10:50:20.648468
555	SORTIE	2026-02-12 10:50:20.756634	PORTE_02	f	1.063	2026-02-12 10:50:20.756634
556	SORTIE	2026-02-12 10:50:35.176824	PORTE_02	f	0.99	2026-02-12 10:50:35.176824
557	ENTREE	2026-02-13 08:06:00.496825	PORTE_01	f	1.325	2026-02-13 08:06:00.496825
558	ENTREE	2026-02-13 08:06:03.326704	PORTE_01	f	2.761	2026-02-13 08:06:03.326704
559	ENTREE	2026-02-13 08:06:04.970113	PORTE_01	f	1.631	2026-02-13 08:06:04.970113
560	ENTREE	2026-02-13 08:06:06.136859	PORTE_01	f	0.796	2026-02-13 08:06:06.136859
561	ENTREE	2026-02-13 08:06:09.119136	PORTE_01	f	2.969	2026-02-13 08:06:09.119136
562	ENTREE	2026-02-13 08:06:12.088804	PORTE_01	f	2.904	2026-02-13 08:06:12.088804
563	ENTREE	2026-02-13 08:06:16.137223	PORTE_01	f	3.834	2026-02-13 08:06:16.137223
564	ENTREE	2026-02-13 08:07:45.619666	PORTE_01	f	0.457	2026-02-13 08:07:45.619666
565	ENTREE	2026-02-13 08:07:47.231886	PORTE_01	f	1.592	2026-02-13 08:07:47.231886
566	ENTREE	2026-02-13 08:07:48.016096	PORTE_01	f	0.29	2026-02-13 08:07:48.016096
567	ENTREE	2026-02-13 08:07:50.735264	PORTE_01	f	2.704	2026-02-13 08:07:50.735264
568	ENTREE	2026-02-13 08:07:51.918734	PORTE_01	f	1.171	2026-02-13 08:07:51.918734
569	ENTREE	2026-02-13 08:07:52.547638	PORTE_01	f	0.611	2026-02-13 08:07:52.547638
570	ENTREE	2026-02-13 08:07:54.550375	PORTE_01	f	1.548	2026-02-13 08:07:54.550375
571	ENTREE	2026-02-13 08:08:29.006334	PORTE_01	f	0.73	2026-02-13 08:08:29.006334
572	ENTREE	2026-02-13 08:08:29.954386	PORTE_01	f	0.929	2026-02-13 08:08:29.954386
573	ENTREE	2026-02-13 08:08:45.399323	PORTE_01	b	0.15	2026-02-13 08:08:45.399323
574	ENTREE	2026-02-13 08:08:46.490761	PORTE_01	f	0.626	2026-02-13 08:08:46.490761
575	ENTREE	2026-02-13 08:08:47.178203	PORTE_01	f	0.214	2026-02-13 08:08:47.178203
576	ENTREE	2026-02-13 08:08:48.309293	PORTE_01	f	1.12	2026-02-13 08:08:48.309293
577	ENTREE	2026-02-13 08:08:49.160039	PORTE_01	f	0.817	2026-02-13 08:08:49.160039
578	ENTREE	2026-02-13 08:08:49.908713	PORTE_01	f	0.747	2026-02-13 08:08:49.908713
579	ENTREE	2026-02-13 08:08:51.505881	PORTE_01	f	1.21	2026-02-13 08:08:51.505881
580	ENTREE	2026-02-13 08:08:52.186838	PORTE_01	f	0.662	2026-02-13 08:08:52.186838
581	ENTREE	2026-02-13 08:08:53.290104	PORTE_01	f	0.405	2026-02-13 08:08:53.290104
582	ENTREE	2026-02-13 08:08:54.187383	PORTE_01	f	0.316	2026-02-13 08:08:54.187383
583	ENTREE	2026-02-13 08:08:56.214744	PORTE_01	f	1.351	2026-02-13 08:08:56.214744
584	ENTREE	2026-02-13 08:08:57.141398	PORTE_01	f	0.915	2026-02-13 08:08:57.141398
585	ENTREE	2026-02-13 08:08:58.275379	PORTE_01	f	1.118	2026-02-13 08:08:58.275379
586	ENTREE	2026-02-13 08:08:59.551368	PORTE_01	f	1.159	2026-02-13 08:08:59.551368
587	ENTREE	2026-02-13 08:09:00.878983	PORTE_01	f	0.674	2026-02-13 08:09:00.878983
588	ENTREE	2026-02-13 08:09:01.834716	PORTE_01	f	0.631	2026-02-13 08:09:01.834716
589	ENTREE	2026-02-13 08:09:02.559867	PORTE_01	f	0.701	2026-02-13 08:09:02.559867
590	ENTREE	2026-02-13 08:09:04.205908	PORTE_01	f	0.871	2026-02-13 08:09:04.205908
591	ENTREE	2026-02-13 08:09:05.261489	PORTE_01	f	0.585	2026-02-13 08:09:05.261489
592	ENTREE	2026-02-13 08:09:06.867685	PORTE_01	f	1.593	2026-02-13 08:09:06.867685
597	ENTREE	2026-02-13 08:09:12.445727	PORTE_01	f	0.773	2026-02-13 08:09:12.445727
598	ENTREE	2026-02-13 08:09:14.041661	PORTE_01	f	1.467	2026-02-13 08:09:14.041661
599	ENTREE	2026-02-13 08:09:15.127551	PORTE_01	f	1.073	2026-02-13 08:09:15.127551
600	ENTREE	2026-02-13 08:09:15.395682	PORTE_01	b	1.367	2026-02-13 08:09:15.395682
601	ENTREE	2026-02-13 08:09:16.08922	PORTE_01	f	0.945	2026-02-13 08:09:16.08922
602	ENTREE	2026-02-13 08:09:17.830828	PORTE_01	f	1.336	2026-02-13 08:09:17.830828
603	ENTREE	2026-02-13 08:09:19.446749	PORTE_01	f	1.601	2026-02-13 08:09:19.446749
604	ENTREE	2026-02-13 08:09:20.743357	PORTE_01	f	1.286	2026-02-13 08:09:20.743357
606	ENTREE	2026-02-13 08:09:22.324288	PORTE_01	f	0.54	2026-02-13 08:09:22.324288
607	ENTREE	2026-02-13 08:09:23.198162	PORTE_01	f	0.835	2026-02-13 08:09:23.198162
608	ENTREE	2026-02-13 08:09:24.921006	PORTE_01	f	1.555	2026-02-13 08:09:24.921006
593	ENTREE	2026-02-13 08:09:08.206588	PORTE_01	f	1.258	2026-02-13 08:09:08.206588
594	ENTREE	2026-02-13 08:09:09.475584	PORTE_01	f	1.256	2026-02-13 08:09:09.475584
595	ENTREE	2026-02-13 08:09:10.609458	PORTE_01	f	1.098	2026-02-13 08:09:10.609458
596	ENTREE	2026-02-13 08:09:11.604744	PORTE_01	f	0.566	2026-02-13 08:09:11.604744
605	ENTREE	2026-02-13 08:09:21.638673	PORTE_01	f	0.879	2026-02-13 08:09:21.638673
609	ENTREE	2026-02-13 08:09:26.92329	PORTE_01	f	1.409	2026-02-13 08:09:26.92329
610	ENTREE	2026-02-13 08:10:19.820791	PORTE_01	f	1.87	2026-02-13 08:10:19.820791
611	ENTREE	2026-02-13 08:10:19.824448	PORTE_01	b	2.092	2026-02-13 08:10:19.824448
612	ENTREE	2026-02-13 08:10:21.777575	PORTE_01	f	1.69	2026-02-13 08:10:21.777575
613	ENTREE	2026-02-13 08:10:21.863616	PORTE_01	b	1.814	2026-02-13 08:10:21.863616
614	ENTREE	2026-02-13 08:10:23.871155	PORTE_01	f	1.561	2026-02-13 08:10:23.871155
615	ENTREE	2026-02-13 08:10:26.057868	PORTE_01	f	2.042	2026-02-13 08:10:26.057868
616	ENTREE	2026-02-13 08:10:27.261633	PORTE_01	f	0.956	2026-02-13 08:10:27.261633
617	ENTREE	2026-02-13 08:10:28.13865	PORTE_01	f	0.865	2026-02-13 08:10:28.13865
618	ENTREE	2026-02-13 08:10:29.937375	PORTE_01	f	1.174	2026-02-13 08:10:29.937375
619	ENTREE	2026-02-13 08:10:30.027749	PORTE_01	b	3.132	2026-02-13 08:10:30.027749
620	ENTREE	2026-02-13 08:10:31.095226	PORTE_01	f	1.025	2026-02-13 08:10:31.095226
621	ENTREE	2026-02-13 08:10:32.101736	PORTE_01	f	0.531	2026-02-13 08:10:32.101736
622	ENTREE	2026-02-13 08:10:34.026527	PORTE_01	f	1.484	2026-02-13 08:10:34.026527
623	ENTREE	2026-02-13 08:10:35.05156	PORTE_01	f	0.566	2026-02-13 08:10:35.05156
624	ENTREE	2026-02-13 08:10:36.076937	PORTE_01	f	0.94	2026-02-13 08:10:36.076937
625	ENTREE	2026-02-13 08:10:37.256186	PORTE_01	f	1.112	2026-02-13 08:10:37.256186
626	ENTREE	2026-02-13 08:24:29.5882	PORTE_01	f	1.407	2026-02-13 08:24:29.5882
627	ENTREE	2026-02-13 08:24:33.096314	PORTE_01	f	0.256	2026-02-13 08:24:33.096314
628	ENTREE	2026-02-13 08:24:52.908939	PORTE_01	f	0.391	2026-02-13 08:24:52.908939
629	ENTREE	2026-02-13 08:25:03.102022	PORTE_01	f	0.35	2026-02-13 08:25:03.102022
630	ENTREE	2026-02-13 08:25:07.950885	PORTE_01	f	0.401	2026-02-13 08:25:07.950885
631	ENTREE	2026-02-13 08:25:12.709566	PORTE_01	f	0.242	2026-02-13 08:25:12.709566
632	ENTREE	2026-02-13 08:25:20.529856	PORTE_01	f	0.79	2026-02-13 08:25:20.529856
633	ENTREE	2026-02-13 08:25:22.754101	PORTE_01	f	0.393	2026-02-13 08:25:22.754101
634	ENTREE	2026-02-13 08:25:23.827045	PORTE_01	f	0.905	2026-02-13 08:25:23.827045
635	ENTREE	2026-02-13 08:25:26.737581	PORTE_01	f	0.369	2026-02-13 08:25:26.737581
636	ENTREE	2026-02-13 08:25:45.716713	PORTE_01	f	0.286	2026-02-13 08:25:45.716713
637	ENTREE	2026-02-13 08:27:03.532326	PORTE_01	f	0.436	2026-02-13 08:27:03.532326
638	ENTREE	2026-02-13 08:27:05.360048	PORTE_01	f	0.441	2026-02-13 08:27:05.360048
639	ENTREE	2026-02-13 08:27:07.659648	PORTE_01	f	0.7	2026-02-13 08:27:07.659648
640	ENTREE	2026-02-13 08:27:09.758056	PORTE_01	f	0.49	2026-02-13 08:27:09.758056
641	ENTREE	2026-02-13 08:27:11.389534	PORTE_01	f	0.24	2026-02-13 08:27:11.389534
642	ENTREE	2026-02-13 08:27:22.92171	PORTE_01	f	0.334	2026-02-13 08:27:22.92171
643	ENTREE	2026-02-13 08:27:42.824781	PORTE_01	f	0.249	2026-02-13 08:27:42.824781
644	ENTREE	2026-02-13 08:27:45.121599	PORTE_01	f	0.203	2026-02-13 08:27:45.121599
645	ENTREE	2026-02-13 08:28:42.656248	PORTE_01	f	0.105	2026-02-13 08:28:42.656248
646	ENTREE	2026-02-13 08:29:50.165309	PORTE_01	f	0.444	2026-02-13 08:29:50.165309
647	ENTREE	2026-02-13 08:30:04.056548	PORTE_01	f	0.129	2026-02-13 08:30:04.056548
648	ENTREE	2026-02-13 08:30:05.487909	PORTE_01	f	1.37	2026-02-13 08:30:05.487909
649	ENTREE	2026-02-13 08:30:08.445141	PORTE_01	f	0.314	2026-02-13 08:30:08.445141
650	ENTREE	2026-02-13 08:30:44.78865	PORTE_01	f	0.435	2026-02-13 08:30:44.78865
651	ENTREE	2026-02-13 08:30:48.574867	PORTE_01	f	0.337	2026-02-13 08:30:48.574867
652	ENTREE	2026-02-13 08:30:55.89231	PORTE_01	f	0.372	2026-02-13 08:30:55.89231
653	ENTREE	2026-02-13 08:31:55.681177	PORTE_01	f	3.418	2026-02-13 08:31:55.681177
654	ENTREE	2026-02-13 08:31:59.583427	PORTE_01	f	0.504	2026-02-13 08:31:59.583427
655	ENTREE	2026-02-13 08:34:03.533269	PORTE_01	f	0.289	2026-02-13 08:34:03.533269
656	ENTREE	2026-02-13 08:34:03.53689	PORTE_01	f	0.287	2026-02-13 08:34:03.53689
657	ENTREE	2026-02-13 08:34:42.688907	PORTE_01	f	0.121	2026-02-13 08:34:42.688907
658	ENTREE	2026-02-13 08:39:16.430152	PORTE_01	f	0.282	2026-02-13 08:39:16.430152
659	ENTREE	2026-02-13 08:40:01.630486	PORTE_01	f	0.622	2026-02-13 08:40:01.630486
660	ENTREE	2026-02-13 08:40:24.320718	PORTE_01	f	0.795	2026-02-13 08:40:24.320718
661	ENTREE	2026-02-13 08:40:25.514738	PORTE_01	f	0.307	2026-02-13 08:40:25.514738
662	ENTREE	2026-02-13 08:40:26.553419	PORTE_01	f	1.024	2026-02-13 08:40:26.553419
663	ENTREE	2026-02-13 08:40:27.537571	PORTE_01	f	0.138	2026-02-13 08:40:27.537571
664	ENTREE	2026-02-13 08:40:29.75405	PORTE_01	f	2.07	2026-02-13 08:40:29.75405
665	ENTREE	2026-02-13 08:40:49.809423	PORTE_01	f	1.715	2026-02-13 08:40:49.809423
666	ENTREE	2026-02-13 08:43:47.690426	PORTE_01	f	0.122	2026-02-13 08:43:47.690426
667	ENTREE	2026-02-13 08:49:39.042917	PORTE_01	f	0.799	2026-02-13 08:49:39.042917
668	ENTREE	2026-02-13 08:49:47.233897	PORTE_01	f	0.342	2026-02-13 08:49:47.233897
669	ENTREE	2026-02-13 08:54:29.632295	PORTE_01	f	0.303	2026-02-13 08:54:29.632295
670	ENTREE	2026-02-13 08:54:41.379042	PORTE_01	f	0.417	2026-02-13 08:54:41.379042
671	ENTREE	2026-02-13 09:00:40.066048	PORTE_01	f	0.679	2026-02-13 09:00:40.066048
672	ENTREE	2026-02-13 09:00:51.820925	PORTE_01	f	1.154	2026-02-13 09:00:51.820925
673	ENTREE	2026-02-13 09:00:54.98599	PORTE_01	f	0.563	2026-02-13 09:00:54.98599
674	ENTREE	2026-02-13 09:00:58.108908	PORTE_01	f	0.121	2026-02-13 09:00:58.108908
675	ENTREE	2026-02-13 09:00:58.749196	PORTE_01	f	0.481	2026-02-13 09:00:58.749196
676	ENTREE	2026-02-13 09:01:01.434604	PORTE_01	f	0.529	2026-02-13 09:01:01.434604
677	ENTREE	2026-02-13 09:01:52.328398	PORTE_01	b	0.835	2026-02-13 09:01:52.328398
678	ENTREE	2026-02-13 09:01:52.959201	PORTE_01	b	0.105	2026-02-13 09:01:52.959201
679	ENTREE	2026-02-13 09:02:03.913276	PORTE_01	f	0.691	2026-02-13 09:02:03.913276
680	ENTREE	2026-02-13 09:02:11.429566	PORTE_01	b	2.616	2026-02-13 09:02:11.429566
681	ENTREE	2026-02-13 09:02:12.375493	PORTE_01	f	1.811	2026-02-13 09:02:12.375493
682	ENTREE	2026-02-13 09:02:15.33829	PORTE_01	f	0.35	2026-02-13 09:02:15.33829
683	ENTREE	2026-02-13 09:02:36.19652	PORTE_01	f	0.716	2026-02-13 09:02:36.19652
684	ENTREE	2026-02-13 09:02:38.935703	PORTE_01	b	0.328	2026-02-13 09:02:38.935703
685	ENTREE	2026-02-13 09:02:48.447012	PORTE_01	b	0.218	2026-02-13 09:02:48.447012
686	ENTREE	2026-02-13 09:02:49.961928	PORTE_01	f	1.128	2026-02-13 09:02:49.961928
687	ENTREE	2026-02-13 09:02:53.151993	PORTE_01	b	0.415	2026-02-13 09:02:53.151993
688	ENTREE	2026-02-13 09:04:09.207068	PORTE_01	b	0.515	2026-02-13 09:04:09.207068
689	ENTREE	2026-02-13 09:05:30.061439	PORTE_01	f	0.406	2026-02-13 09:05:30.061439
690	ENTREE	2026-02-13 09:05:37.372145	PORTE_01	b	0.303	2026-02-13 09:05:37.372145
691	ENTREE	2026-02-13 09:05:42.764752	PORTE_01	b	0.272	2026-02-13 09:05:42.764752
692	ENTREE	2026-02-13 09:05:53.104083	PORTE_01	b	0.531	2026-02-13 09:05:53.104083
693	ENTREE	2026-02-13 09:06:04.06756	PORTE_01	b	0.341	2026-02-13 09:06:04.06756
694	ENTREE	2026-02-13 09:06:19.757023	PORTE_01	b	0.878	2026-02-13 09:06:19.757023
695	ENTREE	2026-02-13 09:06:24.143429	PORTE_01	b	0.597	2026-02-13 09:06:24.143429
696	ENTREE	2026-02-13 09:06:26.543297	PORTE_01	b	0.486	2026-02-13 09:06:26.543297
697	ENTREE	2026-02-13 09:06:32.896664	PORTE_01	b	0.226	2026-02-13 09:06:32.896664
698	ENTREE	2026-02-13 09:06:41.40725	PORTE_01	b	0.362	2026-02-13 09:06:41.40725
699	ENTREE	2026-02-13 09:09:17.442365	PORTE_01	f	1.958	2026-02-13 09:09:17.442365
700	ENTREE	2026-02-13 09:09:26.296725	PORTE_01	f	0.463	2026-02-13 09:09:26.296725
701	ENTREE	2026-02-13 09:15:21.737688	PORTE_01	f	2.025	2026-02-13 09:15:21.737688
702	ENTREE	2026-02-13 09:18:33.497399	PORTE_01	b	0.109	2026-02-13 09:18:33.497399
703	ENTREE	2026-02-13 09:18:42.325693	PORTE_01	b	0.766	2026-02-13 09:18:42.325693
704	ENTREE	2026-02-13 09:25:27.012506	PORTE_01	f	2.023	2026-02-13 09:25:27.012506
705	ENTREE	2026-02-13 09:25:42.736522	PORTE_01	f	0.178	2026-02-13 09:25:42.736522
706	ENTREE	2026-02-13 09:26:02.797436	PORTE_01	f	0.542	2026-02-13 09:26:02.797436
707	ENTREE	2026-02-13 09:26:15.964755	PORTE_01	f	0.378	2026-02-13 09:26:15.964755
708	SORTIE	2026-02-13 09:28:54.054202	PORTE_02	f	0.306	2026-02-13 09:28:54.054202
709	SORTIE	2026-02-13 09:29:03.922388	PORTE_02	f	0.22	2026-02-13 09:29:03.922388
710	SORTIE	2026-02-13 09:29:07.534802	PORTE_02	f	2.05	2026-02-13 09:29:07.534802
711	SORTIE	2026-02-13 09:29:11.380639	PORTE_02	f	0.123	2026-02-13 09:29:11.380639
712	SORTIE	2026-02-13 09:29:13.698571	PORTE_02	f	0.276	2026-02-13 09:29:13.698571
713	SORTIE	2026-02-13 09:29:15.24771	PORTE_02	f	0.261	2026-02-13 09:29:15.24771
714	SORTIE	2026-02-13 09:29:31.833234	PORTE_02	f	0.205	2026-02-13 09:29:31.833234
715	ENTREE	2026-02-13 09:30:46.481668	PORTE_01	f	0.429	2026-02-13 09:30:46.481668
716	ENTREE	2026-02-13 09:30:49.529323	PORTE_01	f	0.212	2026-02-13 09:30:49.529323
717	ENTREE	2026-02-13 09:30:50.728311	PORTE_01	f	0.16	2026-02-13 09:30:50.728311
718	ENTREE	2026-02-13 09:30:51.755501	PORTE_01	f	0.11	2026-02-13 09:30:51.755501
719	ENTREE	2026-02-13 09:30:52.801333	PORTE_01	f	0.156	2026-02-13 09:30:52.801333
720	ENTREE	2026-02-13 09:30:53.804023	PORTE_01	f	0.194	2026-02-13 09:30:53.804023
721	ENTREE	2026-02-13 09:30:55.664069	PORTE_01	f	0.192	2026-02-13 09:30:55.664069
722	ENTREE	2026-02-13 09:30:57.532179	PORTE_01	f	0.12	2026-02-13 09:30:57.532179
723	ENTREE	2026-02-13 09:30:59.38946	PORTE_01	f	0.115	2026-02-13 09:30:59.38946
724	ENTREE	2026-02-13 09:31:01.810624	PORTE_01	f	0.276	2026-02-13 09:31:01.810624
725	ENTREE	2026-02-13 09:31:03.481123	PORTE_01	f	0.197	2026-02-13 09:31:03.481123
726	ENTREE	2026-02-13 09:31:04.280983	PORTE_01	f	0.123	2026-02-13 09:31:04.280983
727	ENTREE	2026-02-13 09:31:05.227332	PORTE_01	f	0.125	2026-02-13 09:31:05.227332
728	ENTREE	2026-02-13 09:31:05.975844	PORTE_01	f	0.105	2026-02-13 09:31:05.975844
729	ENTREE	2026-02-13 09:31:06.83217	PORTE_01	f	0.101	2026-02-13 09:31:06.83217
730	ENTREE	2026-02-13 09:31:07.572909	PORTE_01	f	0.107	2026-02-13 09:31:07.572909
731	ENTREE	2026-02-13 09:31:08.518904	PORTE_01	f	0.126	2026-02-13 09:31:08.518904
732	ENTREE	2026-02-13 09:31:09.367729	PORTE_01	f	0.133	2026-02-13 09:31:09.367729
733	ENTREE	2026-02-13 09:31:10.341325	PORTE_01	f	0.114	2026-02-13 09:31:10.341325
734	ENTREE	2026-02-13 09:31:17.542417	PORTE_01	f	3.748	2026-02-13 09:31:17.542417
735	ENTREE	2026-02-13 09:31:18.662145	PORTE_01	f	0.162	2026-02-13 09:31:18.662145
736	ENTREE	2026-02-13 09:31:20.230704	PORTE_01	f	0.168	2026-02-13 09:31:20.230704
737	ENTREE	2026-02-13 09:31:27.839098	PORTE_01	f	0.565	2026-02-13 09:31:27.839098
738	ENTREE	2026-02-13 09:31:30.860284	PORTE_01	f	3.009	2026-02-13 09:31:30.860284
739	ENTREE	2026-02-13 09:31:52.142464	PORTE_01	f	0.446	2026-02-13 09:31:52.142464
740	ENTREE	2026-02-13 09:31:54.432691	PORTE_01	f	0.16	2026-02-13 09:31:54.432691
741	ENTREE	2026-02-13 09:32:05.730996	PORTE_01	f	0.546	2026-02-13 09:32:05.730996
742	ENTREE	2026-02-13 09:32:09.511708	PORTE_01	f	0.352	2026-02-13 09:32:09.511708
743	SORTIE	2026-02-13 09:32:13.519879	PORTE_02	f	0.221	2026-02-13 09:32:13.519879
744	ENTREE	2026-02-13 09:32:15.063806	PORTE_01	f	0.928	2026-02-13 09:32:15.063806
745	SORTIE	2026-02-13 09:32:20.431342	PORTE_02	f	0.784	2026-02-13 09:32:20.431342
746	SORTIE	2026-02-13 09:32:22.674684	PORTE_02	f	0.218	2026-02-13 09:32:22.674684
747	SORTIE	2026-02-13 09:32:26.851924	PORTE_02	b	0.476	2026-02-13 09:32:26.851924
748	ENTREE	2026-02-13 09:32:27.26371	PORTE_01	f	0.53	2026-02-13 09:32:27.26371
749	ENTREE	2026-02-13 09:32:29.709205	PORTE_01	f	0.773	2026-02-13 09:32:29.709205
750	SORTIE	2026-02-13 09:32:30.038019	PORTE_02	b	0.473	2026-02-13 09:32:30.038019
751	ENTREE	2026-02-13 09:32:34.501892	PORTE_01	f	0.315	2026-02-13 09:32:34.501892
752	SORTIE	2026-02-13 09:32:45.067551	PORTE_02	f	0.237	2026-02-13 09:32:45.067551
753	SORTIE	2026-02-13 09:32:48.724109	PORTE_02	f	0.281	2026-02-13 09:32:48.724109
754	SORTIE	2026-02-13 09:33:10.208739	PORTE_02	f	0.492	2026-02-13 09:33:10.208739
755	SORTIE	2026-02-13 09:33:18.280569	PORTE_02	f	0.364	2026-02-13 09:33:18.280569
756	SORTIE	2026-02-13 09:33:21.008997	PORTE_02	f	0.298	2026-02-13 09:33:21.008997
757	SORTIE	2026-02-13 09:33:23.404285	PORTE_02	f	0.306	2026-02-13 09:33:23.404285
758	SORTIE	2026-02-13 09:33:26.955827	PORTE_02	b	0.365	2026-02-13 09:33:26.955827
759	SORTIE	2026-02-13 09:33:29.842822	PORTE_02	b	0.373	2026-02-13 09:33:29.842822
760	SORTIE	2026-02-13 09:33:32.564645	PORTE_02	f	0.424	2026-02-13 09:33:32.564645
761	SORTIE	2026-02-13 09:34:17.205929	PORTE_02	b	0.144	2026-02-13 09:34:17.205929
762	SORTIE	2026-02-13 09:34:49.382735	PORTE_02	f	0.112	2026-02-13 09:34:49.382735
763	SORTIE	2026-02-13 09:35:12.338974	PORTE_02	f	0.635	2026-02-13 09:35:12.338974
764	SORTIE	2026-02-13 09:35:12.864808	PORTE_02	b	0.269	2026-02-13 09:35:12.864808
765	SORTIE	2026-02-13 09:35:25.511801	PORTE_02	f	0.121	2026-02-13 09:35:25.511801
766	SORTIE	2026-02-13 09:39:51.948976	PORTE_02	f	0.346	2026-02-13 09:39:51.948976
767	SORTIE	2026-02-13 09:39:56.104293	PORTE_02	b	0.314	2026-02-13 09:39:56.104293
768	SORTIE	2026-02-13 09:40:05.036513	PORTE_02	f	0.299	2026-02-13 09:40:05.036513
769	SORTIE	2026-02-13 09:44:11.401299	PORTE_02	f	0.416	2026-02-13 09:44:11.401299
770	SORTIE	2026-02-13 09:46:29.408166	PORTE_02	b	0.297	2026-02-13 09:46:29.408166
771	SORTIE	2026-02-13 09:46:36.829089	PORTE_02	f	0.313	2026-02-13 09:46:36.829089
772	SORTIE	2026-02-13 09:46:52.863112	PORTE_02	f	0.15	2026-02-13 09:46:52.863112
773	SORTIE	2026-02-13 09:47:25.059565	PORTE_02	f	0.63	2026-02-13 09:47:25.059565
774	SORTIE	2026-02-13 09:47:27.103283	PORTE_02	f	0.475	2026-02-13 09:47:27.103283
775	SORTIE	2026-02-13 09:47:33.27458	PORTE_02	b	3.767	2026-02-13 09:47:33.27458
776	SORTIE	2026-02-13 09:47:55.185097	PORTE_02	f	0.522	2026-02-13 09:47:55.185097
777	SORTIE	2026-02-13 09:47:59.443409	PORTE_02	f	1.756	2026-02-13 09:47:59.443409
778	SORTIE	2026-02-13 09:48:21.116023	PORTE_02	b	0.195	2026-02-13 09:48:21.116023
779	SORTIE	2026-02-13 09:48:23.257464	PORTE_02	b	0.106	2026-02-13 09:48:23.257464
780	SORTIE	2026-02-13 09:48:24.682023	PORTE_02	f	0.346	2026-02-13 09:48:24.682023
781	SORTIE	2026-02-13 09:52:56.12107	PORTE_02	f	0.2	2026-02-13 09:52:56.12107
782	SORTIE	2026-02-13 09:53:19.143024	PORTE_02	f	0.25	2026-02-13 09:53:19.143024
783	SORTIE	2026-02-13 09:56:35.618316	PORTE_02	f	0.338	2026-02-13 09:56:35.618316
784	SORTIE	2026-02-13 09:56:41.710566	PORTE_02	f	0.359	2026-02-13 09:56:41.710566
785	SORTIE	2026-02-13 09:56:50.761188	PORTE_02	b	0.459	2026-02-13 09:56:50.761188
786	SORTIE	2026-02-13 09:57:52.50651	PORTE_02	f	0.224	2026-02-13 09:57:52.50651
787	SORTIE	2026-02-13 09:58:28.158321	PORTE_02	f	0.245	2026-02-13 09:58:28.158321
788	SORTIE	2026-02-13 10:22:47.923523	PORTE_02	f	0.276	2026-02-13 10:22:47.923523
789	SORTIE	2026-02-13 10:23:27.431638	PORTE_02	f	0.247	2026-02-13 10:23:27.431638
790	SORTIE	2026-02-13 10:23:46.316465	PORTE_02	f	0.133	2026-02-13 10:23:46.316465
791	SORTIE	2026-02-13 10:24:17.738059	PORTE_02	f	0.308	2026-02-13 10:24:17.738059
792	SORTIE	2026-02-13 10:24:32.016083	PORTE_02	f	0.25	2026-02-13 10:24:32.016083
793	SORTIE	2026-03-03 09:47:20.525922	PORTE_02	b	0.393	2026-03-03 09:47:20.525922
794	SORTIE	2026-03-03 09:47:20.565638	PORTE_02	b	0.392	2026-03-03 09:47:20.565638
795	SORTIE	2026-03-03 09:48:16.20679	PORTE_02	f	0.313	2026-03-03 09:48:16.20679
796	SORTIE	2026-03-03 09:48:16.207465	PORTE_02	f	0.314	2026-03-03 09:48:16.207465
797	SORTIE	2026-03-03 09:48:20.280048	PORTE_02	f	0.377	2026-03-03 09:48:20.280048
798	SORTIE	2026-03-03 09:48:20.282531	PORTE_02	f	0.377	2026-03-03 09:48:20.282531
799	SORTIE	2026-03-03 09:48:23.420589	PORTE_02	f	0.237	2026-03-03 09:48:23.420589
800	SORTIE	2026-03-03 09:48:23.435728	PORTE_02	f	0.237	2026-03-03 09:48:23.435728
801	SORTIE	2026-03-03 09:48:49.393811	PORTE_02	f	0.377	2026-03-03 09:48:49.393811
802	SORTIE	2026-03-03 09:48:49.405094	PORTE_02	f	0.377	2026-03-03 09:48:49.405094
803	SORTIE	2026-03-03 09:49:06.795833	PORTE_02	f	0.349	2026-03-03 09:49:06.795833
804	SORTIE	2026-03-03 09:49:06.830134	PORTE_02	f	0.349	2026-03-03 09:49:06.830134
805	SORTIE	2026-03-03 09:49:24.177005	PORTE_02	f	0.459	2026-03-03 09:49:24.177005
806	SORTIE	2026-03-03 09:49:24.187923	PORTE_02	f	0.459	2026-03-03 09:49:24.187923
807	SORTIE	2026-03-03 09:49:31.365026	PORTE_02	f	0.192	2026-03-03 09:49:31.365026
808	SORTIE	2026-03-03 09:49:31.365258	PORTE_02	f	0.192	2026-03-03 09:49:31.365258
809	SORTIE	2026-03-03 09:49:32.880871	PORTE_02	f	0.18	2026-03-03 09:49:32.880871
810	SORTIE	2026-03-03 09:49:32.882337	PORTE_02	f	0.181	2026-03-03 09:49:32.882337
811	SORTIE	2026-03-03 09:49:34.371695	PORTE_02	f	0.11	2026-03-03 09:49:34.371695
812	SORTIE	2026-03-03 09:49:34.376079	PORTE_02	f	0.11	2026-03-03 09:49:34.376079
813	SORTIE	2026-03-03 09:49:39.967863	PORTE_02	f	0.669	2026-03-03 09:49:39.967863
814	SORTIE	2026-03-03 09:49:39.972338	PORTE_02	f	0.669	2026-03-03 09:49:39.972338
815	SORTIE	2026-03-03 09:49:40.648452	PORTE_02	f	0.512	2026-03-03 09:49:40.648452
817	SORTIE	2026-03-03 09:49:41.674501	PORTE_02	f	0.538	2026-03-03 09:49:41.674501
820	SORTIE	2026-03-03 09:49:43.140894	PORTE_02	f	0.617	2026-03-03 09:49:43.140894
821	SORTIE	2026-03-03 09:49:44.54687	PORTE_02	f	0.455	2026-03-03 09:49:44.54687
823	SORTIE	2026-03-03 09:49:46.22462	PORTE_02	f	0.76	2026-03-03 09:49:46.22462
828	SORTIE	2026-03-03 09:49:51.181993	PORTE_02	f	0.273	2026-03-03 09:49:51.181993
829	SORTIE	2026-03-03 09:49:55.252567	PORTE_02	f	0.428	2026-03-03 09:49:55.252567
816	SORTIE	2026-03-03 09:49:40.648699	PORTE_02	f	0.511	2026-03-03 09:49:40.648699
818	SORTIE	2026-03-03 09:49:41.674705	PORTE_02	f	0.538	2026-03-03 09:49:41.674705
819	SORTIE	2026-03-03 09:49:43.140761	PORTE_02	f	0.617	2026-03-03 09:49:43.140761
822	SORTIE	2026-03-03 09:49:44.547432	PORTE_02	f	0.455	2026-03-03 09:49:44.547432
824	SORTIE	2026-03-03 09:49:46.225009	PORTE_02	f	0.76	2026-03-03 09:49:46.225009
825	SORTIE	2026-03-03 09:49:50.086468	PORTE_02	f	0.322	2026-03-03 09:49:50.086468
826	SORTIE	2026-03-03 09:49:50.090152	PORTE_02	f	0.323	2026-03-03 09:49:50.090152
827	SORTIE	2026-03-03 09:49:51.181428	PORTE_02	f	0.273	2026-03-03 09:49:51.181428
830	SORTIE	2026-03-03 09:49:55.253309	PORTE_02	f	0.428	2026-03-03 09:49:55.253309
831	SORTIE	2026-03-03 09:52:22.167803	PORTE_02	f	0.34	2026-03-03 09:52:22.167803
832	SORTIE	2026-03-03 09:52:22.171266	PORTE_02	f	0.34	2026-03-03 09:52:22.171266
833	SORTIE	2026-03-03 09:52:35.290596	PORTE_02	f	0.473	2026-03-03 09:52:35.290596
834	SORTIE	2026-03-03 09:52:35.294388	PORTE_02	f	0.473	2026-03-03 09:52:35.294388
835	SORTIE	2026-03-03 09:52:39.02102	PORTE_02	f	0.502	2026-03-03 09:52:39.02102
836	SORTIE	2026-03-03 09:52:39.030474	PORTE_02	f	0.503	2026-03-03 09:52:39.030474
837	SORTIE	2026-03-03 09:52:42.250885	PORTE_02	f	0.821	2026-03-03 09:52:42.250885
838	SORTIE	2026-03-03 09:52:42.253642	PORTE_02	f	0.821	2026-03-03 09:52:42.253642
839	SORTIE	2026-03-03 09:52:46.199354	PORTE_02	f	0.658	2026-03-03 09:52:46.199354
840	SORTIE	2026-03-03 09:52:46.201071	PORTE_02	f	0.658	2026-03-03 09:52:46.201071
841	SORTIE	2026-03-03 09:52:52.517613	PORTE_02	f	0.622	2026-03-03 09:52:52.517613
842	SORTIE	2026-03-03 09:52:52.521988	PORTE_02	f	0.622	2026-03-03 09:52:52.521988
843	SORTIE	2026-03-03 09:52:53.826697	PORTE_02	f	0.469	2026-03-03 09:52:53.826697
844	SORTIE	2026-03-03 09:52:53.830653	PORTE_02	f	0.469	2026-03-03 09:52:53.830653
845	SORTIE	2026-03-03 09:52:57.615854	PORTE_02	f	1.865	2026-03-03 09:52:57.615854
846	SORTIE	2026-03-03 09:52:57.621275	PORTE_02	f	1.865	2026-03-03 09:52:57.621275
847	SORTIE	2026-03-03 09:52:58.769619	PORTE_02	f	0.418	2026-03-03 09:52:58.769619
848	SORTIE	2026-03-03 09:52:58.77909	PORTE_02	f	0.414	2026-03-03 09:52:58.77909
849	SORTIE	2026-03-03 09:52:59.90623	PORTE_02	f	0.371	2026-03-03 09:52:59.90623
850	SORTIE	2026-03-03 09:52:59.908603	PORTE_02	f	0.371	2026-03-03 09:52:59.908603
851	SORTIE	2026-03-03 09:53:00.992029	PORTE_02	f	0.421	2026-03-03 09:53:00.992029
852	SORTIE	2026-03-03 09:53:00.995161	PORTE_02	f	0.419	2026-03-03 09:53:00.995161
853	SORTIE	2026-03-03 09:53:02.041659	PORTE_02	f	0.483	2026-03-03 09:53:02.041659
854	SORTIE	2026-03-03 09:53:02.041773	PORTE_02	f	0.484	2026-03-03 09:53:02.041773
855	SORTIE	2026-03-03 09:53:02.83427	PORTE_02	f	0.271	2026-03-03 09:53:02.83427
856	SORTIE	2026-03-03 09:53:02.836441	PORTE_02	f	0.274	2026-03-03 09:53:02.836441
857	SORTIE	2026-03-03 09:53:05.620844	PORTE_02	f	0.321	2026-03-03 09:53:05.620844
858	SORTIE	2026-03-03 09:53:05.621395	PORTE_02	f	0.321	2026-03-03 09:53:05.621395
859	SORTIE	2026-03-03 09:53:08.549816	PORTE_02	f	0.347	2026-03-03 09:53:08.549816
860	SORTIE	2026-03-03 09:53:08.550985	PORTE_02	f	0.342	2026-03-03 09:53:08.550985
861	SORTIE	2026-03-03 09:53:09.880503	PORTE_02	f	0.272	2026-03-03 09:53:09.880503
862	SORTIE	2026-03-03 09:53:09.884523	PORTE_02	f	0.272	2026-03-03 09:53:09.884523
863	SORTIE	2026-03-03 09:55:07.14603	PORTE_02	b	0.564	2026-03-03 09:55:07.14603
864	SORTIE	2026-03-03 09:55:07.156907	PORTE_02	b	0.564	2026-03-03 09:55:07.156907
865	SORTIE	2026-03-03 09:56:46.4472	PORTE_02	f	0.489	2026-03-03 09:56:46.4472
866	SORTIE	2026-03-03 09:56:46.458813	PORTE_02	f	0.489	2026-03-03 09:56:46.458813
867	SORTIE	2026-03-03 09:58:13.573109	PORTE_02	b	0.313	2026-03-03 09:58:13.573109
868	SORTIE	2026-03-03 09:58:41.166857	PORTE_02	b	0.419	2026-03-03 09:58:41.166857
869	SORTIE	2026-03-03 10:05:22.643583	PORTE_02	f	0.526	2026-03-03 10:05:22.643583
870	SORTIE	2026-03-03 10:05:24.099652	PORTE_02	f	1.197	2026-03-03 10:05:24.099652
871	SORTIE	2026-03-03 10:05:25.30524	PORTE_02	f	0.938	2026-03-03 10:05:25.30524
872	SORTIE	2026-03-03 10:05:27.288151	PORTE_02	f	0.496	2026-03-03 10:05:27.288151
873	SORTIE	2026-03-03 10:05:29.262892	PORTE_02	f	0.317	2026-03-03 10:05:29.262892
874	SORTIE	2026-03-03 10:05:31.862296	PORTE_02	f	0.342	2026-03-03 10:05:31.862296
875	SORTIE	2026-03-03 10:05:36.051968	PORTE_02	f	1.608	2026-03-03 10:05:36.051968
876	SORTIE	2026-03-03 10:05:45.700368	PORTE_02	f	1.529	2026-03-03 10:05:45.700368
877	SORTIE	2026-03-03 10:05:48.7801	PORTE_02	f	1.848	2026-03-03 10:05:48.7801
878	SORTIE	2026-03-03 10:05:51.243213	PORTE_02	f	0.491	2026-03-03 10:05:51.243213
879	SORTIE	2026-03-03 10:07:19.919039	PORTE_02	f	0.319	2026-03-03 10:07:19.919039
880	SORTIE	2026-03-03 10:08:17.110941	PORTE_02	f	0.314	2026-03-03 10:08:17.110941
881	SORTIE	2026-03-03 10:17:11.793347	PORTE_02	f	0.358	2026-03-03 10:17:11.793347
882	SORTIE	2026-03-03 10:20:09.449357	PORTE_02	b	0.114	2026-03-03 10:20:09.449357
883	SORTIE	2026-03-03 10:21:39.604929	PORTE_02	b	0.141	2026-03-03 10:21:39.604929
884	ENTREE	2026-03-03 10:21:43.543765	PORTE_01	f	0.788	2026-03-03 10:21:43.543765
885	ENTREE	2026-03-03 10:21:45.274603	PORTE_01	f	0.89	2026-03-03 10:21:45.274603
886	ENTREE	2026-03-03 10:21:46.328562	PORTE_01	f	0.333	2026-03-03 10:21:46.328562
887	ENTREE	2026-03-03 10:21:47.934385	PORTE_01	f	0.958	2026-03-03 10:21:47.934385
888	ENTREE	2026-03-03 10:21:48.933004	PORTE_01	b	1.915	2026-03-03 10:21:48.933004
889	ENTREE	2026-03-03 10:21:49.531678	PORTE_01	f	0.545	2026-03-03 10:21:49.531678
890	ENTREE	2026-03-03 10:21:50.957451	PORTE_01	f	0.869	2026-03-03 10:21:50.957451
891	ENTREE	2026-03-03 10:21:53.207627	PORTE_01	f	1.065	2026-03-03 10:21:53.207627
892	ENTREE	2026-03-03 10:21:56.820635	PORTE_01	f	2.737	2026-03-03 10:21:56.820635
893	SORTIE	2026-03-03 10:25:00.883292	PORTE_02	b	0.296	2026-03-03 10:25:00.883292
894	SORTIE	2026-03-03 10:29:54.625722	PORTE_02	f	1.642	2026-03-03 10:29:54.625722
895	SORTIE	2026-03-03 10:29:54.629511	PORTE_02	f	1.643	2026-03-03 10:29:54.629511
896	SORTIE	2026-03-03 10:30:02.773124	PORTE_02	f	0.356	2026-03-03 10:30:02.773124
897	SORTIE	2026-03-03 10:30:02.773276	PORTE_02	f	0.363	2026-03-03 10:30:02.773276
898	SORTIE	2026-03-03 10:30:05.928305	PORTE_02	f	0.475	2026-03-03 10:30:05.928305
899	SORTIE	2026-03-03 10:30:05.931923	PORTE_02	f	0.476	2026-03-03 10:30:05.931923
900	SORTIE	2026-03-03 10:30:08.724845	PORTE_02	f	0.572	2026-03-03 10:30:08.724845
901	SORTIE	2026-03-03 10:30:08.7287	PORTE_02	f	0.572	2026-03-03 10:30:08.7287
902	SORTIE	2026-03-03 10:30:11.701525	PORTE_02	f	0.644	2026-03-03 10:30:11.701525
903	SORTIE	2026-03-03 10:30:11.705954	PORTE_02	f	0.645	2026-03-03 10:30:11.705954
904	SORTIE	2026-03-03 10:31:25.784613	PORTE_02	f	0.315	2026-03-03 10:31:25.784613
905	SORTIE	2026-03-03 10:31:28.681036	PORTE_02	f	0.403	2026-03-03 10:31:28.681036
906	SORTIE	2026-03-03 10:31:35.132812	PORTE_02	f	0.315	2026-03-03 10:31:35.132812
907	SORTIE	2026-03-03 10:31:37.475299	PORTE_02	f	0.599	2026-03-03 10:31:37.475299
908	SORTIE	2026-03-03 10:32:05.030649	PORTE_02	f	0.498	2026-03-03 10:32:05.030649
909	SORTIE	2026-03-03 10:32:07.678787	PORTE_02	f	0.688	2026-03-03 10:32:07.678787
910	SORTIE	2026-03-03 10:32:59.189791	PORTE_02	f	0.307	2026-03-03 10:32:59.189791
911	SORTIE	2026-03-03 10:35:56.933582	PORTE_02	f	0.236	2026-03-03 10:35:56.933582
912	SORTIE	2026-03-03 10:36:02.151079	PORTE_02	f	0.366	2026-03-03 10:36:02.151079
913	SORTIE	2026-03-03 10:36:13.540696	PORTE_02	b	0.423	2026-03-03 10:36:13.540696
914	SORTIE	2026-03-03 10:36:40.889994	PORTE_02	b	3.711	2026-03-03 10:36:40.889994
915	SORTIE	2026-03-03 10:36:48.461981	PORTE_02	b	0.44	2026-03-03 10:36:48.461981
916	SORTIE	2026-03-03 10:37:02.010518	PORTE_02	b	0.466	2026-03-03 10:37:02.010518
917	SORTIE	2026-03-03 10:44:38.00095	PORTE_02	f	0.28	2026-03-03 10:44:38.00095
918	SORTIE	2026-03-03 10:47:18.171559	PORTE_02	f	0.394	2026-03-03 10:47:18.171559
919	SORTIE	2026-03-03 10:47:21.298693	PORTE_02	f	0.31	2026-03-03 10:47:21.298693
920	SORTIE	2026-03-03 10:47:26.179744	PORTE_02	f	0.275	2026-03-03 10:47:26.179744
921	SORTIE	2026-03-03 10:47:29.71844	PORTE_02	f	0.14	2026-03-03 10:47:29.71844
922	SORTIE	2026-03-03 10:47:31.149821	PORTE_02	f	0.14	2026-03-03 10:47:31.149821
923	SORTIE	2026-03-03 10:47:32.626999	PORTE_02	f	0.131	2026-03-03 10:47:32.626999
924	SORTIE	2026-03-03 10:47:44.080027	PORTE_02	f	0.103	2026-03-03 10:47:44.080027
925	SORTIE	2026-03-03 10:47:57.504072	PORTE_02	f	0.352	2026-03-03 10:47:57.504072
926	SORTIE	2026-03-03 10:48:04.020069	PORTE_02	b	0.459	2026-03-03 10:48:04.020069
927	SORTIE	2026-03-03 10:48:04.936824	PORTE_02	f	0.883	2026-03-03 10:48:04.936824
928	SORTIE	2026-03-03 10:48:33.787045	PORTE_02	b	0.678	2026-03-03 10:48:33.787045
929	SORTIE	2026-03-03 10:48:46.784692	PORTE_02	b	0.54	2026-03-03 10:48:46.784692
930	SORTIE	2026-03-03 10:49:06.38122	PORTE_02	b	0.659	2026-03-03 10:49:06.38122
931	SORTIE	2026-03-03 10:49:50.976222	PORTE_02	f	0.637	2026-03-03 10:49:50.976222
932	SORTIE	2026-03-03 10:51:11.898518	PORTE_02	b	2.194	2026-03-03 10:51:11.898518
933	SORTIE	2026-03-03 10:51:14.29764	PORTE_02	b	1.422	2026-03-03 10:51:14.29764
934	SORTIE	2026-03-03 10:51:15.470943	PORTE_02	b	0.391	2026-03-03 10:51:15.470943
935	SORTIE	2026-03-03 10:51:16.516913	PORTE_02	b	0.347	2026-03-03 10:51:16.516913
936	SORTIE	2026-03-03 10:51:17.537677	PORTE_02	b	0.108	2026-03-03 10:51:17.537677
937	SORTIE	2026-03-03 10:51:19.047708	PORTE_02	b	0.467	2026-03-03 10:51:19.047708
938	SORTIE	2026-03-03 10:51:20.441112	PORTE_02	b	0.339	2026-03-03 10:51:20.441112
939	SORTIE	2026-03-03 10:51:22.038126	PORTE_02	b	0.618	2026-03-03 10:51:22.038126
940	SORTIE	2026-03-03 10:51:23.469986	PORTE_02	b	0.549	2026-03-03 10:51:23.469986
941	SORTIE	2026-03-03 10:51:24.705784	PORTE_02	b	0.442	2026-03-03 10:51:24.705784
942	SORTIE	2026-03-03 10:51:25.944935	PORTE_02	b	0.369	2026-03-03 10:51:25.944935
943	SORTIE	2026-03-03 10:51:27.078333	PORTE_02	b	0.303	2026-03-03 10:51:27.078333
944	SORTIE	2026-03-03 10:51:28.416502	PORTE_02	b	0.45	2026-03-03 10:51:28.416502
945	SORTIE	2026-03-03 10:51:29.658631	PORTE_02	b	0.462	2026-03-03 10:51:29.658631
946	SORTIE	2026-03-03 10:51:30.729836	PORTE_02	b	0.277	2026-03-03 10:51:30.729836
947	SORTIE	2026-03-03 10:51:31.756425	PORTE_02	b	0.129	2026-03-03 10:51:31.756425
948	SORTIE	2026-03-03 10:51:58.830343	PORTE_02	f	0.184	2026-03-03 10:51:58.830343
949	SORTIE	2026-03-03 10:51:59.441763	PORTE_02	f	0.102	2026-03-03 10:51:59.441763
950	SORTIE	2026-03-03 10:52:00.132911	PORTE_02	f	0.128	2026-03-03 10:52:00.132911
951	SORTIE	2026-03-03 10:52:01.195738	PORTE_02	f	0.149	2026-03-03 10:52:01.195738
952	SORTIE	2026-03-03 10:52:01.961893	PORTE_02	f	0.18	2026-03-03 10:52:01.961893
953	SORTIE	2026-03-03 10:52:03.362725	PORTE_02	f	0.123	2026-03-03 10:52:03.362725
954	SORTIE	2026-03-03 10:52:06.105033	PORTE_02	f	0.105	2026-03-03 10:52:06.105033
955	SORTIE	2026-03-03 10:52:09.977518	PORTE_02	b	2.246	2026-03-03 10:52:09.977518
956	SORTIE	2026-03-03 10:52:15.173718	PORTE_02	f	2.253	2026-03-03 10:52:15.173718
957	SORTIE	2026-03-03 10:52:16.760974	PORTE_02	f	0.898	2026-03-03 10:52:16.760974
958	SORTIE	2026-03-03 10:53:21.472889	PORTE_02	f	0.212	2026-03-03 10:53:21.472889
959	SORTIE	2026-03-03 10:53:28.1089	PORTE_02	f	0.437	2026-03-03 10:53:28.1089
960	SORTIE	2026-03-03 10:53:38.60488	PORTE_02	b	0.52	2026-03-03 10:53:38.60488
961	SORTIE	2026-03-03 10:54:45.286077	PORTE_02	b	0.359	2026-03-03 10:54:45.286077
962	SORTIE	2026-03-03 10:54:47.679371	PORTE_02	b	0.418	2026-03-03 10:54:47.679371
963	SORTIE	2026-03-03 10:54:50.676545	PORTE_02	f	0.386	2026-03-03 10:54:50.676545
964	SORTIE	2026-03-03 10:55:06.83716	PORTE_02	f	0.926	2026-03-03 10:55:06.83716
965	SORTIE	2026-03-03 10:55:13.404794	PORTE_02	f	0.555	2026-03-03 10:55:13.404794
966	SORTIE	2026-03-03 10:55:15.236196	PORTE_02	f	0.388	2026-03-03 10:55:15.236196
967	SORTIE	2026-03-03 10:55:29.294107	PORTE_02	b	0.133	2026-03-03 10:55:29.294107
968	SORTIE	2026-03-03 10:55:30.625153	PORTE_02	b	1.294	2026-03-03 10:55:30.625153
969	SORTIE	2026-03-03 10:55:32.167368	PORTE_02	b	0.553	2026-03-03 10:55:32.167368
970	SORTIE	2026-03-03 10:55:33.333502	PORTE_02	f	0.259	2026-03-03 10:55:33.333502
\.


--
-- Data for Name: qr_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qr_tokens (token, scope, revoked, created_at) FROM stdin;
a03197dc-687c-4e98-9021-63055a7faa83	admin	f	2026-02-12 10:15:45.965167
f7539118-f959-446f-aa3d-738ab6436114	admin	f	2026-02-12 10:21:52.258218
e847a3b9-5628-453d-9190-40af1bab075b	admin	f	2026-02-12 10:26:24.293438
c4f4f98f-1df0-4908-8a6b-1281dff8d034	admin	f	2026-02-12 10:50:41.927971
0036d2b3-1afb-4dc4-a43e-565119deea84	admin	f	2026-02-13 08:23:09.564185
08940f8b-81f7-49c8-b8b1-1f090853fac4	admin	f	2026-03-02 09:54:14.989931
2561d662-47cf-447b-9e75-b7acd7debe6c	admin	f	2026-03-02 09:56:00.548527
2a5b597e-7d40-4a08-a658-9fdc60e69a35	admin	f	2026-03-02 10:02:01.248843
df07e206-a939-4901-9d59-73b330f32047	admin	f	2026-03-03 08:07:58.527294
\.


--
-- Name: alertes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alertes_id_seq', 4, true);


--
-- Name: led_battery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.led_battery_id_seq', 9, true);


--
-- Name: login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_id_seq', 1, true);


--
-- Name: logs_oscillo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_oscillo_id_seq', 7104, true);


--
-- Name: passages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passages_id_seq', 970, true);


--
-- Name: alertes alertes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertes
    ADD CONSTRAINT alertes_pkey PRIMARY KEY (id);


--
-- Name: appareils appareils_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appareils
    ADD CONSTRAINT appareils_pkey PRIMARY KEY (id);


--
-- Name: dashboard_settings dashboard_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_settings
    ADD CONSTRAINT dashboard_settings_pkey PRIMARY KEY (id);


--
-- Name: door_settings door_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.door_settings
    ADD CONSTRAINT door_settings_pkey PRIMARY KEY (door_id);


--
-- Name: led_battery led_battery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.led_battery
    ADD CONSTRAINT led_battery_pkey PRIMARY KEY (id);


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
-- Name: ndns ndns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ndns
    ADD CONSTRAINT ndns_pkey PRIMARY KEY (id);


--
-- Name: passages passages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passages
    ADD CONSTRAINT passages_pkey PRIMARY KEY (id);


--
-- Name: qr_tokens qr_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_tokens
    ADD CONSTRAINT qr_tokens_pkey PRIMARY KEY (token);


--
-- Name: alertes fk_alertes_appareil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertes
    ADD CONSTRAINT fk_alertes_appareil FOREIGN KEY (appareil_id) REFERENCES public.appareils(id) ON DELETE CASCADE;


--
-- Name: led_battery fk_led_battery_appareil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.led_battery
    ADD CONSTRAINT fk_led_battery_appareil FOREIGN KEY (appareil_id) REFERENCES public.appareils(id) ON DELETE CASCADE;


--
-- Name: logs_oscillo fk_logs_oscillo_appareil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs_oscillo
    ADD CONSTRAINT fk_logs_oscillo_appareil FOREIGN KEY (appareil_id) REFERENCES public.appareils(id) ON DELETE CASCADE;


--
-- Name: ndns fk_ndns_appareil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ndns
    ADD CONSTRAINT fk_ndns_appareil FOREIGN KEY (id) REFERENCES public.appareils(id) ON DELETE CASCADE;


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
-- Name: TABLE alertes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.alertes TO gauthier;
GRANT ALL ON TABLE public.alertes TO jeremy;
GRANT ALL ON TABLE public.alertes TO leo;


--
-- Name: SEQUENCE alertes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.alertes_id_seq TO gauthier;
GRANT ALL ON SEQUENCE public.alertes_id_seq TO jeremy;
GRANT ALL ON SEQUENCE public.alertes_id_seq TO leo;


--
-- Name: TABLE appareils; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.appareils TO gauthier;
GRANT ALL ON TABLE public.appareils TO jeremy;
GRANT ALL ON TABLE public.appareils TO leo;


--
-- Name: TABLE dashboard_settings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.dashboard_settings TO gauthier;
GRANT ALL ON TABLE public.dashboard_settings TO jeremy;
GRANT ALL ON TABLE public.dashboard_settings TO leo;


--
-- Name: TABLE door_settings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.door_settings TO gauthier;
GRANT ALL ON TABLE public.door_settings TO jeremy;
GRANT ALL ON TABLE public.door_settings TO leo;


--
-- Name: TABLE led_battery; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.led_battery TO gauthier;
GRANT ALL ON TABLE public.led_battery TO jeremy;
GRANT ALL ON TABLE public.led_battery TO leo;


--
-- Name: SEQUENCE led_battery_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.led_battery_id_seq TO gauthier;
GRANT ALL ON SEQUENCE public.led_battery_id_seq TO jeremy;
GRANT ALL ON SEQUENCE public.led_battery_id_seq TO leo;


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
-- Name: TABLE ndns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ndns TO gauthier;
GRANT ALL ON TABLE public.ndns TO jeremy;
GRANT ALL ON TABLE public.ndns TO leo;


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
-- Name: TABLE qr_tokens; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.qr_tokens TO gauthier;
GRANT ALL ON TABLE public.qr_tokens TO jeremy;
GRANT ALL ON TABLE public.qr_tokens TO leo;


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

\unrestrict fm52Xudcb9xe99orCvDa0tHwAyexmOvNn7hvzVTE5eLSeFn3WSQ7DF8AwVXqlq9
