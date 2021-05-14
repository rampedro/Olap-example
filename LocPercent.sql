


--schema:
--country
--province
--city
--percent_of_all (decimal(x, 5, 4))
--percent_in_group (decimal(x, 5, 4))
--order by country, province, city


WITH
    Roll (country, province, city, level,sales) as (
        select C.country,
               C.province,
	       C.city,
		 grouping(city) + grouping(province) + grouping(country)
		,
               sum(P.sale)
        from Purchase P, Customer C
	where P.cust# = C.cust#
        group by rollup(country,province,city)
	order by country, province,city
)

,

    Rollcountry (country,province,city,sales) as (
        select country,province,city,sales
        from Roll
	where level = 2
)
		
,

	Total (country, province, city, sales) as (
        select country,province,city,sales
        from Roll
	where level = 3
    
	)


,


result (a,b,c,d,e) as (
select R.country, R.province,R.city, decimal(float(R.sales)/T.sales,5,4) as percent_over_all ,decimal(float(R.sales)/ P.sales,5,4) as percent_in_group  from Roll R, Roll P, Total T
where R.country = P.country and R.province = P.province and (P.level = R.level + 1)

union all

select R.country, R.province,R.city, decimal(float(R.sales)/T.sales,5,4) as percent_over_all ,decimal(float(R.sales)/ P.sales,5,4) as percent_in_group  from Roll R, Rollcountry P, Total T
where R.level > 0 and P.country = R.country and level !=2

union all

select country, province,city, 1.0 , 1.0 from Total


)

,
append(a,b,c,d,e) as (


	select a as country, b as province, c as city , d as percent_over_all , e as percent_in_group from result

	union all 
	
	select C.country, C.province, C.city, decimal(float(C.sales) / T.sales,5,4) as percent_over_all, decimal(float(C.sales) / T.sales,5,4) as percent_in_group from Rollcountry C, Total T)


select a as country, b as province, c as city , d as percent_over_all , e as percent_in_group from append 
order by a, b,c;

