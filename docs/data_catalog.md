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
