-- In MSSQL RegEx based replace function not available. We can use PATINDEX, CONCAT, and LEN to worklike RegEx replace
/*
Assume Below is the table named Student under database School
--[DLS]-> Don't like start
--[DLE]-> Don't like end
------------------------------------------------------------------------------
ID	| Name	  | Address	                       | Edible                       |
1	  | John	  | Rajajinagar,Bangalore-560010	 | Mango, Apple[DLS]Graphs[DLE] |
2	  | Jeeva	  | Bidadi,Ramanagara-562109    	 | Orage, Apple                 |
3	  | Jebra	  | Magadi,Ramanagara-562120	     | Mango[DLS]Apple[DLE]         |
------------------------------------------------------------------------------
*/

--Scenario 1:We need to replace value of Edible column of John of likeable items(Mango,Apple -> we are not aware of value in this scenario) with Watermelon. 
----------- Scenario 1 logic starts-----------------------
/*
John Edible value 
Current value -> Mango, Apple[DLS]Graphs[DLE]
Exepected value -> Watermelon[DLS]Graphs[DLE]
*/
DECLARE @PreEdible AS VARCHAR(700)
DECLARE @PostEdible AS VARCHAR(700)
-- Get the Don't like edible value from the table
SET @PreEdible=(Select Substring(Evalue,lpoint,Elength) from
(Select PATINDEX('%[[]DLE%', [Edible]) as lpoint,[Edible] as Evalue,LEN([Edible]) as Elength FROM [School].[dbo].[Student] where [Name]='John') as t)
-- Concate the like and don't like edible value
SET @PostEdible = (Select CONCAT('Watermelon',@PreEdible))
-- Update the table with expected result
Update  [School].[dbo].[Student]
SET Edible=@PostEdible where [Name]='John'

-------------- END of the Scenario 1 ---------------------------------

