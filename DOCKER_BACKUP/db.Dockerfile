FROM postgres:13

COPY ./sql_scripts/01_L0_create_tables.sql /docker-entrypoint-initdb.d/
COPY ./sql_scripts/02_L0_create_views.sql /docker-entrypoint-initdb.d/
COPY ./sql_scripts/03_L1_create_tables.sql /docker-entrypoint-initdb.d/