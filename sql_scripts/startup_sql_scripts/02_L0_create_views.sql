

DROP VIEW IF EXISTS layer0.v_import_data_hb;
CREATE VIEW layer0.v_import_data_hb as
SELECT 
	hb.id::VARCHAR, 
	hb.first_name::VARCHAR, 
	hb.last_name::VARCHAR, 
	hb.email::VARCHAR, 
	COALESCE(lower(hb.gender), 'unspecified') ::VARCHAR as gender,
	hb.ip_address::VARCHAR, 
	TO_TIMESTAMP(hb.dob, 'MM/DD/YYYY') as dob, 
	hb.country_code::VARCHAR
FROM layer0.import_data_hb as hb
;

DROP VIEW IF EXISTS layer0.v_import_data_wwc;
CREATE VIEW layer0.v_import_data_wwc as
SELECT 
	index, 
	COALESCE(lower( wwc.gender_1), 'unspecified') ::VARCHAR as gender,
	COALESCE(wwc.name_1, 'unspecified' )::VARCHAR as title, 
	name_2::VARCHAR as first_name, 
	name_3::VARCHAR as last_name, 
	location_1::VARCHAR as street, 
	location_2::VARCHAR as city, 
	location_3::VARCHAR as state, 
	location_4::VARCHAR as postcode, 
	email_1::VARCHAR as email, 
	login_1::VARCHAR as username, 
	login_2::VARCHAR as password, 
	login_3::VARCHAR as salt, 
	login_4::VARCHAR as md5, 
	login_5::VARCHAR as sha1, 
	login_6::VARCHAR as sha256, 
	TO_TIMESTAMP(wwc.dob_1, 'YYYY-MM-DD HH24:MI:SS') as dob,
	TO_TIMESTAMP(wwc.registered_1, 'YYYY-MM-DD HH24:MI:SS') as registered, 
	phone_1::VARCHAR as phone, 
	cell_1::VARCHAR as cell, 
	id_1::VARCHAR as id_name, 
	id_2::VARCHAR as id_value, 
	picture_1::VARCHAR as picture_large, 
	picture_2::VARCHAR as picture_medium, 
	picture_3::VARCHAR as picture_thumb, 
	nat_1::VARCHAR as country_code
	FROM layer0.import_data_wwc as wwc;
