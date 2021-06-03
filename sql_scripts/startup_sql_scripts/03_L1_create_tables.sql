CREATE SCHEMA IF NOT EXISTS layer1;

drop table if exists layer1.user_account ;
CREATE TABLE IF NOT EXISTS layer1.user_account (
	user_acct_id SERIAL PRIMARY KEY,
	src_sys_id VARCHAR(50) NOT NULL,
	src_sys VARCHAR(20) NOT NULL,
	title_id SMALLINT NOT NULL,
	first_name VARCHAR(45),
	last_name VARCHAR(45),
	gender_id SMALLINT NOT NULL,
	email VARCHAR(450),
	date_of_birth TIMESTAMP,
	date_registered TIMESTAMP,
	id_code_name VARCHAR(20),
	id_code_val VARCHAR(45),
	ip_address VARCHAR(20),
	country_id VARCHAR(20)
);

comment on table layer1.user_account is 'User accounts from hb and wwc systems';
comment on column layer1.user_account.src_sys_id is 'User ID from the source system. HB - id, WWC - login';

CREATE TABLE IF NOT EXISTS layer1.lov_gender (
	gender_id SERIAL PRIMARY KEY,
	gender VARCHAR (20)
);
comment on table layer1.lov_gender is 'List of values of gender';

drop table if exists layer1.lov_title;
CREATE TABLE IF NOT EXISTS layer1.lov_title (
	title_id SERIAL PRIMARY KEY,
	title VARCHAR (20),
	gender_id INT
);
comment on table layer1.lov_title is 'List of values of titles';

drop table if exists layer1.user_picture;
CREATE TABLE IF NOT EXISTS layer1.user_picture (
	user_acct_id INT,
	picture_large_url VARCHAR(250),
	picture_medium_url VARCHAR(250),
	picture_thumb_url VARCHAR(250)
);
comment on table layer1.user_picture is 'Pictures for user accounts, if available';

DROP TABLE IF EXISTS layer1.user_address;
CREATE TABLE IF NOT EXISTS layer1.user_address (
	user_address_id SERIAL PRIMARY KEY,
	user_acct_id INT,
	user_street VARCHAR(250),
	user_city VARCHAR(250),
	user_state VARCHAR(100),
	user_postcode VARCHAR(20)
);
comment on table layer1.user_address is 'Address for user accounts, if available';

CREATE TABLE IF NOT EXISTS layer1.account_login(
	user_acct_id INT NOT NULL,	
	username VARCHAR(100),
	password VARCHAR(100),
	salt VARCHAR(100),
	md5 VARCHAR(100),
	sha1 VARCHAR(100),
	sha256 VARCHAR(100)
);
comment on table layer1.account_login is 'Account for user accounts, if available';

DROP TABLE IF EXISTS layer1.user_phone;
CREATE TABLE IF NOT EXISTS layer1.user_phone(
	user_acct_id INT NOT NULL,	
	phone_nr VARCHAR (20),
	cell_nr VARCHAR (20)
);
comment on table layer1.user_phone is 'Phone numbers for user accounts, if available';