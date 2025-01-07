/*This file involve various SQL concepts such as JOINS.
This file uses the UA_HALLUX database, a synthetically generated database representing a mid-size music publishing and booking agency*/

USE UA_HALLUX5103

/*JOINS 
• Link related tables together in SQL queries by using either subqueries or joins.
• Relationships between tables are established by setting up primary key to foreign key relationships between columns that are common to both tables.
• A SQL JOIN is a relational operation that combines rows from two or more tables based on a shared attribute, yielding a new result set that integrates data from the participating tables. 
Inner Join
Left Join
Left Join (Filtering the NULLS) 
Right Join
Right Join (Filtering the NULLS) 
Full Join
Cross Join
*/

/* Key Notes about JOINS
• Multi-table Joins: You can join more than two tables in the same query.
• Join Sequence: Tables are joined two at a time, creating a new result set to be joined with the next table.
• Types of Joins: You can mix different types of joins (INNER, LEFT, RIGHT, FULL OUTER) in the same query.
• Order Matters: The sequence in which you join tables can affect performance and readability.
• Aliasing: Use table aliases for better readability and shorter SQL queries.
• Be Mindful of Performance: The more tables involved, the more complex the query optimization.
• Test Incrementally: Build and test your multi-table joins incrementally for easier debugging.  
*/


--Retrieve the customer order information with order date range between 1 Jan, 2008 and 31 Dec, 2010
SELECT *
FROM 
	Order_Header AS OH
WHERE 
	Order_Date BETWEEN '1/1/2008' AND '12/31/2010'
ORDER BY 
	ORDER_DATE;


-- In order to get both order and customer information, we need to perform join
SELECT 
	*
FROM 
	Order_Header AS OH INNER JOIN
	Customer AS C ON OH.Customer_Id = C.Customer_Id
WHERE 
	Order_Date BETWEEN '1/1/2008' AND '12/31/2010'
ORDER BY 
	ORDER_DATE;

--or
SELECT 
	*
FROM 
	Order_Header OH INNER JOIN
	Customer C ON OH.Customer_Id = C.Customer_Id
WHERE 
	Order_Date BETWEEN '1/1/2008' AND '12/31/2010'
ORDER BY 
	ORDER_DATE;

--or
SELECT 
	*
FROM 
	Order_Header OH INNER JOIN
	Customer C ON OH.Customer_Id = C.Customer_Id
WHERE 
	Order_Date BETWEEN '1/1/2008' AND '12/31/2010'
ORDER BY 
	ORDER_DATE;

--or
--Try select below code, Right click > Design query in editor > Click ok, It will remove * and give all column names
SELECT 
	OH.Order_Source_Id, OH.Order_Id, OH.Customer_Id AS Expr2, OH.Subtotal_Amount, OH.Promise_Date, OH.Order_Date, 
	OH.Total_Amount, OH.Tax_Amount, C.Phone_Number AS Expr3, C.Customer_Id AS Expr1, C.First_Name AS Expr4, 
    C.Zip_Code_Ext AS Expr5, C.Last_Name AS Expr6, C.Street_Address AS Expr7, C.Name AS Expr8, C.Email AS Expr9, C.Zip_Code AS Expr10
FROM     
	dbo.Order_Header AS OH INNER JOIN
    dbo.Customer AS C ON OH.Customer_Id = C.Customer_Id
WHERE  
	(OH.Order_Date BETWEEN '1/1/2008' AND '12/31/2010')
ORDER BY 
	OH.Order_Date;

--or
SELECT 
	c.*, Order_Id
FROM 
	Order_Header OH INNER JOIN
	Customer C ON OH.Customer_Id = C.Customer_Id
WHERE 
	Order_Date BETWEEN '1/1/2008' AND '12/31/2010'
ORDER BY 
	ORDER_Date;


--Retrieve all order details and customer information for orders placed between January 1, 2008, and December 31, 2010, sorted by order date.
SELECT 
	Name, SUM(total_amount) as Sum_Total_Amount
FROM 
	Order_Header OH INNER JOIN
	Customer C ON OH.Customer_Id = C.Customer_Id
WHERE 
	Order_Date BETWEEN '1/1/2008' AND '12/31/2010'
GROUP BY  
	Name
HAVING 
	SUM(total_amount)>=40000
ORDER BY 
	Sum_Total_Amount DESC;


-- Summarize total order amounts by customer and state for Arkansas between 2008 and 2010, sorted by the highest total.
SELECT 
	Name, SUM(total_amount) as Sum_Total_Amount, State_Abbr
FROM 
	Order_Header OH INNER JOIN
	Customer C ON OH.Customer_Id = C.Customer_Id INNER JOIN
	ZIP_Code ZC ON ZC.Zip_Code = C.Zip_Code
WHERE 
	Order_Date BETWEEN '1/1/2008' AND '12/31/2010'AND State_Abbr = 'AR'
GROUP BY  
	Name, State_Abbr
ORDER BY 
	Sum_Total_Amount DESC;


--Parameterizing the above query
DECLARE @START_DATE AS DATETIME
DECLARE @END_DATE AS DATETIME
DECLARE @SUM_TOTAL_AMOUNT AS MONEY
DECLARE @STATE_ABBR AS VARCHAR(2)

SET @START_DATE = '1/1/2008'
SET @END_DATE = '12/31/2010'
SET @SUM_TOTAL_AMOUNT = 10000
SET @STATE_ABBR ='AR'

SELECT 
	Name, SUM(total_amount) as Sum_Total_Amount, State_Abbr
FROM 
	Order_Header OH INNER JOIN
	Customer C ON OH.Customer_Id = C.Customer_Id INNER JOIN
	ZIP_Code ZC ON ZC.Zip_Code = C.Zip_Code
WHERE 
	Order_Date BETWEEN @START_DATE AND @END_DATE AND State_Abbr = @STATE_ABBR
GROUP BY  
	Name, State_Abbr
HAVING 
	SUM(total_amount)>=@SUM_TOTAL_AMOUNT
ORDER BY 
	Sum_Total_Amount DESC;


--Retrieve all customer records where the first name is missing (NULL).
SELECT 
	* 
FROM 
	CUSTOMER
WHERE 
	First_Name IS NULL;


--JOINS for Simple Tables : Table_A, Table_B
SELECT * FROM Table_A
SELECT * FROM Table_B


/*
INNER JOIN: Common data
*/
SELECT 
	* 
FROM 
	TABLE_A A INNER JOIN 
	TABLE_B B ON A.Person_Id = B.Person_Id;

--or
SELECT 
	* 
FROM	
	TABLE_A A JOIN 
	TABLE_B B ON A.Person_Id = B.Person_Id;


/*
LEFT JOIN (aka LEFT OUTER JOIN)
• Matches: All rows from the left table and matching rows from the right table.
• Result: If no match, NULLs are returned for columns from the right table
*/
SELECT 
	* 
FROM	
	TABLE_A A LEFT JOIN 
	TABLE_B B ON A.Person_Id = B.Person_Id;


--Retrieves all customer IDs from Order_Header with matching IDs from Customer.
SELECT 
	Order_Header.Customer_Id, Customer.Customer_Id 
FROM 
	Order_Header LEFT JOIN 
	Customer ON Customer.Customer_Id = Order_Header.Customer_Id;


/*
LEFT JOIN (Filtering the NULLS) 
• To filter the results to show the missing values (the NULLs). 
• If you're doing a LEFT JOIN in SQL to identify missing values, you're essentially performing a similar task to using VLOOKUP in Excel to find unmatched entries.
• We want to get only the records that exist in table A, but do not in table B and are not common (Left join is Null)
*/
SELECT 
	* 
FROM	
	TABLE_A A LEFT JOIN 
	TABLE_B B ON A.Person_Id = B.Person_Id
WHERE
	B.Person_Id IS NULL;


/*
RIGHT JOIN (aka RIGHT OUTER JOIN)
• Matches: All rows from the right table and matching rows from the left table.
• Result: If no match, NULLs are returned for columns from the left table
• Note: RIGHT JOIN can generally be rewritten as a LEFT JOIN by reversing the order of the tables. 
• The two types of joins are functionally equivalent but differ in the syntax and readability of the query 
*/
SELECT 
	* 
FROM	
	TABLE_A A RIGHT JOIN 
	TABLE_B B ON A.Person_Id = B.Person_Id;


--Retrieves all customer IDs from Customer with matching IDs from Order_Header.
SELECT 	
	Order_Header.Customer_Id, Customer.Customer_Id 
FROM 	
	Order_Header RIGHT JOIN 
	Customer ON Customer.Customer_Id = Order_Header.Customer_Id;


--RIGHT JOIN (Filtering the NULLS)
--We want to get only the records for table B, but do not in table A and are not common (Right join is null)
SELECT 
	* 
FROM	
	TABLE_A A RIGHT JOIN 
	TABLE_B B ON A.Person_Id = B.Person_Id
WHERE 
	A.Person_Id IS NULL;


/*
FULL JOIN (aka FULL OUTER JOIN)
• Matches: All rows when there is a match in either table.
• Result: Returns all records from each table and returns NULLs for every column from the table that doesn't have a match
*/
SELECT 
	* 
FROM	
	TABLE_A A FULL JOIN 
	TABLE_B B ON A.Person_Id = B.Person_Id;


--Retrieves all customer IDs from both Order_Header and Customer tables, using a FULL JOIN to include matching and non-matching records from both tables*/
SELECT 
	Order_Header.Customer_Id, Customer.Customer_Id 
FROM 
	Order_Header FULL JOIN 
	Customer ON Customer.Customer_Id = Order_Header.Customer_Id;


--CROSS JOIN
/*
• Combines each row from the 1st table with every row from the 2nd.
• No ON condition is required.
• Results in a Cartesian Product of the two tables.

Possible Uses in Data Analytics:
• Cartesian Product: When you need all possible combinations between rows in two tables.
• Data Augmentation: Useful for enriching every row in one table with information from another table, especially for machine learning purposes.
• Date Ranges: Useful for generating all date combinations with specific events.
*/
SELECT 	
	*
FROM 	
	Table_A A CROSS JOIN 
	Table_B B;


--Examples
--Retrieve the customer information  that has not placed orders 
--SELECT COUNT(*) FROM CUSTOMER
--SELECT COUNT(DISTINCT CUstomer_Id) from Order_Header
SELECT	
	C.Customer_Id, C.Name 
FROM	
	Customer C LEFT JOIN 
	Order_Header OH ON C.Customer_Id = OH.Customer_Id
WHERE	
	OH.Order_Id IS NULL;

--or
SELECT	
	C.Customer_Id, C.Name, COUNT(DISTINCT OH.Order_Id) Number_Of_Orders
FROM	
	Customer C LEFT JOIN 
	Order_Header OH ON C.Customer_Id = OH.Customer_Id
GROUP 
  BY	C.Customer_Id, C.Name
HAVING	
	COUNT(DISTINCT OH.Order_Id) = 0;

--or
SELECT	
	C.Customer_Id, C.Name, COUNT(DISTINCT OH.Order_Id) Number_Of_Orders
FROM	
	Customer C LEFT JOIN 
	Order_Header OH ON C.Customer_Id = OH.Customer_Id
GROUP 
  BY	C.Customer_Id, C.Name
ORDER
  BY	3;


--3 Table Join
-- Retrieve the instrument details for each band member based on their association in the Member_Instrument table.
 SELECT  MI.Instrument_Id, I.Instrument_Name, MI.Member_Id
FROM    Member_Instrument MI INNER JOIN
        Instrument I ON MI.Instrument_Id = I.Instrument_Id INNER JOIN
        Band_Member BM on MI.Member_Id = BM.Member_Id
ORDER
BY      3,1;


--4 Table Join
--Retrieve the instrument and personal details of a specific band member identified by Member_Id = '111224'
SELECT   
	I.Instrument_Name, BM.Member_Id, P.First_Name, P.Last_Name
FROM	 
	Member_Instrument MI INNER JOIN
	 Instrument I ON MI.Instrument_Id = I.Instrument_Id INNER JOIN
	 Band_Member BM on MI.Member_Id = BM.Member_Id INNER JOIN
	 Person P on BM.Member_Id = P.Person_Id
WHERE	 
	BM.Member_Id = '111224'
ORDER 
BY	2;


--Find the total revenue for orders in state of AR
SELECT
	SUM(OH.Total_Amount) AS Total_Revenue, ZC.State_Abbr
FROM
	Order_Header OH INNER JOIN
	Customer C ON C.Customer_Id = OH.Customer_Id INNER JOIN
	Zip_Code ZC ON ZC.Zip_Code = C.Zip_Code
WHERE
	ZC.State_Abbr='AR'
GROUP BY
	ZC.State_Abbr;


--Which bands have member(s) from AR?
SELECT 
	DISTINCT Band_Name
FROM 
	Band_Member INNER JOIN 
	Person ON person.Person_Id = Band_Member.Member_Id INNER JOIN 
	Zip_Code ON Zip_Code.Zip_Code = Person.Zip_Code INNER JOIN 
	Band ON Band.Band_Id = Band_Member.Band_Id
WHERE 
	Zip_Code.State_Abbr = 'AR';
 

--Which Agents have no contracts?
SELECT 
	person.first_name, person.last_name
FROM 
	agent LEFT JOIN 
	contract ON contract.agent_id = agent.agent_id INNER JOIN 
	person ON person.person_id = agent.agent_id
WHERE 
	contract.contract_id IS NULL;


--How many members are in the band ‘The Friendly Project’?
SELECT 
	COUNT(*) AS Total_Band_Members
FROM 
	Band_Member BM INNER JOIN
	Band B ON BM.Band_Id=B.Band_Id
WHERE 
	B.Band_Name='The Friendly Project';

--When was the first web order placed?
SELECT
	TOP 1 Order_Date, OS.Source_Name
FROM 
	Order_Header OH INNER JOIN
	Order_Source OS ON OH.Order_Source_Id=OS.Order_Source_Id
WHERE 
	Source_Name='Web'
ORDER BY
	Order_Date;

--or
SELECT 
	os.source_name, min(oh.order_date) as min_order_date
FROM 
	order_header AS oh INNER JOIN 
	order_source AS os ON oh.order_source_id = os.order_source_id
WHERE 
	os.source_name = 'Web'
GROUP BY 
	os.source_name;

--Name the first band to perform in AR in the new century
SELECT 
	b.band_name, p.performance_date 
FROM 
	performance AS p INNER JOIN 
	venue AS v ON p.venue_id = v.venue_id INNER JOIN 
	Zip_code AS z ON z.zip_code = v.zip_code INNER JOIN 
	band AS b ON b.band_id = p.band_id
WHERE 
	z.State_abbr = 'AR' 
ORDER BY 
	p.performance_date;

--or
SELECT 
	top 1 b.band_name, p.performance_date 
FROM 
	performance AS p INNER JOIN 
	venue AS v ON p.venue_id = v.venue_id INNER JOIN 
	Zip_code AS z ON z.zip_code = v.zip_code INNER JOIN 
	band AS b ON b.band_id = p.band_id
WHERE 
	z.State_abbr = 'AR' and YEAR(p.performance_date ) = 2000
ORDER BY 
	p.performance_date;


--Retrieve the yearly total amount of orders for 'T-Jams' from customers in ZIP code '81501', grouped by source name, ZIP code, and order year
SELECT 
	OS.Source_Name, ZC.Zip_Code, SUM(OH.Total_Amount) Total_Amount, Year(OH.Order_Date) as Order_Year
FROM 
	Order_Source OS INNER JOIN
	Order_Header OH ON OH.Order_Source_Id=OS.Order_Source_Id INNER JOIN
	Customer C ON C.Customer_Id=OH.Customer_Id INNER JOIN
	Zip_Code ZC ON ZC.Zip_Code=C.Zip_Code
WHERE 
	OS.Source_Name='T-Jams' AND ZC.Zip_Code='81501'
GROUP BY
	OS.Source_Name, ZC.Zip_Code,Year(OH.Order_Date)
ORDER BY
	Year(Order_Date) DESC;


--Retrieve the name and contact phone number of venues with no scheduled performances, avoiding the use of INNER JOIN.
SELECT 
	V.Venue_Name, V.Contact_Phone 
FROM 
	Venue V LEFT JOIN
	Performance P ON V.Venue_Id=P.Venue_Id
WHERE 
	P.Performance_Id IS NULL;


--Summarize item quantities by type and year (2011-2013), grouped by item type and sorted by total quantity in descending order.
SELECT	
	IT.Item_Type, SUM(OD.Quantity) AS Total_Quantity,
	SUM(CASE WHEN YEAR(OH.Order_Date) = 2011 THEN OD.Quantity END) Total_Quantity_2011,
	SUM(CASE WHEN YEAR(OH.Order_Date) = 2012 THEN OD.Quantity END) Total_Quantity_2012,
	SUM(CASE WHEN YEAR(OH.Order_Date) = 2013 THEN OD.Quantity END) Total_Quantity_2013
FROM	
	Order_Header OH INNER JOIN 
	Order_Detail OD ON OH.Order_Id = OD.Order_Id INNER JOIN
	Item I ON OD.Item_ID = I.Item_ID INNER JOIN 
	Item_Type IT ON IT.Item_Type_ID = I.Item_Type_ID
WHERE	
	YEAR(OH.Order_Date) IN (2011,2012,2013)
GROUP BY 
	IT.Item_Type
ORDER BY 
	SUM(OD.Quantity) DESC;


-- Retrieve the top 5 items by total quantity sold across all years, including item descriptions.
SELECT	
	TOP 5 
	I.Item_Description, SUM(OD.Quantity) AS Total_Quantity
FROM	
	Order_Header OH INNER JOIN
	Order_Detail OD ON OH.Order_Id = OD.Order_Id INNER JOIN 
	Item I ON OD.Item_ID = I.Item_ID
GROUP BY 
	I.Item_Description
ORDER BY 
	SUM(OD.Quantity) DESC;


--Retrieves the first and last names of band members along with their associated instrument names by joining four tables
SELECT 
	p.First_Name, p.Last_Name, Instrument_Name
FROM	
	[dbo].[Instrument] AS I INNER JOIN
	[dbo].[Member_Instrument] MI ON I.INSTRUMENT_ID = MI.INSTRUMENT_ID inner join
	[dbo].[Band_Member] BM ON BM.Member_Id = MI.Member_Id INNER JOIN
	[dbo].[Person] P ON P.Person_Id = BM.Member_Id;


--Analyzes instruments played by band members, summarizing the count of unique bands, unique band-genre combinations, and bands in the 'Country' and 'Rock' genres, filtered by genres and grouped by instrument, with at least 50 unique bands.
SELECT  	
	Instrument_Name,
	COUNT(DISTINCT BM.Band_Id) as Unique_Bands,
	COUNT(DISTINCT CAST(BM.Band_Id as VARCHAR(50)) + CAST(BG.Genre_Id as VARCHAR(50))) as Unique_Bands_Genre,
	COUNT(DISTINCT CASE WHEN G.Genre = 'Country' THEN BM.Band_Id END) as Unique_Country_Bands,
	COUNT(DISTINCT CASE WHEN G.Genre = 'Rock' THEN BM.Band_Id END) as Unique_Rock_Bands
FROM	
	Band B INNER JOIN 
	Band_Member BM on B.Band_Id = BM.Band_Id  INNER JOIN
	Member_Instrument MI on MI.Member_Id = BM.Member_Id INNER JOIN
	Instrument I ON I.Instrument_Id = MI.Instrument_Id INNER JOIN
	Band_Genre BG on B.Band_Id = BG.Band_Id INNER JOIN
	Genre G on BG.Genre_Id = G.Genre_ID
WHERE	
	G.Genre IN ('Country','Rock')
GROUP BY	
	Instrument_Name
HAVING	
	COUNT(DISTINCT BM.Band_Id) >= 50
ORDER BY	
	2 DESC;


--Retrieves the counts of band members grouped by band name, filters for bands starting with 'The,' and includes only those with exactly 5 members.
SELECT 
	COUNT(BM.Member_Id) AS Band_Members_Count, B.Band_Name
FROM 
	BAND B INNER JOIN
	Band_Member BM ON B.Band_Id=BM.Band_Id
GROUP BY 
	B.Band_Name
HAVING 
	B.Band_Name LIKE 'The%' and COUNT(BM.Member_Id)=5;



