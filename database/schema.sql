--
-- PostgreSQL database dump
--

\restrict jAO5qqTe616b6hU8Y2f2MIYwNTZiikFDrpbCg5dU8nBbZRBMePKkvYnptWnY5OF

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-08 18:37:37

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 229 (class 1259 OID 16586)
-- Name: compensation_credits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compensation_credits (
    credit_id integer NOT NULL,
    employee_id integer NOT NULL,
    days_credited numeric(3,1) NOT NULL,
    earned_date date NOT NULL,
    expiry_date date NOT NULL,
    status character varying(20) DEFAULT 'AVAILABLE'::character varying,
    CONSTRAINT compensation_credits_days_credited_check CHECK ((days_credited = ANY (ARRAY[0.5, 1.0]))),
    CONSTRAINT compensation_credits_status_check CHECK (((status)::text = ANY ((ARRAY['AVAILABLE'::character varying, 'USED'::character varying, 'EXPIRED'::character varying])::text[])))
);


ALTER TABLE public.compensation_credits OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16585)
-- Name: compensation_credits_credit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compensation_credits_credit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compensation_credits_credit_id_seq OWNER TO postgres;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 228
-- Name: compensation_credits_credit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compensation_credits_credit_id_seq OWNED BY public.compensation_credits.credit_id;


--
-- TOC entry 220 (class 1259 OID 16491)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id integer NOT NULL,
    department_name character varying(100) NOT NULL,
    hod_id integer,
    start_date date
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16490)
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_department_id_seq OWNER TO postgres;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 219
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_department_id_seq OWNED BY public.departments.department_id;


--
-- TOC entry 227 (class 1259 OID 16560)
-- Name: employee_leave_balances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_leave_balances (
    balance_id integer NOT NULL,
    employee_id integer NOT NULL,
    leave_code character varying(10) NOT NULL,
    accrued_leaves numeric(5,2) DEFAULT 0.00,
    leaves_taken numeric(5,2) DEFAULT 0.00,
    current_balance numeric(5,2) DEFAULT 0.00,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employee_leave_balances OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16559)
-- Name: employee_leave_balances_balance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_leave_balances_balance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_leave_balances_balance_id_seq OWNER TO postgres;

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 226
-- Name: employee_leave_balances_balance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_leave_balances_balance_id_seq OWNED BY public.employee_leave_balances.balance_id;


--
-- TOC entry 222 (class 1259 OID 16502)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    name character varying(100) NOT NULL,
    department_id integer NOT NULL,
    salary numeric(10,2) DEFAULT 0.00 NOT NULL,
    category_type character varying(20),
    designation character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT employees_category_type_check CHECK (((category_type)::text = ANY ((ARRAY['Vacation'::character varying, 'Non-Vacation'::character varying])::text[])))
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16501)
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_employee_id_seq OWNER TO postgres;

--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 221
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- TOC entry 225 (class 1259 OID 16536)
-- Name: leave_policies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_policies (
    policy_id integer NOT NULL,
    category_type character varying(20) NOT NULL,
    leave_code character varying(10) NOT NULL,
    yearly_allowance numeric(5,2) DEFAULT 0.00,
    accrual_amount numeric(5,2) DEFAULT 0.00,
    accrual_interval_months integer DEFAULT 12,
    min_days_per_request integer,
    max_days_per_request integer,
    max_cap_limit integer,
    action_on_cap_exceeded character varying(20) DEFAULT 'CAP_AT_MAX'::character varying,
    requires_proof_document boolean DEFAULT false,
    CONSTRAINT leave_policies_action_on_cap_exceeded_check CHECK (((action_on_cap_exceeded)::text = ANY ((ARRAY['RESET_TO_ZERO'::character varying, 'CAP_AT_MAX'::character varying])::text[]))),
    CONSTRAINT leave_policies_category_type_check CHECK (((category_type)::text = ANY ((ARRAY['Vacation'::character varying, 'Non-Vacation'::character varying])::text[])))
);


ALTER TABLE public.leave_policies OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16535)
-- Name: leave_policies_policy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leave_policies_policy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leave_policies_policy_id_seq OWNER TO postgres;

--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 224
-- Name: leave_policies_policy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leave_policies_policy_id_seq OWNED BY public.leave_policies.policy_id;


--
-- TOC entry 231 (class 1259 OID 16606)
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_requests (
    request_id integer NOT NULL,
    employee_id integer NOT NULL,
    leave_code character varying(10) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    total_days integer GENERATED ALWAYS AS (((end_date - start_date) + 1)) STORED,
    duration_type character varying(20) DEFAULT 'FULL_DAY'::character varying,
    document_proof_path character varying(255) DEFAULT NULL::character varying,
    status character varying(20) DEFAULT 'Pending'::character varying,
    applied_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT leave_requests_duration_type_check CHECK (((duration_type)::text = ANY ((ARRAY['FULL_DAY'::character varying, 'HALF_DAY'::character varying])::text[]))),
    CONSTRAINT leave_requests_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Approved'::character varying, 'Rejected'::character varying])::text[])))
);


ALTER TABLE public.leave_requests OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16605)
-- Name: leave_requests_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leave_requests_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leave_requests_request_id_seq OWNER TO postgres;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 230
-- Name: leave_requests_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leave_requests_request_id_seq OWNED BY public.leave_requests.request_id;


--
-- TOC entry 223 (class 1259 OID 16526)
-- Name: leave_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_types (
    leave_code character varying(10) NOT NULL,
    leave_name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.leave_types OWNER TO postgres;

--
-- TOC entry 4900 (class 2604 OID 16589)
-- Name: compensation_credits credit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_credits ALTER COLUMN credit_id SET DEFAULT nextval('public.compensation_credits_credit_id_seq'::regclass);


--
-- TOC entry 4885 (class 2604 OID 16494)
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN department_id SET DEFAULT nextval('public.departments_department_id_seq'::regclass);


--
-- TOC entry 4895 (class 2604 OID 16563)
-- Name: employee_leave_balances balance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_leave_balances ALTER COLUMN balance_id SET DEFAULT nextval('public.employee_leave_balances_balance_id_seq'::regclass);


--
-- TOC entry 4886 (class 2604 OID 16505)
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- TOC entry 4889 (class 2604 OID 16539)
-- Name: leave_policies policy_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies ALTER COLUMN policy_id SET DEFAULT nextval('public.leave_policies_policy_id_seq'::regclass);


--
-- TOC entry 4902 (class 2604 OID 16609)
-- Name: leave_requests request_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests ALTER COLUMN request_id SET DEFAULT nextval('public.leave_requests_request_id_seq'::regclass);


--
-- TOC entry 5100 (class 0 OID 16586)
-- Dependencies: 229
-- Data for Name: compensation_credits; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5091 (class 0 OID 16491)
-- Dependencies: 220
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5098 (class 0 OID 16560)
-- Dependencies: 227
-- Data for Name: employee_leave_balances; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5093 (class 0 OID 16502)
-- Dependencies: 222
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5096 (class 0 OID 16536)
-- Dependencies: 225
-- Data for Name: leave_policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.leave_policies VALUES (1, 'Vacation', 'EL', 10.00, 5.00, 6, 5, NULL, 240, 'RESET_TO_ZERO', false);
INSERT INTO public.leave_policies VALUES (2, 'Vacation', 'CL', 15.00, 15.00, 12, NULL, 4, NULL, 'CAP_AT_MAX', false);
INSERT INTO public.leave_policies VALUES (3, 'Vacation', 'RH', 2.00, 2.00, 12, NULL, NULL, NULL, 'CAP_AT_MAX', false);
INSERT INTO public.leave_policies VALUES (4, 'Vacation', 'SCL', 15.00, 15.00, 12, NULL, NULL, NULL, 'CAP_AT_MAX', false);
INSERT INTO public.leave_policies VALUES (5, 'Vacation', 'OOD', 0.00, 0.00, 12, NULL, NULL, NULL, 'CAP_AT_MAX', true);
INSERT INTO public.leave_policies VALUES (6, 'Non-Vacation', 'EL', 30.00, 15.00, 6, 5, NULL, 240, 'RESET_TO_ZERO', false);
INSERT INTO public.leave_policies VALUES (7, 'Non-Vacation', 'CL', 15.00, 15.00, 12, NULL, 4, NULL, 'CAP_AT_MAX', false);
INSERT INTO public.leave_policies VALUES (8, 'Non-Vacation', 'RH', 2.00, 2.00, 12, NULL, NULL, NULL, 'CAP_AT_MAX', false);
INSERT INTO public.leave_policies VALUES (9, 'Non-Vacation', 'OOD', 0.00, 0.00, 12, NULL, NULL, NULL, 'CAP_AT_MAX', true);


--
-- TOC entry 5102 (class 0 OID 16606)
-- Dependencies: 231
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5094 (class 0 OID 16526)
-- Dependencies: 223
-- Data for Name: leave_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.leave_types VALUES ('EL', 'Earned Leave', 'Accrued periodic leave with roll-over cap');
INSERT INTO public.leave_types VALUES ('CL', 'Casual Leave', 'Yearly allowance for short personal absences');
INSERT INTO public.leave_types VALUES ('RH', 'Restricted Holiday', 'Optional festive holidays');
INSERT INTO public.leave_types VALUES ('SCL', 'Special Casual Leave', 'Allowed for specific positions (HOD, Dean, COE)');
INSERT INTO public.leave_types VALUES ('OOD', 'On Official Duty', 'Requires official proof/letter approval');
INSERT INTO public.leave_types VALUES ('LOP', 'Loss of Pay', 'Unpaid leave applied when balance exhausts');
INSERT INTO public.leave_types VALUES ('COMP', 'Compensation Leave', 'Claimable every 6 months for extra work done');


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 228
-- Name: compensation_credits_credit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compensation_credits_credit_id_seq', 1, false);


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 219
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_department_id_seq', 1, false);


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 226
-- Name: employee_leave_balances_balance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_leave_balances_balance_id_seq', 1, false);


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 221
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 1, false);


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 224
-- Name: leave_policies_policy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_policies_policy_id_seq', 9, true);


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 230
-- Name: leave_requests_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_requests_request_id_seq', 1, false);


--
-- TOC entry 4932 (class 2606 OID 16599)
-- Name: compensation_credits compensation_credits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_credits
    ADD CONSTRAINT compensation_credits_pkey PRIMARY KEY (credit_id);


--
-- TOC entry 4916 (class 2606 OID 16500)
-- Name: departments departments_department_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_name_key UNIQUE (department_name);


--
-- TOC entry 4918 (class 2606 OID 16498)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- TOC entry 4928 (class 2606 OID 16574)
-- Name: employee_leave_balances employee_leave_balances_employee_id_leave_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_leave_balances
    ADD CONSTRAINT employee_leave_balances_employee_id_leave_code_key UNIQUE (employee_id, leave_code);


--
-- TOC entry 4930 (class 2606 OID 16572)
-- Name: employee_leave_balances employee_leave_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_leave_balances
    ADD CONSTRAINT employee_leave_balances_pkey PRIMARY KEY (balance_id);


--
-- TOC entry 4920 (class 2606 OID 16515)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 4924 (class 2606 OID 16553)
-- Name: leave_policies leave_policies_category_type_leave_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT leave_policies_category_type_leave_code_key UNIQUE (category_type, leave_code);


--
-- TOC entry 4926 (class 2606 OID 16551)
-- Name: leave_policies leave_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT leave_policies_pkey PRIMARY KEY (policy_id);


--
-- TOC entry 4934 (class 2606 OID 16623)
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (request_id);


--
-- TOC entry 4922 (class 2606 OID 16534)
-- Name: leave_types leave_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_pkey PRIMARY KEY (leave_code);


--
-- TOC entry 4940 (class 2606 OID 16600)
-- Name: compensation_credits compensation_credits_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_credits
    ADD CONSTRAINT compensation_credits_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id) ON DELETE CASCADE;


--
-- TOC entry 4938 (class 2606 OID 16575)
-- Name: employee_leave_balances employee_leave_balances_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_leave_balances
    ADD CONSTRAINT employee_leave_balances_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id) ON DELETE CASCADE;


--
-- TOC entry 4939 (class 2606 OID 16580)
-- Name: employee_leave_balances employee_leave_balances_leave_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_leave_balances
    ADD CONSTRAINT employee_leave_balances_leave_code_fkey FOREIGN KEY (leave_code) REFERENCES public.leave_types(leave_code) ON DELETE CASCADE;


--
-- TOC entry 4936 (class 2606 OID 16516)
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id) ON DELETE CASCADE;


--
-- TOC entry 4935 (class 2606 OID 16521)
-- Name: departments fk_dept_hod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_dept_hod FOREIGN KEY (hod_id) REFERENCES public.employees(employee_id) ON DELETE SET NULL;


--
-- TOC entry 4937 (class 2606 OID 16554)
-- Name: leave_policies leave_policies_leave_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT leave_policies_leave_code_fkey FOREIGN KEY (leave_code) REFERENCES public.leave_types(leave_code) ON DELETE CASCADE;


--
-- TOC entry 4941 (class 2606 OID 16624)
-- Name: leave_requests leave_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id) ON DELETE CASCADE;


--
-- TOC entry 4942 (class 2606 OID 16629)
-- Name: leave_requests leave_requests_leave_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_leave_code_fkey FOREIGN KEY (leave_code) REFERENCES public.leave_types(leave_code) ON DELETE CASCADE;


-- Completed on 2026-10-08 18:37:38

--
-- PostgreSQL database dump complete
--

\unrestrict jAO5qqTe616b6hU8Y2f2MIYwNTZiikFDrpbCg5dU8nBbZRBMePKkvYnptWnY5OF

