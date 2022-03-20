# In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the following query:
use sakila;
DROP PROCEDURE IF EXISTS personal_information;

delimiter $$ 
create procedure personal_information ()

begin 
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;

end; 
$$
delimiter ; 
# Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc
delimiter $$ 
create procedure personal_information_category (in cat_name varchar(25))

begin 
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = cat_name
  group by first_name, last_name, email;

end; 
$$
delimiter ; 
call personal_information_category('Animation');
use sakila;
# Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

select c. name as category_name, count(f.film_id) as count from category c
join film_category fc on
 c.category_id= fc.category_id
join film f on
 fc.film_id=f.film_id
group by 1
order by 2 desc;
delimiter $$ 

DROP procedure IF EXISTS film_category_count;
create procedure film_category_count (in number_ int)

begin 
	select c.name as category_name, count(f.film_id) as count from category c
	join film_category fc on
	 c.category_id= fc.category_id
	join film f on
	 fc.film_id=f.film_id
	group by 1
	having  count(f.film_id) > number_
	order by 2 desc;
end;
 
$$
delimiter ; 
call film_category_count(70);

