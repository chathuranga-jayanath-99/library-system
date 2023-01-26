import ballerina/io;

public class Database {
    private string dbPath = "./data";

    private boolean debug = true;

    // store json
    private json usersJson = ();
    private json booksJson = ();
    private json userBooksJson = ();
    private json authorsJson = ();

    // store in json arr
    private json[] usersJsonArr = [];
    private json[] booksJsonArr = [];
    private json[] userBooksJsonArr = [];
    private json[] authorsJsonArr = [];
    
    // store in table
    table<User> key(id) usersTable = table [];
    table<Book> key(id) booksTable = table [];
    table<UserBook> key(userId, bookId) userBooksTable = table [];
    table<Author> key(id) authorsTable = table [];

    public function init() {
        io:println("db initialized");
        
        error? err = self.loadJsons();
        self.loadTables();
    }

    public function loadJsons() returns error? {
        self.usersJson = check io:fileReadJson(self.dbPath + "/users.json");
        self.usersJsonArr = <json[]> self.usersJson;

        self.booksJson = check io:fileReadJson(self.dbPath + "/books.json"); 
        self.booksJsonArr = <json[]> self.booksJson;

        self.userBooksJson = check io:fileReadJson(self.dbPath + "/userBooks.json");
        self.userBooksJsonArr = <json[]> self.userBooksJson;

        self.authorsJson = check io:fileReadJson(self.dbPath + "/authors.json");
        self.authorsJsonArr = <json[]> self.authorsJson;
    }

    public function loadTables() {
        error? err = self.loadUsersTable();
        err = self.loadBooksTable(); 
    }

    public function loadUsersTable() returns error? {
        self.usersTable = table [];
        
        foreach int i in 0...(self.usersJsonArr.length() - 1) {
            json[] userBorrowedBooks = self.getUserBorrowedBooks(check self.usersJsonArr[i].id);
            userBorrowedBooks = userBorrowedBooks.cloneReadOnly();
            
            if self.debug {
                io:println("insider db load users table");
                io:println(userBorrowedBooks);
            }

            self.usersTable.put({
                id: check self.usersJsonArr[i].id,
                fname: check self.usersJsonArr[i].fname,
                lname: check self.usersJsonArr[i].lname,
                tel: check self.usersJsonArr[i].tel,
                books: <Book[]> userBorrowedBooks
            });
        }
    }

    public function loadBooksTable() returns error? {
        self.booksTable = table [];
        
        foreach int i in 0...(self.booksJsonArr.length() - 1) {
            self.booksTable.put({
                id: check self.booksJsonArr[i].id,
                name: check self.booksJsonArr[i].name,
                authorId: check self.booksJsonArr[i].authorId,
                copies: check self.booksJsonArr[i].copies
            });
        }
    }
 

    public function readUserBooks() returns error? {

        self.userBooksTable = table [];

        foreach int i in 0...(self.userBooksJsonArr.length() - 1) {
            self.userBooksTable.put({
                userId: check self.booksJsonArr[i].userId,
                bookId: check self.booksJsonArr[i].bookId,
                expireDate: check self.booksJsonArr[i].expireDate,
                fine: check self.booksJsonArr[i].fine
            });
        }
    }

    public function readAuthors() returns error? {
        self.authorsTable = table [];

        foreach int i in 0...(self.authorsJsonArr.length() - 1) {
            self.authorsTable.put({
                id: check self.authorsJsonArr[i].id,
                name: check self.authorsJsonArr[i].name
            });            
        }
    }

    public function getUsers() returns User[] {
        User[] users = from var user in self.usersTable
                        select user;
        return users;
    }

    public function getUser(int id) returns User {
        User[] users = from var user in self.usersTable
                    where id == id 
                    select user;
        return users[0];
    }

    public function getBooks() returns Book[] {
        Book[] books = from var book in self.booksTable 
                        select book;
        return books;
    }

    public function getBook(int id) returns Book {
        Book[] books = from var book in self.booksTable 
                        where book.id == id 
                        select book;
        return books[0];
    }

    public function getAuthors() returns Author[] {
        Author[] authors = from var author in self.authorsTable 
                            select author;
        return authors;
    }

    public function getAuthor(int id) returns Author {
        Author[] authors = from var author in self.authorsTable 
                            select author;
        return authors[0];
    }

    public function getUserBooks() returns UserBook[] {
        UserBook[] userBooks = from var userBook in self.userBooksTable 
                                select userBook;
        return userBooks;
    }

    public function getUserBook(int userId, int bookId) returns UserBook {
        UserBook[] userBooks = from var userBook in self.userBooksTable 
                                where userId==userId && bookId==bookId 
                                select userBook;
        return userBooks[0];
    }

    public function getBookAuthor(int bookId) returns Author {
        json bookAuthor = from var book in self.booksJsonArr 
                            join var author in self.authorsJsonArr 
                            on book.authorId equals author.id 
                            where book.id === bookId 
                            select author; 
        return <Author>bookAuthor;
    }

    public function getUserBorrowedBooks(int userId) returns json[] {
        json[] books = from var book in self.booksJsonArr 
                        // join var userBook in self.userBooksTable 
                        // on userId equals userBook.userId 
                        select book;
        if self.debug {
            io:println("in db, getUserBorrowedBooks");
            io:println(books);
        }
        return books;
    }

}