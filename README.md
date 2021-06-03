# music data warehouse

Data pipeline and datawarehouse for music games.

The aim of this project is to create a small Datawarehouse, populated with data about users of two games. The data comes from two systems and analysis will be done on both systems at once.

The solution is based on Python with a database running on PostgreSQL. Database has two layers (schemas), one for import of data files and one with transformed data available for analysis. It is possible to load data from this layer to end-user systems for analysis. It is also possible to do analysis in SQL and build a datamart level on top of the data directly in the database.

Virtual environments for both systems are created using Docker and are managed by Docker-compose.

### **Main files:**
#### **Python files:**
- `musicdwh/musicdwh.py`

Python script opening extract files from a given date. Games have two sources, "hb" in .csv and "wwc" in .json. They come in once a day and are exported into folder structure based on date.
- `hb` data contain IP address, but miss country code. To obtain country code we utilize ipapi, which unfortunately in the free tier has limits of queries. Therefore the data is passed in chunks and there is waiting time between chunks.
This makes the code run slowly. There are other IP converters available, all have limits in free tier. Paid tier would be without these limitations.
- `wwc` data comes in .json format, one cell can contain lists of different values. The lists are parsed into new columns of dataframe upon load.
- two lists of values (LOVs) have been added to the load to enable saving repetitive data in separate tables.
- data in the database is updated with new values, right now there is no historization feature. This can be added in the future.

#### **SQL scripts working with the data:**
- `sql_scripts/startup_sql_scripts` : scripts setting up the database, tables and views
- `sql_scripts/04_L0_L1_load.sql` : ETL script processing data from layer0 to layer1, creating dependencies
- `sql_scripts/05_L0_L1_update.sql` : ETL script updating any changes in existing records

#### **reports on the data**
- questions.sql 
    - report on gender composition of the users
    - report on youngest and olders user per country


--------

## Issues / TODO
- long run time due to lookup of IP addresses
- more tests need to be added


## Features
--------

* create a database schema
* clean data
* create data pipeline
* import user accounts
* update any modified records

## Prerequisites
--------
* install docker
* install docker-compose
* install git
* clone repository:
```
git clone https://github.com/dagmar-urbancova/musicdwh
```


## Getting Started
* start service:
```
docker-compose up --build

```
* set env var
```
export DATA_DATE='2021-04-28'
```

In case Python does not connect to the database, run .py manually.
```
python musicdwh/musicdwh.py
```

To run `another day's data`, modify env var DATA_DATE to different date, e.g.:
```
export DATA_DATE='2021-04-29'
```
and run the Python script
```
python musicdwh/musicdwh.py
```

## Credits
-------

## License
* Free software: MIT license
