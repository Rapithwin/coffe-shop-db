# coffe-shop-db
University Database Systems project covering database analysis, design, normalization, and SQL implementation.

**Miniworld Summary**

The coffee shop employs Staff who serve Customers. Customers can join a loyalty program to track their contact info and points. When a sale occurs, a staff member records an Order that includes one or more Products (beverages or bakery items). The shop tracks Inventory (like beans and flour) provided by various Suppliers to ensure they never run out of stock.

**Entities**
- Staff: To track names and shift roles
- Customer: To track loyalty members
- Product: To store names and prices for coffee and pastries
- Order: To record the date, time, and total of each sale
- Supplier: To manage the companies providing your beans and ingredients

**Functional Requirements**
- Retrieval: Generate a report showing which Product sold the most during the morning shift
- Update: Automatically reduce the Inventory levels whenever an Order is placed
