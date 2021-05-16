-- MSSSQL SQL --
-- ======================================================================================================= --
/* ============================ Working with indexing
*/
-- Create Non-clustered index -- 
CREATE INDEX Stock_index
ON StockDB_Main.price_hist.stock (Scode ASC);

-- Example 1: Select data without condition --
select * FROM StockDB_Main.price_hist.stock
 WITH(INDEX(Stock_index)); 
-- (1707 rows affected), Total execution time: 00:00:00.058 --

select * FROM StockDB_Main.price_hist.stock; 
-- (1707 rows affected), Total execution time: 00:00:00.056--

-- Example 2: Select data with where condition --
select * FROM StockDB_Main.price_hist.stock
 WITH(INDEX(Stock_index)) where scode = 'ABB'; 
-- (1 row affected), Total execution time: 00:00:00.037--

select * FROM StockDB_Main.price_hist.stock where scode = 'ABB'; 
-- (1 row affected), Total execution time: 00:00:00.044 --


-- Create clustered index / primary key--
-- remove primary key --
ALTER TABLE StockDB_Main.price_hist.stock
DROP CONSTRAINT PK_StockID


-- Create new cluster index --
CREATE CLUSTERED INDEX new_index_stock ON StockDB_Main.price_hist.stock (scode);

select * FROM StockDB_Main.price_hist.stock
 WITH(INDEX(new_index_stock)) where scode = 'ABB'; 
-- (1 row affected), Total execution time: 00:00:00.044--
 
select * FROM StockDB_Main.price_hist.stock where scode = 'ABB'; 
-- (1 row affected), Total execution time: 00:00:00.042 --


-- Drop table's index -- 
drop index Stock_index ON StockDB_Main.price_hist.stock;  

/* Exercise:

*/

/*Homework*/