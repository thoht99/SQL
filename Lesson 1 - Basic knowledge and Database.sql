
-- POSTGRE SQL --
-- Lesson 1 - Database Development
-- ======================================================================================================= --
/* ================== Create single table without primary key =====================*/ --
-- Regional table --
CREATE TABLE  IF NOT EXISTS public.region (
RegionID SERIAL, 
RegName varchar(255)
);

-- Income Group --
CREATE TABLE  IF NOT EXISTS public.IncomeGroup (
IGID SERIAL, 
IGName varchar(255)
);

-- YearID --
CREATE TABLE  IF NOT EXISTS public.year (
YearID SERIAL, 
YearName date
);

-- PPType -- 
CREATE TABLE  IF NOT EXISTS public.PPType (
PPTypeID SERIAL, 
PPTypeName varchar(255)
);

-- Country --
CREATE TABLE  IF NOT EXISTS public.country (
CountryID SERIAL, 
CntName varchar(255),
CntCode varchar(10), 
RegionID int,
IGID int
);

-- Transaction-- 
CREATE TABLE  IF NOT EXISTS public.Trans ( 
CountryID int,
YearID int,
PPTypeID int,
lifeExpectancy NUMERIC,
GDP NUMERIC,
PPnumber NUMERIC
);


/* ================== Create single table with primary key=================*/
-- Option 1: Alter table by adding Parimary Key --
ALTER TABLE region ADD PRIMARY KEY (RegionID);
ALTER TABLE IncomeGroup ADD PRIMARY KEY (IGID);
ALTER TABLE year ADD PRIMARY KEY (YearID);
ALTER TABLE country ADD PRIMARY KEY (CountryID);
ALTER TABLE PPType ADD PRIMARY KEY (PPTypeID);
ALTER TABLE Trans ADD PRIMARY KEY (YearID,CountryID,PPTypeID);


-- Option 2: Drop table and re-create table with Primary key --
Drop table if exists public.region;
Drop table if exists public.IncomeGroup;
Drop table if exists public.year;
Drop table if exists public.PPType;
Drop table if exists public.country;
Drop table if exists public.Trans;

-- Regional table --
CREATE TABLE  IF NOT EXISTS public.region (
RegionID SERIAL, 
RegName varchar(255),
Constraint PK_RegionID  PRIMARY KEY (RegionID)
);

-- Income Group --
CREATE TABLE  IF NOT EXISTS public.IncomeGroup (
IGID SERIAL, 
IGName varchar(255),
Constraint PK_IGID  PRIMARY KEY (IGID)
);

-- YearID --
CREATE TABLE  IF NOT EXISTS public.year (
YearID SERIAL, 
YearName date,
Constraint PK_YearID  PRIMARY KEY (YearID)
);

-- PPType -- 
CREATE TABLE  IF NOT EXISTS public.PPType (
PPTypeID SERIAL, 
PPTypeName varchar(255),
Constraint PK_PPTypeID  PRIMARY KEY (PPTypeID)
);

-- Country --
CREATE TABLE  IF NOT EXISTS public.country (
CountryID SERIAL, 
CntName varchar(255),
CntCode varchar(10), 
RegionID int,
IGID int,
Constraint PK_CountryID  PRIMARY KEY (CountryID)
);

-- Transaction-- 
CREATE TABLE  IF NOT EXISTS public.Trans ( 
CountryID int,
YearID int,
PPTypeID int,
lifeExpectancy NUMERIC,
GDP NUMERIC,
PPnumber NUMERIC,
Constraint PK_TransID  PRIMARY KEY (CountryID,YearID,PPTypeID)
);

/* ================== Modify table by adding and subtracting columns =================*/
-- Add new columns --
ALTER TABLE public.region 
ADD COLUMN add_column1 VARCHAR
add column add_column2 int

-- Change datatype --
ALTER TABLE public.region  
ALTER COLUMN add_column2 TYPE numeric;

-- Drop existing columns --
ALTER TABLE public.region 
DROP COLUMN add_column1 
drop column add_column2
;


/* ================== Linked between tables by Primary and Foregin keys =================*/
Alter table public.Country ADD FOREIGN KEY (RegionID) REFERENCES dbo.Region (RegionID);
Alter table public.Country ADD FOREIGN KEY (IGID) REFERENCES dbo.IncomeGroup (IGID);

Alter table public.Trans ADD FOREIGN KEY (CountryID) REFERENCES dbo.Country (CountryID);
Alter table public.Trans ADD FOREIGN KEY (YearID) REFERENCES dbo.Year (YeYearIDar);
Alter table public.Trans ADD FOREIGN KEY (PPTypeID) REFERENCES dbo.PPType (PPTypeID);


/*==================== Insert records to each table ====================*/
insert into public.Region (regname) values ('Latin America & Caribbean');
insert into public.IncomeGroup (IGName) values ('Medium Income');
insert into public.Country (CntName,CntCode,RegionID,IGID) values ('Peru','PRU',1,1);
insert into public.Year (YearName) values ('2019-01-01');
insert into public.Trans (YearID,PPTypeID,CountryID,lifeExpectancy,GDP,PPNumber) values (1,1,1,100000,100,1000000);


/*====================  Test table ====================*/
SELECT *  FROM public.Region ;
SELECT *  FROM public.year ;
SELECT *  FROM public.IncomeGroup ;
SELECT *  FROM public.PPType ;
SELECT *  FROM public.country ;
SELECT *  FROM public.Trans ;


/*====================  Delete  records in a table ====================*/
Truncate table  public.Region ;
Truncate table  public.IncomeGroup ;

/*====================  Delete table having relationship ====================*/
Drop table if exists public.Trans; -- => Return error -- 

-- Drop constaint first --
ALTER TABLE public.Region DROP CONSTRAINT PK_RegionID;
ALTER TABLE public.Country DROP CONSTRAINT PK_CtnID;
ALTER TABLE public.Country DROP CONSTRAINT FK_RegionID;
ALTER TABLE public.Country DROP CONSTRAINT FK_IGID;

-- then drop table --
Drop table if exists public.region;



--==============================================================================================--
/*Homework Solution*/
