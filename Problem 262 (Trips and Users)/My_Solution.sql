-- Dimar's Query
with cu as (
    select users_id as client, banned b1
    from users
), du as (
    select users_id as driver, banned b2
    from users
), filternotbanned as (
    select *
    from trips
    left join cu on
        cu.client = trips.client_id
    left join du on
        du.driver = trips.driver_id
    where b1 = 'No' and b2 = 'No' and request_at between '2013-10-01' and '2013-10-03'
), gruptanggal as (
    select request_at as day, round(1.0*count(case when status in ('cancelled_by_client', 'cancelled_by_driver') then status end)/
           count(request_at), 2) as "Cancellation Rate"
    from filternotbanned
    group by request_at
)

select * from gruptanggal