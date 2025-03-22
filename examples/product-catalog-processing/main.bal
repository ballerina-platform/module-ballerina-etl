import ballerina/data.jsondata;
import ballerina/edi;
import ballerina/etl;
import ballerina/io;
import ballerina/random;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/log;

configurable string SYMMETRIC_KEY = ?;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new (
    host = HOST, user = USER, password = PASSWORD, port = PORT, database = DATABASE
);

type Product record {
    string productId;
    string name;
    float price;
    int stock;
    string category;
    string brand;
    string supplier;
};

type ProductCatalog record {
    Product[] products;
};

// Use below function to generate a new key and update the SYMMETRIC_KEY in the Config.toml file
function generateKey() returns error? {
    // Generate a new key
    byte[16] aesKey = [];
    foreach var i in 0 ... 15 {
        aesKey[i] = <byte>(check random:createIntInRange(0, 255));
    }
    string newKey = aesKey.toBase64();
    io:println(`New Key: ${newKey}`);
}

public function main() returns error? {

    log:printInfo("Extracting data from EDI file and CSV file...");
    edi:EdiSchema schema = check edi:getSchema(check io:fileReadJson("resources/product_catalog_schema.json"));
    string ediText = check io:fileReadString("resources/product_catalog.edi");
    json orderData = check edi:fromEdiString(ediText, schema);
    ProductCatalog productCatalog = check jsondata:parseAsType(orderData);
    Product[] newProducts = check io:fileReadCsv("resources/new_products.csv");
    log:printInfo("Data extraction completed");

    log:printInfo("Cleaning data...");
    Product[] cleanedProducts = check etl:removeField(productCatalog.products, "code");
    log:printInfo("Data cleaning completed");

    log:printInfo("Merging data...");
    Product[] allProducts = check etl:mergeData([cleanedProducts, newProducts]);
    log:printInfo("Data merging completed");

    log:printInfo("Encrypting data...");
    Product[] encryptedProducts = check etl:encryptData(allProducts, ["supplier"], SYMMETRIC_KEY);
    log:printInfo("Data encryption completed");

    log:printInfo("Categorizing data...");
    Product[][] categorizedProducts = check etl:categorizeNumeric(encryptedProducts, "stock", [[0, 100], [100, 300], [300, 10000]]);
    log:printInfo("Data categorization completed");

    log:printInfo("Loading data to the database...");
    sql:ExecutionResult _ = check dbClient->execute(
    `CREATE TABLE IF NOT EXISTS low_stock_products (
        productId VARCHAR(50),
        name VARCHAR(100),
        price DECIMAL(10, 2),
        stock INT,
        category VARCHAR(50),
        brand VARCHAR(50),
        supplier VARCHAR(50),
        PRIMARY KEY (productId)
        )`
    );
    sql:ExecutionResult _ = check dbClient->execute(
    `CREATE TABLE IF NOT EXISTS medium_stock_products (
        productId VARCHAR(50),
        name VARCHAR(100),
        price DECIMAL(10, 2),
        stock INT,
        category VARCHAR(50),
        brand VARCHAR(50),
        supplier VARCHAR(50),
        PRIMARY KEY (productId)
        )`
    );
    sql:ExecutionResult _ = check dbClient->execute(
    `CREATE TABLE IF NOT EXISTS high_stock_products (
        productId VARCHAR(50),
        name VARCHAR(100),
        price DECIMAL(10, 2),
        stock INT,
        category VARCHAR(50),
        brand VARCHAR(50),
        supplier VARCHAR(50),
        PRIMARY KEY (productId)
        )`
    );
    foreach var product in categorizedProducts[0] {
        sql:ParameterizedQuery query = `INSERT INTO low_stock_products 
        (productId, name, price, stock, category, brand, supplier) 
        VALUES (${product.productId}, ${product.name}, ${product.price}, ${product.stock}, 
                ${product.category}, ${product.brand}, ${product.supplier})`;
        sql:ExecutionResult _ = check dbClient->execute(query);

    }
    foreach var product in categorizedProducts[1] {
        sql:ParameterizedQuery query = `INSERT INTO medium_stock_products 
        (productId, name, price, stock, category, brand, supplier) 
        VALUES (${product.productId}, ${product.name}, ${product.price}, ${product.stock}, 
                ${product.category}, ${product.brand}, ${product.supplier})`;
        sql:ExecutionResult _ = check dbClient->execute(query);
    }
    foreach var product in categorizedProducts[2] {
        sql:ParameterizedQuery query = `INSERT INTO high_stock_products 
        (productId, name, price, stock, category, brand, supplier) 
        VALUES (${product.productId}, ${product.name}, ${product.price}, ${product.stock}, 
                ${product.category}, ${product.brand}, ${product.supplier})`;
        sql:ExecutionResult _ = check dbClient->execute(query);
    }
    log:printInfo("Data loading completed");
}
