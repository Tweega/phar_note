select row_to_json(t)
from (
  select id, first_name from users
) t;

select row_to_json(t)
from (
  select first_name,
  	(
      select array_to_json(array_agg(row_to_json(d)))
      from (
        select role_name, role_desc
        from user_roles as ur
        	inner join user_roles_user as uru
        		on ur.id = uru.role_id
        where uru.user_id = u.id
        
      ) d
    ) as roles
  from users as u
  where first_name = 'Hermione'
) t

