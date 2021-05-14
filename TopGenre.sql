-- TopCity
-- The top two cities by sales per genre (of book)
-- and also per language (of book).



--For the top genre by sales for each country, province, city, show the top three customers by sales in that genre.
--
--schema:
--country,
--province
--city
--genre,
--cust# (integer)
--rank# (smallint)
--sales (decimal(x, 12, 2))
--order by country, province, city, genre, rank#, cust#



with
    Sales (genre, gg, country, province, city, cust#,  sales) as (
        select B.genre,
               grouping(genre) + grouping(country) + grouping(province) + grouping(city),
               C.country,
               C.province,
               C.city,
		C.cust#,
		sum(sale) as sales
        from Customer C, Purchase P, Book B
        where C.cust# = P.cust#
          and P.book# = B.book#
        group by cube(C.country,C.province,C.city, B.genre), C.cust#
    ),


    Alltables (genre, gg, country, province, city,  sales) as (
        select B.genre,
               grouping(genre) + grouping(country) + grouping(province) + grouping(city),
               C.country,
               C.province,
               C.city,
		sum(sale) as sales
        from Customer C, Purchase P, Book B
        where C.cust# = P.cust#
          and P.book# = B.book#
        group by cube(C.country,C.province,C.city, B.genre)
    ),


        
    TopGenre (genre, rank#, country, province, city, sales) as (
	select genre,
               rank() over( partition by country
                           order by sales desc),
               country, province, city, sales
        from Alltables
        where gg = 0
	--order by sales
	--group by rollup(country,province,city,genre) , sales
	


)
,



    Ranking (genre,cust#, rank#, country, province, city, sales) as (
        select S.genre,
		S.cust#,
               rank() over(partition by S.genre, S.country, S.province,S.city
                           order by S.sales desc),
               S.country, S.province, S.city, S.sales
        from Sales S
        where gg = 0
	--group by country, province,city,genre,sales,cust#
	--order by country , sales DESC
)


--,

 --mix ( country, province, city, genre,ranks ,sales) as (
--	select S.country, S.province, S.city, T.genre, T.ranks, S.sales
--	from TopGenre T, Sales S
--	where ranks = 1 and gg = 0
--	group by S.country, S.province, S.city, T.genre, T.ranks , S.sales
--)


--select * from TopGenre;

--select * from TopGenre where rank# = 1;
select R.country,R.province, R.city,R.genre, R.cust#,R.rank#,decimal(R.sales, 12, 2) as sales from Ranking R,TopGenre T where R.country = T.country and R.genre = T.genre and T.rank#=1 and R.rank# <= 3 order by R.country, R.province, R.city, R.genre, R.rank#, R.cust#;
--select * from TopGenre where ranks <= 3
