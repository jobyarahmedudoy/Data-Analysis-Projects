# MySQL Triggers

## Before insert trigger

DELIMITER //

CREATE TRIGGER triggers.age_insert_testing
BEFORE INSERT ON triggers.customers
FOR EACH ROW
BEGIN
    IF NEW.age < 0 THEN
        SET NEW.age = 0;
    END IF;
END //

DELIMITER ;


## after insert trigger

create table triggers.customers1
(
id INT auto_increment primary key,
name varchar(50) not null,
email varchar(30),
birthdate date
);

create table triggers.message
(
id INT auto_increment,
message_ID INT,
message varchar(200) NOT NULL,
primary key (id,message_ID)
);


DELIMITER //
CREATE TRIGGER dob_null_check
after insert on customers1
for each row
begin
if new.birthdate is null then
insert into message(message_ID,message)
values(new.id,concat('Hi', new.name, ',Please enter your Date of birth'));
end if;
end //
DELIMITER ;


insert into customers1(name,email,birthdate)
values('Asif','abc@gmail.com','1996-10-24'),
('Rock','rock@gmail.com',NULL);

select * from message;


## Before update trigger

create table employees
(
emp_id INT primary key,
emp_name varchar(25),
age INT,
Salary float);

insert into employees
values(101,"Jimmy",35,70000),
(102,"Shane",30,55000),
(103,"Marry",28,62000),
(104,"Dwane",37,57000),
(105,"Sara",32,72000),
(106,"Ammy",35,80000),
(107,"Jack",40,100000);



DELIMITER //
CREATE TRIGGER updte_trigger
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.Salary = 70000 THEN 
        SET NEW.Salary = 40000;
    ELSEIF NEW.Salary < 70000 THEN 
        SET NEW.Salary = 1000;
    END IF;
END//
DELIMITER ;


## before delete trigger

CREATE TABLE staffs (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(100),
    position VARCHAR(50),
    salary INT
);


INSERT INTO staffs (staff_id, staff_name, position, salary) VALUES
(101, 'Rahim', 'Manager', 80000),
(102, 'Karim', 'Supervisor', 60000),
(103, 'Hasan', 'Clerk', 35000);


DELIMITER //

CREATE TRIGGER before_delete_staff
BEFORE DELETE ON staffs
FOR EACH ROW
BEGIN
    INSERT INTO staffs_backup (staff_id, staff_name, position, salary)
    VALUES (OLD.staff_id, OLD.staff_name, OLD.position, OLD.salary);
END //

DELIMITER ;

CREATE TABLE staffs_backup (
    staff_id INT,
    staff_name VARCHAR(100),
    position VARCHAR(50),
    salary INT,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);






DELETE FROM staffs WHERE staff_id = 102;


SELECT * FROM staffs_backup;



