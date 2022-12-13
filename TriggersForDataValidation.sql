-- 1) create a trigger that stops wrong entry of date of birth 

-- create the trigger
drop trigger if exists validate_dob on kyc_data;

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


-- Now test it by inserting some examples
--case 1
insert into kyc_data(dob)
values ('2022-12-14')

--case 2
insert into kyc_data(dob)
values ('2012-12-11')


--case 3
insert into kyc_data(dob)
values ('2002-8-19')

select * from kyc_data

--2) Creating a trigger to stop the entry of existing email address.
drop trigger if exists stop_duplicate_email on kyc_data;

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
     --check the email if it already exist for the old user
	 if new.email_id  = old.email_id 
	 then
	 raise notice 'Duplicate email id is not allowed!';
	 return null;
	 
	 --check for all existing emails for a completely new user
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

-- Test case 1: when someone wants to update the email
update kyc_data 
set email_id = 'sbsr1234@gmail.com'
where customer_id = 13

--check the updates manually
select * from kyc_data
order by customer_id


--test case 2: On new insert
insert into kyc_data(email_id)
values ('sbsr1234@gmail.com')