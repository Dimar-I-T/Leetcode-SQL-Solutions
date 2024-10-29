-- Dimar's Code
with pilter2019 as (
    select order_date, buyer_id
    from orders
    where order_date between '2019-01-01' and '2019-12-31'
), itungbanyak as (
    select buyer_id, count(buyer_id) c
    from pilter2019
    group by buyer_id
), gabungUI as (
    select user_id buyer_id, join_date, c
    from users
    left join itungbanyak on
        itungbanyak.buyer_id = user_id 
)

select buyer_id, join_date, case
    when c is null then 0
    else c end as orders_in_2019
from gabungUI