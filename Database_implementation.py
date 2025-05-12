import tkinter as tk
from tkinter import messagebox
import pyodbc
from datetime import datetime, timedelta

def connect_db():
    return pyodbc.connect(
        r'DRIVER={SQL Server};'
        r'SERVER=LAPTOP-0LR5FBRR\SQLEXPRESS;'
        r'DATABASE=Digital_Library_Management_System_with_Role_Based_Security_and_Reservations;'
        r'Trusted_Connection=yes;'
    )

class LoginWindow:
    def __init__(self, master):
        self.master = master
        master.title("Library Login")

        tk.Label(master, text="Login As").grid(row=0, column=0)
        self.role_var = tk.StringVar(value="member")
        tk.Radiobutton(master, text="Member", variable=self.role_var, value="member").grid(row=0, column=1)
        tk.Radiobutton(master, text="Librarian", variable=self.role_var, value="librarian").grid(row=0, column=2)

        tk.Label(master, text="User ID:").grid(row=1, column=0)
        self.user_id_entry = tk.Entry(master)
        self.user_id_entry.grid(row=1, column=1)

        tk.Button(master, text="Login", command=self.login).grid(row=2, column=1)

    def login(self):
        user_id = self.user_id_entry.get()
        role = self.role_var.get()
        conn = connect_db()
        cursor = conn.cursor()

        if role == "member":
            cursor.execute("SELECT Name FROM Members WHERE MemberID=?", user_id)
        else:
            cursor.execute("SELECT Name FROM Librarian WHERE LibrarianID=?", user_id)

        row = cursor.fetchone()
        if row:
            self.master.withdraw()
            if role == "member":
                MemberDashboard(int(user_id), row.Name)
            else:
                LibrarianDashboard(int(user_id), row.Name)
        else:
            messagebox.showerror("Login Failed", "Invalid ID")

class LibrarianDashboard:
    def __init__(self, user_id, name):
        self.root = tk.Toplevel()
        self.root.title(f"Librarian Dashboard - {name}")

        tk.Label(self.root, text=f"Welcome, {name}").pack()
        tk.Button(self.root, text="View All Resources", command=self.view_resources).pack()
        tk.Button(self.root, text="Add Book", command=self.add_book).pack()
        tk.Button(self.root, text="Logout", command=self.root.destroy).pack()

    def view_resources(self):
        conn = connect_db()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM Resources")
        rows = cursor.fetchall()
        output = "\n".join([f"{r.ResourcesID}: {r.ResourceType}" for r in rows])
        messagebox.showinfo("Resources", output)

    def add_book(self):
        def submit():
            try:
                conn = connect_db()
                cursor = conn.cursor()
                cursor.execute("""
                    INSERT INTO Books (BookID, ResourcesID, Title, AuthorID, Genre, PublicationDate, AvailableCopies)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                """, (
                    int(book_id.get()), int(res_id.get()), title.get(), int(author_id.get()), genre.get(), pub_date.get(), int(copies.get())
                ))
                conn.commit()
                top.destroy()
                messagebox.showinfo("Success", "Book added.")
            except Exception as e:
                messagebox.showerror("Error", str(e))

        top = tk.Toplevel()
        top.title("Add Book")

        labels = ["BookID", "ResourcesID", "Title", "AuthorID", "Genre", "PublicationDate (YYYY-MM-DD)", "AvailableCopies"]
        entries = [tk.Entry(top) for _ in labels]
        for i, (label, entry) in enumerate(zip(labels, entries)):
            tk.Label(top, text=label).grid(row=i, column=0)
            entry.grid(row=i, column=1)

        book_id, res_id, title, author_id, genre, pub_date, copies = entries
        tk.Button(top, text="Submit", command=submit).grid(row=len(labels), column=1)

class MemberDashboard:
    def __init__(self, user_id, name):
        self.user_id = user_id
        self.root = tk.Toplevel()
        self.root.title(f"Member Dashboard - {name}")

        tk.Label(self.root, text=f"Welcome, {name}").pack()
        tk.Button(self.root, text="View Available Books", command=self.view_books).pack()
        tk.Button(self.root, text="Reserve Resource", command=self.reserve_resource).pack()
        tk.Button(self.root, text="Logout", command=self.root.destroy).pack()

    def view_books(self):
        conn = connect_db()
        cursor = conn.cursor()
        cursor.execute("SELECT Title, AvailableCopies FROM Books WHERE AvailableCopies > 0")
        books = cursor.fetchall()
        if books:
            output = "\n".join([f"{b.Title} ({b.AvailableCopies} copies)" for b in books])
        else:
            output = "No books available"
        messagebox.showinfo("Available Books", output)

    def reserve_resource(self):
        def submit_reservation():
            try:
                resource_id = int(resource_id_entry.get())
                conn = connect_db()
                cursor = conn.cursor()
                reservation_id = int(datetime.now().timestamp())
                cursor.execute("""
                    INSERT INTO Reservations (ReservationID, ResourcesID, MemberID, ReservationDate, ExpiryDate, Status)
                    VALUES (?, ?, ?, ?, ?, 'Active')
                """, (
                    reservation_id,
                    resource_id,
                    self.user_id,
                    datetime.now().date(),
                    (datetime.now() + timedelta(days=7)).date()
                ))
                conn.commit()
                top.destroy()
                messagebox.showinfo("Success", "Reservation made.")
            except Exception as e:
                messagebox.showerror("Error", str(e))

        top = tk.Toplevel()
        top.title("Reserve Resource")
        tk.Label(top, text="Enter Resource ID:").grid(row=0, column=0)
        resource_id_entry = tk.Entry(top)
        resource_id_entry.grid(row=0, column=1)
        tk.Button(top, text="Reserve", command=submit_reservation).grid(row=1, column=1)

if __name__ == "__main__":
    root = tk.Tk()
    app = LoginWindow(root)
    root.mainloop()
