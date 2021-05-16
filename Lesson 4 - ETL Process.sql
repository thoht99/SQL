-- MSSQL Server --
-- ETL process by SSIS with Visual Studio ---
-- ======================================================================================================= --
/*Import file to datbase by Import Winzar*/

-- Refer to lecture  and in-class activities --

/*Import file to datbase by SSIS*/

-- Refer to SSIS package files --

/*Homework*/
/*For ETL purpose*/
Drop table StockDB_Add.dbo.listed_company;
Drop TABLE StockDB_Add.dbo.trans_fees;
drop table StockDB_Add.dbo.tax_service;
drop table StockDB_Add.dbo.HOSE_company;;
drop table SSIS_test.dbo.listed_company;
drop table SSIS_test.dbo.[Listed Company];


Create table StockDB_Add.dbo.listed_company(
    CompID int IDENTITY, 
    Scode varchar(255) NUll,
    List_Name varchar(255) NUll,
    date_lst VARCHAR(255) NUll,
    host VARCHAR(255) NUll,
    Industry VARCHAR(255) NUll

);


Create table StockDB_Add.dbo.trans_fees(
    FeeID int IDENTITY,
    Fee_type varchar(255),
    SSI varchar(255),
    SHB varchar(255),
    FPTS varchar(255),
    TCBS varchar(255),
    unit VARCHAR(255)
);

Create table StockDB_Add.dbo.tax_service(
    TaxID int identity,
    selling_PIT numeric,
    custodian_fee numeric,
    stock_type varchar (255),
    unit Varchar(255)
);

-- CHeck information
Select * from SSIS_test.dbo.listed_company order by Scode;
Select * from SSIS_test.dbo.company_listed order by Scode;