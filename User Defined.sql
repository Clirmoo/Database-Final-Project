-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Justin Adrian D. Lim>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION ufnCountTransac
(
	-- Add the parameters for the function here
	@LibrarianID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @total int

	-- Add the T-SQL statements to compute the return value here
	SELECT @total = count(*) from Transactions where LibrarianID = @LibrarianID

	-- Return the result of the function
	RETURN @total

END
GO

