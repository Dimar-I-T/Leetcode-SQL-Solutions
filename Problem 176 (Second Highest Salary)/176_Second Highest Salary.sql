-- Dimar's Query
with diorder as (
    select distinct salary
    from employee
    union (select -1 as salary from employee)
    order by salary desc
    offset 1
    limit 1
)

select case when
    salary = -1 then null
    else salary end as SecondHighestSalary
from diorder

