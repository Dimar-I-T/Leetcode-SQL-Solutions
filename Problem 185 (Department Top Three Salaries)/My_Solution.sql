-- Dimar's Code

with gabungrank as (
    select department.name dn, employee.name, salary, dense_rank() over(partition by departmentId order by salary desc) r
    from employee
    join department on
        department.id = employee.departmentid
)

select dn as department, name as employee, salary
from gabungrank
where r <= 3