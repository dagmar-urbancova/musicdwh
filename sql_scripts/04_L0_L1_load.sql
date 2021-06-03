-- populate LOVs
/*
TRUNCATE layer1.lov_gender RESTART IDENTITY;
TRUNCATE layer1.lov_title RESTART IDENTITY;
*/


INSERT INTO layer1.lov_gender(
gender
)
SELECT
	l0gen.gender::varchar
FROM layer0.lov_gender as l0gen
left join layer1.lov_gender as l1gen
	on l0gen.gender::varchar = l1gen.gender
where l1gen.gender_id IS NULL
;

INSERT INTO layer1.lov_title(
	title,
	gender_id
)
SELECT
	l0.title::varchar,
	gen.gender_id
FROM layer0.lov_title as l0
left join layer1.lov_title as l1
	on l0.title::varchar = l1.title
left join layer1.lov_gender as gen
	on L0.gender = gen.gender
where l1.title_id IS NULL
;

-- populate user_account for hb data
INSERT INTO layer1.user_account(
	src_sys_id, 
	src_sys,
	title_id,
	first_name, 
	last_name, 
	gender_id, 
	email, 
	date_of_birth,
	date_registered,
	id_code_name,
	id_code_val,
	ip_address,
	country_id)
SELECT 
	hb.id as src_sys_id, 
	'hb' as src_sys,
	tit.title_id,
	hb.first_name, 
	hb.last_name, 
	gen.gender_id,
	hb.email, 
	hb.dob as date_of_birth,
	NULL as date_registered,
	NULL as id_code_name,
	NULL as id_code_val,
	hb.ip_address, 
	hb.country_code
FROM layer0.v_import_data_hb as hb
left join layer1.user_account as acct
	on hb.id = acct.src_sys_id
	and 'hb' = acct.src_sys
left join layer1.lov_gender as gen
	on hb.gender = gen.gender
left join layer1.lov_title as tit
	on tit.title = 'unspecified'
where acct.user_acct_id is null
order by hb.id
;

-- populate user_account for wwc data
INSERT INTO layer1.user_account(
	src_sys_id, 
	src_sys,
	title_id,
	first_name, 
	last_name, 
	gender_id, 
	email, 
	date_of_birth,
	date_registered,
	id_code_name,
	id_code_val,
	ip_address,
	country_id)
SELECT
	wwc.username as src_sys_id,
	'wwc' as src_sys,
	tit.title_id,
	wwc.first_name, 
	wwc.last_name, 
	gen.gender_id,
	wwc.email,	
	wwc.dob as date_of_birth,
	wwc.registered as date_registered,
	id_name as id_code_name, 
	id_value as id_code_val, 
	NULL as ip_address,
	wwc.country_code as country_id
FROM layer0.v_import_data_wwc as wwc
left join layer1.user_account as acct
	on wwc.username = acct.src_sys_id
	and 'wwc' = acct.src_sys
left join layer1.lov_title as tit
	on tit.title = wwc.title
left join layer1.lov_gender as gen
	on wwc.gender = gen.gender	
WHERE acct.user_acct_id is null
order by wwc.index;

-- populate user_address for wwc data
INSERT INTO layer1.user_address(
	user_acct_id, 
	user_street, 
	user_city, 
	user_state, 
	user_postcode)
SELECT
	acct.user_acct_id,
	wwc.street, 
	wwc.city, 
	wwc.state, 
	wwc.postcode
FROM layer0.v_import_data_wwc as wwc	
join layer1.user_account as acct
	on wwc.username = acct.src_sys_id
	and 'wwc' = acct.src_sys
left join layer1.user_address as ad
	on ad.user_acct_id = acct.user_acct_id
where ad.user_acct_id IS NULL;

-- populate account_login for wwc data
INSERT INTO layer1.account_login(
	user_acct_id, username, password, salt, md5, sha1, sha256)
SELECT	
	acct.user_acct_id,
	wwc.username, 
	wwc.password, 
	wwc.salt, 
	wwc.md5, 
	wwc.sha1, 
	wwc.sha256
FROM layer0.v_import_data_wwc as wwc
join layer1.user_account as acct
	on wwc.username = acct.src_sys_id
	and 'wwc' = acct.src_sys
left join layer1.account_login as al
	on al.user_acct_id = acct.user_acct_id
where al.user_acct_id IS NULL;

-- populate user_phone for wwc data
INSERT INTO layer1.user_phone(
	user_acct_id, 
	phone_nr, 
	cell_nr)
SELECT	
	acct.user_acct_id,
	wwc.phone, 
	wwc.cell
FROM layer0.v_import_data_wwc as wwc
join layer1.user_account as acct
	on wwc.username = acct.src_sys_id
	and 'wwc' = acct.src_sys
left join layer1.user_phone as up
	on up.user_acct_id = acct.user_acct_id
where up.user_acct_id IS NULL;

-- populate user_picture for wwc data
INSERT INTO layer1.user_picture(
	user_acct_id, picture_large_url, picture_medium_url, picture_thumb_url)
SELECT
	acct.user_acct_id,
	wwc.picture_large, 
	wwc.picture_medium, 
	wwc.picture_thumb
FROM layer0.v_import_data_wwc as wwc
join layer1.user_account as acct
	on wwc.username = acct.src_sys_id
	and 'wwc' = acct.src_sys
left join layer1.user_picture as pic
	on pic.user_acct_id = acct.user_acct_id
where pic.user_acct_id IS NULL;