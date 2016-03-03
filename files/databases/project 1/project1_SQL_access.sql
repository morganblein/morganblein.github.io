DROP TABLE HOTEL_t 		CASCADE CONSTRAINTS ;
DROP TABLE EMPLOYEE_t 		CASCADE CONSTRAINTS ;
DROP TABLE CUSTOMER_t 		CASCADE CONSTRAINTS ;
DROP TABLE RESERVATION_t 		CASCADE CONSTRAINTS ;
DROP TABLE ROOM_t 		CASCADE CONSTRAINTS ;
DROP TABLE BOOKING_LINE_t 		CASCADE CONSTRAINTS ;


CREATE TABLE HOTEL_t
             (Hotel_ID        number         NOT NULL,
              Hotel_Name      VARCHAR(25)         NOT NULL,
			  Hotel_Address      VARCHAR(30)    ,
			  Hotel_Zip         VARCHAR(9)     ,
CONSTRAINT HOTEL_PK PRIMARY KEY (Hotel_ID));

CREATE TABLE EMPLOYEE_t
             (Employee_ID         VARCHAR(10)    NOT NULL,
	      Employee_Last_Name       VARCHAR(25)         NOT NULL,
		  Employee_First_Name       VARCHAR(25)    ,
		  Employee_Phone_Number       VARCHAR(15)    ,
	      Employee_Address    VARCHAR(30)    ,
          Employee_Zip         VARCHAR(9)     ,
		  Hotel_ID        number(11,0)         NOT NULL,
CONSTRAINT EMPLOYEE_PK PRIMARY KEY (Employee_ID),
CONSTRAINT EMPLOYEE_FK FOREIGN KEY (Hotel_ID) REFERENCES HOTEL_t(Hotel_ID));


CREATE TABLE CUSTOMER_t
             (Customer_ID         number         NOT NULL,
	      Customer_Last_Name       VARCHAR(25)         NOT NULL,
		  Customer_First_Name       VARCHAR(25)    ,
		  Customer_Phone_Number       VARCHAR(15)    ,
	      Customer_Address    VARCHAR(30)    ,
          Customer_Zip         VARCHAR(9)     ,
		  Hotel_ID        number(11,0)         NOT NULL,
CONSTRAINT CUSTOMER_PK PRIMARY KEY (Customer_ID),
CONSTRAINT CUSTOMER_FK FOREIGN KEY (Hotel_ID) REFERENCES HOTEL_t(Hotel_ID));


CREATE TABLE RESERVATION_t
             (Reservation_ID            VARCHAR(10)         NOT NULL,
	      Reservation_invoice   number(9,2)    ,
	      Customer_ID         number (11,0)         NOT NULL,		  
CONSTRAINT RESERVATION_PK PRIMARY KEY (Reservation_ID ),
CONSTRAINT RESERVATION_FK FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER_t(Customer_ID));


CREATE TABLE ROOM_t
             (Room_ID            number (5,0)        NOT NULL,
	      Room_Type       VARCHAR(20)    
			CHECK(Room_Type IN('Twins', 'Queen', 'King', 'Suite', 'King_suite')),			
          Room_Fee            number (7,2)           ,
CONSTRAINT ROOM_PK PRIMARY KEY (Room_ID));

CREATE TABLE BOOKING_LINE_t
             (Reservation_ID         VARCHAR(10)          NOT NULL,
              Room_ID            number (5,0)        NOT NULL,
			  Check_in            VARCHAR(10)        ,
			  Check_out            VARCHAR(10)        ,
CONSTRAINT BOOKING_LINE_PK PRIMARY KEY (Reservation_ID, Room_ID),
CONSTRAINT BOOKING_LINE_FK1 FOREIGN KEY (Reservation_ID) REFERENCES RESERVATION_t(Reservation_ID),
CONSTRAINT BOOKING_LINE_FK2 FOREIGN KEY (Room_ID) REFERENCES ROOM_t(Room_ID));



delete from HOTEL_t;
delete from EMPLOYEE_t;
delete from CUSTOMER_t;
delete from RESERVATION_t;
delete from ROOM_t;
delete from BOOKING_LINE_t

INSERT INTO HOTEL_t  (Hotel_ID, Hotel_Name, Hotel_Address, Hotel_Zip)
VALUES  (01, 'La Reine Astride', '1 place de la republique', '69005');

INSERT INTO EMPLOYEE_t  (Employee_ID, Employee_Last_Name, Employee_First_Name, Employee_Phone_Number, Employee_Address, Employee_Zip, Hotel_ID)
VALUES  (001, 'Jean', 'Francois', '+3361010101010', '1 golden gate ave', '69003', 01);

INSERT INTO CUSTOMER_t  (Customer_ID, Customer_Last_Name, Customer_First_Name, Customer_Phone_Number, Customer_Address, Customer_Zip, Hotel_ID)
VALUES  (001, 'Smith', 'John', '415-000-0000', '1 golden gate ave', '94117', 01);

INSERT INTO RESERVATION_t  (Reservation_ID, Reservation_invoice, Customer_ID)
VALUES  (001, '438.00', 001);

INSERT INTO ROOM_t  (Room_ID, Room_Type, Room_Fee)
VALUES  (315, 'King', '219.00');

INSERT INTO BOOKING_LINE_t  (Reservation_ID, Room_ID, Check_in, Check_out)
VALUES  (001, 315, '10/23/1015', '10/25/1015');

DESC HOTEL_t;
DESC EMPLOYEE_t;
DESC CUSTOMER_t;
DESC RESERVATION_t;
DESC ROOM_t;
DESC BOOKING_LINE_t
