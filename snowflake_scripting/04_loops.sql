/*
    # Loops

    Ref: https://docs.snowflake.com/en/developer-guide/snowflake-scripting/loops

    Snowflake supports all the traditional looping constructs found in other programming langauges.
*/

-- FOR loop
BEGIN
    LET result VARCHAR := '';
    
    FOR i IN 1 TO 5 DO -- both start and end are inclusive: [1, 2, 3, 4, 5]
        result := result || ' ' || i;
    END FOR;
    
    RETURN result;
END;

-- FOR loop in reverse
BEGIN
    LET result VARCHAR := '';

    FOR x IN REVERSE 1 to 5 DO
        result := result || ' ' || x;
    END FOR;
    
    RETURN result;
END;

-- FOR loop on a CURSOR
BEGIN
    CREATE OR REPLACE TEMP TABLE customers(id NUMBER, name VARCHAR);
    INSERT INTO customers VALUES (1, 'John Smith'), (2, 'Jane Doe');

    LET result := '';
    LET customer_cursor CURSOR FOR SELECT * FROM customers; -- declare a CURSOR for above table

    FOR record IN customer_cursor DO 
        result := result || ' ' || record.name;
    END FOR;

    RETURN result;
END;


-- WHILE loop

BEGIN
    LET counter := 0;
    LET result := '';

    WHILE (counter < 10) DO 
        result := result || ' ' || counter;
        counter := counter + 1;
    END WHILE;

    RETURN result;
END;

-- REPEAT (or DO-WHILE) loop: for executing loop at least once

BEGIN
    LET result VARCHAR DEFAULT '';
    LET counter INTEGER DEFAULT 0;

    REPEAT
        result := 'executed!';
    UNTIL(counter = 0)
    END REPEAT;
    
    RETURN result;
END;

-- LOOP loop: for infinite loops(alternate for while(1 = 1) DO ...)

BEGIN
    LET counter := 0;
    LET result := '';

    LOOP
        result := result || ' ' || counter;
        IF (counter = 10) THEN
            BREAK; -- loop stops with this break
        END IF;
        counter := counter + 1;
    END LOOP;

    RETURN result;
END;

/* 
    Note that BREAK and CONTINUE can be used with any of these loops to exit or skip iteration, respectively. 
*/