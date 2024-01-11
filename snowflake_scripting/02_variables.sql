/*
    # VARIABLES

    Ref: https://docs.snowflake.com/en/developer-guide/snowflake-scripting/variables

    There are few ways to declare variables in Snowflake Scripting. First is within the DECLARE section where we can use one of the following:

    <variable_name> <type>;
    <variable_name> {DEFAULT | := } <expression>;
    <variable_name> <type> {DEFAULT | := } <expression>;

    First variation creates a variable with a specific type; second one doesn't specify the data type but lets SF figure it out using
    the DEFAULT value; third is the most complete delcaration.

    Note that instead of using DEFAULT keyword, we can use := to assign default value directly.

    As for the actual type, it can be a SQL data type, a CURSOR, RESULTSET, or an EXCEPTION.
*/

DECLARE
    name VARCHAR;
    age := 1;
    gender VARCHAR DEFAULT 'unspecified';
BEGIN
    RETURN age;
END;

/* 
    The second way to declare variables is within the BEGIN...END blocks. Below is the syntax:

    LET <variable_name> <type> {DEFAULT | := } <expression>;
    LET <variable_name> {DEFAULT | := } <expression>;

    The key difference here is that we need to use the LET keyword.
*/

BEGIN
    LET x NUMBER DEFAULT 12;
    LET y NUMBER := 10;

    x := x * 10;

    RETURN x * y;
END;

DECLARE
    profit NUMBER(38, 2) DEFAULT 0.0;
BEGIN
    LET cost NUMBER(38, 2) := 100.0;
    LET revenue NUMBER(38, 2) DEFAULT 110.0; -- alt way to set default value

    profit := revenue - cost;

    RETURN profit;
END;

/*
    ## Variable Scope

    When we declare a variable within the DECLARE section, that variable is only visible to it's block(the BEGIN...END section) or any
    nested blocks within that. 

    Any variables declared within a block is only visible to that block or any nested blocks.
*/

DECLARE
    -- accessible within the block or nested block
    first_name VARCHAR := 'Anton';
    last_name VARCHAR := 'De Silva';
BEGIN
    LET full_name VARCHAR; -- accessible within this block and nested block
    BEGIN
        LET prefix VARCHAR := 'Mr'; -- not accessible outside this block
        full_name := prefix || ' ' || first_name || ' ' || last_name;
    END;
    RETURN full_name;
END;

/*
    ## Assigning and Using Variables

    To assign a value to a variable that already declared, we can use the ":=" operator. Using the equal sign(=) does not work
    because it reserved for use by SQL statments(i.e. SELECT .. FROM table WHERE name =)
*/

BEGIN
    LET str VARCHAR := '12.5'; 
    LET num NUMBER(5,2);
    
    num := CAST(str AS NUMBER(5,2)) * 10; -- variable assignment can call SQL functions & UDFs
    
    RETURN num;
END;

/*
    When using variables, there are really 3 use cases:

    1. Using variables within Snowflake Scripting language as we seen before. This includes things like RETURN statement or string concatenation.
    In such cases, we can use the variable identifier as is:

    RETURN myNum;
    LET sql VARCHAR := 'SELECT * FROM ' || my_table_name;

    2. Using variable as a SQL bind variable: if we are executing a query directly within Snowflake Scripting, and we want to inject
    the variable's value into the query, we need to prefix the variable with colon as shown below:
*/

BEGIN
    LET num := 1;
    SELECT 1 = :num; -- using variable within a query requires a colon
END;

/*
    3. Using variable value as a Snowflake Object: if the variable has the name of SF object, we need to use the special keyword
    IDENTIFIER to express that varaible value refer to a Snowflake object:
*/
BEGIN
    LET schemaName := 'INFORMATION_SCHEMA';
    LET tableName := 'DATABASES';
    LET fullName := schemaName || '.' || tableName;

    SELECT * FROM IDENTIFIER(:fullName);
END;

/*
    ## Extracting result of a SQL query into variables

    If we run a query that returns just ONE row, we can extract the values of that row into variables
*/

CREATE OR REPLACE PROCEDURE tutorial.stored_procs.current_info()
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
    LET current_account VARCHAR := 'unknown_account';
    LET current_role VARCHAR := 'unknown_role';
    LET current_user VARCHAR := 'unknown';
    
    SELECT current_account(), current_role(), current_user() INTO :current_account, :current_role, :current_user;

    RETURN current_account || ',' || current_role || ',' || current_user;
END;

CALL tutorial.stored_procs.current_info();

/* 
    We can use the same INTO syntax to get values of another stored proc that returns a scalar value
 */

 BEGIN
    LET result VARCHAR DEFAULT 'unknown';
    CALL tutorial.stored_procs.current_info() INTO :result;
    RETURN 'Result from Proc: ' || result;
 END;

