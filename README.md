#The following queries have been requested:


## A. PubLangGen (cube)
The cube of language × genre × publisher reporting the percentage of book titles in that group with respect to all book titles.

schema: publisher, language, genre, percentage (decimal(x, 5, 4))
order by publisher, language, genre


## B. LocPercent (roll up)
The roll-up of country > province > city reporting the percentage of sales for each group with respect to all sales and reporting the percentage of sales for each group with respect to sales in the immediate super-group (for example, sales for CND-ON-Toronto over CND-ON-ALL).

schema:
country, province, city, percent_of_all (decimal(x, 5, 4)), percent_in_group (decimal(x, 5, 4))
order by country, province, city



## C. TopGenre (top K)
For the top genre by sales for each country, province, city, show the top three customers by sales in that genre.

schema: country, province, city, genre, cust# (integer), rank# (smallint), sales (decimal(x, 12, 2))
order by country, province, city, genre, rank#, cust#
