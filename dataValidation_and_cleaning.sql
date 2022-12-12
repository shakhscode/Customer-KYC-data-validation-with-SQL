select * from kyc_data

--1) check the age, if less than 18 on date of login, then delete the entry
select * from kyc_data 
where last_login_date - dob < 18
-- all customers are 18+ on the day of login.


-- 2) Check whether a customer has two email ids or not, if found any then delete the first one one.

delete from kyc_data 
    where email_id in 
                     (select min(email_id) from kyc_data
                      group by customer_id
                      having count(email_id) > 1)

-- 3) Check the civil score, if a score is found greater then 900 or less than 200 then mark it as 'Abnormal'

select *, 
       case 
	   when civil_score > 900 then 'Abnormal'
	   when civil_score < 200 then 'Abnormal'
	   else 'Okay'
	   end as Civil_Score_Flag
	 from kyc_data
