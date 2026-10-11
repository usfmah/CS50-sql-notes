
CREATE TABLE Users (
    id PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
);

CREATE TABLE Schools (
    id PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    location TEXT NOT NULL,
    foundation_year INTEGER NOT NULL
);

CREATE TABLE Companies (
    id PRIMARY KEY,
    name TEXT NOT NULL,
    industry TEXT NOT NULL,
    location TEXT NOT NULL
);

CREATE TABLE connections (
    "user_id" INTEGER,
    "connection_id" INTEGER,

    PRIMARY KEY ("user_id", "connection_id"),

    CHECK ("user_id" < "connection_id"),

    FOREIGN KEY ("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY ("connection_id") REFERENCES "Users"("id")
);

CREATE TABLE Education (
    user_id INTEGER,
    school_id INTEGER,
    start_date TEXT NOT NULL,
    end_date TEXT ,
    degree_type TEXT NOT NULL,

    FOREIGN KEY ("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY ("school_id") REFERENCES "Schools"("id"),
    PRIMARY KEY (user_id, school_id, start_date)
);

CREATE TABLE Employment (
    user_id INTEGER,
    company_id INTEGER,
    start_date TEXT NOT NULL,
    end_date TEXT,
    title TEXT NOT NULL,
    FOREIGN KEY ("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY ("company_id") REFERENCES "Companies"("id"),
    PRIMARY KEY (user_id, company_id, start_date)
);
