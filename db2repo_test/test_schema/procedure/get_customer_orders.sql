CREATE OR REPLACE PROCEDURE DB2REPO_TEST.TEST_SCHEMA.GET_CUSTOMER_ORDERS (CUSTOMER_ID_PARAM VARCHAR)
RETURNS VARCHAR(134217728)
LANGUAGE SQL
AS
DECLARE
    result VARCHAR DEFAULT '';
    c1 CURSOR FOR 
        SELECT ORDER_ID, ORDER_DATE, TOTAL_AMOUNT, STATUS
        FROM ORDERS
        WHERE CUSTOMER_ID = CUSTOMER_ID_PARAM::NUMBER
        ORDER BY ORDER_DATE DESC;
BEGIN
    FOR record IN c1 DO
        result := result || 'Order ID: ' || record.ORDER_ID || 
                  ', Date: ' || record.ORDER_DATE || 
                  ', Amount: ' || record.TOTAL_AMOUNT || 
                  ', Status: ' || record.STATUS || '; ';
    END FOR;
    RETURN result;
END;
