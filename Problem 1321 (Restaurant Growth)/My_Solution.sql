-- Dimar's Code
with kumulatif as (
    select row_number() over() r, sum(s) over(order by visited_on) as kum, visited_on
    from (
        select row_number() over(), sum(amount) s, visited_on
        from (
            select *
            from customer
            order by visited_on
        )
        group by visited_on
    ) as cus
), gabung_k1_k2 as (
    select k1.visited_on visited_on, k1.kum as kiri, k2.kum as kanan
    from kumulatif k1
    left join kumulatif k2 on
        k1.r = k2.r + 7
    offset 6
), ubah_null as (
    select visited_on, kiri, coalesce(kanan, 0) as kanan
    from gabung_k1_k2
)

select visited_on, kiri - kanan as amount,
       round(1.0*(kiri - kanan)/7, 2) as average_amount
from ubah_null