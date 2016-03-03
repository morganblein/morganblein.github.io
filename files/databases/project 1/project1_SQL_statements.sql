DROP TABLE HOTEL_t 		CASCADE CONSTRAINTS ;
DROP TABLE EMPLOYEE_t 		CASCADE CONSTRAINTS ;
DROP TABLE CUSTOMER_t 		CASCADE CONSTRAINTS ;
DROP TABLE RESERVATION_t 		CASCADE CONSTRAINTS ;
DROP TABLE ROOM_t 		CASCADE CONSTRAINTS ;
DROP TABLE BOOKING_LINE_t 		CASCADE CONSTRAINTS ;


CREATE TABLE HOTEL_t
             (Hotel_ID        number         NOT NULL,
              Hotel_Name      VARCHAR2(25)         NOT NULL,
			  Hotel_Address      VARCHAR2(30)    ,
			  Hotel_Zip         VARCHAR2(9)     ,
CONSTRAINT HOTEL_PK PRIMARY KEY (Hotel_ID));

CREATE TABLE EMPLOYEE_t
             (Employee_ID         VARCHAR2(10)    NOT NULL,
	      Employee_Last_Name       VARCHAR2(25)         NOT NULL,
		  Employee_First_Name       VARCHAR2(25)    ,
		  Employee_Phone_Number       VARCHAR2(15)    ,
	      Employee_Address    VARCHAR2(30)    ,
          Employee_Zip         VARCHAR2(9)     ,
		  Hotel_ID        number(11,0)         NOT NULL,
CONSTRAINT EMPLOYEE_PK PRIMARY KEY (Employee_ID),
CONSTRAINT EMPLOYEE_FK FOREIGN KEY (Hotel_ID) REFERENCES HOTEL_t(Hotel_ID));


CREATE TABLE CUSTOMER_t
             (Customer_ID         number         NOT NULL,
	      Customer_Last_Name       VARCHAR2(25)         NOT NULL,
		  Customer_First_Name       VARCHAR2(25)    ,
		  Customer_Phone_Number       VARCHAR2(15)    ,
	      Customer_Address    VARCHAR2(30)    ,
          Customer_Zip         VARCHAR2(9)     ,
		  Hotel_ID        number(11,0)         NOT NULL,
CONSTRAINT CUSTOMER_PK PRIMARY KEY (Customer_ID),
CONSTRAINT CUSTOMER_FK FOREIGN KEY (Hotel_ID) REFERENCES HOTEL_t(Hotel_ID));


CREATE TABLE RESERVATION_t
             (Reservation_ID            VARCHAR2(10)         NOT NULL,
	      Reservation_invoice   number(9,2)    ,
	      Customer_ID         number (11,0)         NOT NULL,		  
CONSTRAINT RESERVATION_PK PRIMARY KEY (Reservation_ID ),
CONSTRAINT RESERVATION_FK FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER_t(Customer_ID));


CREATE TABLE ROOM_t
             (Room_ID            number (5,0)        NOT NULL,
	      Room_Type       VARCHAR2(20)    
			CHECK(Room_Type IN('Twins', 'Queen', 'King', 'Suite', 'King_suite')),			
          Room_Fee            number (7,2)           ,
CONSTRAINT ROOM_PK PRIMARY KEY (Room_ID));

CREATE TABLE BOOKING_LINE_t
             (Reservation_ID         VARCHAR2(10)          NOT NULL,
              Room_ID            number (5,0)        NOT NULL,
			  Check_in            VARCHAR2(10)        ,
			  Check_out            VARCHAR2(10)        ,
CONSTRAINT BOOKING_LINE_PK PRIMARY KEY (Reservation_ID, Room_ID),
CONSTRAINT BOOKING_LINE_FK1 FOREIGN KEY (Reservation_ID) REFERENCES RESERVATION_t(Reservation_ID),
CONSTRAINT BOOKING_LINE_FK2 FOREIGN KEY (Room_ID) REFERENCES ROOM_t(Room_ID));



delete from HOTEL_t;
delete from EMPLOYEE_t;
delete from CUSTOMER_t;
delete from RESERVATION_t;
delete from ROOM_t;
delete from BOOKING_LINE_t


DESC HOTEL_t;
DESC EMPLOYEE_t;
DESC CUSTOMER_t;
DESC RESERVATION_t;
DESC ROOM_t;
DESC BOOKING_LINE_t
