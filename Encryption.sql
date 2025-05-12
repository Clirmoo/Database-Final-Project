use Digital_Library_Management_System_with_Role_Based_Security_and_Reservations



CREATE CERTIFICATE Transacc
	WITH SUBJECT = 'Members Transaction Status';
GO

CREATE SYMMETRIC KEY Status_Keyy
	WITH ALGORITHM = AES_256
	ENCRYPTION BY CERTIFICATE Transacc;
GO

ALTER TABLE Transactions
	ADD Status_Encryptedd varbinary(123);
GO

OPEN SYMMETRIC KEY Status_Keyy
	DECRYPTION BY CERTIFICATE Transacc;

UPDATE Transactions
SET Status_Encryptedd = EncryptByKey(Key_GUID('Status_Keyy'),
	"Status", 1, HASHBYTES('SHA1', CONVERT (varbinary
	, TransactionID)));

GO
select * from Transactions