/*DDL*/
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    street VARCHAR(100),
    postal_code VARCHAR(10),
	role_type VARCHAR(50),
    phone VARCHAR(20),
    salary INT,
    hire_date DATE,
    birth_date DATE,
    staff_role VARCHAR(20)
);

CREATE TABLE staff_shifts (
    staff_id INT REFERENCES staff(staff_id),
    start_shift TIMESTAMP NOT NULL,
    end_shift TIMESTAMP CHECK(end_shift > start_shift),
    PRIMARY KEY (staff_id, start_shift)
);

CREATE TABLE manager (
    staff_id INT PRIMARY KEY REFERENCES staff(staff_id)
);

CREATE TABLE cashier (
    staff_id INT PRIMARY KEY REFERENCES staff(staff_id)
);

CREATE TABLE barista (
    staff_id INT PRIMARY KEY REFERENCES staff(staff_id)
);

CREATE TABLE janitor (
    staff_id INT PRIMARY KEY REFERENCES staff(staff_id)
);

CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    street VARCHAR(100),
    postal_code VARCHAR(10),
    phone VARCHAR(20)
);

CREATE TABLE item (
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price INT CHECK (price >= 0),
    sale_price INT CHECK (sale_price >= 0),
    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0)
);

CREATE TABLE supplier (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    street VARCHAR(100),
    postal_code VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(100),
    supply_type VARCHAR(50)
);

CREATE TABLE supplier_items (
    supplier_id INT REFERENCES supplier(supplier_id),
    item_id INT REFERENCES item(item_id),
    quantity INT DEFAULT 0 CHECK (quantity >= 0),
    PRIMARY KEY (supplier_id, item_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    order_time TIME NOT NULL DEFAULT CURRENT_TIME,
    total_payment INT DEFAULT 0 CHECK (total_payment >= 0),
    payment_method VARCHAR(50),
    customer_id INT REFERENCES customer(customer_id),
    staff_id INT REFERENCES staff(staff_id) -- The staff member who took the order
);

CREATE TABLE order_items (
    order_id INT REFERENCES orders(order_id),
    item_id INT REFERENCES item(item_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_sale INT,
    PRIMARY KEY (order_id, item_id)
);

CREATE OR REPLACE FUNCTION update_total_payment()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE orders
    SET total_payment = (
        SELECT COALESCE(SUM(quantity * price_at_sale), 0)
        FROM order_items
        WHERE order_id = COALESCE(NEW.order_id, OLD.order_id)
    )
    WHERE order_id = COALESCE(NEW.order_id, OLD.order_id);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_total_payment
AFTER INSERT OR UPDATE OR DELETE
ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_total_payment();

/*DML*/
INSERT INTO staff (first_name, last_name, city, street, postal_code, phone,role_type, salary, hire_date, birth_date)
VALUES 
('John', 'Smith', 'New York', '123 Espresso Way', '10001', '555-0101', 'Barista', 3500000, '2023-01-15', '1990-05-20'),
('Alice', 'Wong', 'Brooklyn', '456 Latte Ln', '11201', '555-0102','Cashier', 3200000, '2023-03-10', '1995-10-10');

INSERT INTO barista (staff_id) VALUES (1);
INSERT INTO cashier (staff_id) VALUES (2);

INSERT INTO item (name, description, price, sale_price, stock_quantity)
VALUES 
('Espresso', 'Rich and bold double shot', 30000, 30000, 100),
('Latte', 'Creamy steamed milk and espresso', 45000, 45000, 50),
('Coffee Beans', '1kg bag of house blend', 150000, 120000, 20);


INSERT INTO customer (first_name, last_name, city, street, postal_code, phone)
VALUES 
('Robert', 'Smith', 'New York', '789 Coffee Blvd', '10002', '555-0201'),
('Alicia', 'Zelaya', 'Brooklyn', '321 Roast St', '11202', '555-0202');

INSERT INTO supplier (name, city, street, postal_code, phone, email, supply_type)
VALUES 
('Premium Roast Co.', 'Seattle', '789 Arabica St', '98101', '555-0301', 'orders@premiumroast.com', 'Coffee Beans'),
('Green Valley Dairy', 'Jersey City', '101 Pasture Rd', '07302', '555-0302', 'delivery@greenvalley.com', 'Dairy');

INSERT INTO supplier_items (supplier_id, item_id, quantity) 
VALUES (1, 3, 100);

INSERT INTO supplier_items (supplier_id, item_id, quantity) 
VALUES 
(2, 1, 500),
(2, 2, 500);

INSERT INTO orders (customer_id, staff_id, payment_method)
VALUES (1, 2, 'Cash');

INSERT INTO Order_Items (
    order_id,
    item_id,
    quantity,
    price_at_sale
)
SELECT
    1,
    item_id,
    2,
    price
FROM Item
WHERE item_id = 2;

INSERT INTO Order_Items (
    order_id,
    item_id,
    quantity,
    price_at_sale
)
SELECT
    1,
    item_id,
    1,
    price
FROM Item
WHERE item_id = 1;

