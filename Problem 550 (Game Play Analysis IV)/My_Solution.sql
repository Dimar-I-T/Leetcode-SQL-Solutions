-- Dimar's Code
with idxRN as (
    select player_id, event_date,
           row_number() over(partition by player_id
                             order by event_date) r
    from activity
), ambilDua as (
    select row_number() over() idx, player_id, event_date, r
    from idxRN
    where r < 3
), banding as (
    select p1.player_id pi1, p1.event_date e1,
           p2.player_id pi2, p2.event_date e2,
           p2.event_date - p1.event_date selisihT
    from ambilDua p1
    inner join ambilDua p2 on
        p1.idx = p2.idx - 1
), ambilSel1 as (
    select count(pi1) c
    from banding
    where pi1 = pi2 and selisihT = 1  
), distActivity as (
    select distinct player_id
    from activity
), idxDA as (
    select row_number() over() r, player_id
    from distActivity
)

select round(1.0 * c / (select r
                        from idxDA
                        order by r desc
                        limit 1), 2) as fraction
from ambilSel1;