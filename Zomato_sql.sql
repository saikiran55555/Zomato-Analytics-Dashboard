create database zomato;

select count(1)
from zomato;

select count(1)
from countrycodes;

-- 1.Country Map Table

select z.RestaurantName,z.city,c.country
from zomato z
join countrycodes c
on z.CountryCode = c.`country code`;

-- 2.Calender Table

select Datekey_Opening,
year(str_to_date(Datekey_Opening,"%Y-%m-%d")) as year,
month(str_to_date(Datekey_Opening,"%Y-%m-%d")) as month_no,
monthname(str_to_date(Datekey_Opening,"%Y-%m-%d")) as month_name,
quarter(str_to_date(Datekey_Opening,"%Y-%m-%d")) as Quarter,

date_format(str_to_date(Datekey_Opening,"%Y-%m-%d"),"%Y-%m") as `Year-Month`,

weekday(str_to_date(Datekey_Opening,"%Y-%m-%d")) as Weekdayno,
dayname(str_to_date(Datekey_Opening,"%Y-%m-%d")) as Weekdayname,
case 
	when month(str_to_date(Datekey_Opening,"%Y-%m-%d")) >=4 
     then month(str_to_date(Datekey_Opening,"%Y-%m-%d")) - 3
    else month(str_to_date(Datekey_Opening,"%Y-%m-%d"))+9
    end as FinancialMonth,
case
	when month(str_to_date(Datekey_Opening,"%Y-%m-%d")) between 4 and 6 then 'FQ1'
    when month(str_to_date(Datekey_Opening,"%Y-%m-%d")) between 7 and 9 then 'FQ2'
    when month(str_to_date(Datekey_Opening,"%Y-%m-%d")) between 10 and 12 then 'FQ3'
    when month(str_to_date(Datekey_Opening,"%Y-%m-%d")) between 1 and 3 then 'FQ4'
end as FinancialQuarter

from zomato;

-- 3.Find the no.of restaurants based on city and country

select count(z.Restaurant_ID) as RestaurantsCount,
		z.city,
		c.country 
from zomato z 
join countrycodes c
on z.CountryCode = c.`Country Code`
group by z.city,c.country;

-- 4.Numbers of Resturants opening based on Year , Quarter , Month
select 
	year(str_to_date(Datekey_Opening,"%Y-%m-%d")) as year,
    quarter(str_to_date(Datekey_Opening,"%Y-%m-%d")) as Quarter,
    month(str_to_date(Datekey_Opening,"%Y-%m-%d")) as month_no,
    count(Restaurant_ID) as RestaurantsCount
from zomato
group by year,Quarter,month_no
order by year,Quarter,month_no;

-- 5.Count of Resturants based on Average Ratings

select 
	CASE
    WHEN rating IS NULL THEN 'No Rating'
    WHEN rating < 2 THEN 'Below Average'
    WHEN rating < 3 THEN 'Average'
    WHEN rating < 4 THEN 'Above Average'
    ELSE 'Outstanding'
END AS rating_category,
	count(Restaurant_ID) as RestaurantsCount
from zomato
group by rating_category
order by RestaurantsCount desc;

-- 6.Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

select
	case
    when Average_Cost_for_two < 300 then 'Very Low'
    when Average_Cost_for_two < 700 then 'Low'
    when Average_Cost_for_two < 1200 then 'Moderate'
    when Average_Cost_for_two < 2000 then 'High'
    else 'Very High'
end as price_bucket,
count(*) as RestaurantsCount
from zomato
group by price_bucket
order by RestaurantsCount desc;
    
-- 7.Percentage of Resturants based on "Has_Table_booking"

select
	Has_Table_booking,
	concat(round(count(*)* 100/(select count(*) from zomato ),2), '%') as Restaurants_Percentage
from zomato
group by Has_Table_booking
order by Restaurants_Percentage desc;

-- 8.Percentage of Resturants based on "Has_Online_delivery"

select
	Has_Online_delivery,
    concat(round(count(*) * 100/sum(count(*)) over() ,2),'%') as Restaurants_Percentage
from zomato
group by Has_Online_delivery
order by Restaurants_Percentage;
	
-- 9. Details based on Cusines, City, Ratings

select
	Cuisines,
    city,
    Rating,
    count(*) as Total_Restaurants
from zomato
group by Cuisines,
		 city,
		 Rating;
		

    




