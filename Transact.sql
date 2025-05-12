use Digital_Library_Management_System_with_Role_Based_Security_and_Reservations
go
begin tran InsertMagazine
	insert into Magazine
	values (1, 5, 'Tell me Everything', 'Book Digest Media House', 'Literature', '2023-04-01', 10)
	commit tran
go
select * from Magazine