#!/usr/bin/env python

"""Tests for `musicdwh` package."""
#import sys
#sys.path.append('..')
import pytest
import pandas as pd
from pandas._testing import assert_frame_equal
import sqlalchemy as sqla

from musicdwh.musicdwh import import_hb, import_wwc, import_lov, ip_convert_country, import_game, upload_to_db


HB_FILE_PATH_INS = './data/hb/2021/04/28/hb.csv'
HB_FILE_PATH_UPD = './data/hb/2021/04/29/hb.csv'
WWC_FILE_PATH_INS = './data/wwc/2021/04/28/wwc.json'
WWC_FILE_PATH_UPD = './data/wwc/2021/04/29/wwc.json'
DATE_INS = '2021-04-28'
DATE_UPD = '2021-04-29'

def test_import_hb_dataframe_type():
    # tests, if returns type DataFrame
    df_import = import_hb(HB_FILE_PATH_INS) 
    assert "pandas.core.frame.DataFrame" in str(type(df_import))

def test_import_hb_dataframe_data():
    # tests, if returns correct data in DataFrame
    # intialise data of lists.
    data = {'id':[1, 2, 3, 4, 5],
            'first_name':['Maria', 'Douglas', 'Barbara', 'Jacqueline', 'Janet'],
            'last_name':['Russell', 'Cunningham', 'Rice', 'Cook', 'Jones'],
            'email':['mrussell0@soup.io', 'dcunningham1@sogou.com', 'brice2@bizjournals.com', 'jcook3@amazon.co.jp', 'jjones4@surveymonkey.com'],
            'gender':['Female', 'Male', 'Female', 'Female', 'Female'],
            'ip_address':['141.48.134.32', '75.5.5.45', '87.137.224.0', '249.125.240.30', '190.235.91.244'],
            'dob':['5/26/1976', '1/25/1980', '4/15/1979', '5/2/1963', '8/17/1968']
            }
    # Create DataFrame
    df = pd.DataFrame(data)

    df_import = import_hb(HB_FILE_PATH_INS) 
    assert_frame_equal(df_import, df)

def test_ip_convert_country():
    # tests lookup of country ID from IP_address
    # intialise data of lists.
    data = {'id':[1, 2, 3, 4, 5],
            'first_name':['Maria', 'Douglas', 'Barbara', 'Jacqueline', 'Janet'],
            'last_name':['Russell', 'Cunningham', 'Rice', 'Cook', 'Jones'],
            'email':['mrussell0@soup.io', 'dcunningham1@sogou.com', 'brice2@bizjournals.com', 'jcook3@amazon.co.jp', 'jjones4@surveymonkey.com'],
            'gender':['Female', 'Male', 'Female', 'Female', 'Female'],
            'ip_address':['141.48.134.32', '75.5.5.45', '87.137.224.0', '249.125.240.30', '190.235.91.244'],
            'dob':['5/26/1976', '1/25/1980', '4/15/1979', '5/2/1963', '8/17/1968'],
            'country_code':['DE', 'US', 'DE', 'Undefined', 'PE']
            }
    # Create DataFrame
    df = pd.DataFrame(data)

    df_import = import_hb(HB_FILE_PATH_INS) 
    # get country codes from IP address
    ip_code_series = ip_convert_country(df_import['ip_address'], 30, 100)
    # append country code to hb dataframe
    df_import['country_code']=ip_code_series    
    assert_frame_equal(df_import, df)

def test_import_game_hb():
    # test importing hb data into dataframe by calling parent function
    df_import = import_game ('hb', DATE_INS, './data')
    # intialise data of lists.
    data = {'id':[1, 2, 3, 4, 5],
            'first_name':['Maria', 'Douglas', 'Barbara', 'Jacqueline', 'Janet'],
            'last_name':['Russell', 'Cunningham', 'Rice', 'Cook', 'Jones'],
            'email':['mrussell0@soup.io', 'dcunningham1@sogou.com', 'brice2@bizjournals.com', 'jcook3@amazon.co.jp', 'jjones4@surveymonkey.com'],
            'gender':['Female', 'Male', 'Female', 'Female', 'Female'],
            'ip_address':['141.48.134.32', '75.5.5.45', '87.137.224.0', '249.125.240.30', '190.235.91.244'],
            'dob':['5/26/1976', '1/25/1980', '4/15/1979', '5/2/1963', '8/17/1968']
            }
    # Create DataFrame
    df = pd.DataFrame(data)    
    assert_frame_equal(df_import, df)

# def test_import_hb_update():      
#     assert import_hb(HB_FILE_PATH_UPD) == [expected_output] "This will not be printed if assertion passes"

# def test_import_wwc_new():
#     assert import_wwc(WWC_FILE_PATH_INS) == [expected_output] "This will not be printed if assertion passes"

# def test_import_wwc_update():
#     assert import_wwc(WWC_FILE_PATH_UPD) == [expected_output] "This will not be printed if assertion passes"


def test_import_lov():
    # test importing LOV data into dataframe
    df_import = import_lov('./data/LOVs/LOV_gender.csv')
    data = {'gender':['female', 'male', 'unspecified', 'other']  
            } 
    # Create DataFrame
    df = pd.DataFrame(data)    
    assert_frame_equal(df_import, df)

# def test_ip_convert_country():



# def test_import_game_wwc():



# def test_upload_to_db():    