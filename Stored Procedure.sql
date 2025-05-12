USE Digital_Library_Management_System_with_Role_Based_Security_and_Reservations

GO

CREATE PROCEDURE uspDisplayTransactionperResources
	@ResourcesID int
AS

	SET NOCOUNT ON;
	SELECT t.TransactionID as 'Transaction ID', CONCAT(t.MemberID, ', ', t.LibrarianID) as 'ID', r.ResourceType
	from Transactions t
	inner join Resources r
	on t.ResourcesID = r.ResourcesID
	where t.ResourcesID = @ResourcesID