CREATE SCHEMA IF NOT EXISTS layer0;

CREATE TABLE "layer0".import_data_wwc
(
    index bigint,
    gender_1 text,
    name_1 text,
    name_2 text,
    name_3 text,
    location_1 text,
    location_2 text,
    location_3 text,
    location_4 text,
    email_1 text,
    login_1 text,
    login_2 text,
    login_3 text,
    login_4 text,
    login_5 text,
    login_6 text,
    dob_1 text,
    registered_1 text,
    phone_1 text,
    cell_1 text,
    id_1 text,
    id_2 text,
    picture_1 text,
    picture_2 text,
    picture_3 text,
    nat_1 text
);


CREATE TABLE "layer0".import_data_hb
(
    index bigint,
    id bigint,
    first_name text COLLATE pg_catalog."default",
    last_name text COLLATE pg_catalog."default",
    email text COLLATE pg_catalog."default",
    gender text COLLATE pg_catalog."default",
    ip_address text COLLATE pg_catalog."default",
    dob text COLLATE pg_catalog."default",
    country_code text COLLATE pg_catalog."default"
);
