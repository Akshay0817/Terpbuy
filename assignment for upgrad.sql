use terpbuy;
/*Question 1:*/
/*How many rows of data are stored for each table in the database? List the name of each table followed by the number of rows it has.*/
select table_name as "Table Name" , table_rows As "Number of Rows"
from information_schema.tables
where table_schema = "terpbuy";
/* Akshay Singh - 25/09/2023 */


/*Question 2:*/ 
/*Which products are considered high-priced products? A high-priced product has a price exceeding $100.00. List the names and prices of the high-priced products*/

select product_name,product_price
from product
where product_price > 100.00;
/*Akshay Singh - 23/09/2023 */




/*Question 3:*/ 
/*List all orders placed by customers in the state of Florida. Note: The state abbreviation for Florida is 'FL'. Include the customers’ first names, last names, city, and segment, along with the order ID and order date.*/
select  first_name, last_name, city, state, segment,order_id,order_date
from customer
	inner join orders on orders.customer_id=customer.customer_id
    where state = "FL";
/*Akshay Singh - 22/09/2023 */


/*Question 4:*/ 
/*List all products that fall in one of the following categories: 'Computers', 'Toys', 'Tennis  & Racquet'. Include the products’ names, category, department, and price.*/
select category.category_id,product.department_id , category_name, product_name, product_price,department_name
from category
	inner join product on product.category_id=category.category_id 
    inner join department on department.department_id=product.department_id
    where category_name = "Computers"
    OR category_name = "Toys"
    OR category_name = "Tennis & Racquet";
    /*Akshay Singh - 22/09/2023 */
    
/*Question 5:*/ 
/*TerpBuy is considering reducing its product offerings. Which products have not yet been sold? Include the name, category, and department for each such product.*/
select product_name , product.category_id ,category_name, department_name
from orders
inner join order_line on order_line.order_id = orders.order_id
    inner join product on product.product_id = order_line.product_id
		inner join category on category.category_id = product.category_id
        inner join department on department.department_id = product.department_id
        where order_status in ( 'ON_HOlD' , 'PROCESSING' );
		/*Akshay Singh - 25/09/2023 */


/*Question 6:*/
#List the names of all cities from where orders are shipped. Also, for such cities, find the number of orders for which shipping was delayed. Sort the list of cities in order from the highest to the least number of shipping orders.
select orders.order_id, order_city
from orders
	inner join order_line on order_line.order_id = orders.order_id
    where actual_shipping_days > scheduled_shipping_days
order by scheduled_shipping_days desc;
/*Akshay Singh - 25/09/2023 */

/*Question 7:*/
/*How many customers are there in each segment? Show the most popular segment at the top of the result. Incorporate a column alias in the result.*/
    
SELECT
    segment AS "Customer Segment",
    COUNT(*) AS "Number of Customers"
FROM
    customer
GROUP BY
    segment
ORDER BY
    COUNT(*) DESC;
/*Akshay Singh - 24/09/2023 */


# Question 8:
/*How many orders were placed in the first quarter of 2021? Note: A quarter consists of three months. Incorporate a column alias in the result.*/ 
select count(order_id) as "first quarter order"
from orders
where order_date between "2021-01-01" and "2021-03-31";
/*Akshay Singh - 24/09/2023 */




/* Question 9:*/
/*List in alphabetical order all states supporting multiple customer segments.*/
select state, Count(distinct segment) as "Final Result"
from customer
group by state
having count(*)>1
order by state;
/*Akshay Singh - 25/09/2023 */



/*Question 10:*/

/*To help the commercial sales department with its marketing, find all customers in the corporate segment who have not placed any orders. Include each customers’ first name, last name, street, city, state, and zip code. Sort the results by the last name first and then by the first name.*/
SELECT c.last_name, c.first_name, c.street, c.city, c.state
FROM
customer AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
WHERE c.segment = 'Corporate'
    AND o.order_id IS NULL
ORDER BY
    c.last_name asc,
    c.first_name asc;
    /*Akshay Singh - 24/09/2023 */
/* Question 11: */
/* There has been a recall of the product Nike Mens Free 5.0+ Running Shoe. TerpBuy would have to offer a discount coupon to all customers who purchased this product. Find all orders that included this product as a part of the purchase. For all such orders, list the customers’ first names, last names, street, state, zip code, and order date. Each customer can be offered only one discount coupon. Hence, do not list the same customer more than once*/
select distinct(first_name), last_name, state, city, zipcode,  order_date
from product
	inner join order_line on order_line.product_id = product.product_id
    inner join orders on orders.order_id = order_line.order_id
    inner join customer on customer.customer_id = orders.customer_id
where product_name = "Nike Mens Free 5.0+ Running Shoe";
/*Akshay Singh - 24/09/2023 */




#Question 12;
/*Premium customers are those customers who have placed orders with order amounts greater than the average order amount. For each customer, find the first and last names, and the order amount for all orders that exceeded the average order amount.*/

SELECT first_name,last_name, SUM(ol.total_price) AS total_amount
FROM customer c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_line ol ON o.order_id = ol.order_id
GROUP BY c.customer_id,c.first_name,c.last_name
HAVING SUM(ol.total_price) > (
        SELECT AVG(total_price)
        FROM order_line
    );