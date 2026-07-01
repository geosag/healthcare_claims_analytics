-- cleaned st table
select 
	status_id,
	initcap(claim_status) as claim_status,
	upper("type") as "type"
from st;

-- cleaned claim table
select 
	claim_id,
	status_id, 
	trim(date_of_service)::date as date_of_service,
	date(date_trunc('month', date(trim(date_of_service)))) as dos_month_year,
	extract(year from trim(date_of_service)::date) as dos_year,
	trim(received_date)::date as received_date,
	date(date_trunc('month', date(trim(received_date)))) as received_date_month_year,
	extract(year from trim(received_date)::date) as received_date_year,
	add_by
from claim;

-- cleaned cov table
select distinct coverage_name from (
select
	coverage_id,
	member_id,
	initcap(lower(trim(coverage_name))) as coverage_name,
	trim(effective_date)::date as effective_date,
	case
		when trim(term_date) = 'NULL' then null
		else trim(term_date)::date
	end as term_date
from cov);

-- cleaned add table
select * from add;

-- cleaned claim_payment table
select * from claim_payment;

-- cleaned mem table
select
	member_id,
	member_first_name,
	member_last_name,
	address_id,
	trim(gender) as gender,
	date(split_part(member_dob, '-', 3) || '-' || split_part(member_dob, '-', 2) || '-' || split_part(member_dob, '-', 1)) as member_dob,
	case 
		when (current_date - date(split_part(member_dob, '-', 3) || '-' || split_part(member_dob, '-', 2) || '-' || split_part(member_dob, '-', 1)))/365 between 0 and 18
			then '0-18'
		when (current_date - date(split_part(member_dob, '-', 3) || '-' || split_part(member_dob, '-', 2) || '-' || split_part(member_dob, '-', 1)))/365 between 19 and 35
			then '19-35'
		when (current_date - date(split_part(member_dob, '-', 3) || '-' || split_part(member_dob, '-', 2) || '-' || split_part(member_dob, '-', 1)))/365 between 36 and 50
			then '36-50'
		else '50+'
	end as age_bins,
	claim_id,
	coverage_id
from mem;

-- cleaned pr table
select 
	provider_id,
	provider_first_name,
	provider_last_name,
	trim(degree) as degree,
	trim(network) as network,
	claim_id,
	case 
		when trim(practice_name) = 'ABC HOSPITAL'
		then 'ABC Hospital'
		else initcap(lower(trim(practice_name)))
	end as practice_name,
	address_id,
	trim(gender) as gender
from pr;