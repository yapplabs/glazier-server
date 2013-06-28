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
    key text NOT NULL,
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pane_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pane_entries (
    id integer NOT NULL,
    pane_id uuid NOT NULL,
    key text NOT NULL,
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pane_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pane_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pane_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pane_entries_id_seq OWNED BY pane_entries.id;


--
-- Name: pane_type_user_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pane_type_user_entries (
    id integer NOT NULL,
    pane_type_name text NOT NULL,
    github_id bigint NOT NULL,
    key text NOT NULL,
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pane_type_user_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pane_type_user_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pane_type_user_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pane_type_user_entries_id_seq OWNED BY pane_type_user_entries.id;


--
-- Name: pane_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pane_types (
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    manifest text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pane_user_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pane_user_entries (
    id integer NOT NULL,
    pane_id uuid NOT NULL,
    github_id bigint NOT NULL,
    key text NOT NULL,
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pane_user_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pane_user_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pane_user_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pane_user_entries_id_seq OWNED BY pane_user_entries.id;


--
-- Name: panes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE panes (
    id uuid NOT NULL,
    repository character varying(255),
    pane_type_name character varying(255) NOT NULL,
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

ALTER TABLE ONLY pane_entries ALTER COLUMN id SET DEFAULT nextval('pane_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pane_type_user_entries ALTER COLUMN id SET DEFAULT nextval('pane_type_user_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pane_user_entries ALTER COLUMN id SET DEFAULT nextval('pane_user_entries_id_seq'::regclass);


--
-- Name: dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (repository);


--
-- Name: page_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY page_templates
    ADD CONSTRAINT page_templates_pkey PRIMARY KEY (key);


--
-- Name: pane_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pane_entries
    ADD CONSTRAINT pane_entries_pkey PRIMARY KEY (id);


--
-- Name: pane_type_user_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pane_type_user_entries
    ADD CONSTRAINT pane_type_user_entries_pkey PRIMARY KEY (id);


--
-- Name: pane_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pane_types
    ADD CONSTRAINT pane_types_pkey PRIMARY KEY (name);


--
-- Name: pane_user_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pane_user_entries
    ADD CONSTRAINT pane_user_entries_pkey PRIMARY KEY (id);


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
-- Name: pane_entries_pane_id_key_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX pane_entries_pane_id_key_idx ON pane_entries USING btree (pane_id, key);


--
-- Name: pane_type_user_entries_pane_type_name_github_id_key_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX pane_type_user_entries_pane_type_name_github_id_key_idx ON pane_type_user_entries USING btree (pane_type_name, github_id, key);


--
-- Name: pane_user_entries_pane_id_github_id_key_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX pane_user_entries_pane_id_github_id_key_idx ON pane_user_entries USING btree (pane_id, github_id, key);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: pane_entries_pane_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pane_entries
    ADD CONSTRAINT pane_entries_pane_id_fkey FOREIGN KEY (pane_id) REFERENCES panes(id) ON DELETE CASCADE;


--
-- Name: pane_type_user_entries_github_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pane_type_user_entries
    ADD CONSTRAINT pane_type_user_entries_github_id_fkey FOREIGN KEY (github_id) REFERENCES users(github_id) ON DELETE CASCADE;


--
-- Name: pane_type_user_entries_pane_type_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pane_type_user_entries
    ADD CONSTRAINT pane_type_user_entries_pane_type_name_fkey FOREIGN KEY (pane_type_name) REFERENCES pane_types(name) ON DELETE CASCADE;


--
-- Name: pane_user_entries_github_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pane_user_entries
    ADD CONSTRAINT pane_user_entries_github_id_fkey FOREIGN KEY (github_id) REFERENCES users(github_id) ON DELETE CASCADE;


--
-- Name: pane_user_entries_pane_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pane_user_entries
    ADD CONSTRAINT pane_user_entries_pane_id_fkey FOREIGN KEY (pane_id) REFERENCES panes(id) ON DELETE CASCADE;


--
-- Name: panes_pane_type_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY panes
    ADD CONSTRAINT panes_pane_type_name_fkey FOREIGN KEY (pane_type_name) REFERENCES pane_types(name) ON DELETE CASCADE;


--
-- Name: panes_repository_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY panes
    ADD CONSTRAINT panes_repository_fkey FOREIGN KEY (repository) REFERENCES dashboards(repository) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130522195433');

INSERT INTO schema_migrations (version) VALUES ('20130531194536');

INSERT INTO schema_migrations (version) VALUES ('20130613142629');

INSERT INTO schema_migrations (version) VALUES ('20130613220234');

INSERT INTO schema_migrations (version) VALUES ('20130613220300');

INSERT INTO schema_migrations (version) VALUES ('20130627220253');