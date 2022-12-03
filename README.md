
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

### 1. Problem Statement

Following is a snapshot of the relational data send to a database from a user website. This is the KYC data of the customers of a online credit agency.

Most of the fields are directly entered by the customers during login and some other fields are system generated. Before analyzing the data it is important to make sure that data is correct.

![dataset](https://user-images.githubusercontent.com/76909183/205445336-9a422aad-7aef-4cf2-a64b-dd01c90bb969.jpg)


- Here, age is automatically calculated by the system when the user enters date of birth.
- Civil score is determined based on the history of financial activities avaiable on the KYC documemt.

Validate the data to make sure that -

- age is not less than 18, on the date of login.

- There are no same email address for different customers.

- Length of contact number should be 10 only.

- Civil score is not more than 900.

Check the above criteria and if any wrong data is found then remove it. Also create some triggers for validating the future data.

### 2. Manual Data Validation and Cleaning

First check the criteria manually and if any thing is found wrong then then remove it.


### 3. Auto Validation by Triggers

