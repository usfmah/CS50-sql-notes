
CREATE TABLE Ingredients (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price_per_unit REAL NOT NULL,
    unit TEXT NOT NULL
);

CREATE TABLE Donuts (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    gluten_free INTEGER NOT NULL CHECK (gluten_free IN (0, 1)),
    price REAL NOT NULL
);

CREATE TABLE Donut_Ingredients (
    donut_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    PRIMARY KEY (donut_id, ingredient_id),
    FOREIGN KEY (donut_id) REFERENCES Donuts(id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(id)
);

CREATE TABLE Customers (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

CREATE TABLE Orders (
    id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(id)
);

CREATE TABLE Order_Items (
    order_id INTEGER NOT NULL,
    donut_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, donut_id),
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (donut_id) REFERENCES Donuts(id)
);
