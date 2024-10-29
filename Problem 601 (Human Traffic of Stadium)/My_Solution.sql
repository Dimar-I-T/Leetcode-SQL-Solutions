with filteratas1 as (
    (select id, visit_date, people, row_number() over() ro
    from stadium
    where people >= 100)
    union (select '0' as id, '1000-01-01' as visit_date, '0' as people, '0' as ro)
), filteratas2 as (
    select * from filteratas1
    union
    select (select id + 1 from stadium order by id desc limit 1) as id, '1000-01-01' as visit_date, '0' as people, 
    (select ro + 1 from filteratas1 order by ro desc limit 1) as ro
), filteratas as (
    select * from filteratas2
    order by id
), satudua as (
    select row_number() over() ro1, f1.id a1, f2.id a2, f2.id - f1.id as sel
    from filteratas f1 join filteratas f2 on f1.ro = f2.ro - 1 
), bandingselisih as (
    select row_number() over() + 1 ro2, s2.sel selkiri, s1.sel seltengah, s3.sel selkanan
    from satudua s1
    join satudua s2 on s2.ro1 + 1 = s1.ro1
    join satudua s3 on
        s3.ro1 - 1 = s1.ro1
), filtersel as (
    select ro2
    from bandingselisih
    where seltengah = 1 and (seltengah = selkiri or seltengah = selkanan)
), gabungfssd as (
    select ro2, satudua.a1, satudua.a2
    from filtersel
    join satudua on
        satudua.ro1 = filtersel.ro2
), munculakhir as (
    select row_number() over() rom, s1.id skiri, s2.id stengah, s3.id skanan
    from filteratas s1
    join filteratas s2 on  s1.id = s2.id - 1
    join filteratas s3 on s1.id = s3.id - 2
), akhir1 as (
    (select id, visit_date, people, row_number() over() ro3
    from stadium
    where id in (select a1 from gabungfssd) or
        id in (select a2 from gabungfssd))
    union
    (select -1 as id, '1000-01-01' as visit_date, '0' as people, '0' as ro3)
), sortedakhir1 as (
    select * from akhir1 order by ro3
), tigakolom as (
    select s1.id ki, s2.id te, s3.id ka
    from sortedakhir1 s1
    join sortedakhir1 s2 on
        s1.ro3 = s2.ro3 - 1
    join sortedakhir1 s3 on
        s1.ro3 = s3.ro3 - 2
), filtermin as (
    select * from tigakolom where ki = te - 1 and ki = ka - 2
)

select id, visit_date, people from stadium
where id in (select ki from filtermin) or 
id in (select te from filtermin) or id in (select ka from filtermin)
    