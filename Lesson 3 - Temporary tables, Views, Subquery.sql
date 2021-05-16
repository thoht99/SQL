-- PostgreSQL --
-- ======================================================================================================= --

/* Create a temporary table*/
-- Create temporary table for all columns --
Create table method1_temptb1 as Select * 
from  public.region
where regname like  '%Asia%'
;

/*Create temporary table and assign created table to other schema*/
Create table instructor.method1_temptb1 as Select * 
from  public.region
where regname like  '%Asia%'
;


-- Create temporary table for selected columns --

Create table method1_temptb1_col (temp_id, temp_name) as
Select regionid, regname
from  public.region
where regname like  '%Asia%'
;

select * from method1_temptb1_col;

-- Create temporaty table from multiple table

Create table temp_mtable AS
select tbl1.regname, tbl2.cntname
from public.region tbl1 right join public.country tbl2
on  tbl1.regionid = tbl2.regionid
where tbl2.cntcode like '%A';

select * from temp_mtable;

/* ============================ Uses of temporarty table
As stated, temporary is used for quick access to data without the needs to re-write complicated query again. It also saves time and resources for querying data
*/
/*Excersice: Apply the use of temporary table to create a dataset having Country, Year, PPnumber, and PPtype (Global, Male, Female) in different columns
 
select * from public.trans;
drop table if EXISTS trans_temp1;
drop table if EXISTS trans_temp2;
drop table if EXISTS trans_temp3;

create table trans_temp1 AS
    select CountryID, yearID,PPnumber,PPtypeID
    from public.trans
    where PPtypeID = 1;

create table trans_temp2 AS
    select CountryID, yearID,PPnumber,PPtypeID
    from public.trans
    where PPtypeID = 2;

create table trans_temp3 AS
    select CountryID, yearID,PPnumber,PPtypeID
    from public.trans
    where PPtypeID = 3 ;

select tbl1.CountryID, 
tbl1.yearID,
tbl1.PPnumber as GLobal_PPnumber,
tbl2.PPnumber as Female_PPnumber,
tbl3.PPnumber as Male_PPnumber
from trans_temp1 tbl1 left join trans_temp2 TBL2
    on tbl1.CountryID = tbl2.CountryID and  tbl1.yearID = tbl2.yearID
left join trans_temp3 TBL3
    on tbl1.CountryID = tbl3.CountryID and  tbl1.yearID = tbl3.yearID
;
 */

/*Thinking about a simpler solution? we can use pivot function to complete this task 
Option 1: In PostgreSQL: crosstab function
CREATE EXTENSION IF NOT EXISTS tablefunc; 
select * 
from crosstab(select CountryID, yearID,PPnumber,PPtypeID from public.trans order by 1,2)
as pivot_table(CountryID int,yearID int, 1 int, 2 int, 3 int)
;
Otption 2: Using basic syntax with case when

select CountryID, yearID,
CASE when PPtypeID = 1 then PPnumber end as Global_PPnumber, 
CASE when PPtypeID = 2 then PPnumber end as Female_PPnumber, 
CASE when PPtypeID = 3 then PPnumber end as Male_PPnumber
from public.trans 
;
*/


/* ============================ Create views */
-- Create a single view --

drop view if EXISTS tempview1;
Create view  tempview1 as
    Select regionid, regname
    from  public.region
    where regname like  '%Asia%'
;

select * from tempview1;

-- Create a multiple views --
drop view if EXISTS tempview1;
drop view if EXISTS tempview2;

Create view  tempview1  as
    Select regionid, regname
    from  public.region
    where regname like  '%Asia%',
view tempview2 AS
     Select regionid, regname
    from  public.region  
    where regname like  '%Ameica'
    ;
select * from  tempview1 union select * from  tempview2;

/* ============================ Using subquery (a query within other query)
- Nested query within where statement of other queries
- It can be used as an alternative method for joining table

*/
select * from public.trans where countryid  in (
    select countryid from public.country 
        where  cntname like '%Euro%'
    ); -- Total execution time: 00:00:00.335--

select * 
from public.trans tbl1 left join  public.country tbl2 
ON tbl1.countryID = tbl2.countryID
where tbl2.cntname like '%Euro%'
; -- Total execution time: 00:00:00.392 -- 


/*Excercise: Using View and subquery functions to generate a dataset having all below condition:
- Include Country Name, RegionName, Popuplation Type, GPD, Life Expectationcy and 
- Selected countries having minimum average GDP is 50,000
*/

Create View global_info as (
    select 

)


-- MSSSQL SQL --
-- ======================================================================================================= --

select * from  Classroom.dbo.#method1_temptb1;

/* 
Temporary tables, Views and Sub-queries are also available in MSSQL Server. ALso most syntaxes are same except the syntax to create "Temporary table"
In MSSQL Server:
- Temporary table: Select [columns] into #temp_table from table ;
- Views: Create VIEW View_table  as Select [columns] from [table];
- Subquery: Select [columns] from [table] where [key-column] in (select key-column from [other table] );
*/

/* Create a temporary table */
-- Method 1 with  local temporary table --
-- Create temporary table from 1 single table --
Select * 
into #method1_temptb1
from  StockDB_Main.price_hist.stock 
where scode like  'H%'
;

/*!!!!!!!! Select data from a table in a schema and then asssign created tables in another schema !!!!!!!!!*/
Select * 
into Classroom.dbo.#method1_temptb1
from  StockDB_Main.price_hist.stock 
where scode like  'H%'
;


-- get data --
select * from #method1_temptb1;

-- Create temporary table from 2 tables --
select tbl1.stockid, tbl1.Scode, tbl2.HostName
into #method1_temptb2
from  StockDB_Main.price_hist.stock tbl1
left join StockDB_Main.price_hist.host tbl2
on tbl1.HostID = tbl2.HostID
where scode like  'H%';

select * from #method1_temptb2;

-- Method 2 with global temporary table --
-- Create temporary table from 1 single table --
Select * 
into ##method2_temptb1
from  StockDB_Main.price_hist.stock 
where scode like  'H%'
;
-- get data --
select * from #method2_temptb1;

-- Create temporary table from 2 tables --
select tbl1.stockid, tbl1.Scode, tbl2.HostName
into ##method2_temptb2
from  StockDB_Main.price_hist.stock tbl1
left join StockDB_Main.price_hist.host tbl2
on tbl1.HostID = tbl2.HostID
where scode like  'H%';

select * from #method2_temptb2;


/* Create a View */
select * from StockDB_Main.price_hist.reference;  

Create VIEW View1  as 
select * 
from StockDB_Main.price_hist.reference
where AvgPrice > RefPrice
; 

Select * from StockDB_Main.dbo.View1 where AvgPrice <10 ;


/*Working with subquery*/
Create View StockCount as 
select StockID, count(StockID) as appear_count
from StockDB_Main.price_hist.trans
group by StockID; 

Select * from dbo.StockCount;

select * from StockDB_Main.price_hist.trans
where Stockid in (
    select stockId 
    from dbo.StockCount 
    where appear_count < 100 
    );  


-- ======================================================================================================= --
-- Homework--
-- MSSQL --
-- Working with 2 database StockDB_Main, StockDB_Add in  MSSQL Server--

select * from StockDB_Main.price_hist.trans;
select * from StockDB_Main.price_hist.deal;
select * from StockDB_Add.order_hist.buyorder;

-- Part I --
/*Create a summary dataset  which combine information from different schemas and table*/

-- Create a viewer for main Transaction table in StockDB_Main. The view should have reable text/ strings rather than ID --

Create View Main_data as select 
tbl7.HostName, 
tbl2.scode, 
tbl3.MatchedValue, 
tbl3.MatchedVol, 
tbl4.AvgPrice,  
tbl4.[Difference],
tbl4.RefPrice,
tbl5.CeilPrice,
tbl5.ClosePrice,
tbl5.FloorPrice,
tbl5.High,
tbl5.Low,
tbl5.OpenPrice,
tbl6.DealValue,
tbl6.DealVol,
tbl1.Datadate
from StockDB_Main.price_hist.trans tbl1 
left join StockDB_Main.price_hist.stock tbl2
    on tbl1.StockID = tbl2.StockID
left join StockDB_Main.price_hist.match tbl3
    on tbl1.MatchedID = tbl3.MatchedID
left join StockDB_Main.price_hist.reference tbl4
    on tbl1.RefID = tbl4.RefID
left join StockDB_Main.price_hist.summary tbl5
    on tbl1.SummaryID = tbl5.SummaryID
left join  StockDB_Main.price_hist.Deal tbl6
    on tbl1.DealID = tbl6.DealID
left join StockDB_Main.price_hist.host tbl7    
    on tbl2.HostID = tbl7.HostID
;

-- Create viwer for Odrder table. The view should have reable text/ strings rather than ID  --
Create View Order_tbl as select  
tbl2.BuyOrderCount, 
tbl2.BuyOrderVol, 
tbl2.BuySurplus, 
tbl2.AvgOneBuyOrder,
tbl3.SellOrder,
tbl3.SellOrderVol,
tbl3.SellSurplus,
tbl3.AvgOneSellOrder, 
tbl4.Price,
tbl4.[Difference],
tbl1.Datadate,
tbl1.Scode
from 
StockDB_Add.order_hist.trans_order tbl1
left join StockDB_Add.order_hist.buyorder tbl2
    on tbl1.BuyID = tbl2.BuyID
left join StockDB_Add.order_hist.sellorder tbl3
    on tbl1.SellID = tbl3.SellID
left join StockDB_Add.order_hist.Reference tbl4
    on tbl1.RefID = tbl4.RefID
 ;


-- Create viwer for Foreign Transaction table. The view should have reable text/ strings rather than ID  --
Create View Freign_table as 
select
tbl2.FbuyVol,
tbl2.FbuyValue,
tbl3.FSellVol,
tbl3.FSellValue,
tbl4.FRawVol,
tbl4.RemainSlot,
tbl4.Owning,
tbl1.Datadate,
tbl1.Scode
from 
StockDB_Add.trans_frg.ftrans tbl1
left join StockDB_Add.trans_frg.fbuy tbl2
    on tbl1.FbuyID = tbl2.FbuyID
left join StockDB_Add.trans_frg.fsell tbl3
    on tbl1.FsellID = tbl3.FsellID
left join StockDB_Add.trans_frg.reference tbl4
    on tbl1.FrefID = tbl4.FrefID
;


-- Combine all view --
Create View Combined_Data as 
Select * 
from 
Main_data tbl1
left join Order_tbl tbl2 on  tbl1.scode = tbl2.scode and tbl1.Datadate = TBL2.Datadate
Left join Freign_table tbl3 on tbl1.scode = tbl3.scode and tbl1.Datadate = tbl3.Datadate
;

/* 1) Create a dataset including following information 
- Calculate min, max, average mathced price of each stock and in each host for every quaters during year
'''
*/  

-- step 1: Create a view or a temp table from original dataset--

create view Summary1 as select tbl1.hostname,
 tbl2.scode,
concat(Datepart(yyyy,Datadate),'-Q',DATEPART(q, Datadate)) as Year_Quarter,
tbl4.MatchedValue
from StockDB_Main.price_hist.host tbl1 
left JOIN StockDB_Main.price_hist.stock tbl2
    on tbl1.HostID = tbl2.HostID
left join StockDB_Main.price_hist.trans tbl3
    on tbl2.StockID = tbl3.StockID
left join  StockDB_Main.price_hist.match tbl4
    on tbl3.MatchedID = tbl4.MatchedID
;

-- step 2: required table -- 
select
hostname, 
scode, 
Year_Quarter, 
min(MatchedValue) as Min_price_quarter,
max(MatchedValue) as Max_price_quarter,
Avg(MatchedValue) as Avg_price_quarter
from Summary1
group by HostName, Scode,Year_Quarter
order by HostName, Scode, Year_Quarter;

/*2) Based on above created table, add more details by:
- Re-order data by  HOSE,HASTC,VN30, and UPCOM
- 
*/

select
hostname, 
scode, 
Year_Quarter, 
min(MatchedValue) as Min_price_quarter,
max(MatchedValue) as Max_price_quarter,
Avg(MatchedValue) as Avg_price_quarter
from Summary1
group by HostName, Scode,Year_Quarter
Order by case when hostname = 'HOSE' then 1
                when hostname = 'HASTC' then 2
                when hostname = 'VN30' then 3
                else 4 end asc
;

-- Part II --