--Netflix Data Analysis Using SQL

--Creating the table and giving the Datatypes

drop table if exists netflix;
create table netflix1
(show_id	varchar(10),
type varchar(10),
title varchar(150),
director varchar(210) ,	
casts	varchar(1000),
country	varchar(150),
date_added	varchar(50),
release_year INT,
rating	varchar(10),
duration	varchar(15),
listed_in	varchar(100),
description varchar(250)
);

--1. Count the number of Movies vs TV Shows
select  type,
count(type)
from netflix1
group by type;

--2. Find the most common rating for movies and TV shows

select * from
(select type,rating,count(rating),
dense_rank() over(partition by type
order by count(rating) desc ) as ranks
from netflix1
group by 1,2)
where ranks=1

--3. List all movies released in a specific year (e.g., 2020)
select release_year,title
from netflix1
where type='Movie' and release_year=2020
order by 2 ;

--4. Find the top 5 countries with the most content on Netflix

SELECT Trim(UNNEST(STRING_TO_ARRAY(country,','))),COUNT(show_id)
FROM NETFLIX1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5.Identify the longest movie 
SELECT TITLE,DURATION FROM NETFLIX1
WHERE type='Movie' and duration=
(select Max(duration) from netflix1);

--6. Find content added in the last 5 years
SELECT *
FROM NETFLIX1
WHERE TO_DATE(DATE_ADDED,'MONTH DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--7. Find all the movies/TV shows by director 'Ram Gopal Varma'!

select title,
director 
from netflix1 
where director='Ram Gopal Varma'


--8. List all TV shows with more than 5 seasons
select title,duration
from netflix1
where type='TV Show' and duration>'5 Seasons'
order by 2

--9. Count the number of content items in each genre

select trim(unnest(string_to_array(listed_in,','))) genre,count(*)
from netflix1
group by 1
order by 2 desc

/*10. Find each year and the average numbers of content release by India on netflix.
return the top 5 with highest average content release*/

select EXTRACT(YEAR FROM to_date(date_added,'MONTH DD YYYY')) as  Year,
count(*),
count(*)::numeric/(select count(*) from netflix1 where country='India')*100 as avg_content_peryear 
FROM netflix1 
where country='India'
group by 1

--11. List all movies that are documentaries

select * from
(select title,type,trim(unnest(string_to_array(listed_in,','))) as genre
from netflix1)
where type='Movie'and genre='Documentaries' ;

--12. Find all content without a director

select * from netflix1
where director is null

--13. Find the movies of actor 'Prabhas'
select * from
(select title,trim(unnest(string_to_array(casts,','))) as casts from netflix1)
where casts='Prabhas'

--14. Find how many movies actor 'Salman Khan' appeared in last 10 years! appeared in last 10 years!

select * from
(select title,trim(unnest(string_to_array(casts,','))) as casts,release_year from netflix1)
where casts='Salman Khan' and release_year>=2014


--15.Find the top 10 actors who have appeared in the highest number of movies produced in

select trim(unnest(string_to_array(casts,','))) actors,count(*) 
from netflix1
group by 1
order by 2 desc
limit 10;

/*16.Categorize the content based on the presence of the keywords 'kill' 
and 'violence' in the description field.
Label content containing these keywords as 'Bad' 
and all other content as 'Good'. 
Count how many items fall into each category.*/

select category,count(*) from
(select * ,
case when description like '%kill%' or description like '%violence%' then 'Bad'
else 'Good' end as Category
from netflix1)
group by 1




