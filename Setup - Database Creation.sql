-- POSTGRE SQL --
--======================================================================================================= --

-- Create schema dbo --
Create Schema dbo;

-- Delete all created table --

DROP TABLE IF EXISTS dbo.stock ;
DROP TABLE IF EXISTS dbo.host ;
DROP TABLE IF EXISTS dbo.transaction ;
DROP TABLE IF EXISTS dbo.bid ;
DROP TABLE IF EXISTS dbo.asked ;
DROP TABLE IF EXISTS dbo.match ;
DROP TABLE IF EXISTS dbo.summary ;
DROP TABLE IF EXISTS dbo.foreign ;

-- Create a single table -- 
-- Stock --
CREATE TABLE  IF NOT EXISTS dbo.stock (
StockID SERIAL, 
Scode varchar(10)
);

-- bid --
CREATE TABLE  IF NOT EXISTS dbo.bid (
BidID SERIAL , 
BidPrice1 numeric,
BidVol1 int
);

-- Ask --
CREATE TABLE  IF NOT EXISTS dbo.asked (
AskedID SERIAL , 
AskedVol int,
AskedPrice numeric
)
;

-- Mathched --
CREATE TABLE  IF NOT EXISTS dbo.match (
MatchedID SERIAL ,
MatchedPrice numeric, 
MatchedVol int
);

-- price --
CREATE TABLE  IF NOT EXISTS dbo.Summary (
SummaryID SERIAL ,
OpenPrice numeric,
HighPrice numeric,
LowPrice numeric,
CeilPrice numeric,
FloorPrice numeric
);

-- foreign --
CREATE TABLE  IF NOT EXISTS dbo.foreign (
ForeignID SERIAL ,
Fbuy int, 
Fsell int
);

-- Create table with relationship --
-- Host --


-- foreign --
CREATE TABLE  IF NOT EXISTS dbo.foreign (
ForeignID SERIAL ,
Fbuy int, 
Fsell int,

Constraint PK_ForeignID  PRIMARY KEY (ForeignID)
);


/* Traditional structure */


CREATE TABLE  IF NOT EXISTS dbo.transaction (
StockID int,
MatchedID int,
AskedID int,
SummaryID int,
ForeignID int,
BidID int,
LoadDate TIMESTAMP ,
Constraint PK_TransactionID  PRIMARY KEY (StockID,MatchedID,SummaryID,ForeignID,BidID,AskedID)
);

/*======================================================= Type 1 =======================================================================*/


-- Transaction --
CREATE TABLE  IF NOT EXISTS dbo.transaction (
TransactionID SERIAL , 
StockID int,
MatchedID int,
AskedID int,
SummaryID int,
ForeignID int,
BidID int,
LoadDate TIMESTAMP ,

Constraint PK_TransactionID  PRIMARY KEY (TransactionID)
);

-- linked primary key in Transaction table to foreign keys in other tables
Alter table dbo.transaction  ADD FOREIGN KEY (StockID) REFERENCES dbo.stock (StockID);
Alter table dbo.transaction  ADD FOREIGN KEY (MatchedID) REFERENCES dbo.match (MatchedID);
Alter table dbo.transaction  ADD FOREIGN KEY (AskedID) REFERENCES dbo.asked (AskedID);
Alter table dbo.transaction  ADD FOREIGN KEY (SummaryID) REFERENCES dbo.summary (SummaryID);
Alter table dbo.transaction  ADD FOREIGN KEY (BidID) REFERENCES dbo.bid (BidID);
Alter table dbo.transaction  ADD FOREIGN KEY (ForeignID) REFERENCES dbo.foreign (ForeignID);

/* Type 3*/
-- linked primary key in Stock table to foreign keys in other tables
Alter table dbo.match  ADD FOREIGN KEY (StockID) REFERENCES dbo.stock (StockID);
Alter table dbo.asked  ADD FOREIGN KEY (StockID) REFERENCES dbo.stock (StockID);
Alter table dbo.summary  ADD FOREIGN KEY (StockID) REFERENCES dbo.stock (StockID);
Alter table dbo.bid  ADD FOREIGN KEY (StockID) REFERENCES dbo.stock (StockID);
Alter table dbo.foreign  ADD FOREIGN KEY (StockID) REFERENCES dbo.stock (StockID);

-- Insert rows to table --
-- Option 1: Insert each single row to each table --
insert into dbo.stock(Scode) values ('STB');
insert into dbo.stock(Scode) values ('SHB');
insert into dbo.stock(Scode) values ('ROS');

-- Option 2: Insert mutple rows to each table --

insert into dbo.stock(Scode) values 
('STB'),
('SHB'),
('ROS');

-- Insert rows  to multiple tables


-- Select record --
select * from dbo.stock;
select * from dbo.host;

-- Delete row from data in table --
-- Truncate table --
Truncate table dbo.stock;
Truncate table dbo.stock restart IDENTITY;

-- Delete selected row
Delete from dbo.stock
where Scode = 'STB';

ALTER SEQUENCE dbo.stock_stockid_seq RESTART WITH 1;

/*=================================================== MSSQL SERVER =========================================*/
-- Create database --
Go


/* Create database StockDB_Main;
Create SCHEMA price_hist;

Create database StockDB_Add;
Create SCHEMA order_hist;
Create SCHEMA trans_frg;
*/
Use StockDB_Main;

-- Create datime table --
DROP TABLE IF EXISTS StockDB_Main.price_hist.datetimetable ;
Create table StockDB_Main.price_hist.datetimetable(
DateID int Identity,
DateDataDownLoad datetime,
DateStockreport date,
Constraint PK_DateID  PRIMARY KEY (DateID)
);

/*
insert into  StockDB_Main.price_hist.datetimetable(DateDataDownLoad,DateStockreport) values (
'2021-03-03','2021-03-11'
);

insert into StockDB_Main.price_hist.datetimetable(DateDataDownLoad, DateStockreport) values ('2021-03-03 00:15:52.943840', '2020-01-30') ;   

select * from  StockDB_Main.price_hist.datetimetable;
*/

-- Create Schema --
-- Drop database --
--Drop database Testdb;--

DROP TABLE IF EXISTS price_hist.stock ;
DROP TABLE IF EXISTS price_hist.host ;
DROP TABLE IF EXISTS price_hist.trans ;
DROP TABLE IF EXISTS price_hist.deal ;
DROP TABLE IF EXISTS price_hist.reference ;
DROP TABLE IF EXISTS price_hist.match ;
DROP TABLE IF EXISTS price_hist.summary ;


 -- Create a single table -- 
CREATE TABLE  price_hist.host (
HostID int IDENTITY, 
HostName varchar(10),

Constraint PK_HostID  PRIMARY KEY (HostID)
);

-- Stock --
CREATE TABLE  price_hist.stock (
StockID int IDENTITY, 
Scode varchar(10),
HostID int,
Constraint PK_StockID  PRIMARY KEY (StockID)
);


-- Refences --

Create Table price_hist.reference(
 RefID int IDENTITY,
 AvgPrice numeric,
 Difference varchar (255),
 RefPrice numeric,
Constraint PK_RefID  PRIMARY KEY (RefID)
);

-- Mathched --
CREATE TABLE  price_hist.match (
MatchedID int IDENTITY,
MatchedValue numeric, 
MatchedVol int,
Constraint PK_Matched  PRIMARY KEY (MatchedID)
);


-- Summary --
CREATE TABLE price_hist.summary (
SummaryID int IDENTITY,
ClosePrice numeric,
OpenPrice numeric,
High numeric,
Low numeric,
CeilPrice numeric,
FloorPrice numeric,

Constraint PK_SummaryID  PRIMARY KEY (SummaryID)
);

-- Deal --
CREATE TABLE  price_hist.deal (
DealID int IDENTITY,
DealVol numeric, 
DealValue numeric,
Constraint PK_DealID  PRIMARY KEY (DealID)
);


CREATE TABLE  price_hist.trans (
TransID int IDENTITY,
StockID int,
MatchedID int,
RefID int,
SummaryID int,
DealID int,
Datadate Date ,
ImportedDateTime datetime,
Constraint PK_TransactionID  PRIMARY KEY (StockID,MatchedID,SummaryID,DealID,RefID)
);

-- Additional Database --

Use StockDB_Add;

-- Create SCHEMA order_hist; --
-- Create SCHEMA trans_frg; --

DROP TABLE IF EXISTS StockDB_Add.order_hist.buyorder ;
DROP TABLE IF EXISTS StockDB_Add.order_hist.sellorder ;
DROP TABLE IF EXISTS StockDB_Add.order_hist.Reference ;
DROP TABLE IF EXISTS StockDB_Add.order_hist.trans_order ;


-- Buy --
CREATE TABLE StockDB_Add.order_hist.buyorder (
BuyID int IDENTITY, 
BuyOrderCount int,
BuyOrderVol int,
BuySurplus int,
AvgOneBuyOrder numeric,

Constraint PK_BuyID  PRIMARY KEY (BuyID)
);

-- Sell --
CREATE TABLE  order_hist.sellorder (
SellID int IDENTITY, 
SellOrder int,
SellOrderVol int,
SellSurplus int,
AvgOneSellOrder numeric,

Constraint PK_SellID  PRIMARY KEY (SellID)
);

-- Reference --
CREATE TABLE  order_hist.Reference (
RefID int IDENTITY, 
Price numeric,
Difference varchar(255),
DiffBuySellVol numeric,
Constraint PK_RefID  PRIMARY KEY (RefID)
);

-- Transaction -- 


CREATE TABLE  order_hist.trans_order (
TransID int IDENTITY,
BuyID int,
SellID int,
RefID int,
Scode varchar(10),
Datadate Date ,
ImportedDateTime datetime,
Constraint PK_TransactionID  PRIMARY KEY (BuyID,SellID,RefID)
);


-- Foreing transation --
DROP TABLE IF EXISTS StockDB_Add.trans_frg.fbuy ;
DROP TABLE IF EXISTS StockDB_Add.trans_frg.fsell ;
DROP TABLE IF EXISTS StockDB_Add.trans_frg.reference ;
DROP TABLE IF EXISTS StockDB_Add.trans_frg.ftrans ;


-- Buy --
CREATE TABLE  trans_frg.fbuy (
FbuyID int IDENTITY, 
FBuyVol int,
FbuyValue numeric,

Constraint PK_FbuyID  PRIMARY KEY (FbuyID)
);

-- Sell --
CREATE TABLE  trans_frg.fsell (
FsellID int IDENTITY, 
FSellVol int,
FSellValue numeric,

Constraint PK_FsellID  PRIMARY KEY (FsellID)
);

-- reference --
CREATE TABLE  trans_frg.reference (
FrefID int IDENTITY, 
FRawVol int,
RemainSlot int,
Owning VARCHAR(255),
Constraint PK_FrefID  PRIMARY KEY (FrefID)
);

-- Transaction -- 

CREATE TABLE  trans_frg.ftrans (
TransID int IDENTITY,    
FbuyID int,
FsellID int,
FrefID int,
Scode varchar(10),
Datadate datetime ,
Constraint PK_TransactionID  PRIMARY KEY (FbuyID,FsellID,FrefID)
);

-- ======================== --
Use StockDB_Main;
/*insert data to  MSSQL Server 
select * from  StockDB_Main.price_hist.host ;
TRUNCATE TABLE StockDB_Main.price_hist.host;

select * from  StockDB_Main.price_hist.stock;
TRUNCATE TABLE StockDB_Main.price_hist.stock;


select * from  StockDB_Main.price_hist.deal;
TRUNCATE TABLE StockDB_Main.price_hist.stock; 

select * from  StockDB_Main.price_hist.trans;
-- Insert data to StockDB_main
insert into StockDB_Main.price_hist.host(HostName) output Inserted.HostID values 
('HNX'),
('HOSE') 
;*/

