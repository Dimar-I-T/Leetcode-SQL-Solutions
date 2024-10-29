-- Dimar's Code
with pip as (
    select distinct product_id
    from prices
), piu as (
    select distinct unitssold.product_id as upp
    from unitssold
    right join pip on
    pip.product_id = unitssold.product_id
), piu1 as(
    select row_number() over() r, upp
    from piu
), cgabung as (
    select u.product_id up, prices.product_id pp, start_date sd, end_date ed, price p, purchase_date pd, units u
    from unitssold u
    cross join prices
    order by up
), filtercg as (
    select up, case 
        when pp = up and pd between sd and ed then p*u
        else 0 end as kali, case 
        when pp = up and pd between sd and ed then u
        else 0 end as un
    from cgabung
)

select up product_id, round(sum(kali)/sum(un), 2) average_price
from filtercg
group by product_id
union 
(select r, 0 as average_price
from piu1
where upp is null)