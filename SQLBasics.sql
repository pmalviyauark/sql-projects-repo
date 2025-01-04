/*This file involve various SQL concepts such as basic SELECT statements, WHERE clauses, aggregate functions, and more.
This file uses the UA_HALLUX database, a synthetically generated database representing a mid-size music publishing and booking agency*/

USE UA_HALLUX5103

/*Data Manipulation Language - Maintain and Query Database
SELECT: Specify the columns or expressions to retrieve. What comes back in the results?
FROM: Define the table(s) or view(s) to query. Where did we get the results?
WHERE: Set conditions to filter rows. Which records do we include in the results?
GROUP BY: Categorize results for aggregation. Aggregate by what?
HAVING: Filter groups based on conditions. Which groups do we include in the results?
ORDER BY: Sort the results by specified criteria (ASC or DESC)*/


-- Retrieve all customer details from the "Customer" table in the "dbo" schema.
SELECT * 
FROM	
	[dbo].[Customer];


-- Retrieve Customer_Id and Total Amount from the "Order Header" table in the "dbo" schema.
SELECT 
	Customer_Id,
	Total_Amount 
FROM 
	[dbo].[Order_Header];


-- This query groups data by Customer_Id and calculates the total amount for each customer.
SELECT	
	Customer_Id, 
	Sum(Total_Amount) AS Total 
FROM	
	[dbo].[Order_Header]
GROUP BY	
	Customer_Id;


-- Retrieves each customer's total order amount, sorted in descending order.
SELECT 
	Customer_Id, 
	Sum(Total_Amount) AS Total 
FROM
	[dbo].[Order_Header]
GROUP BY 
	Customer_Id
ORDER BY 
	Total DESC;


-- Retrieves customers with total orders exceeding 7000, sorted in descending order
SELECT 
	Customer_Id, 
	Sum(Total_Amount) AS Total 
FROM 
	[dbo].[Order_Header]
GROUP BY 
	Customer_Id
HAVING 
	Sum(Total_Amount) > 7000 --Having is only used to filter based on the aggregate which is Sum(Total_Amount)
ORDER BY 
	Total DESC;


-- Retrieves customers with individual orders over 1000, grouped and sorted by total amount in descending order.
SELECT 
	Customer_Id, 
	Sum(Total_Amount) AS Total 
FROM 
	[dbo].[Order_Header]
WHERE 
	Total_Amount > 1000 -- where is used to filter out row level data
GROUP BY 
	Customer_Id
ORDER BY 
	2 DESC;


-- Retrieves the first and last names of all persons from the Person table.
SELECT 
	First_Name, 
	Last_Name
FROM 
	[dbo].[Person];


-- Retrieves the first and last names of all persons from the Person table whose first name is Kenneth.
SELECT 
	First_Name,
	Last_Name
FROM 
	[dbo].[Person]
WHERE 
	First_Name = 'Kenneth';


-- Retrieves the first and last names of all persons from the Person table whose first name is Anna and sorted alphabetically by last name
SELECT 
	First_Name, 
	Last_Name
FROM 
	[dbo].[Person]
WHERE 
	First_Name = 'Anna'
ORDER BY 
	Last_Name;


-- Retrieve the count of all the people in the database whose first name is ANNA
SELECT
	COUNT(First_Name) AS [Count_of_Anna]
FROM
	[dbo].[Person]
WHERE
	First_Name = 'Anna';

--or
SELECT  
	Count(*) as [Count of Anna]
FROM 
	[dbo].[Person]
WHERE 
	First_Name = 'Anna';


-- Retrieve the count of all the people in the database whose first name is ANNA or first name is Kiri
SELECT  
	Count(*) as [Record Count]
FROM 
	[dbo].[Person]
WHERE 
	First_Name = 'Anna' or First_Name = 'Kiri';

--or
SELECT  
	Count(*) as [Record Count]
FROM 
	[dbo].[Person]
WHERE 
	First_Name IN ('Anna' ,'Kiri');


--Retrieve the state and categorize states (TX - Old Home, AR - New Home) and Other States - Other Home
SELECT 
	State_Name,
	State_Abbr,
	CASE
		WHEN State_Abbr = 'TX' THEN 'Old Home'
		WHEN State_Abbr = 'AR' THEN 'New Home'
		ELSE 'Other Home'
	END AS State_Grouper
FROM 
	[dbo].[State];


--Retrieve the state and categorize states by region
SELECT 
	State_Name, 
	State_Abbr,
       CASE 
           WHEN State_Abbr IN ('CT', 'ME', 'MA', 'NH', 
				'RI', 'VT', 'NJ', 'NY', 'PA') THEN 'Northeast'
           WHEN State_Abbr IN ('IL', 'IN', 'MI', 'OH', 
				'WI', 'IA', 'KS', 'MN', 'MO', 'NE', 'ND', 'SD') THEN 'Midwest'
           WHEN State_Abbr IN ('DE', 'FL', 'GA', 'MD', 
				'NC', 'SC', 'VA', 'WV', 'AL', 'KY', 
				'MS', 'TN', 'AR', 'LA', 'OK', 'TX') THEN 'South'
           WHEN State_Abbr IN ('AZ', 'CO', 'ID', 'MT', 'NV',
				'NM', 'UT', 'WY', 'AK', 'CA', 
				'HI', 'OR', 'WA') THEN 'West'
           ELSE 'Unknown'
       END AS Region
FROM 
	State
ORDER BY 1;


-- SQL comparison operators are used to filter and compare values in queries using WHERE and HAVING Clause.
/* SQL Comparison Operators
=   : Equals
<   : Less than
<=  : Less than or equal to
>   : Greater than
>=  : Greater than or equal to
<>  : Not equal to
^   : Power operator
BETWEEN ... AND ...	  : Checks if a value is within a specified range (inclusive)
IN (list) / NOT IN    : Checks if a value is in or not in a specified list
LIKE '...'            : Matches patterns using wildcards (e.g., %)
IS NULL / IS NOT NULL : Checks for NULL or NOT NULL values
*/

-- Retrieves all orders with an order date between January 3, 2002, and January 5, 2002.
SELECT 
	*
FROM 
	Order_Header
WHERE 
	Order_Date  BETWEEN '2002-01-03' AND '2002-01-05';


/*Retrieve all orders from the Order_Header table within a specific date range, 
excluding those with Order_Source_Id 4, having a Total_Amount greater than 1300, 
and sort them in descending order by Total_Amount*/
SELECT 
	*
FROM 
	Order_Header
WHERE 
	Order_Date >= '2002-01-03' 
	AND Order_Date <= '2005-01-05' 
	AND Order_Source_Id <> 4
	AND Total_Amount > 1300
ORDER BY 
	Total_Amount Desc;

--or
SELECT 
	*
FROM 
	Order_Header
WHERE 
	Order_Date >='2002-01-03' 
	AND Order_Date<= '2005-01-05' 
	AND Order_Source_Id IN (1,2,3)
	AND Total_Amount> 1300
ORDER BY 
	Total_Amount Desc;


--Retrieve all customer records where the Zip_Code starts with '55' (Like operator)
SELECT 
	* 
FROM 
	Customer
WHERE 
	Zip_Code like '55%';


--Retrieve the minimum, maximum, total, and average values of Total_Amount from the Order_Header table 
--Using Aggregate functions - (min, max, sum, avg)
SELECT  min(Total_Amount) as min_total_amount,
		max(Total_Amount) as max_total_amount,
		sum(Total_Amount) as sum_total_amount,
		avg(Total_Amount) as avg_total_amount
FROM [dbo].[Order_Header];


--Retrieve the minimum, maximum, total, and average values of Total_Amount from the Order_Header table and group by order date
SELECT  Order_Date,
		min(Total_Amount) as min_total_amount,
		max(Total_Amount) as max_total_amount,
		sum(Total_Amount) as sum_total_amount,
		avg(Total_Amount) as avg_total_amount
FROM [dbo].[Order_Header]
GROUP
	BY Order_Date;


--Retrieve the minimum, maximum, total, and average values of Total_Amount, extracting year from order_date from the Order_Header table and group by order date
SELECT  year(order_date) as Year_Order_date,
		min(Total_Amount) as min_total_amount,
		max(Total_Amount) as max_total_amount,
		sum(Total_Amount) as sum_total_amount,
		avg(Total_Amount) as avg_total_amount
FROM [dbo].[Order_Header]
GROUP
	BY year(Order_Date)
ORDER
	BY Year_Order_date;


-- Retrieve aggregate statistics (min, max, sum, avg) of total order amounts grouped by year, for orders placed in the years 2000 to 2004.
SELECT  year(Order_Date) as Year_Order_Date,
		min(Total_Amount) as min_total_amount,
		max(Total_Amount) as max_total_amount,
		sum(Total_Amount) as sum_total_amount,
		avg(Total_Amount) as avg_total_amount
FROM [dbo].[Order_Header]
WHERE  year(Order_Date) IN (2000, 2001, 2002, 2003, 2004)
GROUP
	BY year(Order_Date)
ORDER
	BY Year_Order_Date;


-- Retrieve summary statistics (count, sum, average, min, max) for orders grouped by Order_Source_Id, and filter groups where the average total amount exceeds 1200.
-- HAVING Clause Example
SELECT	Order_Source_Id,
		COUNT(*) AS 'Order_Count',
		SUM(Total_Amount) AS 'Total_Amount_Sum',
		AVG(Total_Amount) AS 'Total_Amount_Avg',
		MIN(Total_Amount) AS 'Total_Amount_Min',
		MAX(Total_Amount) AS 'Total_Amount_Max'
FROM	Order_Header
GROUP 
	BY	Order_Source_Id
HAVING	AVG(Total_Amount) > 1200
ORDER 
	BY  Order_Source_Id;


--Count the total records, unique zip codes, and unique first names in the Customer table.
SELECT 
    COUNT(*) AS record_count,
    COUNT(DISTINCT(zip_code)) AS unique_zip_codes,
    COUNT(DISTINCT(first_name)) AS unique_first_name
FROM 
    Customer;


-- Retrieve unique customer first names, convert them to uppercase, and calculate their length and sort results by original first name.
SELECT 
	DISTINCT(First_Name), 
	UPPER(First_Name) as First_Name_Upper,
	LEN(First_Name) as First_Name_Length
FROM 
	Customer
ORDER BY 
	First_Name;


--Retrieve the top 50 records from the Customer table using top
SELECT TOP 50 *
FROM Customer;

--Find the formation date of the band named "The Data Gamble".
SELECT 
	Band_Name,Formation_Date
FROM 
	[dbo].[Band]
WHERE 
	Band_Name='The Data Gamble';

--Retrieve the street addresses for the customers with a name like "Ken" 
SELECT 
	Street_Address, Name
FROM 
	[dbo].[Customer]
WHERE 
	Name LIKE 'Ken%';

--Retrieve the names of albums that cost less than $1200 but more than $1000 to produce and sort the results by cost.
SELECT 
	Album_Name, Production_Cost
FROM 
	[dbo].[Album]
WHERE 
	Production_Cost<1200 AND Production_Cost>1000
ORDER BY 
	Production_Cost;

/*For the band with an ID of 1346, what is the difference between the percentage made on live performances and the percentage made on album sales? 
Name your newly created measure as 'Live v Album Revenue Difference'*/
SELECT 
	Band_Id, Live_Rev_Pct,Album_Rev_Pct,([Live_Rev_Pct]-[Album_Rev_Pct]) AS 'Live v Album Revenue Difference'
FROM 
	[dbo].[Contract]
WHERE 
	Band_Id ='1346';

--Find how many bands are NOT active bands (status code 'A') currently managed by Hallux Productions? Name the return column as 'Inactive Bands'.
SELECT 
	Band_Status_Code, Count(Band_Status_Code) AS Inactive_Bands
FROM 
	[dbo].[Band]
WHERE 
	Band_Status_Code = 'I'
GROUP BY 
	Band_Status_Code;

/*Retrieve list of customers whose names begin with the word "Kenneth." For each of these customers, retrieve their names and phone numbers from the database.
•	Required Task: Retrieve customer names and their phone numbers where the customer names start with "Kenneth."
•	Advanced Task (Optional): For those looking for an additional challenge, format the retrieved phone numbers into the standard format (XXX) XXX-XXXX.
*/
SELECT 
	Name, Phone_Number, '(' + LEFT(Phone_Number, 3) + ') ' + SUBSTRING(Phone_Number, 4, 3) + '-' + RIGHT(RTRIM(Phone_Number), 4) 	AS Phone_Number
FROM 
	[dbo].[Customer]
WHERE 
	Name LIKE 'Ken%';

--Calculate the average production cost per day for albums released in the first seven days of July 2012, sorted by day.
SELECT 
	AVG(Production_Cost) AS Avg_Production_Cost, Release_Date 
FROM 
	[dbo].[Album]
WHERE 
	Release_Date BETWEEN '2012-07-01' AND '2012-07-07'
GROUP BY 
	Release_Date
ORDER BY 
	Release_Date;

--List customer IDs for customers who have spent $65,000 or more in total, sorted in descending order by the total amount spent.
SELECT 
	Customer_Id, Sum(Total_Amount) AS Total_Spent
FROM 
	[dbo].[Order_Header]
GROUP BY
	Customer_Id
HAVING 
	Sum(Total_Amount)>65000
ORDER BY 
	Sum(Total_Amount) DESC;


--Write an SQL query that provides the count of unique customers for the years 2012, 2013, and 2014 using the Order_Header table ordered by the year
SELECT 
	COUNT(DISTINCT(Customer_Id)) AS Unique_Customers, Year(Order_Date)  AS Order_Date_Year
FROM 
	Order_Header
WHERE 
	Year(Order_Date) IN ('2012','2013','2014')
GROUP BY 
	Year(Order_Date)
ORDER BY 
	Year(Order_Date);

/*The instrument table has a diverse collection of musical instruments. Categorize the instruments into broader categories. 
Write an SQL query that categorizes the 18 instruments in the instruments table into the respective categories below. 
•	Strings: Banjo, Bass Guitar, Cello, Guitar, Sitar, Ukulele, Violin
•	Woodwinds: Clarinet, Flute, Piccolo, Saxophone
•	Brass: Trombone, Trumpet
•	Percussion: Drums, Tambourine
•	Keyboards: Keyboards
•	Vocals: Vocals
•	Others: Harmonica
The query should create a new field named Instrument_Category and use the CASE statement to assign the categories.
The output should have columns Instrument_Name and Instrument_Category. Sort your results by Instrument_Category and then by Instrument_Name.
*/
SELECT Instrument_Name,
	CASE
		WHEN Instrument_Name IN ('Banjo', 'Bass Guitar', 'Cello', 'Guitar', 'Sitar', 'Ukulele', 'Violin') THEN 'Strings'
		WHEN Instrument_Name IN ('Clarinet', 'Flute', 'Picolo', 'Saxophone') THEN 'Woodwinds'
		WHEN Instrument_Name IN ('Trombone', 'Trumpet') THEN 'Brass'
		WHEN Instrument_Name IN ('Drums', 'Tambourine') THEN 'Percussion'
		WHEN Instrument_Name IN ('Keyboards') THEN 'Keyboards'
		WHEN Instrument_Name IN ('Vocals') THEN 'Vocals'
		WHEN Instrument_Name IN ('Harmonica') THEN 'Others'
		ELSE 'Unknown'
		END AS Categorized_Instruments
FROM 
	[dbo].[Instrument]
ORDER BY 
	Categorized_Instruments, Instrument_Name ;





	
