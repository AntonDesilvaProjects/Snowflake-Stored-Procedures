/*
    # Conditional Logic

    Snowflake supports "if" and "case" statements for executing conditional logic. Keep in mind that Snowflake Scripting is a block
    based language so there are no curly braces({}). The beginning/end of a block enclosed by some special syntax.

    Below is the syntax for a If-Then-ElseIf-Else Statement([] sections are optional):

    IF (<condition>) THEN
        -- statements
    [ 
        ELSEIF (<condition>) THEN 
        -- statements
    ]
    [
        ELSE
        -- statements
    ]
    END IF;
*/

BEGIN
    LET count := 0;
    IF (count < 0) THEN
        -- include other statements
        RETURN 'negative';
    ELSEIF (count = 0) THEN
        RETURN 'zero';
    ELSE
        RETURN 'positive';
    END IF;
END;

/*
    ## CASE

    Case statement is similar to if-statement but provides simplier syntax when there are many branches. Snowflake supports
    two variation of the case-statement as shown below.

    1. Simple CASE

    CASE (<expression>)
        WHEN <value_1_for_expression> THEN
        -- statement
        WHEN <value_2_for_expression> THEN
        -- statement
        WHEN <value_3_for_expression> THEN
        -- statement
        ELSE 
        -- statment
    END CASE;
*/

BEGIN
    CASE (2 + 3)
        WHEN 4 THEN
            RETURN '4';
        WHEN 5 THEN
            RETURN '5';
        ELSE
            RETURN 'unknown';
    END CASE;
END;

/* 
    Above is called a "simple" case because we have one expression and the CASE statement captures possible values of the expression
    as branches. This version is suitable when we are dealing with one expression that can have many possible values for which we need
    to execute different logic.
    
    Alternatively, we have a "search" based CASE statment that may evalutes something completely different per every branch and run some
    logic:

    CASE
        WHEN <condition> THEN
        -- statement
        WHEN <condition> THEN
        -- statement
        ELSE
        -- statement
    END CASE;

    Note how the CASE statment itself has no expression.
*/

BEGIN
    LET x := 3;
    LET y := 5;
    CASE
        WHEN x = 1 THEN
            RETURN 'x';
        WHEN y = 2 THEN 
            RETURN 'y';
        ELSE 
            RETURN 'unknown';
    END CASE;
END;