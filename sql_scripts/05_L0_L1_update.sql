-- update user_account for hb data
UPDATE layer1.user_account
	SET 
	title_id= src.title_id, 
	first_name= src.first_name, 
	last_name= src.last_name, 
	gender_id= src.gender_id, 
	email= src.email, 
	date_of_birth= src.date_of_birth, 
	date_registered= src.date_registered, 
	id_code_name= src.id_code_name, 
	id_code_val= src.id_code_val, 
	ip_address= src.ip_address, 
	country_id= src.country_id
FROM 
(
SELECT 
--	hb.id as src_sys_id, 
--	'hb' as src_sys,
	acct.user_acct_id,
	tit.title_id,
	hb.first_name, 
	hb.last_name, 
	gen.gender_id,
	hb.email, 
	hb.dob as date_of_birth,
	to_timestamp(NULL) as date_registered,
	NULL as id_code_name,
	NULL as id_code_val,
	hb.ip_address, 
	hb.country_code as country_id
FROM layer0.v_import_data_hb as hb
join layer1.user_account as acct
	on hb.id = acct.src_sys_id
	and 'hb' = acct.src_sys
left join layer1.lov_gender as gen
	on hb.gender = gen.gender
left join layer1.lov_title as tit
	on tit.title = 'unspecified'
where 
	   tit.title_id <> acct.title_id
	OR hb.first_name <> acct.first_name
	OR hb.last_name <> acct.last_name
	OR gen.gender_id <> acct.gender_id
	OR hb.email <> acct.email
	OR hb.dob <> acct.date_of_birth
	OR hb.ip_address <> acct.ip_address
	OR hb.country_code <> country_id
order by acct.user_acct_id
) as src
where layer1.user_account.user_acct_id = src.user_acct_id;


-- update user_account for wwc data
UPDATE layer1.user_account
	SET 
	title_id= src.title_id, 
	first_name= src.first_name, 
	last_name= src.last_name, 
	gender_id= src.gender_id, 
	email= src.email, 
	date_of_birth= src.date_of_birth, 
	date_registered= src.date_registered, 
	id_code_name= src.id_code_name, 
	id_code_val= src.id_code_val, 
	ip_address= src.ip_address, 
	country_id= src.country_id
FROM 
(
SELECT
	wwc.username as src_sys_id,
	'wwc' as src_sys,
	acct.user_acct_id,
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
join layer1.user_account as acct
	on wwc.username = acct.src_sys_id
	and 'wwc' = acct.src_sys
left join layer1.lov_title as tit
	on tit.title = wwc.title
left join layer1.lov_gender as gen
	on wwc.gender = gen.gender	
where 
	   tit.title_id <> acct.title_id
	OR wwc.first_name <> acct.first_name
	OR wwc.last_name <> acct.last_name
	OR gen.gender_id <> acct.gender_id
	OR wwc.email <> acct.email
	OR wwc.dob <> acct.date_of_birth
	OR wwc.id_name <> acct.id_code_name
	OR wwc.id_value <> acct.id_code_val
	OR wwc.country_code <> country_id
order by acct.user_acct_id
) as src
where layer1.user_account.user_acct_id = src.user_acct_id;


-- update account_login values for wwc
UPDATE layer1.account_login
	SET 
	password=src.password, 
	salt=src.salt, 
	md5=src.md5, 
	sha1=src.sha1, 
	sha256=src.sha256
FROM (
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
join layer1.account_login as al
	on al.user_acct_id = acct.user_acct_id
where 
	   wwc.password <> al.password
	OR wwc.salt <> al.salt
	OR wwc.md5 <> al.md5
	OR wwc.sha1 <> al.sha1
	OR wwc.sha256 <> al.sha256
	) as src
where layer1.account_login.user_acct_id = src.user_acct_id;

-- update user_address
UPDATE layer1.user_address
	SET 
	user_street= src.street, 
	user_city= src.city, 
	user_state= src.state, 
	user_postcode=src.postcode
FROM (
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
	join layer1.user_address as ad
		on ad.user_acct_id = acct.user_acct_id
	where 
		   wwc.street <> ad.user_street
		OR wwc.city <> ad.user_city
		OR wwc.state <> ad.user_state
		OR wwc.postcode <> ad.user_postcode
) as src
where layer1.user_address.user_acct_id = src.user_acct_id;


-- update user_phone
UPDATE layer1.user_phone
	SET 
	phone_nr=src.phone, 
	cell_nr=src.cell
FROM (
	SELECT	
		acct.user_acct_id,
		wwc.phone, 
		wwc.cell
	FROM layer0.v_import_data_wwc as wwc
	join layer1.user_account as acct
		on wwc.username = acct.src_sys_id
		and 'wwc' = acct.src_sys
	join layer1.user_phone as up
		on up.user_acct_id = acct.user_acct_id
	where 
			up.phone_nr <> wwc.phone
		OR	up.cell_nr <> wwc.cell
) as src
WHERE layer1.user_phone.user_acct_id = src.user_acct_id;

-- update user_picture
UPDATE layer1.user_picture
	SET 
		picture_large_url=src.picture_large, 
		picture_medium_url=src.picture_medium, 
		picture_thumb_url=src.picture_thumb
FROM (
	SELECT
		acct.user_acct_id,
		wwc.picture_large, 
		wwc.picture_medium, 
		wwc.picture_thumb
	FROM layer0.v_import_data_wwc as wwc
	join layer1.user_account as acct
		on wwc.username = acct.src_sys_id
		and 'wwc' = acct.src_sys
	join layer1.user_picture as pic
		on pic.user_acct_id = acct.user_acct_id	
	WHERE
			wwc.picture_large <> pic.picture_large_url
		OR	wwc.picture_medium <> pic.picture_medium_url
		OR	wwc.picture_thumb <> pic.picture_thumb_url
) as src
WHERE layer1.user_picture.user_acct_id = src.user_acct_id;
