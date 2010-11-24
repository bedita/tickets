DROP TABLE IF EXISTS tickets;

CREATE TABLE tickets (
  id INTEGER UNSIGNED NOT NULL,
  severity VARCHAR(30) NULL COMMENT 'ticket severity/priority',
  ticket_status VARCHAR(30) NULL COMMENT 'ticket status, depends from object ',
  exp_resolution_date DATETIME NULL COMMENT 'expected resolution date',
  closed_date DATETIME NULL COMMENT 'actual resolution date, closed issue date',
  percent_completed INTEGER NULL COMMENT 'resolution percentage complete',
  PRIMARY KEY(id),
  FOREIGN KEY(id)
    REFERENCES objects(id)
      ON DELETE CASCADE
      ON UPDATE NO ACTION
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT = 'tickets' ;
