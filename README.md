# coffe-shop-db
University Database Systems project covering database analysis, design, normalization, and SQL implementation.

**Miniworld Summary**

The coffee shop employs Staff who serve Customers. Customers can join a loyalty program to track their contact info and points. When a sale occurs, a staff member records an Order that includes one or more Products (beverages or bakery items). The shop tracks Inventory (like beans and flour) provided by various Suppliers to ensure they never run out of stock.

**Entities and Attributes**
- Staff: staff_id, name(first, last), address(city, street, postal_code), phone, salary, hire_date, birth_date, start_time, end_time
- Customer: customer_id, name(first, last), phone, address(city, street, postal_code) 
- Item: item_id, name(first, last), description, price, sale_price
- Order: order_id, date, time, total_payment, payment_method
- Supplier: supplier_id, name, address(city, street, postal_code), phone, email, supply_type

**Staff Specialization**
- Superclass: Staff
- Subclasses: Manager, Cashier, Barista, Janitor
- Constraints: Disjoint and Partial Participation
- Business Rule: Each employee belongs to at most one specialized role, and some general employees may not belong to any subclass

**Functional Requirements**
- Retrieval: Generate a report showing which Product sold the most during the morning shift
- Update: Automatically reduce the Inventory levels whenever an Order is placed

**Relationships**
- Customer "places" Order (1:N): One customer can place many orders, but each order belongs to exactly one customer
- Order "contains" Item (M:N): One order can include many items, and an item can be in many different orders. Relationship Attribute: Quantity
- Supplier "supplies" Item (M:N): Suppliers provide multiple items, and items can be sourced from multiple vendors. Relationship Attribute: Supply_Price
- Cashier "takes" Order (1:N): One cashier handles many orders, but an order is recorded by only one staff member
