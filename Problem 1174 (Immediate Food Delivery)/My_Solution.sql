-- Dimar's Code
with rankdel as (
    select customer_id, order_date od, customer_pref_delivery_date cd,
    rank() over(partition by customer_id order by order_date asc) r
    from delivery
), pilterpertama as (
    select row_number() over() ro, customer_id
    from rankdel
    where r = 1 and od = cd
), distcust as (
    select distinct customer_id cus
    from delivery
), rodist as (
    select row_number() over() roo
    from distcust
)

select round(100.0*(select ro from pilterpertama order by ro desc limit 1)/
       (select roo from rodist order by roo desc limit 1), 2) as immediate_percentage