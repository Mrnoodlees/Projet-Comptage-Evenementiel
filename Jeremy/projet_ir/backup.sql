--
-- PostgreSQL database dump
--

\restrict aZClxgHUXhAwkLsPlghK5JvGX86aCD91kyxKnlRP0UE2gKliajO6SvQOnWK5Bty

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
    id character varying(50) NOT NULL,
    batterie integer,
    frequence integer,
    derniere_vu timestamp without time zone
);


ALTER TABLE public.appareils OWNER TO postgres;

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
-- Name: passages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passages (
    id integer NOT NULL,
    appareil_id character varying(50),
    type character varying(20),
    date_heure timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
-- Name: ordres_mqtt id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordres_mqtt ALTER COLUMN id SET DEFAULT nextval('public.ordres_mqtt_id_seq'::regclass);


--
-- Name: passages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passages ALTER COLUMN id SET DEFAULT nextval('public.passages_id_seq'::regclass);


--
-- Data for Name: appareils; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appareils (id, batterie, frequence, derniere_vu) FROM stdin;
test	639	56	2026-01-13 07:46:15.167448
recpeteurr	\N	\N	2026-01-13 07:46:17.724164
\.


--
-- Data for Name: ordres_mqtt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ordres_mqtt (id, topic, message) FROM stdin;
\.


--
-- Data for Name: passages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passages (id, appareil_id, type, date_heure) FROM stdin;
16754	recpeteurr	SORTIE	2026-01-13 07:18:57.591731
16755	recpeteurr	SORTIE	2026-01-13 07:18:57.59484
16756	recpeteurr	SORTIE	2026-01-13 07:19:00.194838
16757	recpeteurr	SORTIE	2026-01-13 07:19:00.198924
16758	recpeteurr	SORTIE	2026-01-13 07:19:01.572746
16759	recpeteurr	SORTIE	2026-01-13 07:19:01.575141
16760	recpeteurr	SORTIE	2026-01-13 07:19:05.520554
16761	recpeteurr	SORTIE	2026-01-13 07:19:05.523214
16762	recpeteurr	SORTIE	2026-01-13 07:19:06.624783
16763	recpeteurr	SORTIE	2026-01-13 07:19:06.62481
16764	recpeteurr	SORTIE	2026-01-13 07:19:09.628417
16765	recpeteurr	SORTIE	2026-01-13 07:19:09.628443
16766	recpeteurr	SORTIE	2026-01-13 07:19:10.515373
16767	recpeteurr	SORTIE	2026-01-13 07:19:10.515401
16768	recpeteurr	SORTIE	2026-01-13 07:19:14.408294
16769	recpeteurr	SORTIE	2026-01-13 07:19:14.408269
16770	recpeteurr	SORTIE	2026-01-13 07:19:18.833875
16771	recpeteurr	SORTIE	2026-01-13 07:19:18.833845
16772	recpeteurr	SORTIE	2026-01-13 07:19:19.37728
16773	recpeteurr	SORTIE	2026-01-13 07:19:19.37941
16774	recpeteurr	SORTIE	2026-01-13 07:19:19.780281
16775	recpeteurr	SORTIE	2026-01-13 07:19:19.780244
16776	recpeteurr	SORTIE	2026-01-13 07:19:20.995348
16777	recpeteurr	SORTIE	2026-01-13 07:19:20.99531
16778	recpeteurr	SORTIE	2026-01-13 07:19:24.342057
16779	recpeteurr	SORTIE	2026-01-13 07:19:24.342877
16780	recpeteurr	SORTIE	2026-01-13 07:19:25.335267
16781	recpeteurr	SORTIE	2026-01-13 07:19:25.33523
16782	recpeteurr	SORTIE	2026-01-13 07:19:26.035065
16783	recpeteurr	SORTIE	2026-01-13 07:19:26.05101
16784	recpeteurr	SORTIE	2026-01-13 07:19:26.152721
16785	recpeteurr	SORTIE	2026-01-13 07:19:26.166229
16786	recpeteurr	SORTIE	2026-01-13 07:19:26.474535
16787	recpeteurr	SORTIE	2026-01-13 07:19:26.474621
16788	recpeteurr	SORTIE	2026-01-13 07:19:27.204694
16789	recpeteurr	SORTIE	2026-01-13 07:19:27.205781
16790	recpeteurr	SORTIE	2026-01-13 07:19:27.429074
16791	recpeteurr	SORTIE	2026-01-13 07:19:27.43087
16792	recpeteurr	SORTIE	2026-01-13 07:19:28.688048
16793	recpeteurr	SORTIE	2026-01-13 07:19:28.688515
16794	recpeteurr	SORTIE	2026-01-13 07:19:44.516514
16795	recpeteurr	SORTIE	2026-01-13 07:19:44.516541
16796	recpeteurr	SORTIE	2026-01-13 07:19:44.779727
16797	recpeteurr	SORTIE	2026-01-13 07:19:44.779704
16798	recpeteurr	SORTIE	2026-01-13 07:19:50.257981
16799	recpeteurr	SORTIE	2026-01-13 07:19:50.258823
16800	recpeteurr	SORTIE	2026-01-13 07:19:51.171923
16801	recpeteurr	SORTIE	2026-01-13 07:19:51.172732
16802	recpeteurr	SORTIE	2026-01-13 07:19:58.62609
16803	recpeteurr	SORTIE	2026-01-13 07:19:58.629465
16804	recpeteurr	SORTIE	2026-01-13 07:20:26.90873
16805	recpeteurr	SORTIE	2026-01-13 07:20:26.909564
16806	recpeteurr	SORTIE	2026-01-13 07:20:27.044488
16807	recpeteurr	SORTIE	2026-01-13 07:20:27.04689
16808	recpeteurr	SORTIE	2026-01-13 07:20:29.386693
16809	recpeteurr	SORTIE	2026-01-13 07:20:29.391374
16810	recpeteurr	ENTREE	2026-01-13 07:20:53.044358
16811	recpeteurr	ENTREE	2026-01-13 07:20:53.044327
16812	recpeteurr	ENTREE	2026-01-13 07:20:55.054084
16813	recpeteurr	ENTREE	2026-01-13 07:20:55.054095
16814	recpeteurr	ENTREE	2026-01-13 07:20:58.583694
16815	recpeteurr	ENTREE	2026-01-13 07:20:58.583718
16816	recpeteurr	ENTREE	2026-01-13 07:21:01.866038
16817	recpeteurr	ENTREE	2026-01-13 07:21:01.865993
16818	recpeteurr	ENTREE	2026-01-13 07:21:04.544404
16819	recpeteurr	ENTREE	2026-01-13 07:21:04.548949
16820	recpeteurr	ENTREE	2026-01-13 07:21:08.642253
16821	recpeteurr	ENTREE	2026-01-13 07:21:08.642216
16822	recpeteurr	ENTREE	2026-01-13 07:21:13.724768
16823	recpeteurr	ENTREE	2026-01-13 07:21:13.729033
16824	recpeteurr	ENTREE	2026-01-13 07:21:28.049608
16825	recpeteurr	ENTREE	2026-01-13 07:21:28.04957
16826	recpeteurr	ENTREE	2026-01-13 07:21:28.485976
16827	recpeteurr	ENTREE	2026-01-13 07:21:28.486705
16828	recpeteurr	ENTREE	2026-01-13 07:21:33.200414
16829	recpeteurr	ENTREE	2026-01-13 07:21:33.200439
16830	recpeteurr	ENTREE	2026-01-13 07:21:33.491379
16831	recpeteurr	ENTREE	2026-01-13 07:21:33.491407
16832	recpeteurr	ENTREE	2026-01-13 07:21:47.119997
16833	recpeteurr	ENTREE	2026-01-13 07:21:47.119965
16834	recpeteurr	ENTREE	2026-01-13 07:21:49.097561
16835	recpeteurr	ENTREE	2026-01-13 07:21:49.097529
16836	recpeteurr	ENTREE	2026-01-13 07:21:50.5831
16837	recpeteurr	ENTREE	2026-01-13 07:21:50.583126
16838	recpeteurr	ENTREE	2026-01-13 07:21:51.728956
16839	recpeteurr	ENTREE	2026-01-13 07:21:51.729787
16840	recpeteurr	ENTREE	2026-01-13 07:22:18.280286
16841	recpeteurr	ENTREE	2026-01-13 07:22:18.280254
16842	recpeteurr	ENTREE	2026-01-13 07:22:18.545564
16843	recpeteurr	ENTREE	2026-01-13 07:22:18.545599
16844	recpeteurr	ENTREE	2026-01-13 07:22:57.941198
16845	recpeteurr	ENTREE	2026-01-13 07:22:57.941225
16846	recpeteurr	ENTREE	2026-01-13 07:23:44.743185
16847	recpeteurr	ENTREE	2026-01-13 07:23:44.745051
16848	recpeteurr	ENTREE	2026-01-13 07:23:48.846359
16849	recpeteurr	ENTREE	2026-01-13 07:23:48.848886
16850	recpeteurr	ENTREE	2026-01-13 07:24:03.299461
16851	recpeteurr	ENTREE	2026-01-13 07:24:03.303478
16852	recpeteurr	ENTREE	2026-01-13 07:24:04.38794
16853	recpeteurr	ENTREE	2026-01-13 07:24:04.387912
16854	recpeteurr	ENTREE	2026-01-13 07:24:07.936212
16855	recpeteurr	ENTREE	2026-01-13 07:24:07.937774
16856	recpeteurr	ENTREE	2026-01-13 07:24:30.866254
16857	recpeteurr	ENTREE	2026-01-13 07:24:30.866673
16858	recpeteurr	ENTREE	2026-01-13 07:24:46.500398
16859	recpeteurr	ENTREE	2026-01-13 07:24:46.50114
16860	recpeteurr	ENTREE	2026-01-13 07:24:46.997022
16861	recpeteurr	ENTREE	2026-01-13 07:24:46.997048
16862	recpeteurr	ENTREE	2026-01-13 07:24:50.597456
16863	recpeteurr	ENTREE	2026-01-13 07:24:50.597422
16864	recpeteurr	ENTREE	2026-01-13 07:25:23.545576
16865	recpeteurr	ENTREE	2026-01-13 07:25:23.545792
16866	recpeteurr	ENTREE	2026-01-13 07:25:42.094378
16867	recpeteurr	ENTREE	2026-01-13 07:25:42.09442
16868	recpeteurr	ENTREE	2026-01-13 07:26:10.620229
16869	recpeteurr	ENTREE	2026-01-13 07:26:10.620264
16870	recpeteurr	ENTREE	2026-01-13 07:26:17.970756
16871	recpeteurr	ENTREE	2026-01-13 07:26:17.972093
16872	recpeteurr	ENTREE	2026-01-13 07:26:24.236485
16873	recpeteurr	ENTREE	2026-01-13 07:26:24.237906
16874	recpeteurr	ENTREE	2026-01-13 07:26:26.472495
16875	recpeteurr	ENTREE	2026-01-13 07:26:26.477657
16876	recpeteurr	ENTREE	2026-01-13 07:26:27.092318
16877	recpeteurr	ENTREE	2026-01-13 07:26:27.09365
16878	recpeteurr	ENTREE	2026-01-13 07:26:27.875502
16879	recpeteurr	ENTREE	2026-01-13 07:26:27.875464
16880	recpeteurr	ENTREE	2026-01-13 07:26:30.672287
16881	recpeteurr	ENTREE	2026-01-13 07:26:30.672331
16882	recpeteurr	ENTREE	2026-01-13 07:26:34.256585
16883	recpeteurr	ENTREE	2026-01-13 07:26:34.25663
16884	recpeteurr	ENTREE	2026-01-13 07:26:36.631904
16885	recpeteurr	ENTREE	2026-01-13 07:26:36.636488
16886	recpeteurr	ENTREE	2026-01-13 07:26:37.809539
16887	recpeteurr	ENTREE	2026-01-13 07:26:37.813225
16888	recpeteurr	ENTREE	2026-01-13 07:26:40.540138
16889	recpeteurr	ENTREE	2026-01-13 07:26:40.540238
16890	recpeteurr	ENTREE	2026-01-13 07:27:01.87389
16891	recpeteurr	ENTREE	2026-01-13 07:27:01.873856
16892	recpeteurr	ENTREE	2026-01-13 07:27:03.147595
16893	recpeteurr	ENTREE	2026-01-13 07:27:03.147617
16894	recpeteurr	ENTREE	2026-01-13 07:30:34.570511
16895	recpeteurr	ENTREE	2026-01-13 07:30:34.570524
16896	recpeteurr	ENTREE	2026-01-13 07:30:34.966034
16897	recpeteurr	ENTREE	2026-01-13 07:30:34.967147
16898	recpeteurr	ENTREE	2026-01-13 07:30:36.073795
16899	recpeteurr	ENTREE	2026-01-13 07:30:36.074936
16900	recpeteurr	ENTREE	2026-01-13 07:30:37.369739
16901	recpeteurr	ENTREE	2026-01-13 07:30:37.369706
16902	recpeteurr	ENTREE	2026-01-13 07:30:40.319325
16903	recpeteurr	ENTREE	2026-01-13 07:30:40.319348
16904	recpeteurr	ENTREE	2026-01-13 07:30:43.816899
16905	recpeteurr	ENTREE	2026-01-13 07:30:43.816914
16906	recpeteurr	ENTREE	2026-01-13 07:31:04.064801
16907	recpeteurr	ENTREE	2026-01-13 07:31:04.064771
16908	recpeteurr	ENTREE	2026-01-13 07:31:05.179305
16909	recpeteurr	ENTREE	2026-01-13 07:31:05.180107
16910	recpeteurr	ENTREE	2026-01-13 07:31:06.010242
16911	recpeteurr	ENTREE	2026-01-13 07:31:06.010205
16912	recpeteurr	ENTREE	2026-01-13 07:31:15.256148
16913	recpeteurr	ENTREE	2026-01-13 07:31:15.256112
16914	recpeteurr	ENTREE	2026-01-13 07:31:21.56973
16915	recpeteurr	ENTREE	2026-01-13 07:31:21.569755
16916	recpeteurr	ENTREE	2026-01-13 07:31:32.755828
16917	recpeteurr	ENTREE	2026-01-13 07:31:32.755928
16918	recpeteurr	ENTREE	2026-01-13 07:31:41.835688
16919	recpeteurr	ENTREE	2026-01-13 07:31:41.835708
16920	recpeteurr	ENTREE	2026-01-13 07:33:08.213294
16921	recpeteurr	ENTREE	2026-01-13 07:33:08.215108
16922	recpeteurr	ENTREE	2026-01-13 07:33:17.985103
16923	recpeteurr	ENTREE	2026-01-13 07:33:17.985129
16924	recpeteurr	ENTREE	2026-01-13 07:33:18.509552
16925	recpeteurr	ENTREE	2026-01-13 07:33:18.509783
16926	recpeteurr	ENTREE	2026-01-13 07:33:49.224508
16927	recpeteurr	ENTREE	2026-01-13 07:33:49.224474
16928	recpeteurr	ENTREE	2026-01-13 07:37:09.40084
16929	recpeteurr	ENTREE	2026-01-13 07:37:09.404051
16930	recpeteurr	ENTREE	2026-01-13 07:37:11.227505
16931	recpeteurr	ENTREE	2026-01-13 07:37:11.242935
16932	recpeteurr	ENTREE	2026-01-13 07:37:16.549038
16933	recpeteurr	ENTREE	2026-01-13 07:37:16.549263
16934	recpeteurr	ENTREE	2026-01-13 07:37:18.541627
16935	recpeteurr	ENTREE	2026-01-13 07:37:18.541803
16936	recpeteurr	ENTREE	2026-01-13 07:37:18.728091
16937	recpeteurr	ENTREE	2026-01-13 07:37:18.728069
16938	recpeteurr	ENTREE	2026-01-13 07:37:39.871003
16939	recpeteurr	ENTREE	2026-01-13 07:37:39.871033
16940	recpeteurr	ENTREE	2026-01-13 07:37:59.806329
16941	recpeteurr	ENTREE	2026-01-13 07:37:59.80629
16942	recpeteurr	ENTREE	2026-01-13 07:37:59.9965
16943	recpeteurr	ENTREE	2026-01-13 07:37:59.996537
16944	recpeteurr	ENTREE	2026-01-13 07:38:32.92219
16945	recpeteurr	ENTREE	2026-01-13 07:38:32.923029
16946	recpeteurr	ENTREE	2026-01-13 07:38:33.178595
16947	recpeteurr	ENTREE	2026-01-13 07:38:33.182652
16948	recpeteurr	ENTREE	2026-01-13 07:38:46.704421
16949	recpeteurr	ENTREE	2026-01-13 07:38:46.704464
16950	recpeteurr	ENTREE	2026-01-13 07:41:45.397033
16951	recpeteurr	ENTREE	2026-01-13 07:41:45.397781
16952	recpeteurr	ENTREE	2026-01-13 07:41:47.294338
16953	recpeteurr	ENTREE	2026-01-13 07:41:47.294378
16954	recpeteurr	ENTREE	2026-01-13 07:42:00.327035
16955	recpeteurr	ENTREE	2026-01-13 07:42:00.330792
16956	recpeteurr	ENTREE	2026-01-13 07:42:02.844793
16957	recpeteurr	ENTREE	2026-01-13 07:42:02.845107
16958	recpeteurr	ENTREE	2026-01-13 07:42:32.585326
16959	recpeteurr	ENTREE	2026-01-13 07:42:32.590439
16960	recpeteurr	ENTREE	2026-01-13 07:44:21.347718
16961	recpeteurr	ENTREE	2026-01-13 07:44:21.348477
16962	recpeteurr	ENTREE	2026-01-13 07:44:27.924413
16963	recpeteurr	ENTREE	2026-01-13 07:44:27.925423
16964	recpeteurr	ENTREE	2026-01-13 07:44:28.717679
16965	recpeteurr	ENTREE	2026-01-13 07:44:28.747484
16966	recpeteurr	ENTREE	2026-01-13 07:44:35.214711
16967	recpeteurr	ENTREE	2026-01-13 07:44:35.215586
16968	recpeteurr	ENTREE	2026-01-13 07:44:36.416969
16969	recpeteurr	ENTREE	2026-01-13 07:44:36.418045
16970	recpeteurr	ENTREE	2026-01-13 07:44:38.038524
16971	recpeteurr	ENTREE	2026-01-13 07:44:38.038503
16972	recpeteurr	ENTREE	2026-01-13 07:44:40.92429
16973	recpeteurr	ENTREE	2026-01-13 07:44:40.924259
16974	recpeteurr	ENTREE	2026-01-13 07:44:42.489108
16975	recpeteurr	ENTREE	2026-01-13 07:44:42.489133
16976	recpeteurr	ENTREE	2026-01-13 07:44:43.629361
16977	recpeteurr	ENTREE	2026-01-13 07:44:43.62955
16978	recpeteurr	ENTREE	2026-01-13 07:44:45.008439
16979	recpeteurr	ENTREE	2026-01-13 07:44:45.008417
16980	recpeteurr	ENTREE	2026-01-13 07:44:48.03104
16981	recpeteurr	ENTREE	2026-01-13 07:44:48.031896
16982	recpeteurr	ENTREE	2026-01-13 07:45:06.818155
16983	recpeteurr	ENTREE	2026-01-13 07:45:06.81812
16984	recpeteurr	ENTREE	2026-01-13 07:45:07.176027
16985	recpeteurr	ENTREE	2026-01-13 07:45:07.176698
16986	recpeteurr	ENTREE	2026-01-13 07:45:13.562706
16987	recpeteurr	ENTREE	2026-01-13 07:45:13.562675
16988	recpeteurr	ENTREE	2026-01-13 07:45:13.66039
16989	recpeteurr	ENTREE	2026-01-13 07:45:13.660714
16990	recpeteurr	ENTREE	2026-01-13 07:45:18.842462
16991	recpeteurr	ENTREE	2026-01-13 07:45:18.842477
16992	recpeteurr	ENTREE	2026-01-13 07:45:40.643308
16993	recpeteurr	ENTREE	2026-01-13 07:45:40.643274
16994	recpeteurr	ENTREE	2026-01-13 07:45:43.316124
16995	recpeteurr	ENTREE	2026-01-13 07:45:43.316098
16996	recpeteurr	ENTREE	2026-01-13 07:45:44.485511
16997	recpeteurr	ENTREE	2026-01-13 07:45:44.487165
16998	recpeteurr	ENTREE	2026-01-13 07:46:07.212575
16999	recpeteurr	ENTREE	2026-01-13 07:46:07.215149
17000	recpeteurr	ENTREE	2026-01-13 07:46:09.200454
17001	recpeteurr	ENTREE	2026-01-13 07:46:09.20047
17002	recpeteurr	ENTREE	2026-01-13 07:46:17.723243
17003	recpeteurr	ENTREE	2026-01-13 07:46:17.724164
\.


--
-- Name: ordres_mqtt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ordres_mqtt_id_seq', 29, true);


--
-- Name: passages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passages_id_seq', 17003, true);


--
-- Name: appareils appareils_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appareils
    ADD CONSTRAINT appareils_pkey PRIMARY KEY (id);


--
-- Name: ordres_mqtt ordres_mqtt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordres_mqtt
    ADD CONSTRAINT ordres_mqtt_pkey PRIMARY KEY (id);


--
-- Name: passages passages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passages
    ADD CONSTRAINT passages_pkey PRIMARY KEY (id);


--
-- Name: passages passages_appareil_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passages
    ADD CONSTRAINT passages_appareil_id_fkey FOREIGN KEY (appareil_id) REFERENCES public.appareils(id);


--
-- Name: TABLE appareils; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.appareils TO leo;


--
-- Name: TABLE ordres_mqtt; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ordres_mqtt TO leo;


--
-- Name: SEQUENCE ordres_mqtt_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ordres_mqtt_id_seq TO leo;


--
-- Name: TABLE passages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.passages TO leo;


--
-- Name: SEQUENCE passages_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.passages_id_seq TO leo;


--
-- PostgreSQL database dump complete
--

\unrestrict aZClxgHUXhAwkLsPlghK5JvGX86aCD91kyxKnlRP0UE2gKliajO6SvQOnWK5Bty

