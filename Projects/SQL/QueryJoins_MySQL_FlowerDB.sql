#The following was performed in MySQL Workbench, with a pre-defined, pre-populated database provided by Toronto's Metropolitan University's
#Chang School of Continuing Education. 

#Run some standard queries
	
SELECT * FROM flowers;

SELECT * FROM flowers
WHERE color = 'Purple';

SELECT * FROM flowers 
ORDER BY FamilyID DESC;

SELECT FlowerName, Season FROM flowers
WHERE Color = 'White' AND FamilyID = 12;

SELECT * FROM customers
WHERE Address LIKE '%Oshawa%' OR Address LIKE '%Richmond%';

SELECT * FROM flowers
WHERE Season IN ('Spring', 'Summer')
order by Season asc;

SELECT COUNT(Color) FROM flowers
WHERE Color = 'White';

SELECT Season, COUNT(FlowerID)
FROM flowers
GROUP BY Season;

SELECT * FROM flowershopinventory
WHERE QuantityInStock BETWEEN 10 AND 20
ORDER BY ShopID;

#Running the forward engineering script populated the database and tables, but there are no key pairs. 

ALTER TABLE flowers 
ADD constraint fk_family_id FOREIGN KEY(FamilyID)
REFERENCES families(FamilyID);

ALTER TABLE flowershopinventory
ADD CONSTRAINT fk_flowershopinventory_shops FOREIGN KEY (ShopID) REFERENCES shops (ShopID),
ADD CONSTRAINT fk_flowershopinventory_flowers1 FOREIGN KEY (FlowerID) REFERENCES flowers (FlowerID);

ALTER TABLE orders
ADD CONSTRAINT fk_customers_orders FOREIGN KEY (CustomerID) REFERENCES customers (CustomerID),
ADD CONSTRAINT fk_customers_shops FOREIGN KEY (ShopID) REFERENCES shops (ShopID);

#Run join queries, nested queries

#Finding Spring time flowers and their family name
	
SELECT Flo.FlowerID, Fam.FamilyID, Fam.FamilyName, Flo.FlowerName, Flo.Season
FROM flowers as Flo
JOIN
families as Fam 
ON Fam.FamilyID = Flo.FamilyID
WHERE Season = 'Spring';

#Finding all flowers that bloom in the spring but are not part of the Asteraceae family.

SELECT Flo.FlowerID, Flo.FlowerName, Flo.Season, Fam.FamilyName 
FROM flowers AS Flo LEFT OUTER JOIN families as Fam
ON Flo.FamilyID = Fam.FamilyID
WHERE Fam.FamilyName <> 'Asteraceae'
AND
Flo.Season = 'Spring'
Limit 10;

#Finding inventory of spring flowers not in the Asteraceae family

SELECT Flo.FlowerName, Fam.FamilyName, Flo.Season, I.ShopID, I.QuantityInStock
FROM flowers as FLO 
LEFT JOIN families as Fam ON Flo.FamilyID = Fam.FamilyID
LEFT JOIN flowershopinventory as I ON Fam.FamilyID = I.FamilyID
WHERE Fam.FamilyName <> 'Asteraceae'
AND
Flo.Season = 'Spring';

#Returning a list of shops that have summer flowers in stock with an inventory larger than 15

SELECT *
FROM shops as S
WHERE S.ShopID IN (SELECT I.QuantityInStock
					FROM flowershopinventory as I
                    LEFT JOIN flowers as Flo ON I.FlowerID = Flo.FlowerID
                    WHERE Flo.Season = 'Summer'
                    AND
                    QuantityInStock > 15);
                    
              
#Finding the customer with the most orders

Select C.CustomerName, COUNT(O.OrderID)
FROM customers AS C LEFT OUTER JOIN orders as O
ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerName
ORDER BY COUNT(O.OrderID) desc
LIMIT 1;

#Returning the shops the most frequent customer orders from

SELECT Cus.CustomerName, O.OrderID, Sh.ShopName, Sh.Location
FROM customers as Cus 
LEFT JOIN orders as O ON Cus.CustomerID = O.CustomerID
LEFT JOIN shops as Sh ON O.ShopID = Sh.ShopID
WHERE Cus.CustomerName IN (SELECT C.CustomerName
							FROM customers AS C LEFT OUTER JOIN orders as O
							ON C.CustomerID = O.CustomerID
							GROUP BY C.CustomerName
                            HAVING COUNT(O.OrderID) > 4);
