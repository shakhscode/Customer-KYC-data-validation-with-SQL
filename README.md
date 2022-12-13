
# Customer-KYC data validation with SQL
### Aim of the project
- [Validation of data before analysis.](#1-problem-statement-1)
- Manual validation of data quality and data cleaning.
- Auto validation by creating PL-SQL triggers.

### Used tools
- SQL
- Database: PostgreSQL
- PL-SQL to create triggers.
 ***
## Detailed Description

### Contents of the Repository 
#### [1. Problem Statement](#1-problem-statement-1)
#### [2. Manual Data Validation and Cleaning](#2-manual-data-validation-and-cleaning-1)
#### [3. Auto Validation by Triggers](#3-auto-validation-by-triggers-1)
***

### 1. Problem Statement

Following is a snapshot of the relational data ingested to a  database. This is the KYC data of the customers of a online credit agency.

Most of the fields are directly entered by the customers during login and some other fields are system generated. Before analyzing the data it is important to make sure that data is correct.

![dataSnap](https://user-images.githubusercontent.com/76909183/207410298-1835325a-9ecc-4b87-aa1e-26cac41a72ca.jpg)



Validate the data to make sure that -

- age was not less than 18, on the date of register.

- There is no same email address for different customers.

- Civil score should not more than 900 and less than 200, if there is one such record then flag it.

Check the above criteria and if anything found wrong then remove it or flag it accordingly. Also create some triggers for validating the future data.

### 2. Manual Data Validation and Cleaning

Let's  check each criteria manually and if any thing is found wrong then remove the entry or flag it as wrong.

[Check the sql file](/dataValidation_and_cleaning.sql)

### 3. Auto Validation by Triggers

#### i) Create a trigger to stop the entry with a wrong age
- i.e. when the user enters date of birth it should not be a future date, 
- And age on the sign up date should be minimum 18.

Trigger using PL-SQL procedure
```
create trigger validate_dob
before insert
on kyc_data
for each row 
execute procedure check_dob();

--Create the function to define the trigger action
create or replace function check_dob()
returns trigger 
as 
$$
declare 
age_ numeric;
begin 
    --get the age
	SELECT extract(year FROM age(new.dob)) into age_ FROM kyc_data;
	
   -- define the trigger action
   if new.dob > current_date 
   then
   raise notice 'Date of birth can not be a future date.';
   --if this happens then don't insert the value, so return null
   return null;
   
   elseif  age_ < 18
   then
   raise notice 'Minimum age must be 18';
   return null;
   
   end if;

   --if everything is okay then add the new entry 
   return new;
   
end;
$$
LANGUAGE plpgsql;
```

Test Case 1: Enter a future date
```
insert into kyc_data(dob)
values ('2022-12-14')    --tested on 13th Dec, 2022
```
Output:
```
NOTICE:  Date of birth can not be a future date.
INSERT 0 0

Query returned successfully in 346 msec.
```
Test case 2: Enter a date for which age is less than 18
```
insert into kyc_data(dob)
values ('2012-12-11')
```
Output:
```
NOTICE:  Minimum age must be 18
INSERT 0 0

Query returned successfully in 733 msec.
```
ii) Creating a trigger to stop the entry of existing email address.
- When someone wants to update email id or when a new user registers, the provided email id should be unique i.e. it can't be a duplicae of the existing one.
```
--create the trigger
create trigger stop_duplicate_email
before insert or update
on kyc_data
for each row 
execute procedure isDuplicate();

--define the trigger action function.
create or replace function isDuplicate()
returns trigger
as
$$
declare

begin
     --check the email whether it already exist for a old user or not
	 if new.email_id  = old.email_id 
	 then
	 raise notice 'Duplicate email id is not allowed!';
	 return null;
	 
	 --check for all existing emails when a new user registers
	 elseif exists (
      SELECT 1
      from kyc_data 
      where email_id = new.email_id
      )
	 then 
	 raise notice 'Email already exists!';
	 return null;
	 
	 end if;
	 --otherwise
	 return new;
end;
$$
language plpgsql;

```

Test case 1: when an existing user wants to update his/her email
```
update kyc_data 
set email_id = 'sbsr1234@gmail.com'
where customer_id = 13
```
Output:
```
NOTICE:  Duplicate email id is not allowed!
UPDATE 0

Query returned successfully in 653 msec.
```
Test case 2: When a new entry is inserted
```
insert into kyc_data(email_id)
values ('sbsr1234@gmail.com')
```

Output:
```
NOTICE:  Email already exists!
INSERT 0 0

Query returned successfully in 350 msec.
```

### Conclusion
Here only 2 or 3 usecases are shown, how we can validate data using SQL and how PL-SQL triggers can be useful for automatic data validation when data is ingested to a database or data warehouse. Data validation before data analysis is very important and validation criteria depend on the domain of the data.
