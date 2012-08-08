DROP TABLE IF EXISTS tickets;

CREATE TABLE tickets (
  id INTEGER NOT NULL,
  severity VARCHAR(30),
  ticket_status VARCHAR(30),
  exp_resolution_date timestamp without time zone,
  closed_date timestamp without time zone,
  percent_completed INTEGER
);

ALTER TABLE tickets ADD CONSTRAINT tickets_pk PRIMARY KEY (id);
ALTER TABLE tickets ADD CONSTRAINT tickets_fk1 FOREIGN KEY (id) REFERENCES objects(id) MATCH FULL ON DELETE CASCADE;
