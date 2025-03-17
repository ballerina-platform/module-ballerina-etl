import ballerina/etl;
import ballerina/io;

type Order record {
    int id;
    string customer;
    float price;
};

type OrderArray record {
    Order[] orders;
};

public function main() returns error? {
    // Read order data from the CSV file
    Order[] rawOrderData = check io:fileReadCsv("./resources/order_data.csv");

    //Define the field name and the operation to filter orders with price greater than 100
    string fieldName = "price";
    float value = 100.0;

    // Filter orders based on the price being greater than 100
    Order[][] filteredOrders = check etl:filterDataByRelativeExp(rawOrderData, fieldName, etl:GREATER_THAN, value);

    // Write the filtered data (expensive orders) to a new CSV file
    check io:fileWriteCsv("./resources/expensive_orders.csv", filteredOrders[0]);

    // Write the filtered data (cheap orders) to another CSV file
    check io:fileWriteCsv("./resources/cheap_orders.csv", filteredOrders[1]);
}
