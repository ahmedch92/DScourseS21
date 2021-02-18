-- PS3_Chaudhry.sql

--QUESTION NO> 5--

--Part(a): Read in the Florida insurance data CSV file
-- Create Table
CREATE TABLE datname (
    policyID,
    statecode,
    county,
    eq_site_limit,
    hu_site_limit,
    fl_site_limit,
    fr_site_limit,
    tiv_2011,
    tiv_2012,
    eq_site_deductible,
    hu_site_deductible,
    fl_site_deductible,
    fr_site_deductible,
    point_latitude,
    point_longitude,
    line,
    construction,
    point_granularity
);

--Import CSV
.mode CSV;
.import ./FL_insurance_sample.csv datname;

--Part(b): Print out the first 10 rows of the data set
SELECT * FROM datname LIMIT 10;

--Part(c): List which counties are in the sample (i.e. list unique values of the county variable)
SELECT DISTINCT country FROM datname;

--Part(d): Compute the average property appreciation from 2011 to 2012 (i.e. compute the mean of tiv_2012 - tiv_2011)
SELECT AVG(tiv_2012 - tiv_2011) FROM datname

--Part(e): Create a frequency table of the construction variable to see what fraction of buildings are made out of wood or some other material
SELECT counstruction, COUNT(construction) AS FREQ, (COUNT(construction) *100.0 / (SELECT COUNT(*) FROM datname)) AS PCT FROM datname  GROUP BY construction;
