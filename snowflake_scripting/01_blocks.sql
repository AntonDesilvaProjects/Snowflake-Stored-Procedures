/*
    # BLOCKS

    Ref: https://docs.snowflake.com/en/developer-guide/snowflake-scripting/blocks

    In Snowflake Scripting, any procedural logic is written within a Scripting block. A block has the following basic structure:

    DECLARE
        -- variable, cursor, etc declarations
    BEGIN
        -- snowflake scripting and SQL statements
    EXCEPTION
        -- statements for handling exceptions
    END;

    The DECLARE section is for specifying variables, cursors, results sets, and exceptions. It is optional.
    The BEGIN...END section is for the actual logic.
    The EXCEPTION section handles exceptions. It is optional.

    Below is a simple example:
*/

BEGIN
    RETURN 'Hello World!';
END;

/*
    Above is a block that's no associated with any stored procedure, called an "anonymous block". Such blocks are executed immediately.
    Furthermore, the result will display "anonymous block".

    Below is an example block that declares variables:
*/

DECLARE
    radius_of_circle FLOAT;
    area_of_circle FLOAT;
BEGIN
    radius_of_circle := 3;
    area_of_circle := pi() * radius_of_circle * radius_of_circle;
    RETURN area_of_circle;
END;

/*
    In this example, we declare two variables in the DECLARE section and then populate them in the BEGIN...END section. Such variables are scoped
    to the block and cannot be used outside. 

    Anonymous block are executed immediately and cannot be reused; so, we can integrate blocks into a resusable stored procedure.
*/

CREATE OR REPLACE PROCEDURE tutorial.stored_procs.area_of_circle()
    RETURNS FLOAT
    LANGUAGE SQL
    AS
        DECLARE
            radius_of_circle FLOAT;
            area_of_circle FLOAT;
        BEGIN
            radius_of_circle := 3;
            area_of_circle := pi() * radius_of_circle * radius_of_circle;
            RETURN area_of_circle;
        END;

CALL tutorial.stored_procs.area_of_circle();

/*
    Above procedure can be invoked as many times as needed. Furthermore, the output will now say "AREA_OF_CIRCLE"(proc name) instead
    of "anonoymous block".
*/