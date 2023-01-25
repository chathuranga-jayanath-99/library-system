import ballerina/graphql;
import ballerina/io;


service /graphql on new graphql:Listener(9090) {
    Database database;

    public function init() returns error?{
        self.database = check new;
        io:println("server running");

        io:println(self.database.booksTable);
    }

    resource function get greeting() returns string {
        return "Welcome to the library management system";
    }

    resource function get users() returns User[]|error {
        return self.database.getUsers();
    }

    resource function get user(int id) returns User {
        return self.database.getUser(id);
    }  

    resource function get books () returns Book[] {
        return self.database.getBooks();
    }         

    resource function get book (int id) returns Book {
        return self.database.getBook(id);
    }

    resource function get userBooks () returns UserBook[] {
        return self.database.getUserBooks();
    }

    resource function get userBook (int userId, int bookId) returns UserBook {
        return self.database.getUserBook(userId, bookId);
    }

    resource function get authors () returns Author[] {
        return self.database.getAuthors();
    }

    resource function get author (int id) returns Author {
        return self.database.getAuthor(id);
    }

    
}
