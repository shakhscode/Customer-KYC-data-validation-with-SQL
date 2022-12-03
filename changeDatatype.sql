--Check the table
select * from kyc_data

--Necessary data type change/correction before inserting values from csv file

--Change the column datatype for 'mobile_no' into varchar()
alter table kyc_data
alter column mobile_no type varchar(10) using mobile_no::varchar(10)

--Now after importing the values check again

select * from kyc_data
where age > 30

--correct data types if still there is any inappropriate datatype
alter table kyc_data
rename column last_login_date_time 

-- change dob to date (As it is character varying now)
ALTER TABLE kyc_data
ALTER COLUMN dob TYPE DATE 
using to_date(dob, 'DD-MM-YYYY');

-- change last_login_date to date data type.(As it is character varying now)
ALTER TABLE kyc_data
ALTER COLUMN last_login_date_time TYPE DATE 
using to_date(last_login_date_time, 'DD-MM-YYYY');


-- check now
select * from kyc_data