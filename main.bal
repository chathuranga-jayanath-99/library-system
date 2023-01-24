import ballerina/graphql;
import ballerina/io;


service /graphql on new graphql:Listener(9090) {
    Database database;

    public function init() returns error?{
        self.database = check new;
        io:println("server running");

        error? x = self.database.readUsers();
        x = self.database.readBooks();
        x = self.database.readUserBooks();
        x = self.database.readAuthors();
    }

    resource function get greeting() returns string {
        return "Welcome to the library management system";
    }

    resource function get users() returns User[] {
        return self.database.getUsers();
    }

    resource function get user(int id) returns User {
        return self.database.getUser(id);
    }           
}
