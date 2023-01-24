import ballerina/io;

public class Database {
    private string dbPath = "./data";

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

    public function init() returns error? {
        io:println("db initialized");
    }

    public function readUsers() returns error? {
        self.usersJson = check io:fileReadJson(self.dbPath + "/users.json");
        self.usersJsonArr = <json[]> self.usersJson;

        self.usersTable = table [];
        
        foreach int i in 0...(self.usersJsonArr.length() - 1) {
            self.usersTable.put({
                id: check self.usersJsonArr[i].id,
                fname: check self.usersJsonArr[i].fname,
                lname: check self.usersJsonArr[i].lname,
                tel: check self.usersJsonArr[i].tel
            });
        }

    }

    public function readBooks() returns error? {
        self.booksJson = check io:fileReadJson(self.dbPath + "/books.json"); 
        self.booksJsonArr = <json[]> self.booksJson;

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
        self.userBooksJson = check io:fileReadJson(self.dbPath + "/userBooks.json");
        self.userBooksJsonArr = <json[]> self.userBooksJson;

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
        self.authorsJson = check io:fileReadJson(self.dbPath + "/authors.json");
        self.authorsJsonArr = <json[]> self.authorsJson;

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

}