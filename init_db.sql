CREATE SCHEMA layer0
    AUTHORIZATION docker;
COMMENT ON SCHEMA layer0
    IS 'Daily imports';
	
CREATE SCHEMA layer1
    AUTHORIZATION docker;
COMMENT ON SCHEMA layer1
    IS 'Cleaned data with time validity';	


