/*
    # RESULTSETs

    Ref: https://docs.snowflake.com/en/developer-guide/snowflake-scripting/resultsets

    In Snowflake, a RESULTSET is a *SQL data type* that points to the results of some query. In another words, RESULTSETs allow us to declare
    variable whose type refers to some set of rows. RESULTSETs are just pointers to data so in order to work with the actual records,
    we need to do one of the following:

    1. Use the "TABLE(<resultset>)" syntax to retreive the results into a table.
    2. Use a cursor to iterate through a RESULTSET, one row at a time.

    Both CURSORs and RESULTSETs seems to do similar things - they both allow us to run a query and get the results but there are two important
    distinctions:
    
    1. Query Execution Time: For CURSORs, the query is executed only when we call OPEN. For RESULTSETs, the query gets executed immediately when
    we assign it to a variable. Since RESULTSETs are just pointers, the actual results of the query are cached by Snowflake for 24 hours.
    2. Bind Variables: CURSORs support bind variables using USING syntax, RESULTSETs do not.

    Below is an example of using a RESULTSET:
*/

-- get a table from resultset
DECLARE
    -- query runs instantly
    stored_procs RESULTSET DEFAULT(SELECT procedure_name, procedure_owner, created FROM tutorial.information_schema.procedures);
BEGIN
    RETURN TABLE(stored_procs);
END;

-- dynamic query
BEGIN
    LET database VARCHAR := 'tutorial';
    LET schema VARCHAR := 'information_schema';
    LET tableName VARCHAR := 'procedures';

    LET query VARCHAR := 'SELECT * FROM ' || database || '.' || schema || '.' || tableName;
    LET result RESULTSET := (EXECUTE IMMEDIATE :query); -- query runs instantly

    RETURN TABLE(result);
END;

/*
    Above Anonymous function returns a table as a result. If we want to return a Table from a stored proc,
    we need to explicit declare it in the method signature:
*/
CREATE OR REPLACE PROCEDURE tutorial.stored_procs.ls_proc()
RETURNS TABLE() -- we can specify the actual column & data types or use () to say table with "any schema"
LANGUAGE SQL
AS
BEGIN
    LET database VARCHAR := 'tutorial';
    LET schema VARCHAR := 'information_schema';
    LET tableName VARCHAR := 'procedures';

    LET query VARCHAR := 'SELECT * FROM ' || database || '.' || schema || '.' || tableName;
    LET result RESULTSET := (EXECUTE IMMEDIATE :query); -- query runs instantly

    RETURN TABLE(result);
END;

CALL tutorial.stored_procs.ls_proc();



/*
    We can use a CURSOR to iterate through the results of a RESULTSET.
*/
DECLARE
    stored_procs_rs RESULTSET := (SELECT procedure_name, procedure_owner, created FROM tutorial.information_schema.procedures);
    stored_procs_c CURSOR FOR stored_procs_rs;
BEGIN
    LET result_str := '';
    FOR record IN stored_procs_c DO
        result_str := result_str || ', ' || record.procedure_name;
    END FOR;

    RETURN result_str;
END;

/*
    In above example, the CURSOR does not re-OPEN the query; It is executed only once.

    ## Limitations

    Although RESULTSET is a SQL Data Type, we cannot use it in all case where we use other data types:
    
    1. RESULTSET cannot be a column type in a table
    2. RESULTSET cannot be a parameter type in a proc/function
    3. RESULTSET cannot be returned by a proc/function.

    In other words, RESULTSET is only applicable within Snowflake Scripting language. Also, we cannot query a RESULTSET directly either. So
    basically, if we want to transport a RESULTSET, then we need to wrap in a table.

    Below is an example of returning a TABLE from a stored procedure:
*/

