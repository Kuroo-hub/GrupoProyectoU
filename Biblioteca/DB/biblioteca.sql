--
-- PostgreSQL database dump
--

\restrict LLeqoTgUdAepH15srfYqlpF0Phklo9FB0dSRLcEfXYTLh4VCrMkI6Oq9YF4r4hx

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-06-19 19:39:23

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
-- TOC entry 241 (class 1255 OID 26684)
-- Name: fn_generar_multa_por_retraso(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_generar_multa_por_retraso() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   dias_retraso INT;
   monto_por_dia NUMERIC(10,2) := 2.50;
BEGIN 

   IF NEW.fecha_devolucion IS NOT NULL
      AND NEW.fecha_devolucion::DATE > NEW.fecha_limite THEN

      dias_retraso := NEW.fecha_devolucion::DATE - NEW.fecha_limite;

      INSERT INTO multa(fecha_multa, estado, monto, id_prestamo) 
      VALUES(
         CURRENT_DATE,
         'PENDIENTE', 
         dias_retraso * monto_por_dia,
         NEW.id_prestamo
      );

   END IF;

   RETURN NEW;

END;
$$;


ALTER FUNCTION public.fn_generar_multa_por_retraso() OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 34665)
-- Name: sp_procesar_prestamo(integer, integer, integer, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_procesar_prestamo(IN p_id_socio integer, IN p_id_empleado integer, IN p_id_ejemplar integer, IN p_fecha_limite date)
    LANGUAGE plpgsql
    AS $$
DECLARE 
   v_estado_ejemplar VARCHAR(20);
   v_multas_pendientes INT;
   v_prestamos_activos INT;
   v_id_prestamo INT;
BEGIN 
   
   -- 1. Verificar estado del ejemplar
   SELECT estado 
   INTO v_estado_ejemplar
   FROM ejemplar
   WHERE id_ejemplar = p_id_ejemplar;

   -- Validacion si esta nulo el estado del ejemplar
   IF v_estado_ejemplar IS NULL THEN
      RAISE EXCEPTION 'El ejemplar no existe';
   END IF;

   -- Validacion si el estado del ejemplar no es LIBRE
   IF v_estado_ejemplar <> 'LIBRE' THEN
      RAISE EXCEPTION 'El ejemplar no esta disponible';
   END IF;

   -- 2. Verificar que el socio no tenga multas y su limite de prestamos.
   SELECT COUNT(*) 
   INTO v_multas_pendientes
   FROM multa m 
   INNER JOIN prestamo p 
   ON m.id_prestamo = p.id_prestamo
   WHERE p.id_socio = p_id_socio
   AND m.estado = 'PENDIENTE';

   IF v_multas_pendientes > 0 THEN
      RAISE EXCEPTION 'El socio tiene multas pendientes, prestamo negado';
   END IF;

   -- 3. Verificar los prestamos del socio
   SELECT COUNT(*) 
   INTO v_prestamos_activos
   FROM prestamo 
   WHERE id_socio = p_id_socio
   AND estado = 'ACTIVO';

   IF v_prestamos_activos >= 3 THEN
      RAISE EXCEPTION 'El socio tiene 3 prestamos activos';
   END IF;

   -- 4. Registrar prestamo 
   INSERT INTO prestamo(fecha_limite, estado, id_empleado, id_socio)
   VALUES(p_fecha_limite, 'ACTIVO', p_id_empleado, p_id_socio)
   RETURNING id_prestamo INTO v_id_prestamo;

   -- 5. Relacionar prestamo con ejemplar
   INSERT INTO prestamo_ejemplar(id_prestamo, id_ejemplar) 
   VALUES(v_id_prestamo, p_id_ejemplar);

   -- 6. Cambiar estado del ejemplar
   UPDATE ejemplar
   SET estado = 'PRESTADO'
   WHERE id_ejemplar = p_id_ejemplar;

END;
$$;


ALTER PROCEDURE public.sp_procesar_prestamo(IN p_id_socio integer, IN p_id_empleado integer, IN p_id_ejemplar integer, IN p_fecha_limite date) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 233 (class 1259 OID 26594)
-- Name: autor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autor (
    id_autor integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    fecha_nacimiento date NOT NULL,
    sexo character(1) NOT NULL,
    CONSTRAINT ck_sexo_autor CHECK ((sexo = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.autor OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 26593)
-- Name: autor_id_autor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.autor ALTER COLUMN id_autor ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.autor_id_autor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 26549)
-- Name: editorial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editorial (
    id_editorial integer NOT NULL,
    nombre character varying(150) NOT NULL,
    correo character varying(150) NOT NULL,
    telefono character varying(20) NOT NULL,
    direccion character varying(250) NOT NULL,
    CONSTRAINT ck_correo_editorial CHECK (((correo)::text ~~ '%@%'::text)),
    CONSTRAINT ck_telefono_editorial CHECK (((telefono)::text ~ '^[0-9+\- ]+$'::text))
);


ALTER TABLE public.editorial OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 26548)
-- Name: editorial_id_editorial_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.editorial ALTER COLUMN id_editorial ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.editorial_id_editorial_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 26633)
-- Name: ejemplar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ejemplar (
    id_ejemplar integer NOT NULL,
    estado character varying(20) DEFAULT 'LIBRE'::character varying NOT NULL,
    id_libro integer NOT NULL,
    CONSTRAINT ck_estado_ejemplar CHECK (((estado)::text = ANY ((ARRAY['LIBRE'::character varying, 'PRESTADO'::character varying, 'RESERVADO'::character varying, 'FUERA_SERVICIO'::character varying])::text[])))
);


ALTER TABLE public.ejemplar OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 26632)
-- Name: ejemplar_id_ejemplar_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ejemplar ALTER COLUMN id_ejemplar ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ejemplar_id_ejemplar_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 26475)
-- Name: empleado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleado (
    id_empleado integer NOT NULL,
    dui character varying(10) NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    fecha_nacimiento date NOT NULL,
    sexo character(1) NOT NULL,
    CONSTRAINT ck_sexo_empleado CHECK ((sexo = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.empleado OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 26474)
-- Name: empleado_id_empleado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.empleado ALTER COLUMN id_empleado ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.empleado_id_empleado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 26606)
-- Name: genero; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genero (
    id_genero integer NOT NULL,
    nombre character varying(150) NOT NULL
);


ALTER TABLE public.genero OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 26605)
-- Name: genero_id_genero_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.genero ALTER COLUMN id_genero ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.genero_id_genero_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 26568)
-- Name: libro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.libro (
    id_libro integer NOT NULL,
    nombre character varying(150) NOT NULL,
    fecha_publicacion date NOT NULL
);


ALTER TABLE public.libro OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 26665)
-- Name: libro_autor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.libro_autor (
    id_libro integer NOT NULL,
    id_autor integer NOT NULL
);


ALTER TABLE public.libro_autor OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 26576)
-- Name: libro_editorial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.libro_editorial (
    id_libro integer NOT NULL,
    id_editorial integer NOT NULL
);


ALTER TABLE public.libro_editorial OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 26615)
-- Name: libro_genero; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.libro_genero (
    id_genero integer NOT NULL,
    id_libro integer NOT NULL
);


ALTER TABLE public.libro_genero OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 26567)
-- Name: libro_id_libro_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.libro ALTER COLUMN id_libro ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.libro_id_libro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 26530)
-- Name: multa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.multa (
    id_multa integer NOT NULL,
    fecha_multa date NOT NULL,
    estado character varying(15) DEFAULT 'PENDIENTE'::character varying NOT NULL,
    monto numeric(10,2) NOT NULL,
    id_prestamo integer NOT NULL,
    CONSTRAINT ck_estado_multa CHECK (((estado)::text = ANY ((ARRAY['PENDIENTE'::character varying, 'PAGADO'::character varying, 'CANCELADO'::character varying])::text[]))),
    CONSTRAINT ck_monto_multa CHECK ((monto > (0)::numeric))
);


ALTER TABLE public.multa OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 26529)
-- Name: multa_id_multa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.multa ALTER COLUMN id_multa ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.multa_id_multa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 26505)
-- Name: prestamo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prestamo (
    id_prestamo integer NOT NULL,
    fecha_prestamo timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_limite date NOT NULL,
    estado character varying(15) DEFAULT 'ACTIVO'::character varying NOT NULL,
    id_empleado integer NOT NULL,
    id_socio integer NOT NULL,
    fecha_devolucion timestamp without time zone,
    CONSTRAINT ck_estado_prestamo CHECK (((estado)::text = ANY ((ARRAY['ACTIVO'::character varying, 'DEVUELTO'::character varying, 'ATRASADO'::character varying])::text[])))
);


ALTER TABLE public.prestamo OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 26648)
-- Name: prestamo_ejemplar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prestamo_ejemplar (
    id_prestamo integer NOT NULL,
    id_ejemplar integer NOT NULL
);


ALTER TABLE public.prestamo_ejemplar OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 26504)
-- Name: prestamo_id_prestamo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.prestamo ALTER COLUMN id_prestamo ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.prestamo_id_prestamo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 26490)
-- Name: socio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.socio (
    id_socio integer NOT NULL,
    dui character varying(10) NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    fecha_nacimiento date NOT NULL,
    sexo character(1) NOT NULL,
    CONSTRAINT ck_sexo_socio CHECK ((sexo = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.socio OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 26489)
-- Name: socio_id_socio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.socio ALTER COLUMN id_socio ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.socio_id_socio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5137 (class 0 OID 26594)
-- Dependencies: 233
-- Data for Name: autor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autor (id_autor, nombre, apellido, fecha_nacimiento, sexo) FROM stdin;
1	Gabriel	Garcia Marquez	1927-03-06	M
2	J.K.	Rowling	1965-07-31	F
3	George	Orwell	1903-06-25	M
4	Jane	Austen	1775-12-16	F
5	Stephen	King	1947-09-21	M
\.


--
-- TOC entry 5132 (class 0 OID 26549)
-- Dependencies: 228
-- Data for Name: editorial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editorial (id_editorial, nombre, correo, telefono, direccion) FROM stdin;
1	Planeta	contacto@planeta.com	2222-1111	San Salvador
2	Santillana	info@santillana.com	2233-4455	Santa Ana
3	Alfaguara	contacto@alfaguara.com	2244-5566	San Miguel
4	Océano	info@oceano.com	2255-6677	La Libertad
5	Pearson	ventas@pearson.com	2266-7788	Sonsonate
\.


--
-- TOC entry 5142 (class 0 OID 26633)
-- Dependencies: 238
-- Data for Name: ejemplar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ejemplar (id_ejemplar, estado, id_libro) FROM stdin;
1	LIBRE	1
2	PRESTADO	2
3	RESERVADO	2
5	PRESTADO	4
6	RESERVADO	5
4	PRESTADO	3
\.


--
-- TOC entry 5124 (class 0 OID 26475)
-- Dependencies: 220
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empleado (id_empleado, dui, nombre, apellido, fecha_nacimiento, sexo) FROM stdin;
1	12345678-9	Carlos	Martinez	1990-05-10	M
2	98765432-1	Ana	Lopez	1995-09-20	F
3	33333333-3	Pedro	Ramirez	1988-01-12	M
4	44444444-4	Lucia	Fernandez	1992-11-25	F
5	55555555-5	Miguel	Castro	1985-06-18	M
\.


--
-- TOC entry 5139 (class 0 OID 26606)
-- Dependencies: 235
-- Data for Name: genero; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genero (id_genero, nombre) FROM stdin;
1	Fantasia
2	Aventura
3	Drama
4	Ciencia Ficcion
5	Romance
6	Suspenso
\.


--
-- TOC entry 5134 (class 0 OID 26568)
-- Dependencies: 230
-- Data for Name: libro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.libro (id_libro, nombre, fecha_publicacion) FROM stdin;
1	Cien años de soledad	1967-05-30
2	Harry Potter y la piedra filosofal	1997-06-26
3	1984	1949-06-08
4	Orgullo y prejuicio	1813-01-28
5	It	1986-09-15
\.


--
-- TOC entry 5144 (class 0 OID 26665)
-- Dependencies: 240
-- Data for Name: libro_autor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.libro_autor (id_libro, id_autor) FROM stdin;
1	1
2	2
3	3
4	4
5	5
\.


--
-- TOC entry 5135 (class 0 OID 26576)
-- Dependencies: 231
-- Data for Name: libro_editorial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.libro_editorial (id_libro, id_editorial) FROM stdin;
1	1
2	2
3	3
4	4
5	5
\.


--
-- TOC entry 5140 (class 0 OID 26615)
-- Dependencies: 236
-- Data for Name: libro_genero; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.libro_genero (id_genero, id_libro) FROM stdin;
3	1
1	2
2	2
4	3
5	4
6	5
\.


--
-- TOC entry 5130 (class 0 OID 26530)
-- Dependencies: 226
-- Data for Name: multa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.multa (id_multa, fecha_multa, estado, monto, id_prestamo) FROM stdin;
1	2026-06-12	PENDIENTE	5.50	2
2	2026-04-12	PENDIENTE	8.50	5
3	2026-04-13	PAGADO	3.00	3
4	2026-04-15	PENDIENTE	10.00	5
5	2026-05-16	PENDIENTE	12.50	4
\.


--
-- TOC entry 5128 (class 0 OID 26505)
-- Dependencies: 224
-- Data for Name: prestamo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prestamo (id_prestamo, fecha_prestamo, fecha_limite, estado, id_empleado, id_socio, fecha_devolucion) FROM stdin;
1	2026-05-16 00:06:19.947608	2026-06-01	ACTIVO	1	1	2026-06-05 14:30:00
2	2026-05-16 00:06:19.947608	2026-06-10	DEVUELTO	2	2	2026-06-12 10:15:00
3	2026-05-01 10:00:00	2026-05-08	DEVUELTO	3	3	2026-05-07 15:00:00
5	2026-04-01 08:00:00	2026-04-08	ATRASADO	5	5	2026-04-12 11:20:00
6	2026-05-16 14:55:06.579895	2026-07-01	ACTIVO	1	1	\N
7	2026-05-16 14:55:31.962659	2026-07-05	ACTIVO	1	1	\N
4	2026-05-15 09:30:00	2026-05-22	DEVUELTO	4	4	2026-05-27 10:00:00
9	2026-05-21 21:07:54.969178	2026-07-20	ACTIVO	1	3	\N
\.


--
-- TOC entry 5143 (class 0 OID 26648)
-- Dependencies: 239
-- Data for Name: prestamo_ejemplar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prestamo_ejemplar (id_prestamo, id_ejemplar) FROM stdin;
1	2
2	3
3	4
4	5
5	6
9	4
\.


--
-- TOC entry 5126 (class 0 OID 26490)
-- Dependencies: 222
-- Data for Name: socio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.socio (id_socio, dui, nombre, apellido, fecha_nacimiento, sexo) FROM stdin;
1	11111111-1	Luis	Hernandez	2000-02-15	M
2	22222222-2	Maria	Gonzalez	1998-07-30	F
3	66666666-6	Jose	Mendoza	2001-03-14	M
4	77777777-7	Elena	Ruiz	1999-08-22	F
5	88888888-8	Ricardo	Flores	1997-12-05	M
\.


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 232
-- Name: autor_id_autor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.autor_id_autor_seq', 5, true);


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 227
-- Name: editorial_id_editorial_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.editorial_id_editorial_seq', 5, true);


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 237
-- Name: ejemplar_id_ejemplar_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ejemplar_id_ejemplar_seq', 6, true);


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 219
-- Name: empleado_id_empleado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empleado_id_empleado_seq', 5, true);


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 234
-- Name: genero_id_genero_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genero_id_genero_seq', 6, true);


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 229
-- Name: libro_id_libro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.libro_id_libro_seq', 5, true);


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 225
-- Name: multa_id_multa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.multa_id_multa_seq', 5, true);


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 223
-- Name: prestamo_id_prestamo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prestamo_id_prestamo_seq', 9, true);


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 221
-- Name: socio_id_socio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socio_id_socio_seq', 5, true);


--
-- TOC entry 4950 (class 2606 OID 26604)
-- Name: autor pk_autor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autor
    ADD CONSTRAINT pk_autor PRIMARY KEY (id_autor);


--
-- TOC entry 4940 (class 2606 OID 26562)
-- Name: editorial pk_editorial; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editorial
    ADD CONSTRAINT pk_editorial PRIMARY KEY (id_editorial);


--
-- TOC entry 4958 (class 2606 OID 26642)
-- Name: ejemplar pk_ejemplar; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ejemplar
    ADD CONSTRAINT pk_ejemplar PRIMARY KEY (id_ejemplar);


--
-- TOC entry 4928 (class 2606 OID 26486)
-- Name: empleado pk_empleado; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT pk_empleado PRIMARY KEY (id_empleado);


--
-- TOC entry 4952 (class 2606 OID 26612)
-- Name: genero pk_genero; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genero
    ADD CONSTRAINT pk_genero PRIMARY KEY (id_genero);


--
-- TOC entry 4946 (class 2606 OID 26575)
-- Name: libro pk_libro; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro
    ADD CONSTRAINT pk_libro PRIMARY KEY (id_libro);


--
-- TOC entry 4962 (class 2606 OID 26671)
-- Name: libro_autor pk_libro_autor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro_autor
    ADD CONSTRAINT pk_libro_autor PRIMARY KEY (id_libro, id_autor);


--
-- TOC entry 4948 (class 2606 OID 26582)
-- Name: libro_editorial pk_libro_editorial; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro_editorial
    ADD CONSTRAINT pk_libro_editorial PRIMARY KEY (id_libro, id_editorial);


--
-- TOC entry 4956 (class 2606 OID 26621)
-- Name: libro_genero pk_libro_genero; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro_genero
    ADD CONSTRAINT pk_libro_genero PRIMARY KEY (id_genero, id_libro);


--
-- TOC entry 4938 (class 2606 OID 26542)
-- Name: multa pk_multa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.multa
    ADD CONSTRAINT pk_multa PRIMARY KEY (id_multa);


--
-- TOC entry 4936 (class 2606 OID 26518)
-- Name: prestamo pk_prestamo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamo
    ADD CONSTRAINT pk_prestamo PRIMARY KEY (id_prestamo);


--
-- TOC entry 4960 (class 2606 OID 26654)
-- Name: prestamo_ejemplar pk_prestamo_ejemplar; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamo_ejemplar
    ADD CONSTRAINT pk_prestamo_ejemplar PRIMARY KEY (id_prestamo, id_ejemplar);


--
-- TOC entry 4932 (class 2606 OID 26501)
-- Name: socio pk_socio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socio
    ADD CONSTRAINT pk_socio PRIMARY KEY (id_socio);


--
-- TOC entry 4942 (class 2606 OID 26566)
-- Name: editorial uq_correo_editorial; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editorial
    ADD CONSTRAINT uq_correo_editorial UNIQUE (correo);


--
-- TOC entry 4930 (class 2606 OID 26488)
-- Name: empleado uq_dui_empleado; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT uq_dui_empleado UNIQUE (dui);


--
-- TOC entry 4934 (class 2606 OID 26503)
-- Name: socio uq_dui_socio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socio
    ADD CONSTRAINT uq_dui_socio UNIQUE (dui);


--
-- TOC entry 4944 (class 2606 OID 26564)
-- Name: editorial uq_nombre_editorial; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editorial
    ADD CONSTRAINT uq_nombre_editorial UNIQUE (nombre);


--
-- TOC entry 4954 (class 2606 OID 26614)
-- Name: genero uq_nombre_genero; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genero
    ADD CONSTRAINT uq_nombre_genero UNIQUE (nombre);


--
-- TOC entry 4975 (class 2620 OID 26685)
-- Name: prestamo tg_generar_multa_por_retraso; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_generar_multa_por_retraso AFTER UPDATE OF fecha_devolucion ON public.prestamo FOR EACH ROW EXECUTE FUNCTION public.fn_generar_multa_por_retraso();


--
-- TOC entry 4973 (class 2606 OID 26677)
-- Name: libro_autor fk_id_autor_libro_autor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro_autor
    ADD CONSTRAINT fk_id_autor_libro_autor FOREIGN KEY (id_autor) REFERENCES public.autor(id_autor) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4966 (class 2606 OID 26588)
-- Name: libro_editorial fk_id_editorial_libro_editorial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro_editorial
    ADD CONSTRAINT fk_id_editorial_libro_editorial FOREIGN KEY (id_editorial) REFERENCES public.editorial(id_editorial) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4971 (class 2606 OID 26660)
-- Name: prestamo_ejemplar fk_id_ejemplar_prestamo_ejemplar; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamo_ejemplar
    ADD CONSTRAINT fk_id_ejemplar_prestamo_ejemplar FOREIGN KEY (id_ejemplar) REFERENCES public.ejemplar(id_ejemplar) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4963 (class 2606 OID 26519)
-- Name: prestamo fk_id_empleado_prestamo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamo
    ADD CONSTRAINT fk_id_empleado_prestamo FOREIGN KEY (id_empleado) REFERENCES public.empleado(id_empleado) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4968 (class 2606 OID 26622)
-- Name: libro_genero fk_id_genero_libro_genero; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro_genero
    ADD CONSTRAINT fk_id_genero_libro_genero FOREIGN KEY (id_genero) REFERENCES public.genero(id_genero) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4970 (class 2606 OID 26643)
-- Name: ejemplar fk_id_libro_ejemplar; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ejemplar
    ADD CONSTRAINT fk_id_libro_ejemplar FOREIGN KEY (id_libro) REFERENCES public.libro(id_libro) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4974 (class 2606 OID 26672)
-- Name: libro_autor fk_id_libro_libro_autor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro_autor
    ADD CONSTRAINT fk_id_libro_libro_autor FOREIGN KEY (id_libro) REFERENCES public.libro(id_libro) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4967 (class 2606 OID 26583)
-- Name: libro_editorial fk_id_libro_libro_editorial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro_editorial
    ADD CONSTRAINT fk_id_libro_libro_editorial FOREIGN KEY (id_libro) REFERENCES public.libro(id_libro) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4969 (class 2606 OID 26627)
-- Name: libro_genero fk_id_libro_libro_genero; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro_genero
    ADD CONSTRAINT fk_id_libro_libro_genero FOREIGN KEY (id_libro) REFERENCES public.libro(id_libro) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4965 (class 2606 OID 26543)
-- Name: multa fk_id_prestamo_multa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.multa
    ADD CONSTRAINT fk_id_prestamo_multa FOREIGN KEY (id_prestamo) REFERENCES public.prestamo(id_prestamo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4972 (class 2606 OID 26655)
-- Name: prestamo_ejemplar fk_id_prestamo_prestamo_ejemplar; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamo_ejemplar
    ADD CONSTRAINT fk_id_prestamo_prestamo_ejemplar FOREIGN KEY (id_prestamo) REFERENCES public.prestamo(id_prestamo) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4964 (class 2606 OID 26524)
-- Name: prestamo fk_id_socio_prestamo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamo
    ADD CONSTRAINT fk_id_socio_prestamo FOREIGN KEY (id_socio) REFERENCES public.socio(id_socio) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2026-06-19 19:39:23

--
-- PostgreSQL database dump complete
--

\unrestrict LLeqoTgUdAepH15srfYqlpF0Phklo9FB0dSRLcEfXYTLh4VCrMkI6Oq9YF4r4hx

