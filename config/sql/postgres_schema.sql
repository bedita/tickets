DROP TABLE IF EXISTS tickets;

CREATE TABLE tickets (
  id INTEGER UNSIGNED NOT NULL,
  severity VARCHAR(30) NULL COMMENT 'ticket severity/priority',
  ticket_status VARCHAR(30) NULL COMMENT 'ticket status, depends from object ',
  exp_resolution_date DATETIME NULL COMMENT 'expected resolution date',
  closed_date DATETIME NULL COMMENT 'actual resolution date, closed issue date',
  percent_completed INTEGER NULL COMMENT 'resolution percentage complete'
);

ALTER TABLE tickets ADD CONSTRAINT tickets_pk PRIMARY KEY (id);
ALTER TABLE tickets ADD CONSTRAINT tickets_fk1 FOREIGN KEY (id) REFERENCES objects(id) MATCH FULL ON DELETE CASCADE;
