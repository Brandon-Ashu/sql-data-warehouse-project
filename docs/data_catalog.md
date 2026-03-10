1. **gold.dim_customers**
   - **Purpose**: Stores customers details enriched with demographic and geographic data
   - **Columns**:

|Column Name |     Data Type        |Description                                                                       |
|-------------|----------------------|-----------------------------------------------------------------------------------|
|customer_key |     INT              |Surrogate key uniquely identifying each customer record in the dimension table     |
|customer_id  |  INT                 |Unique numerical identifier assigned to each customer                              |
|customer_number| VARCHAR(50)        |Alphanumeric identifier representing the customer, used for tracking and referencing|
|first_name    | VARCHAR(50)         |The customer's first name as recorded in the system                                 |
|last_name     | VARCHAR(50)         |The customer's last name or family name                                             |
|country       | VARCHAR(50)         |Country of residence for the customer(e.g Australia)                                |
|marital_status| VARCHAR(50)         |The marital status of the customer(e.g 'married','single')                          |
|gender        | VARCHAR(50)          |The gender of the customer(e.g 'male','female')                                    |
|birthdate     | DATE                 |Customer date of birth, formatted as YYYY-MM-DD(e.g '1971-05-10')                  |    
|create_date   | DATE                 |The date and time when the customer record was created                             |


2. **gold.dim_products**
   - **Purpose**: provides information about the products and their attributes
   - **Columns**:

|Column Name |     Data Type       |Description                                                                       |
|-------------|--------------------|-----------------------------------------------------------------------------------|
|product_key  |     INT            |Surrogate key uniquely identifying each product record in the product dimension table|
|product_id  |  INT                 |Unique numerical identifier assigned to the product for internal tracking and referencing                               |
|product_number| VARCHAR(50)        |Alphanumeric code representing the product,often used for categorization and inventory|
|product_name   | VARCHAR(50)         |Descriptive name of the product including key details such as type, colour and size                               |
|category_id   | VARCHAR(50)         |A unique identifier of the product's category, linking to high-level classification.                                          |
|category      | VARCHAR(50)         |The broader classification of the product(e.g bikes,components) to group related items                              |
|subcategory| VARCHAR(50)         |A more detailed classification of the product within the category such as product type                         |
|maintenance      | VARCHAR(50)          | Indicates whether the product requires maintenance(e.g, 'Yes','No')              |
|cost    | DATE                 |The cost or base price of the product, measured in monetary units               |    
|product_line| VARCHAR(50) | The specific product line or series to which the product belongs (e.g Road,Mountain,Touring,Unknown, Other sales)
|start_date   | DATE                 |The date in which the product became available for sale or use, stored in 'YYYY-MM-DD'(e.g '2003-07-01')                           |

