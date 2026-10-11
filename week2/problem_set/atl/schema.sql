CREATE TABLE Passengers (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    age INTEGER NOT NULL
);

CREATE TABLE Airlines (
    airline_code INTEGER PRIMARY KEY,
    company_name TEXT NOT NULL
);

CREATE TABLE Concourses (
    concourse TEXT PRIMARY KEY
        CHECK (concourse IN ('A', 'B', 'C', 'D', 'E', 'F', 'T'))
);

CREATE TABLE Airline_Concourses (
    airline_code INTEGER NOT NULL,
    concourse TEXT NOT NULL,

    PRIMARY KEY (airline_code, concourse),

    FOREIGN KEY (airline_code)
        REFERENCES Airlines(airline_code),

    FOREIGN KEY (concourse)
        REFERENCES Concourses(concourse)
);

CREATE TABLE Flights (
    flight_number INTEGER NOT NULL,
    airline_code INTEGER NOT NULL,
    departure_airport TEXT NOT NULL,
    arrival_airport TEXT NOT NULL,
    departure_datetime TEXT NOT NULL,
    arrival_datetime TEXT NOT NULL,

    PRIMARY KEY (flight_number, departure_datetime),

    FOREIGN KEY (airline_code)
        REFERENCES Airlines(airline_code)
);

CREATE TABLE Check_Ins (
    passenger_id INTEGER NOT NULL,
    flight_number INTEGER NOT NULL,
    departure_datetime TEXT NOT NULL,
    check_in_datetime TEXT NOT NULL,

    FOREIGN KEY (passenger_id)
        REFERENCES Passengers(id),

    FOREIGN KEY (flight_number, departure_datetime)
        REFERENCES Flights(flight_number, departure_datetime)
);