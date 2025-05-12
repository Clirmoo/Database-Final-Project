USE Digital_Library_Management_System_with_Role_Based_Security_and_Reservations;
GO

-- Resources
INSERT INTO Resources (ResourcesID, ResourceType) VALUES
(1, 'Book'), (2, 'Article'), (3, 'Electronic'), (4, 'Journal'), (5, 'Magazine');

-- Authors
INSERT INTO Author (AuthorID, Name, Biography, DateOfBirth, Nationality, Awards, Genre) VALUES
(1, 'George Orwell', 'English novelist and journalist.', '1903-06-25', 'British', 'Prometheus Hall of Fame Award', 'Dystopian'),
(2, 'Jane Austen', 'Known for romantic fiction.', '1775-12-16', 'British', 'Posthumous acclaim', 'Romance');

-- Librarians
INSERT INTO Librarian (LibrarianID, Name, ContactInfo, EmployeeID, Role, HireDate) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'EMP001', 'Admin', '2020-01-15');

-- Members
INSERT INTO Members (MemberID, ResourcesID, Name, ContactInfo, MembershipType) VALUES
(1, 1, 'John Doe', 'john.doe@example.com', 'Regular'),
(2, 2, 'Jane Smith', 'jane.smith@example.com', 'Premium');

-- Books
INSERT INTO Books (BookID, ResourcesID, Title, AuthorID, Genre, PublicationDate, AvailableCopies) VALUES
(1, 1, '1984', 1, 'Dystopian', '1949-06-08', 5),
(2, 1, 'Pride and Prejudice', 2, 'Romance', '1813-01-28', 3);

-- Articles
INSERT INTO Article (ArticleID, ResourcesID, Title, AuthorID, Keywords, PublicationDate, PageRange) VALUES
(1, 2, 'Dystopian Literature in the 20th Century', 1, 'Dystopia, Literature, Orwell', '2001-03-15', '12-25');

-- Electronic Resources
INSERT INTO ElectronicResources (ResourceID, ResourcesID, Title, ResourceType, AuthorID, PublicationDate, FileFormat, FileSize, AccessType, ExpiryDate) VALUES
(1, 3, 'Digital Revolution', 'E-Book', 1, '2015-09-01', 'PDF', 2.5, 'Free', NULL);

-- Journals
INSERT INTO Journal (JournalID, ResourcesID, Title, Publisher, PublicationFrequency, SubjectArea, PublicationDate, AvailableCopies) VALUES
(1, 4, 'Literary Review', 'Academic Press', 'Monthly', 'Literature', '2023-01-01', 2);

-- Magazines
INSERT INTO Magazine (MagazineID, ResourcesID, Title, Publisher, Genre, PublicationDate, AvailableCopies) VALUES
(1, 5, 'Book Digest', 'Media House', 'Literature', '2023-04-01', 10);

-- Reservations
INSERT INTO Reservations (ReservationID, ResourcesID, MemberID, ReservationDate, ExpiryDate, Status) VALUES
(1, 1, 1, '2025-05-01', '2025-05-10', 'Active');

-- Loans
INSERT INTO Loans (LoanID, ResourcesID, MemberID, LoanDate, DueDate, ReturnDate) VALUES
(1, 1, 1, '2025-05-01', '2025-05-15', NULL);

-- Transactions
INSERT INTO Transactions (MemberID, ResourcesID, LibrarianID, TransactionType, DueDate, ReturnDate, Status) VALUES
(1, 1, 1, 'Borrow', '2025-05-15', NULL, 'Active'),
(2, 3, 1, 'Access', NULL, NULL, 'Accessed');
