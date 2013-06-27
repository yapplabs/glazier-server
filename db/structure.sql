--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: card_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE card_entries (
    id integer NOT NULL,
    card_id uuid NOT NULL,
    access text NOT NULL,
    github_id bigint,
    key text,
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: card_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE card_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: card_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE card_entries_id_seq OWNED BY card_entries.id;


--
-- Name: card_manifests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE card_manifests (
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    manifest text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dashboards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dashboards (
    repository character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: page_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE page_templates (
    id integer NOT NULL,
    key character varying(255),
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: page_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE page_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE page_templates_id_seq OWNED BY page_templates.id;


--
-- Name: panes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE panes (
    id uuid NOT NULL,
    repository character varying(255),
    card_manifest_name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    github_id bigint NOT NULL,
    github_access_token text,
    github_login text,
    name text,
    email text,
    gravatar_id text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY card_entries ALTER COLUMN id SET DEFAULT nextval('card_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY page_templates ALTER COLUMN id SET DEFAULT nextval('page_templates_id_seq'::regclass);


--
-- Name: card_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_entries
    ADD CONSTRAINT card_entries_pkey PRIMARY KEY (id);


--
-- Name: card_manifests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_manifests
    ADD CONSTRAINT card_manifests_pkey PRIMARY KEY (name);


--
-- Name: dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (repository);


--
-- Name: page_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY page_templates
    ADD CONSTRAINT page_templates_pkey PRIMARY KEY (id);


--
-- Name: panes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY panes
    ADD CONSTRAINT panes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (github_id);


--
-- Name: index_card_entries_on_card_id_and_access_and_github_id_and_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_card_entries_on_card_id_and_access_and_github_id_and_key ON card_entries USING btree (card_id, access, github_id, key);


--
-- Name: index_page_templates_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_page_templates_on_key ON page_templates USING btree (key);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: panes_card_manifest_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY panes
    ADD CONSTRAINT panes_card_manifest_name_fkey FOREIGN KEY (card_manifest_name) REFERENCES card_manifests(name) ON DELETE CASCADE;


--
-- Name: panes_repository_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY panes
    ADD CONSTRAINT panes_repository_fkey FOREIGN KEY (repository) REFERENCES dashboards(repository) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130522195433');

INSERT INTO schema_migrations (version) VALUES ('20130523220519');

INSERT INTO schema_migrations (version) VALUES ('20130530213906');

INSERT INTO schema_migrations (version) VALUES ('20130531194536');

INSERT INTO schema_migrations (version) VALUES ('20130613142629');

INSERT INTO schema_migrations (version) VALUES ('20130613220234');

INSERT INTO schema_migrations (version) VALUES ('20130613220300');