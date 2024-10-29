-- Dimar's Code
with orang_rating_terbanyak as (
    select users.name n
    from movierating
    join users on
        users.user_id = movierating.user_id
    group by users.user_id, users.name
    order by count(users.user_id) desc, users.name asc
    limit 1
), film_rating_terbesar as (
    select movies.title mt, 1.0*sum(mov.rating)/count(movies.title)
    from
    (
        select *
        from movierating
        where extract(month from created_at) = 2 and extract(year from created_at) = 2020
    ) as mov
    join movies on
        movies.movie_id = mov.movie_id
    group by movies.title
    order by 1.0*sum(mov.rating)/count(movies.title) desc, movies.title asc
    limit 1
)

select n as results
from orang_rating_terbanyak
union all
select mt as results
from film_rating_terbesar