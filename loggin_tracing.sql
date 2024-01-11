USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE DATABASE tutorial_log_trace_db;

CREATE OR REPLACE WAREHOUSE tutorial_log_trace_wh
  WAREHOUSE_TYPE = STANDARD
  WAREHOUSE_SIZE = XSMALL;


-- Create an event table and assign it to the account; we can have only ONE event table per account
CREATE OR REPLACE EVENT TABLE tutorial_event_table;

ALTER ACCOUNT SET EVENT_TABLE = tutorial_log_trace_db.public.tutorial_event_table;

SHOW PARAMETERS LIKE 'event_table' IN ACCOUNT;


ALTER DATABASE tutorial_log_trace_db SET LOG_LEVEL = INFO;
ALTER SESSION SET LOG_LEVEL = DEBUG;

CREATE OR REPLACE PROCEDURE test_log()
RETURNS VARCHAR
LANGUAGE SQL
AS
BEGIN
    SYSTEM$LOG_INFO('Information-level message');
END;


CALL test_log();

SELECT * FROM tutorial_log_trace_db.public.tutorial_event_table;