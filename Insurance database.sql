USE newdatabase;

create table person (driver_id varchar(10),
name varchar(20),
address varchar(30),
primary key(driver_id));

INSERT INTO person (driver_id, name, address) VALUES
('D001', 'John Doe', '123 Elm St, New York'),
('D002', 'Jane Smith', '456 Oak Rd, Los Angeles'),
('D003', 'Michael Brown', '789 Pine Ave, Chicago'),
('D004', 'Emily Davis', '321 Maple Dr, Houston'),
('D005', 'David Wilson', '654 Cedar Ln, Phoenix');

select * from person;
drop table car;
create table car(reg_num varchar(10),model varchar(30),year int, primary
key(reg_num));

INSERT INTO car (reg_num, model, year) VALUES
('KA01-1234', 'Honda Civic', 2022),
('DL03-5678', 'Toyota Camry', 2023),
('MH12-9012', 'Ford Mustang', 2021),
('KA05-3456', 'Tesla Model 3', 2024),
('DL01-7890', 'Hyundai i20', 2020);

select * from car;

create table accident(report_num int, accident_date date, location
varchar(20),primary key(report_num));
drop table accident ;

INSERT INTO accident (report_num, accident_date, location) VALUES 
(101, '2026-01-15', 'MG Road'),
(102, '2026-02-28', 'Indiranagar'),
(103, '2026-05-12', 'Jayanagar'),
(104, '2026-08-19', 'Whitefield'),
(105, '2026-10-05', 'Koramanagala');

select * from accident;
drop table owns ;
create table owns(driver_id varchar(10),reg_num varchar(10),
primary key(driver_id, reg_num),
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num));

INSERT INTO owns (driver_id, reg_num) VALUES 
('D001', 'KA01-1234'),
('D002', 'DL03-5678'),
('D003', 'MH12-9012'),
('D004', 'KA05-3456'),
('D005', 'DL01-7890');

select * from accident;
drop table owns ;
create table participated(driver_id varchar(10), reg_num varchar(10),

report_num int, damage_amount int,

primary key(driver_id, reg_num, report_num),

foreign key(driver_id) references person(driver_id),

foreign key(reg_num) references car(reg_num),

foreign key(report_num) references accident(report_num));

select * from participated;
update participated set damage_amount=25000

where reg_num='KA053408' and report_num=12;

select count(distinct driver_id) CNT

from participated a, accident b

where a.report_num=b.report_num and b.accident_date like '%08';

insert into accident values(16,'2008-03-08','Domlur');

select * from accident;
SELECT * FROM PARTICIPATED ORDER BY damage_amount DESC;

SELECT AVG(damage_amount) FROM PARTICIPATED;

DELETE FROM PARTICIPATED 
WHERE damage_amount < (
    SELECT avg_damage FROM (
        SELECT AVG(damage_amount) AS avg_damage FROM PARTICIPATED
    ) AS temp
);

SELECT name 
FROM person a, participated b 
WHERE a.driver_id = b.driver_id 
  AND b.damage_amount > (SELECT AVG(damage_amount) FROM participated);

-- Replace 'insurance_db' with your actual database schema name if it's different
USE bhimanna; 

SELECT MAX(damage_amount) AS maximum_damage 
FROM PARTICIPATED;

