select d.categoryName, month.money
from (	
    select DISTINCT COALESCE(NULLIF(categoryName,''), 'Без категории') as categoryName
    from TT
    where date like '_PASTE_YEAR_HERE_%'
    and outcome > 0
) as d
left join (
    select COALESCE(NULLIF(categoryName,''), 'Без категории') as categoryName, cast(sum (outcome) as int) as money
    from TT
    where date like '_PASTE_YEAR_HERE_-_PASTE_MONTH_HERE_%'
    and outcomeAccountName = incomeAccountName
    group by categoryName
) as month
on (d.categoryName = month.categoryName)
order by 1;