/*
    # Cursors

    Ref: https://docs.snowflake.com/en/developer-guide/snowflake-scripting/cursors

    Cursors allow us to iterate through the rows of a RESULTSET or a query, one row at a time. To use a cursor, we need to
    follow the below steps:

    1. Declare the cursor either in the DECLARATION section or in the BEGIN...END blocks. 

    DECLARE
        my_cursor CURSOR FOR SELECT....;

    BEGIN
        LET my_cursor CURSOR FOR SELECT...;

    Note that in BEGIN...END block, we don't use a := for variable declaration.

    We can also create a cursor out a RESULTSET(which is just a reference to some rows).

    rs RESULTSET := SELECT...
    my_cursor CURSOR FOR rs;


    Cursor also has a feature where we can use bind variables in it query:

    my_cursor CURSOR FOR SELECT * FROM my_table WHERE status = ?;

    The ? can be replaced dynamically when the cursor is "opened" using the USING keyword:

    OPEN my_cursor USING(my_status_variable);

    2. Opening a cursor

    When we declare the CURSOR, we simply associate a SQL query with it but that query is not executed until we
    "open" the CURSOR as shown below:

    OPEN my_cursor;
    OPEN my_cursor USNG (my_status_variable);

    Note that cursors don't order rows in any specific way. If ordering is desired, the SQL query should include an
    ORDER BY clause.

    3. Fetching Data

    Once the cursor is opened, we can use it retrieve rows. We can use the FETCH command to "load" values of the rows
    to variable for our processing:

    FETCH my_cursor INTO my_var_col_1, my_var_col_2,....

    FETCH...INTO is pretty flexible in terms of copying data. If there is a mismatch in the columns available from the
    query and the number of varaibles, additional/missing ones are ignored.

    4. Closing 

    Once we are done, we would need to close the CURSOR. A closed cursor cannot return any more rows and reopening the cursor goes
    back to the beginning. 

    Note: All the above steps are only for manually working with CURSORS. If we use a For loop, it will all be handled automatically.
*/

DECLARE
    table_names VARCHAR DEFAULT '';
    table_cursor CURSOR FOR SELECT table_name FROM tutorial.information_schema.tables WHERE table_type = ? ORDER BY table_name;
BEGIN
    LET current_tbl_name VARCHAR;
    -- open the cursor
    OPEN table_cursor USING ('VIEW');
    -- fetch first row
    FETCH table_cursor INTO current_tbl_name;
    table_names := table_names || ' ' || current_tbl_name;

    -- fetch the next row
    FETCH table_cursor INTO current_tbl_name;
    table_names := table_names || ' ' || current_tbl_name;

    -- close the cursor
    CLOSE table_cursor;

    RETURN table_names;
END;




