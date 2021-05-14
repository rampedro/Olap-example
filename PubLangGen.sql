
--The cube of language × genre × publisher reporting the percentage of book titles in that group with respect to all book titles.

--schema:
	--publisher
	--language
	--genre
	--percentage (decimal(x, 5, 4))
--order by publisher, language, genre


with
	mycube (publisher,gp,language,gl,genre,gg) as (

	select publisher, grouping(B.publisher),language, grouping(B.language),genre, grouping(B.genre)
	from Book B
	group by cube(B.publisher,B.language,B.genre)

	)
,
	byall (language,ll,genre,gg , publisher,pp) as (

		select language,count(language), genre, count(genre) ,publisher, count(publisher)
		from Book
		group by cube(language,genre,publisher)
		order by language, publisher, genre


	)

		
	
	


select publisher, language,genre , decimal(float(gg) / 50000, 5, 4) as percent  from byall 
--select publisher,genre ,language, percent from byLang;
;
