create Database if not exists amazonsales; 

use amazonsales; 


Create table if not exists Asales (
 invoice_id  varchar(30) Not null primary Key,
 branch  varchar (5) not null,
    city varchar (30) not null,
    customer_type varchar (30) not null,
    gender  varchar(10) not null,
    product_line varchar (100) not null,
    unit_price  decimal(10,2) not null,
    quantity int not null,
    VAT  float not null,
    total decimal (12,4) not null,
    date datetime not null,
    time TIME not null,
    payment_method varchar (15)  not null, 
    cogs  decimal (10, 2) not null,
    gross_margin_pct float ,
    gross_income decimal(12, 4) not null,
    rating float 
); 

select * from Asales  

# Adding New Column "Time_Of_Day"
select time,
    (case 
          when `time` between "00:00:00" and "12:00:00" then "Morning"
          when `time` between "12:01:00" and "16:00:00" then "Afternoon"
          else  "Evening" 
    end 
    ) As time_of_day
from Asales; 
alter table Asales add column time_of_day  varchar(30);
update Asales
set time_of_day= 
   (case
        when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else  "Evening" 
       end
   ) ;

## New column named "Dayname" 

select date , 
   dayname(date) from Asales ;
Alter Table Asales Add column day_name varchar(10) 
update Asales 
set day_name = dayname(date);  

###new column named "monthname" 

select date,
      monthname(date) from Asales;
Alter Table Asales Add column Month_Name varchar (10) 

update Asales 
set Month_Name = monthname(date)

##  Exploratory Data Analysis (EDA) ----- 

#--1--What is the count of distinct cities in the dataset?---
select city, count(distinct city) as city_count from asales
group by city
order by city_count; 

#-2--For each branch, what is the corresponding city?--
select distinct city,branch from Asales; 
#--/ we have three branches "A = Yanqon" , "B = Mandalay" , "C = Naypyitaw" ..///

#--3--What is the count of distinct product lines in the dataset?--
select count(distinct product_line)as dist_product_line from Asales;
  ##---we have 6 distinct product_line in our dataset...
  
##--4-Which payment method occurs most frequently?--
select payment_method,count(payment_method) as payment from Asales
group by payment_method 
order by payment desc;
#--- Most of the customer uses "Ewallet Payment mode "


##-5--Which product line has the highest sales?--
select product_line , count(product_line) as sales 
from Asales 
group by product_line  
order by sales desc;
#--// Fashion Accessories has the heighest sales over the period--///


##-6--How much revenue is generated each month?--
select Month_Name , sum(total) as revenue 
from Asales 
group by month_name 
order by revenue desc; 
#--// January month generated the heighest revenue--//

 
##-7--In which month did the cost of goods sold reach its peak?---
select month_name , sum(cogs) as goods_sold from Asales 
group by month_name 
order by goods_sold desc;
#--// In January cogs is at peak--///


##-8--Which product line generated the highest revenue?---
 select product_line , sum(total) as revenue from Asales 
 group by product_line 
 order by revenue desc;
 #--/// Food and beverages generates heighest revenue--///
 
##-9--In which city was the highest revenue recorded?--- 
select city , sum(total) as revenue from Asales 
group by city 
order by revenue desc;
#--// Naypyitaw city has the highest revenue recorded--//


##-10--Which product line incurred the highest Value Added Tax?---
select product_line , sum(VAT) as heighest_vat from Asales 
group by product_line 
order by heighest_vat desc;
#--// Food and Beverages has incurred the highest vat--//


##-11-For each product line, add a column indicating "Good" 
##if its sales are above average, otherwise "Bad."--
select avg(quantity) as avg_quantity from asales; --## 5.5 is the avg quantity--///

select product_line ,
       (case 
          when avg(quantity) > 6 Then "Good" 
          else "Bad"
          end ) as remark 
	from Asales 
	group by product_line
    
 ###-12--Identify the branch that exceeded the average number of products sold.---
 select branch , sum(quantity) as total_sales from asales
 group by branch 
 having total_sales > (select avg(quantity) from asales);
 #--// Branch "A" exceeded the avg product solds compare to branch "b" , "c"..//
 
 
 ##-13--Which product line is most frequently associated with each gender?---
 select product_line , gender, count(gender) as gender_count from asales 
 group by product_line, gender 
 order by gender_count desc;  
 #--Fashion Accessories , food & beverage , sports & travel is associated with the female
  #--/ Health and beauty, Electronic Accessories has associated with the male..///alter
  
  
 ##-14--Calculate the average rating for each product line.--
 select product_line , avg(rating) as avg_rating from asales 
 group by product_line 
 order by avg_rating desc; 
#.. Avg rating for food and beverages = 7.1 , Fashion Accessories = 7.0 
#.. the least rating we got for the "Home and Lifestyle"=6.8..//alter


##-15--Count the sales occurrences for each time of day on every weekday.--
select time_of_day ,day_name, count(*) as total_sales from asales 
group by time_of_day ,day_name
order by total_sales desc; 
#-- // Most of the sales occurs on "Saturday Evening"

##-16-Identify the customer type contributing the highest revenue.
select customer_type , sum(total) as revenue from asales 
group by customer_type 
order by revenue desc; 
---#member contributes the heighest revenue---

##-17--Determine the city with the highest VAT percentage.---
select city,avg(vat) as avg_vat from asales
group by city
order by avg_vat desc; 
#----Naypyitaw has the heighest Vat percentage---

##-18--Identify the customer type with the highest VAT payments.---
select customer_type , avg(vat) as avg_vat from asales 
group by customer_type 
order by avg_vat desc; 
#-- Members has the highest VAT Payment ..//

 select customer_type , sum(vat) as total_vat from asales 
 group by customer_type 
 order by total_vat desc;  
 
 ##-19--What is the count of distinct customer types in the dataset?-- 
 select distinct customer_type  from asales;
#--- We have "Members", "Normal" these two customers we have in the dataset ../// 


##-20--What is the count of distinct payment methods in the dataset?--
select distinct payment_method from asales; 

##-21--Which customer type occurs most frequently?---
 select customer_type , count(*) as cust from asales 
 group by customer_type
 order by cust desc;
 
##-22--Identify the customer type with the highest purchase frequency.--
 select customer_type , count(*) as cust from asales 
 group by customer_type
 order by cust desc;  
 
 ##-23--Determine the predominant gender among customers.--
 select gender , count(*) as gender_count from asales 
 group by gender 
 order by gender_count desc;
 #-- Females are predominant gender among the customer ../// 
 
 

 ##-24-Examine the distribution of genders within each branch.---
 select gender,branch , count(*) as gen_count from asales
 group by gender ,branch
 order by gen_count desc;
 
 ##-25--Identify the time of day when customers provide the most ratings.---
 select time_of_day , avg(rating) as avg_rating from asales 
 group by time_of_day 
 order by avg_rating desc; 
 #-- customer provides rating during Afternoon
#25 
  select time_of_day  , count(rating) as rating from asales 
  group by time_of_day
  order by rating desc;
  
 ##-26--Determine the time of day with the highest customer ratings for each branch.
select time_of_day, branch, count(rating) as rating from asales 
group by time_of_day , branch 
order by rating desc ;
#-- "B" branch has received 148 ratings during evening hours///

##-27--Identify the day of the week with the highest average ratings.
select day_name , avg(rating) as rating from asales 
group by day_name 
order by rating desc; 
#---Customer gives heighest ratings on "Monday"

###-28--Determine the day of the week with the highest average ratings for each branch.--
select day_name , branch, avg(rating) as rating from asales 
group by day_name , branch 
order by rating desc ;
- # "MONDAY" "B" branch has the heighest rating  

# ---   Product Analysis :- After extracting information from the dataset we got to know 
   #--1) highest sales generated from the Fashion & Accessories  product_line 
    #--2) Highest revenue from the product line Food And Beverage 
    #--3)Highest VAT from the Food and Beverage 
    #--4)Food and Beverage , Fashion Accessories are predominent by female
    #--where as health & beuty ,electronics , home & lifestyle are predominent by males ///
    
    #---- Sales Analysis:- 1)Highest Revenue genrated durinh the month of january 
     #--2) Sales generated mostly on the saturday evening 
     #--3) Members of Amazon contributes the highest revenue
     #-- 4) most of the sales generated from the city "NAYPYITAW" 
     
     
     #---Customer Analysis:- 1 we have two type of customers in the dataset i.e "members" & "Normal"
     #--2) Members generate the highest revenue 
     
    
    ## to increase the sales we must offer membership to the customers so that we can attract
    # our members with special offers and good advertisement to increase sales 
    # --Lowest sales occurrs from the health & beuty so we need to look ways to increase sales by offering 
    ## good memebership plans and discounts 
    
    
