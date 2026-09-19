-- *** The Lost Letter ***

-- Find Anneke's address ID so I can identify the address from which the package was sent.
SELECT id
FROM addresses
WHERE address = '900 Somerville Avenue';

-- Find all destination address IDs for packages sent from Anneke's address.
SELECT to_address_id
FROM packages
WHERE from_address_id = 432;

-- Check the details of the possible destination addresses to identify Varsha's address.
SELECT *
FROM addresses
WHERE id = '854'
OR id = '4984'
OR id = '484'
OR id = '585';

-- Find the package sent from Anneke's address to Varsha's address and check its contents.
SELECT id, contents
FROM packages
WHERE from_address_id = 432
AND to_address_id = 854;

-- Check the scan history of the package to determine where it was picked up and dropped off.
SELECT *
FROM scans
WHERE package_id = 384;


-- *** The Devious Delivery ***

--  Check for the information using the contents
SELECT *
FROM packages 
WHERE contents LIKE '%duck%';

-- Check the address type of deleviry 
SELECT *
FROM addresses 
WHERE id = '50'; 

-- Check the scans to know is delevired or no 

SELECT *
FROM scans
WHERE package_id = '5098';

-- Cheack what's 384
SELECT *
FROM addresses
WHERE id = 348;

-- *** The Forgotten Gift ***

-- Check for for and to adress ids 

SELECT *  
FROM addresses
WHERE address = '728 Maple Place'
OR address = '109 Tileston Street'; 

-- Check contents of the package 

SELECT contents, id
FROM packages
WHERE from_address_id = '9873';

-- Check for last place the gift has reached 
SELECT * 
FROM scans 
WHERE package_id = '9523';

-- Check what is this address
SELECT *
FROM addresses
WHERE id = '7432';


-- Check driver's name 
SELECT name 
FROM drivers
WHERE id = '17';