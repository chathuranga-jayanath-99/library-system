type User record {|
    readonly int id;
    string fname;
    string lname;
    string tel;
|};

type Book record {|
    readonly int id;
    string name;
    int authorId;
    int copies;
|};

type UserBook record {|
    readonly int userId;
    readonly int bookId;
    string expireDate;
    float fine;
|};

type Author record {|
    readonly int id;
    string name;
|};