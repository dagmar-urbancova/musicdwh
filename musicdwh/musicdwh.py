"""Main module."""


import os
import sys
import time
from datetime import datetime
import pandas as pd

import ipapi
import sqlalchemy as sqla


try:
    DATA_DATE = os.environ['DATA_DATE']
    print('Using data from {}'.format(DATA_DATE))
except:
    print('Envvar DATA_DATE not set.')
    sys.exit(1)

try:
    POSTGRES_PASSWORD = os.environ['POSTGRES_PASSWORD']
    print('Using password from POSTGRES_PASSWORD')
except:
    print('Envvar POSTGRES_PASSWORD not set.')
    sys.exit(1)

try:
    POSTGRES_USER = os.environ['POSTGRES_USER']
    print('Using password from POSTGRES_USER')
except:
    print('Envvar POSTGRES_USER not set.')
    sys.exit(1)


try:
    POSTGRES_DB = os.environ['POSTGRES_DB']
    print('Using password from POSTGRES_DB')
except:
    print('Envvar POSTGRES_DB not set.')
    sys.exit(1)


# define database connection
db_name = POSTGRES_DB
db_user = POSTGRES_USER
db_pass = POSTGRES_PASSWORD
db_host = 'database'
db_port = '5432'
DB_CONNECTION = 'postgresql://{}:{}@{}:{}/{}'.format(
    db_user, db_pass, db_host, db_port, db_name
)

# define constants
DATA_PATH = './data'
DB_LAYER_0 = 'layer0'
DB_LAYER_1 = 'layer1'
RETRY_COUNT = 5
DELAY_TIME = 5


def import_hb(file_path):
    # import csv file - hb
    # import data to DataFrame
    print('Reading hb data from {}'.format(file_path))
    try:
        data_hb2 = pd.read_csv(file_path)
        return(data_hb2)
    except:
        print('hb data not accessible')

def import_wwc(file_path):
    # import json file - wwc
    # import data to DataFrame
    print('Reading wwc data from {}'.format(file_path))    
    try:
        data_wwc_i = pd.read_json(file_path, lines=True)
        # split data into dataframe columns
        dfs = []
        for c in data_wwc_i:
            tmp = pd.DataFrame(list(data_wwc_i[c]))
            tmp.columns = [c + '_%s' % str(i+1) for i in range(tmp.shape[1])]
            dfs.append(tmp)

        data_wwc = pd.concat(dfs, 1)
        return(data_wwc)
    except:
        print('wwc data not accessible')

def import_lov(file_path):
    # import csv file - LOV
    # import data to DataFrame
    print('Reading LOV data from {}'.format(file_path))    
    try:
        data = pd.read_csv(file_path)
        return(data)
    except:
        print('data not accessible')

def ip_convert_country  (
                        ip_address_series, 
                        batch, 
                        sleep_time = 60):
    # get country code from IP address, ipapi limit - 1,000 requests daily , 45/minute
    # using IP-API
    # series to list
    size_counter = 0
    country_code = ''
    ip_list = ip_address_series.to_list()
    code_list = []
    # for each element in list get IP
    for address in ip_list:
    # if we reached free limit of 45 items per minute, sleep
        if size_counter >= batch:
            size_counter = 0
            #print('Sleeping')
            time.sleep(sleep_time)
        else:
            pass

        try:
            country_code = ipapi.location(address, output='country_code')
        except:
            country_code = 'NaN'
        code_list.append(country_code)
        size_counter += 1
    code_series = pd.Series(code_list)
    return(code_series)


def import_game (
                game_id, 
                export_date, 
                data_path
                ):
    try:
        export_date_d=datetime.strptime(export_date,'%Y-%m-%d')
    except:
        print('DATA_DATE is not in the right format. Please set in format YYYY-MM-DD.')
        sys.exit(1)
    date_y = export_date_d.strftime("%Y")
    date_m = export_date_d.strftime("%m")
    date_d = export_date_d.strftime("%d")
    #data_path = '/musicdwh/musicdwh/data/'
    wwc_path = '/wwc/{}/{}/{}/wwc.json'.format(date_y, date_m, date_d)
    hb_path = '/hb/{}/{}/{}/hb.csv'.format(date_y, date_m, date_d)
    # expecting date in format 'YYYY-MM-DD'
    if game_id == 'wwc':
        imported_data = import_wwc(data_path + wwc_path)
        print('import wwc from: ' + data_path + wwc_path)
    elif game_id == 'hb':
        imported_data = import_hb(data_path + hb_path)
        print('import hb from: ' + data_path + hb_path)
    else:
        print ('Please choose a game to import: wwc / hb')
    return(imported_data)

def connect_to_db(db_con, retry_count, delay):
    
    print('Connecting to {}'.format(db_con))
    engine = sqla.create_engine(db_con, isolation_level="AUTOCOMMIT")
    
    return engine

def upload_to_db(
                df, 
                db_table, 
                engine, 
                db_schema
                ):
    sql = sqla.text("TRUNCATE TABLE {}.{}".format(db_schema, db_table))
    try:
        engine.execute(sql)
    except:
        print("{}.{} - Table does not exist.".format(db_schema, db_table))
    df.to_sql(db_table, engine, schema=db_schema, if_exists='append')


# main script
if __name__ == '__main__':
    print("================================= starting load =================================")
    # create database connection
    engine = connect_to_db(DB_CONNECTION, RETRY_COUNT, DELAY_TIME)
    # populate LOVs
    LOV_PATH = '{}/LOVs'.format(DATA_PATH)
    #LOV_gender
    gender_df = import_lov('{}/LOV_gender.csv'.format(LOV_PATH))
    upload_to_db (gender_df, 'lov_gender', engine, DB_LAYER_0)
    #LOV_title
    title_df = import_lov('{}/LOV_title.csv'.format(LOV_PATH))
    upload_to_db (title_df, 'lov_title', engine, DB_LAYER_0)


    # load wwc data
    data_wwc = import_game ('wwc', DATA_DATE, DATA_PATH)


    # load hb data
    data_hb = import_game ('hb', DATA_DATE, DATA_PATH)
    # get country codes from IP address
    ip_code_series = ip_convert_country(data_hb['ip_address'], 30, 100)
    # append country code to hb dataframe
    data_hb['country_code']=ip_code_series


    # upload daily data to database, schema L0
    upload_to_db (data_hb, 'import_data_hb', engine, DB_LAYER_0)
    upload_to_db (data_wwc, 'import_data_wwc', engine, DB_LAYER_0)

    # run load to Layer1
    with open('./sql_scripts/04_L0_L1_load.sql', 'r') as sql_file:
        script_string = sql_file.read()
        print('Running insert script L0_L1_load')
        db_script = engine.execute(script_string)
    # run updates on existing records
    with open('./sql_scripts/05_L0_L1_update.sql', 'r') as sql_file:
        script_string = sql_file.read()
        print('Running update script L0_L1_update')
        db_script = engine.execute(script_string)        

