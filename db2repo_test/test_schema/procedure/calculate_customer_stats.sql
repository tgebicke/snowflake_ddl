CREATE OR REPLACE PROCEDURE TEST_SCHEMA.CALCULATE_CUSTOMER_STATS (CUSTOMER_ID_PARAM VARCHAR)
RETURNS OBJECT
LANGUAGE JAVASCRIPT
AS
$$
function calculateStats(customerId) {
    // Query to get customer data test test test
    var customerQuery = `SELECT FIRST_NAME, LAST_NAME FROM CUSTOMERS WHERE CUSTOMER_ID = ${customerId}`;
    var customerResult = snowflake.execute({sqlText: customerQuery});
    
    if (customerResult.next()) {
        var firstName = customerResult.getColumnValue(1);
        var lastName = customerResult.getColumnValue(2);
        
        // Query to get order statistics
        var statsQuery = `
            SELECT 
                COUNT(*) as TOTAL_ORDERS,
                SUM(TOTAL_AMOUNT) as TOTAL_SPENT,
                AVG(TOTAL_AMOUNT) as AVG_ORDER_VALUE
            FROM ORDERS 
            WHERE CUSTOMER_ID = ${customerId}
        `;
        var statsResult = snowflake.execute({sqlText: statsQuery});
        
        if (statsResult.next()) {
            return {
                customer_name: firstName + " " + lastName,
                total_orders: statsResult.getColumnValue(1),
                total_spent: statsResult.getColumnValue(2),
                avg_order_value: statsResult.getColumnValue(3)
            };
        }
    }
    
    return {error: "Customer not found"};
}

return calculateStats(CUSTOMER_ID_PARAM);
$$
