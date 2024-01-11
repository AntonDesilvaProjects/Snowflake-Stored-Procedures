/*
    # Exceptions

    Snowflake Scripting supports both raising(i.e. "throwing") and handling(i.e. "catching") exceptions. We can also define our own
    exception and raise them throughout the code to provide more meaningful feedback as to what went wrong.

    Below is a simple example:
*/

DECLARE
    my_exception EXCEPTION (-20002, 'My Custom Exception!');
BEGIN
    LET should_raise_exc BOOLEAN := true;
    IF (should_raise_exc) THEN
        RAISE my_exception; -- use "RAISE" keyword to throw the exception
    END IF;

    RETURN 'Completed Execution Successfully!';
END;

/*
    First note that the syntaxt for exception declaration is slight different than we have seen before(there is not := or DEFAULT). Next,
    the exception "constructor" takes an "exception number" which according SF docs:

    "A number to uniquely identify the exception. The number must be an integer between -20000 and -20999. The number should not be used for any other exception that exists at the same time."

    We can also include an optional message with the exception.
*/

/* 
    ## Handling Exceptions

    Once exception is raised, we can either handle it in a EXCEPTION block or pass it to the enclosing block. 

    Below is simple example of handling above exception:
 */
DECLARE
    my_exception EXCEPTION (-20002, 'My Custom Exception!');
BEGIN
    LET should_raise_exc BOOLEAN := true;
    IF (should_raise_exc) THEN
        RAISE my_exception; -- use "RAISE" keyword to throw the exception
    END IF;

    RETURN 'Completed Execution Successfully!';
EXCEPTION
    WHEN my_exception THEN 
        -- 'object_construct' function creates a OBJECT variant
        RETURN OBJECT_CONSTRUCT(
            'Error Type', 'My Custom Error',
            'SQLCODE', sqlcode,
            'SQLERRM', sqlerrm,
            'SQLSTATE', sqlstate
        );
    WHEN OTHER THEN
        RETURN OBJECT_CONSTRUCT(
            'Error Type', 'Unexpected Error',
            'SQLCODE', sqlcode,
            'SQLERRM', sqlerrm,
            'SQLSTATE', sqlstate
        );
END;

/*
    As we can see, we declare an EXCEPTION block to deal with errors. Within this block, we can handle different types of errors
    based on the type using CASE statement like syntax. In above example, we have a specific branch for our custom exception("my_exception") and an "OTHER" branch to handle anything else. Snowflake by default provides two built in exceptions which we can handle separately if needed:

    STATEMENT_ERROR - an error related to a SQL statement
    EXPRESSION_ERROR - an error related Snowflake Scriping expression

    Furthermore, Snowflake provides 3 built-in variables that provides additional details about the error:

    sqlcode - code from the exception
    sqlerrm - message from the exception
    sqlstate - sql state as per ANSI standard

    Below is another example of handling error including nested error as well as rethrowing error:
*/

DECLARE
    my_exception_1 EXCEPTION (-20002, 'my error #1!');
    my_exception_2 EXCEPTION (-20003, 'my error #2!');
BEGIN
    LET input VARCHAR := 'd';
    LET return_value VARCHAR := 'unspecified';

    -- inner block that executes logic that may throw an error
    BEGIN
        CASE(input)
            WHEN 'a' THEN
                RAISE my_exception_1;
            WHEN 'b' THEN
                RAISE my_exception_2;
            WHEN 'c' THEN
                return_value := 12 / 0; -- simulate expression error
            ELSE 
                return_value := 'some_value';
        END CASE;
    EXCEPTION
        WHEN my_exception_1 THEN
            return_value := 'error for value a'; -- handle the error
        WHEN OTHER THEN
            RAISE; -- "rethrow" the exception
    END;

    RETURN 'Result: ' || return_value;
EXCEPTION
    WHEN my_exception_2 THEN
        RETURN 'Exception 2: ' || sqlcode || ' - ' || sqlerrm;
    -- will not catch expression_error
END;