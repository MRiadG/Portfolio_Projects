USE `gdb023`;
show tables
select * from dim_customer
select * from dim_product
select * from fact_gross_price
select * from fact_manufacturing_cost
select * from fact_pre_invoice_deductions
select * from fact_sales_monthly

-- Problems and sollutions

-- 1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
select 
	distinct(customer),
    region,
    market 
from dim_customer
where customer = "Atliq Exclusive" and region = "APAC"



-- 2. What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields,
	-- unique_products_2020 
	-- unique_products_2021 
	-- percentage_chg
-- way 1
SELECT
    SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END) AS unique_products_2020,
    SUM(CASE WHEN fiscal_year = 2021 THEN sold_quantity ELSE 0 END) AS unique_products_2021,
    (SUM(CASE WHEN fiscal_year = 2021 THEN sold_quantity ELSE 0 END) - 
     SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END)) * 100.0 /
     NULLIF(SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END), 0) AS percentage_change
FROM
    fact_sales_monthly;   
    
-- way_2   
SELECT
    SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END) AS unique_products_2020,
    SUM(CASE WHEN fiscal_year = 2021 THEN sold_quantity ELSE 0 END) AS unique_products_2021,
    CASE 
        WHEN SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END) = 0 THEN NULL
        ELSE (SUM(CASE WHEN fiscal_year = 2021 THEN sold_quantity ELSE 0 END) - 
              SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END)) * 100.0 /
              SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END)
    END AS percentage_change
FROM
    fact_sales_monthly;
    
-- way_3
WITH product_totals AS (
    SELECT
        SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END) AS unique_products_2020,
        SUM(CASE WHEN fiscal_year = 2021 THEN sold_quantity ELSE 0 END) AS unique_products_2021
    FROM
        fact_sales_monthly
)
SELECT
    unique_products_2020,
    unique_products_2021,
    CASE 
        WHEN unique_products_2020 = 0 THEN NULL
        ELSE (unique_products_2021 - unique_products_2020) * 100.0 / unique_products_2020
    END AS percentage_change
FROM
    product_totals;
    
-- way_4
SELECT
    totals.total_sold_2020,
    totals.total_sold_2021,
    CASE 
        WHEN totals.total_sold_2020 = 0 THEN NULL
        ELSE (totals.total_sold_2021 - totals.total_sold_2020) * 100.0 / totals.total_sold_2020
    END AS percent_change
FROM (
    SELECT
        SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END) AS total_sold_2020,
        SUM(CASE WHEN fiscal_year = 2021 THEN sold_quantity ELSE 0 END) AS total_sold_2021
    FROM
        fact_sales_monthly
) AS totals;


		-- Year-over-Year Sales Comparison with Percentage Change for 2020 and 2021 by Product"
		-- This reflects that the query compares the total sold quantities for each product between 2020 and 2021 and calculates the percentage change

SELECT
    t.product_code,
    t.total_sold_quantity_2020,
    t.total_sold_quantity_2021,
    CASE
        WHEN t.total_sold_quantity_2020 = 0 THEN NULL 
        ELSE (t.total_sold_quantity_2021 - t.total_sold_quantity_2020) * 100.0 / t.total_sold_quantity_2020
    END AS percent_change
FROM 
    (
    SELECT 
        product_code,
        SUM(CASE WHEN fiscal_year = 2020 THEN sold_quantity ELSE 0 END) AS total_sold_quantity_2020,
        SUM(CASE WHEN fiscal_year = 2021 THEN sold_quantity ELSE 0 END) AS total_sold_quantity_2021
    FROM 
        fact_sales_monthly
    GROUP BY 
        product_code
    ) AS t;

    
/* "Total Sold Quantity by Product for Fiscal Year "2020" and "2021" */

select product_code,fiscal_year,sum(sold_quantity)  from fact_sales_monthly 
group by product_code,fiscal_year having fiscal_year = 2020 and 2021


-- 3 Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
-- The final output contains 2 fields, segment product_count

select
	distinct(segment),
    count(product_code) as segment_product_count
from dim_product
group by segment
order by segment_product_count desc


-- 4 Which segment had the most increase in unique products in 2021 vs 2020? 
-- The final output contains these fields, 
	--segment 
    --product_count_2020 
    --product_count_2021 
    --difference
    
-- way 1
-- increase in count
SELECT 
    t.segment,
    COUNT(CASE WHEN t.fiscal_year = 2020 THEN t.product_code END) AS product_count_2020,
    COUNT(CASE WHEN t.fiscal_year = 2021 THEN t.product_code END) AS product_count_2021,
    COUNT(CASE WHEN t.fiscal_year = 2021 THEN t.product_code END) - 
    COUNT(CASE WHEN t.fiscal_year = 2020 THEN t.product_code END) AS Difference
FROM 
    (
    SELECT 
        p.segment,
        p.product_code,
        s.fiscal_year
    FROM 
        dim_product AS p
    LEFT JOIN 
        fact_sales_monthly AS s
    ON 
        p.product_code = s.product_code
    ) AS t
GROUP BY 
    t.segment;

--  increase in sold quantity
SELECT 
    t.segment,
    SUM(CASE WHEN t.fiscal_year = 2020 THEN t.sold_quantity ELSE 0 END) AS product_sold_2020,
    SUM(CASE WHEN t.fiscal_year = 2021 THEN t.sold_quantity ELSE 0 END) AS product_sold_2021,
    SUM(CASE WHEN t.fiscal_year = 2021 THEN t.sold_quantity ELSE 0 END) - SUM(CASE WHEN t.fiscal_year = 2020 THEN t.sold_quantity ELSE 0 END) AS Difference
FROM 
    (
    SELECT 
        p.segment,
        s.sold_quantity,
        s.fiscal_year
    FROM 
        dim_product AS p
    LEFT JOIN 
        fact_sales_monthly AS s
    ON 
        p.product_code = s.product_code
    ) AS t
GROUP BY 
    t.segment;

-- way 2
SELECT 
    t.segment,
    SUM(CASE WHEN t.fiscal_year = 2020 THEN 1 ELSE 0 END) AS product_count_2020,
    SUM(CASE WHEN t.fiscal_year = 2021 THEN 1 ELSE 0 END) AS product_count_2021,
    SUM(CASE WHEN t.fiscal_year = 2021 THEN 1 ELSE 0 END) - 
    SUM(CASE WHEN t.fiscal_year = 2020 THEN 1 ELSE 0 END) AS Difference
FROM 
    (
    SELECT 
        p.segment,
        p.product_code,
        s.fiscal_year
    FROM 
        dim_product AS p
    LEFT JOIN 
        fact_sales_monthly AS s
    ON 
        p.product_code = s.product_code
    ) AS t
GROUP BY 
    t.segment;

-- 5 Get the products that have the highest and lowest manufacturing costs. 
-- The final output should contain these fields,
	-- product_code
	-- product manufacturing_cost

SELECT 
    product_code,
    manufacturing_cost
FROM 
    fact_manufacturing_cost
WHERE 
    manufacturing_cost = (SELECT MIN(manufacturing_cost) FROM fact_manufacturing_cost)
    
UNION ALL

SELECT 
    product_code,
    manufacturing_cost
FROM 
    fact_manufacturing_cost
WHERE 
    manufacturing_cost = (SELECT MAX(manufacturing_cost) FROM fact_manufacturing_cost)
 
 -- 6  Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market.
 -- The final output contains these fields, 
	 -- customer_code
	 -- customer 
	 -- average_discount_percentage

select 
		d.customer_code,
        c.customer,
        round(avg(d.pre_invoice_discount_pct),2) as avg_discount_price
from 
		fact_pre_invoice_deductions as d
left join 
		dim_customer as c
		on d.customer_code = c.customer_code
where 
		market = "India" 
		and fiscal_year = 2021
group by 
		d.customer_code,
        c.customer
order by 
		avg_discount_price desc
limit 5

-- 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month . 
-- This analysis helps to get an idea of low and high-performing months and take strategic decisions. 
-- The final report contains these columns: 
	-- Month 
	-- Year 
	-- Gross sales Amount
select 
		month(s.date) as Month,
		year(s.date) as Year,
		round(sum(p.gross_price * s.sold_quantity),2) as Gross_sales_Amount
from 
		dim_customer as c
join
		fact_sales_monthly as s
on 
		c.customer_code = s.customer_code
join 
		fact_gross_price as p
on 
		s.product_code = p.product_code
where
		c.customer = "Atliq Exclusive"
    
group by
		month(s.date),
		year(s.date)
order by 
		Year asc,
        Month asc

-- 8 In which quarter of 2020, got the maximum total_sold_quantity? 
-- The final output contains these fields sorted by the total_sold_quantity, 
	-- Quarter 
	-- total_sold_quantity
-- way 1
select 
		temp.Quarter,
        sum(temp.sold_quantity) as Total_sold_quantity
from
(SELECT 
		*,
		CASE 
			WHEN MONTH(date) IN (9, 10, 11) THEN 1 
			when month(date) in (12,1,2) then 2
            when month(date) in (3,4,5) then 3
			else 4
		END AS Quarter
FROM 
		fact_sales_monthly ) as Temp
where 
		fiscal_year = 2020
Group By
		temp.Quarter

-- way 2: if the fiscal year starts from january

select 
		temp.Quarter,
        sum(temp.sold_quantity) as Total_sold_quantity
from
(  SELECT 
    *,
    CEIL(MONTH(date) / 3.0) AS Quarter
FROM 
    fact_sales_monthly
 ) as Temp
where 
		fiscal_year = 2020
Group By
		temp.Quarter
order by 
		Quarter

-- 9 Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? 
-- The final output contains these fields, 
	-- channel 
	-- gross_sales_mln 
	-- percentage    
select 
		*,
        Round(sq.gross_sales_mln*100/(select sum(sq_2.gross_sales_mln)
		from 	
			(select 
			c.channel,
			sum(s.sold_quantity * p.gross_price) as gross_sales_mln 
			from 
					dim_customer as c
			join 
					fact_sales_monthly as s
			on 
					c.customer_code = s.customer_code
			join 
					fact_gross_price as p
			on 
					s.product_code = p.product_code
			where 
					s.fiscal_year = 2021
			group by 
					c.channel
			order by 
					gross_sales_mln desc) as sq_2),2) as percentage  
	
from
(select 
		c.channel,
        sum(s.sold_quantity * p.gross_price) as gross_sales_mln
from 
		dim_customer as c
join 
		fact_sales_monthly as s
on 
		c.customer_code = s.customer_code
join 
		fact_gross_price as p
on 
		s.product_code = p.product_code
where 
		s.fiscal_year = 2021
group by 
		c.channel
order by 
		gross_sales_mln desc) as sq
limit 1       
        
        
-- way 2 (with the ctes)
-- (more prefereable)
with channel_sales as (
select 
	c.channel,
    sum(s.sold_quantity * p.gross_price) as gross_sales_mln
from
	dim_customer as c
join 
	fact_sales_monthly as s 
on 
	c.customer_code = s.customer_code
join 
	fact_gross_price as p
on
	s.product_code = p.product_code
where 
	s.fiscal_year = 2021
group by 
	c.channel
order by 
	gross_sales_mln desc
),
total_sales as (
select 
	sum(gross_sales_mln) as total_gross_sales_mln
from 	
	channel_sales
)
select
	cs.channel,
    cs.gross_sales_mln,
    round(cs.gross_sales_mln * 100 / ts.total_gross_sales_mln,2)as percentage
from 
	channel_sales as cs,
    total_sales as ts
order by 
	gross_sales_mln desc
limit 1


-- 10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021?
--  The final output contains these fields, 
-- division 
-- product_code 
-- product total_sold_quantity 
-- rank_order

-- way 1

with cte as (
select 
	p.division,
	p.product_code,
    sum(s.sold_quantity) as product_total_sold_quantity
from 
	dim_product as p
join 
	fact_sales_monthly as s
on 
	p.product_code = s.product_code
where 
	s.fiscal_year = 2021
group by 
	p.division,
    p.product_code ) ,
cte2 as (
select 
	* ,
    rank() over (partition by cte.division order by cte.product_total_sold_quantity desc) as rank_order
from cte )
select *
from 
	cte2
where 
	rank_order in (1,2,3)
ORDER BY 
    division, rank_order;	
    
-- way 2

select 
	* 
from
	(
	with cte as (
	select 
		p.division,
		p.product_code,
		sum(s.sold_quantity) as product_total_sold_quantity
	from 
			dim_product as p
	join 
			fact_sales_monthly as s
	on 
			p.product_code = s.product_code
	where 
			s.fiscal_year = 2021
	group by 
			p.division,
			p.product_code )
	select 
			* ,
			rank() over (partition by cte.division order by cte.product_total_sold_quantity desc) as rank_order
	from 
			cte 
	) as f
where 
	rank_order in (1,2,3)
ORDER BY 
	division, rank_order;

