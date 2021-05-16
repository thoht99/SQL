-- MSSSQL SQL --
-- ======================================================================================================= --
/*Linked to other scripts
Originally, we can call a SQL script from another script but we cannot directly use outputs generated from  other SQL script. Linking different scripts should create
temporary tables or views which can save generated outputs
*/

/* ============================ User-deifned value/ Declare variable to assign value
To use declared variable(s), we need to run Declare operation and related opertions in a same time.

*/
-- Declare value --
DECLARE @input1 int;
set @input1 = 10
Select  *  from  StockDB_Main.price_hist.stock where  stockID  = @input1;

-- Declare a set of valeus from list --

Declare @tbl_var  table(ID_col int)
insert into @tbl_var values(1),(2),(3),(4)
select * from @tbl_var;

-- Declare a set of values from select -- 
Declare @dcr_table  table (ID_col int);
insert into  @dcr_table (ID_col)
 select stockid from StockDB_Main.price_hist.stock;
select * from  @dcr_table;


/*User-defined function
- An uer-definied function is a ground codes which we stored to re-use later without re-writing
*/
-- Return a scalar values --
Use StockDB_Main;

Create function price_hist.find_stock(@inputid int)
Returns varchar(250)
AS
Begin
    Declare @returned_value varchar(250)
    Select @returned_value = Scode from  StockDB_Main.price_hist.stock where stockID = @inputid;
    Return @returned_value;
end;

-- Execute created function: --
select price_hist.find_stock(1) as returned_Scode;

-- Return a table-value --
Use StockDB_Main;

Create function price_hist.find_stock_tbl(@inputid int)
Returns table
AS
RETURN(
    Select * from  StockDB_Main.price_hist.stock where stockID = @inputid
);

-- Execute created function: --
SELECT * FROM price_hist.find_stock_tbl (10)

/* Note:
-- Modify a function --

-- Drop a function --
Drop function price_hist.find_stock;
*/


/* ============================ Procedure
A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again.
So if you have an SQL query that you write over and over again, save it as a stored procedure, and then just call it to execute it.
You can also pass parameters to a stored procedure, so that the stored procedure can act based on the parameter value(s) that is passed.

GO statement determines the end of the batch in SQL Server thus @TestVariable lifecycle ends with GO statement line. 
The variable which is declared above the GO statement line can not be accessed under the GO statement. 
However, we can overcome this issue by carrying the variable value with the help of the temporary tables:
*/

-- Create a procedure --
CREATE PROCEDURE proc1 @id int AS
 select *  from  StockDB_Main.price_hist.stock where  StockID = @id
Go 
;
-- execure a procedure --
Exec proc1 @id = 11;


/*============================ Control of flow (T_transaction)
Operations used to perform special buit-in functions for operting users'core syntax. In MSSQL, control of flow include:
- Begin - end
- Break
- Continue
- If-else
- Goto
- Return
- Try - Catch
- Waitfor
- While-Loop

 */

/* ===================== If - ELSE IF - ELSE Statement
If-else statement applied to a completed query but not an element like Case-When does. 
When if-else statment is standalone, it is not stored in the data server like UDF or Procedures. However, we need to run both
Delcared variable and if-else statement simultaneously to have output.
- If-esle statement are normllary combine with other control-flow operation (e.g. while-loop) or a set of other codes.
*/ 
-- if-else statement --
DECLARE @StudentMarks INT= 91;
IF @StudentMarks >= 80
    PRINT 'Passed, Congratulations!!';
    ELSE 
    PRINT 'Failed, Try again ';

 -- if-else if- else statement --
DECLARE @StudentMarks INT= 70;
IF @StudentMarks > 80
    PRINT 'Passed, Congratulations!!';
ELSE IF @StudentMarks = 80
    PRINT 'Failed, Try again ';
ELSE IF @StudentMarks < 80
    PRINT 'Failed, Try again  below';


/* ===================== WHILE_LOOP Statemtnt
A statement will re-run forerver unil it meets selected condition
Note: keep in mind smaple structure:
DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= number)
BEGIN
    [A SQL statement]

    SET @Counter  = @Counter  + 1
END

*/
DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 10)
BEGIN
    PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
    SET @Counter  = @Counter  + 1
END

/*Exercise: Using if-else and while-loop statements to find data:

step 1: Count number of scode in each host and use "ROW_NUMBER() OVER(ORDER BY YourColumn)" to get index of each row
Step 2: create a while-loop to utilise step 1's output as input for if-else statement
Step 3: Create if-else statements with conditions:
- number of stocks < 500:  print 'less than 500' 
- 500 <= number of stocks 500 <800 : '500 to 800'
- 800 <= number of stocks 500: 'from 800'
 */
create view  stock_count as 
select hostname, 
count(scode)  as Stock_count,
ROW_NUMBER() OVER(ORDER BY hostname) as row_index
from StockDB_Main.price_hist.host tbl1 right join StockDB_Main.price_hist.stock tbl2 
on tbl1.HostID = tbl2.HostID
group by  hostname
;

select * from stock_count;

Declare @Counter int
SET @Counter=1
WHILE ( @Counter <= 3) -- 3 is number of hosts --
BEGIN
    declare @stock_cnt int
    set @stock_cnt = (select stock_count from  stock_count where  row_index = @Counter)

    declare @hostname varchar(5)
    set @hostname = (select hostname from  stock_count where  row_index = @Counter)

    if @stock_cnt < 500
        PRINT @hostname + ' less than 500';
    else if  500 <= @stock_cnt and @stock_cnt < 800
        PRINT @hostname + ' 500 to 800';   
    else if 800 <= @stock_cnt 
        PRINT @hostname + ' from 800';
        
    SET @Counter  = @Counter  + 1
END


/* ===================== Break and Continue statement
- If a BREAK statement is executed within a WHILE-loop, 
then it causes the control to go out of the while loop and start executing the first statement immediately after the while loop.

- If a CONTINUE statement is executed within a WHILE-loop, 
then it skips executing the statements following it and transfers control to the beginning of while loop to start the execution of the next iteration.
*/

DECLARE @Counter INT
SET @Counter=1
WHILE ( @Counter <= 20)
BEGIN
    SET @Counter  = @Counter  + 1
    print @Counter
    if @Counter <= 10
        CONTINUE
    ELSE
        break
END

/* ===================== Try-catch statement

By some reasons, we can encounter error codes. So, we have two option: 
- fix the error, or
- ignore the error

Using try-catch is a method to ignore the error code by doing something else or keep running other code

*/

BEGIN TRY  
     select * from sometbale;
END TRY  
BEGIN CATCH  
     select * from StockDB_Main.price_hist.host; 
END CATCH;  


/*Homework*/
-- Find information for required report by using procedure, user-definied function, etc. learnt in lesson 4--
-- 1) Stock Code, Started Date, Industry, Company Name, Days from starting date, Current matched price --
-- 2) Ranking stock in the host from startint date by conditions --
-- 3) Cost and benefit of trading transaction and owning stock --


