-- Dimar's Code
with piltertanggal as (
    select product_id, new_price, change_date
    from products
    where change_date <= '2019-08-16'
), rankpt as (
    select product_id, new_price, change_date, rank() over(partition by product_id order by change_date desc) r
    from piltertanggal
)

select product_id, new_price price
from rankpt
where r = 1
union 
select product_id, 10 as price
from products
where product_id not in 
(select distinct product_id
 from rankpt )