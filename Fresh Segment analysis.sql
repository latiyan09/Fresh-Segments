use fresh_segments;

Select * from interest_metrics;

describe interest_metrics;

describe interest_map;

-- What is count of records in the interest_metrics for each month_year?

Select month_year, count(*) as TotalCount from interest_metrics group by month_year order by month_year; 

-- Before dropping the values, it would be useful to find out the percentage of null values.
select round(100*(sum(case when interest_id is NULL then 1 end)/count(*)),2) as null_perc from interest_metrics;

WITH null_ids AS (
select count(*) as NULLCount, (select count(*) from interest_metrics) as TotalCount from interest_metrics where interest_id is NULL)

select round(100*(NULLCount/TotalCount),2) as null_perc from null_ids;

-- The percentage of null values is 8.36% which is less than 10%, hence I would suggest to drop all the null values.
-- Drop rows where interest_id is NULL

SET SQL_SAFE_UPDATES = 0;
delete from interest_metrics where interest_id is NULL;
SET SQL_SAFE_UPDATES = 1;

select Round(100*sum(case when interest_id is NULL then 1 end)/count(*),2) as Null_perc from interest_metrics;

-- How many interest_id values exist in the interest_metrics table but not in the interest_map table?

Select count(distinct(imap.id)) as map_id_count,
count(distinct(imat.interest_id)) as matrics_id_count, 
SUM(case when imap.id is Null then 1 end) as not_in_metric,
SUM(case when imat.interest_id is Null then 1 end) as not_in_map
from interest_map as imap
left outer join interest_metrics as imat on imap.id=imat.interest_id;

--  Summarise the id values in the interest_map by its total record count in this table.
Select count(id) as count from interest_map;

Select id, interest_name, count(*) as count from interest_map as map left outer join interest_metrics as mat on map.id=mat.interest_id group by id order by count desc;

-- Check your logic by checking the rows where 'interest_id = 21246' in your joined output and include all columns from interest_metrics and all columns from interest_map except from the id column.

select * from interest_metrics as mat left outer join interest_map as map on map.id=mat.interest_id where mat.interest_id = 21246 and _month is not null;

-- Are there any records in your joined table where the month_year value is before the created_at value from the interest_map table?

select count(*) as count from interest_map as map inner join interest_metrics as mat 
on map.id=mat.interest_id where mat.month_year < date_format(map.created_at,'%m-%Y');

-- Which interests have been present in all month_year dates in our dataset?

select count(distinct(month_year)),count(distinct(interest_id))  from interest_metrics;

with interest_ctc as(
select interest_id, count(distinct(month_year)) as count from interest_metrics where month_year is not null group by interest_id)

select count(interest_id) from interest_ctc where count =14;

-- which month_year have the largest composition values in distinct interests ?

select * from interest_metrics;

select * from interest_map;

SELECT month_year, count(distinct(interest_id)) as count
FROM interest_metrics where month_year is not null group by month_year order by count desc;






