USE Digital_Library_Management_System_with_Role_Based_Security_and_Reservations;
GO

CREATE TABLE Resources(
	ResourcesID int PRIMARY KEY,
	ResourceType varchar(50),
);

CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    "Name" VARCHAR(255) NOT NULL,
    Biography TEXT,
    DateOfBirth DATE,
    Nationality VARCHAR(100),
    Awards TEXT,
    Genre VARCHAR(100)
);

CREATE TABLE ElectronicResources (
    ResourceID INT PRIMARY KEY,
	ResourcesID int,
    Title VARCHAR(255) NOT NULL,
    ResourceType VARCHAR(50) NOT NULL CHECK (ResourceType IN ('E-Book', 'Video', 'Audio', 'Document')),
    AuthorID INT,
    PublicationDate DATE,
    FileFormat VARCHAR(50),
    FileSize DECIMAL(10,2),
    AccessType VARCHAR(50) NOT NULL CHECK (AccessType IN ('Free', 'Subscription', 'One-Time Purchase')),
    ExpiryDate DATE NULL,
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
	FOREIGN KEY (ResourcesID) REFERENCES Resources(ResourcesID)
);

CREATE TABLE Article (
    ArticleID INT PRIMARY KEY,
	ResourcesID int,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    Keywords TEXT,
    PublicationDate DATE,
    PageRange VARCHAR(50),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
	FOREIGN KEY (ResourcesID) REFERENCES Resources(ResourcesID)
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
	ResourcesID int,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    Genre VARCHAR(100),
    PublicationDate DATE,
    AvailableCopies INT DEFAULT 0,
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID) ON DELETE SET NULL,
	FOREIGN KEY (ResourcesID) REFERENCES Resources(ResourcesID)
);

CREATE TABLE Journal (
    JournalID INT PRIMARY KEY,
	ResourcesID int,
    Title VARCHAR(255) NOT NULL,
    Publisher VARCHAR(255),
    PublicationFrequency VARCHAR(100),
    SubjectArea VARCHAR(255),
    PublicationDate DATE,
    AvailableCopies INT DEFAULT 0
	FOREIGN KEY (ResourcesID) REFERENCES Resources(ResourcesID)
);

CREATE TABLE Magazine (
    MagazineID INT PRIMARY KEY,
	ResourcesID int,
    Title VARCHAR(255) NOT NULL,
    Publisher VARCHAR(255),
    Genre VARCHAR(100),
    PublicationDate DATE,
    AvailableCopies INT DEFAULT 0
	FOREIGN KEY (ResourcesID) REFERENCES Resources(ResourcesID)
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
	ResourcesID int,
    "Name" VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    MembershipType VARCHAR(50) NOT NULL CHECK (MembershipType IN ('Regular', 'Premium', 'VIP'))
	FOREIGN KEY (ResourcesID) REFERENCES Resources(ResourcesID)
);

CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY,
    ResourcesID INT,
    MemberID INT,
    ReservationDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    "Status" VARCHAR(50) NOT NULL CHECK (Status IN ('Active', 'Cancelled', 'Completed')),
    FOREIGN KEY (ResourcesID) REFERENCES Resources(ResourcesID) ,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    ResourcesID INT,
    MemberID INT,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,
    FOREIGN KEY (ResourcesID) REFERENCES Resources(ResourcesID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE Librarian (
    LibrarianID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    EmployeeID VARCHAR(50) UNIQUE NOT NULL,
    "Role" VARCHAR(100) NOT NULL CHECK (Role IN ('Admin', 'Staff')),
    HireDate DATE NOT NULL
);


CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    MemberID INT,
	ResourcesID int,
    LibrarianID INT,  -- Added this column
    TransactionType VARCHAR(50) NOT NULL CHECK (TransactionType IN ('Borrow', 'Return', 'Access')),
    TransactionDate DATETIME DEFAULT GETDATE(),
    DueDate DATE NULL,
    ReturnDate DATE NULL,
    Status VARCHAR(50) NOT NULL CHECK (Status IN ('Active', 'Returned', 'Overdue', 'Accessed')),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (LibrarianID) REFERENCES Librarian(LibrarianID),
	FOREIGN KEY (ResourcesID) REFERENCES Resources(ResourcesID)
);
