CREATE DATABASE books;
USE books;


-- CREATION DES TABLES

CREATE TABLE users(
id_users INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
firstname VARCHAR(50) NOT NULL,
lastname VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL UNIQUE,
`password` VARCHAR(100) NOT NULL
)ENGINE=InnoDB;

CREATE TABLE book(
id_book INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
title VARCHAR(50) NOT NULL,
`description` TEXT NOT NULL,
publication_date DATE NOT NULL,
author VARCHAR(50) NOT NULL,
id_category INT,
id_users INT
)ENGINE=InnoDB;

CREATE TABLE category(
id_category INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR(50) NOT NULL
)ENGINE=InnoDB;


-- AJOUT DES CONTRAINTES DE CLE ETRANGERE

ALTER TABLE book
ADD CONSTRAINT fk_category
FOREIGN KEY (id_category)
REFERENCES category(id_category);

ALTER TABLE book
ADD CONSTRAINT fk_users
FOREIGN KEY (id_users)
REFERENCES users(id_users);


-- AJOUT DES CONTRAINTES DE VERIFICATION

ALTER TABLE users
ADD CONSTRAINT CK_Firstname_Minlength
CHECK (LENGTH(firstname) >= 2);

ALTER TABLE users
ADD CONSTRAINT CK_Lastname_Minlength
CHECK (LENGTH(lastname) >= 2);

ALTER TABLE book
ADD CONSTRAINT CK_Title_Minlength
CHECK (LENGTH(title) >= 3);

ALTER TABLE book
ADD CONSTRAINT CK_description
CHECK (LENGTH(`description`) > 0 AND LENGTH(`description`) <= 500 );



-- REMPLISSAGE DES TABLES

INSERT INTO category(`name`) VALUES ('Roman'),('SF'),('fantastique'),('biopic'),('thriller');

INSERT INTO book (title,`description`, publication_date, author, id_category)
	VALUES ("titre1", "description1", "2025-06-01","auteur1",1),
		   ("titre2", "description2", "2025-06-02","auteur2",2),
           ("titre3", "description3", "2025-06-03","auteur3",3),
           ("titre4", "description4", "2025-06-04","auteur4",4),
           ("titre5", "description5", "2025-06-05","auteur5",5),
           ("titre6", "description6", "2025-06-06","auteur6",1),
           ("titre7", "description7", "2025-06-07","auteur7",2),
           ("titre8", "description8", "2025-06-08","auteur8",3),
           ("titre9", "description9", "2025-06-09","auteur9",4),
           ("titre10", "description10", "2025-06-10","auteur10",5),
           ("titre11", "description11", "2025-06-11","auteur11",1),
           ("titre12", "description12", "2025-06-12","auteur12",2),
           ("titre13", "description13", "2025-06-13","auteur13",3),
           ("titre14", "description14", "2025-06-14","auteur14",4),
           ("titre15", "description15", "2025-06-15","auteur15",5);
           
INSERT INTO users(firstname, lastname, email, `password`) 
	VALUES ("firstname1", "lastname1", "email1@mail.com","password1"),
		   ("firstname2", "lastname2", "email2@mail.com","password2"),
           ("firstname3", "lastname3", "email3@mail.com","password3");
           
           
-- ASSOCIATION ENTRE LIVRES ET UTILISATEURS
           
UPDATE book SET id_users = 1 WHERE id_book = 1;
UPDATE book SET id_users = 1 WHERE id_book = 2;
UPDATE book SET id_users = 1 WHERE id_book = 3;
UPDATE book SET id_users = 1 WHERE id_book = 4;
UPDATE book SET id_users = 1 WHERE id_book = 5;
UPDATE book SET id_users = 2 WHERE id_book = 6;
UPDATE book SET id_users = 2 WHERE id_book = 7;
UPDATE book SET id_users = 2 WHERE id_book = 8;
UPDATE book SET id_users = 2 WHERE id_book = 9;
UPDATE book SET id_users = 2 WHERE id_book = 10;
UPDATE book SET id_users = 3 WHERE id_book = 11;
UPDATE book SET id_users = 3 WHERE id_book = 12;
UPDATE book SET id_users = 3 WHERE id_book = 13;
UPDATE book SET id_users = 3 WHERE id_book = 14;
UPDATE book SET id_users = 3 WHERE id_book = 15;


-- CREATION DE DROITS

GRANT SELECT ON *.* TO 'Utilisateur'@'%';
GRANT INSERT, UPDATE, DELETE ON users TO 'Utilisateur'@'%';
GRANT INSERT, UPDATE, DELETE ON book TO 'Utilisateur'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE ON *.* TO 'Admin'@'%';

FLUSH PRIVILEGES;


-- REQUETES DE CONSULTATION

SELECT id_users, firstname, lastname, email FROM users;
SELECT id_book, title, `description`, publication_date FROM book ORDER BY title ASC, publication_date ASC;
SELECT id_book, title, `description`, publication_date, author, category.`name`AS category FROM book INNER JOIN category ON book.id_category = category.id_category;
SELECT id_book, title, `description`, publication_date, author, category.`name`AS category, firstname, lastname FROM book INNER JOIN category ON book.id_category = category.id_category INNER JOIN users ON book.id_users = users.id_users WHERE firstname = 'firstname1' AND lastname = 'lastname1';

-- REQUETE DE PROCEDURE

DELIMITER $$ 

CREATE PROCEDURE `creationUser`( 
	IN new_firstname VARCHAR(50),
	IN new_lastname VARCHAR(50),
	IN new_email VARCHAR(50), 
	IN new_password VARCHAR(100) 
) 
BEGIN 
START TRANSACTION;
	IF (SELECT id_utilisateur FROM utilisateur WHERE email = new_email ) > 0 THEN ROLLBACK; 
		SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Le compte existe déjà en BDD';
	ELSE 
		INSERT INTO utilisateur(firstname, lastname, email, `password`) 
		VALUE(new_firstname, new_lastname, new_email, new_password); 
		COMMIT; 
	END IF; 
END;
