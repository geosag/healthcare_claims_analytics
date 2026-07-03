-- cleaned st table
SELECT 
	status_id,
	INITCAP(claim_status) AS claim_status,
	UPPER("type") AS "type"
FROM st;

-- cleaned claim table
SELECT 
	claim_id,
	status_id, 
	TRIM(date_of_service)::DATE AS date_of_service,
	DATE(DATE_TRUNC('month', DATE(TRIM(date_of_service)))) AS dos_month_year,
	EXTRACT(YEAR FROM TRIM(date_of_service)::DATE) AS dos_year,
	TRIM(received_date)::DATE AS received_date,
	DATE(DATE_TRUNC('month', DATE(TRIM(received_date)))) AS received_date_month_year,
	EXTRACT(YEAR FROM TRIM(received_date)::DATE) AS received_date_year,
	add_by
FROM claim;

-- cleaned cov table
SELECT DISTINCT coverage_name FROM (
SELECT
	coverage_id,
	member_id,
	INITCAP(LOWER(TRIM(coverage_name))) AS coverage_name,
	TRIM(effective_date)::DATE AS effective_date,
	CASE
		WHEN TRIM(term_date) = 'NULL' THEN NULL
		ELSE TRIM(term_date)::DATE
	END AS term_date
FROM cov);

-- cleaned add table
SELECT * FROM add;

-- cleaned claim_payment table
SELECT * FROM claim_payment;

-- cleaned mem table
SELECT
	member_id,
	member_first_name,
	member_last_name,
	address_id,
	TRIM(gender) AS gender,
	DATE(SPLIT_PART(member_dob, '-', 3) || '-' || SPLIT_PART(member_dob, '-', 2) || '-' || SPLIT_PART(member_dob, '-', 1)) AS member_dob,
	CASE 
		WHEN (CURRENT_DATE - DATE(SPLIT_PART(member_dob, '-', 3) || '-' || SPLIT_PART(member_dob, '-', 2) || '-' || SPLIT_PART(member_dob, '-', 1)))/365 BETWEEN 0 AND 18
			THEN '0-18'
		WHEN (CURRENT_DATE - DATE(SPLIT_PART(member_dob, '-', 3) || '-' || SPLIT_PART(member_dob, '-', 2) || '-' || SPLIT_PART(member_dob, '-', 1)))/365 BETWEEN 19 AND 35
			THEN '19-35'
		WHEN (CURRENT_DATE - DATE(SPLIT_PART(member_dob, '-', 3) || '-' || SPLIT_PART(member_dob, '-', 2) || '-' || SPLIT_PART(member_dob, '-', 1)))/365 BETWEEN 36 AND 50
			THEN '36-50'
		ELSE '50+'
	END AS age_bins,
	claim_id,
	coverage_id
FROM mem;

-- cleaned pr table
SELECT 
	provider_id,
	provider_first_name,
	provider_last_name,
	TRIM(degree) AS degree,
	TRIM(network) AS network,
	claim_id,
	CASE 
		WHEN TRIM(practice_name) = 'ABC HOSPITAL'
		THEN 'ABC Hospital'
		ELSE INITCAP(LOWER(TRIM(practice_name)))
	END AS practice_name,
	address_id,
	TRIM(gender) AS gender
FROM pr;