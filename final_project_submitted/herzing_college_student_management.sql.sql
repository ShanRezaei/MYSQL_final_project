-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Oct 12, 2022 at 03:44 AM
-- Server version: 5.7.36
-- PHP Version: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `herzing_college_student_management`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `add_class_rooms`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_class_rooms` (IN `r_room_number` INT(11), IN `r_capacity` INT(11))  BEGIN
	
    # declare instanced variables 
	DECLARE var_room_number INT(11);
	DECLARE var_capacity INT(11) ;
	

   # set instanced variables to class_rooms input
	SET var_room_number = r_room_number;
	SET var_capacity = r_capacity ;
	
    
   # inserting values
    INSERT INTO Class_rooms (room_number, capacity) 
    VALUES (var_room_number , var_capacity );

END$$

DROP PROCEDURE IF EXISTS `add_program`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_program` (IN `p_Program_names` VARCHAR(150), IN `p_duration` VARCHAR(50), IN `p_cost` VARCHAR(50), IN `p_next_start_date` DATETIME, `p_class_room_id` INT)  BEGIN

# declaring instance variables
                DECLARE var_Program_name VARCHAR(50);
	DECLARE var_duration VARCHAR(50);
	DECLARE var_cost VARCHAR(50);
	DECLARE var_next_start_date DATETIME;
                DECLARE var_class_room_id INT;
                DECLARE result TEXT;
    
    SET var_Program_name = p_Program_names;
    SET var_duration = p_duration;
    SET var_cost = p_cost;
    SET var_next_start_date =p_next_start_date;
    SET var_class_room_id=p_class_room_id;
    
    
	INSERT INTO Programs (Program_names, duration, cost, next_start_date, class_room_id) VALUES (var_Program_name, var_duration, var_cost, var_next_start_date, var_class_room_id);
	SET result = CONCAT(var_Program_name,' was successfully added!');
    
	SELECT result AS 'Program result';

END$$

DROP PROCEDURE IF EXISTS `add_student`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_student` (IN `s_First_name` VARCHAR(50), IN `s_Last_name` VARCHAR(50), IN `s_dob` DATETIME, IN `s_Address` VARCHAR(200), IN `s_Email` VARCHAR(200), IN `s_Phone` INT(11), IN `s_status` VARCHAR(50))  BEGIN
	
    # declare instanced variables 
	DECLARE var_firstname VARCHAR(50);
	DECLARE var_lastname VARCHAR(50) ;
	DECLARE var_dob DATETIME;
                DECLARE var_address VARCHAR(200);
	DECLARE var_email VARCHAR(200);
	DECLARE var_phone INT(11);
	DECLARE var_status VARCHAR(50);



   # set instanced variables to student input
	SET var_firstname = s_First_name;
	SET var_lastname = s_Last_name;
	SET var_dob = s_dob;
                SET var_address=s_Address ;
	SET var_email= s_Email;
	SET var_phone=s_Phone ;
	SET var_status= s_status;

    
   # inserting values and setting status to active
    INSERT INTO students (First_name, Last_name, dob, Address,Email,Phone,status) 
    VALUES (var_firstname, var_lastname, var_dob,var_address,var_email,var_phone,var_status);

END$$

DROP PROCEDURE IF EXISTS `add_Student_invoice`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_Student_invoice` (IN `i_student_id` INT, IN `i_balance` INT, IN `i_status` VARCHAR(50))  BEGIN
	
 # declared variables
    DECLARE var_student_id INT ;
   DECLARE var_balance INT ;
    DECLARE var_status VARCHAR(50);
    DECLARE result TEXT;
    
 # set instanced variables to IN para
    SET var_student_id =  i_student_id;
   SET var_balance = i_balance;
    SET var_status = i_status;
    
 # check if student id exists, if so adds a new invoice respectively
    IF(var_student_id = (SELECT id  FROM students WHERE  id = var_student_id))THEN
		SET result =  CONCAT('invoice successfully added for student number ', var_student_id);
        INSERT INTO Student_invoice (student_id, balance, status) 
       VALUES (var_student_id, var_balance, var_status);
	ELSE
		SET result = "The invoice you're trying to add cannot be added due to unknown student";
	END IF;
    
    SELECT result AS 'Invoice result';
    
END$$

DROP PROCEDURE IF EXISTS `add_Student_profile`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_Student_profile` (IN `sp_program_id` INT, IN `sp_enrolment_date` DATETIME, IN `sp_student_id` INT)  BEGIN

# declaring instance variables
                
	DECLARE var_enrolment_date DATETIME;
                DECLARE var_program_id INT;
                DECLARE var_student_id INT;
                DECLARE result TEXT;
    
    
    SET var_enrolment_date  = sp_enrolment_date;
    SET var_program_id=sp_program_id;
    SET var_student_id=sp_student_id;
    
    
	INSERT INTO Student_profile (student_id,program_id, enrolment_date) VALUES (var_student_id,var_program_id,  var_enrolment_date);
	SET result = CONCAT(var_Program_name,' was successfully added!');
    
	SELECT result AS 'Program result';

END$$

DROP PROCEDURE IF EXISTS `deallocate_class_room`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deallocate_class_room` (IN `r_room_number` INT(11))  BEGIN

# declaring instance variable
    DECLARE var_room_number INT(11);
    DECLARE var_id INT;
    DECLARE result TEXT;
   
# setting instance variables
    SET var_room_number = r_room_number;
	
	
 # stores class_room id into instanced variable
    SELECT id INTO var_id
    FROM Class_rooms
    WHERE Class_rooms.room_number LIKE var_room_number  ;
	
    # permanently removing Class_rooms from the Class_rooms table
    IF (var_id = (SELECT id FROM Class_rooms WHERE Class_rooms.room_number LIKE var_room_number  )) THEN
		DELETE FROM Class_rooms WHERE room_number = var_room_number ;
        SET result  = CONCAT(var_room_number, ' has been successfully deleted!');
	ELSE
		SET result  = ' OOPS! Something went wrong, please try again.';
    END IF;
    
    # displays final result of delete procedure
    SELECT result AS 'Deallocation result';

END$$

DROP PROCEDURE IF EXISTS `deallocate_invoice`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deallocate_invoice` (IN `i_id` INT(11))  BEGIN
	
    # declare instance variables
    DECLARE var_id INT;
    DECLARE result TEXT;
    
    # set instanced variables
    SET var_id = i_id;
    
    # checks if id exists in the invoice table, if so deletes the chosen row
    IF(var_id = (SELECT Student_invoice.id FROM Student_invoice WHERE Student_invoice.id = var_id))THEN
		DELETE FROM Student_invoice WHERE Student_invoice.id = var_id;
        SET result = CONCAT('Invoice number ', var_id ,' has been deleted successfully!');
	ELSE
        SET result = 'id does not exist and therefore cannot be deleted';
	END IF;
    
    # displays whether id was found or not
    SELECT result AS 'Deallocation result';

END$$

DROP PROCEDURE IF EXISTS `deallocate_program`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deallocate_program` (IN `p_id` INT)  BEGIN

    DECLARE var_id INT;
    DECLARE result TEXT;
    DECLARE var_Program_name TEXT;
    
    SET var_id = p_id;
    SET var_Program_name = (SELECT Program_names FROM Programs WHERE id = var_id);
    
    IF (var_id = (SELECT id FROM Programs WHERE id = var_id)) THEN
		DELETE FROM Programs  WHERE id = var_id;
        SET result = CONCAT('ID number ', var_id, ' named ', var_Program_name , ' has been sucessfully deleted.');
	ELSE 
		SET result = 'no matches were found.';
	END IF;
    
    SELECT result AS 'Delete row results';

END$$

DROP PROCEDURE IF EXISTS `deallocate_student`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deallocate_student` (IN `s_First_name` VARCHAR(50), IN `s_Last_name` VARCHAR(50), IN `s_dob` DATETIME)  BEGIN

# declaring instance variable
    DECLARE var_firstname VARCHAR(50);
    DECLARE var_lastname VARCHAR(50) ;
    DECLARE var_dob DATETIME;
    DECLARE var_id INT;
    DECLARE result TEXT;
   
    # setting instance variables
	SET var_firstname = s_First_name;
	SET var_lastname = s_Last_name;
	SET var_dob = s_dob;

    
    # stores student id into instanced variable
    SELECT id INTO var_id
    FROM students
    WHERE students.First_name LIKE var_firstname AND students.Last_name LIKE var_lastname  AND  students.dob  LIKE var_dob ;
	
    # permanently removing student from the students table
    IF (var_id = (SELECT id FROM students WHERE students.First_name LIKE var_firstname AND students.Last_name LIKE var_lastname  AND  students.dob  LIKE var_dob)) THEN
		DELETE FROM students WHERE First_name = var_firstname AND Last_name = var_lastname  AND  dob = var_dob;
        SET result  = CONCAT(var_firstname,var_lastname, ' has been successfully deleted!');
	ELSE
		SET result  = ' OOPS! Something went wrong, please try again.';
    END IF;
    
    # displays final result of delete procedure
    SELECT result AS 'Deallocation result';

END$$

DROP PROCEDURE IF EXISTS `deallocate_Student_profile`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deallocate_Student_profile` (IN `sp_id` INT)  BEGIN

    DECLARE var_id INT;
    DECLARE result TEXT;
    DECLARE var_student_id INT;
    
    SET var_id = sp_id;
    SET var_student_id = (SELECT student_id FROM Student_profile WHERE id = var_id);
    
    IF (var_id = (SELECT id FROM Student_profile WHERE id = var_id)) THEN
		DELETE FROM Student_profile  WHERE id = var_id;
        SET result = CONCAT('ID number ', var_id,  ' has been sucessfully deleted.');
	ELSE 
		SET result = 'no matches were found.';
	END IF;
    
    SELECT result AS 'Delete row results';

END$$

DROP PROCEDURE IF EXISTS `find_invoice_by_student_number`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_invoice_by_student_number` (`i_student_id` INT(11))  BEGIN

# declare instance variables
	DECLARE var_id INT;
                DECLARE result TEXT;
    
# store student id into variable
    SET var_id = i_student_id;
    
# displays invoice and invoice details based on student ID
    IF(var_id = (SELECT student_id  FROM Student_invoice )) THEN
		SELECT * FROM Student_invoice;
		
	ELSE
		SET result = 'no matches found, please try again';
	
    END IF;
    	SELECT result;
END$$

DROP PROCEDURE IF EXISTS `search_all_students`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_all_students` ()  BEGIN
	SELECT *
    FROM students
    ORDER BY First_name;
END$$

DROP PROCEDURE IF EXISTS `search_invoice`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_invoice` (IN `i_id` INT(11))  BEGIN 
	DECLARE result TEXT;
	IF((SELECT student_id  FROM student_invoice WHERE id = i_id) IS NOT NULL) THEN
		SELECT *
		FROM student_invoice
		WHERE id = i_id;
	ELSE
		SELECT 'invoice does not exists .';
	END IF;
	


 END$$

DROP PROCEDURE IF EXISTS `search_student`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_student` (IN `s_id` INT(11))  BEGIN

# checks if studentd exists 
	IF((SELECT First_name FROM students WHERE id = s_id) IS NOT NULL) THEN
		SELECT *
		FROM students
		WHERE id = s_id;
	ELSE
		SELECT 'STUDENT does not exists .';
	END IF;
	
END$$

DROP PROCEDURE IF EXISTS `update_class_rooms`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_class_rooms` (IN `r_id` INT, IN `r_room_number` INT(11), IN `r_capacity` INT(11))  BEGIN 
	
    	DECLARE var_room_number INT(11);
	DECLARE var_capacity INT(11) ;
	DECLARE var_id INT DEFAULT 0;	
	DECLARE result TEXT;


    # set instanced variables to class_rooms input
	SET var_room_number = r_room_number;
	SET var_capacity = r_capacity ;
	SET var_id = r_id;
    
    # checks to see if class_rooms exists and enters correct information
	IF(var_id = (SELECT id FROM Class_rooms WHERE id = var_id)) THEN
		IF(var_room_number NOT LIKE (SELECT Class_rooms.room_number FROM Class_rooms WHERE id = var_id)) THEN
			UPDATE Class_rooms SET Class_rooms.room_number = var_room_number WHERE id = var_id;
			SET result= 'Update is done.';
        		END IF;
      		  IF(var_capacity NOT LIKE (SELECT capacity FROM Class_rooms WHERE id = var_id)) THEN
			UPDATE Class_rooms SET Class_rooms.capacity = var_capacity WHERE id = var_id;
			SET result= 'Update is done.';
       		 END IF;
       		 
             ELSE 
                
       	SET result= 'Class_room does not exists .';

            END IF;
    
    # Displays the Class_room update results
    SELECT result AS 'Update results';
    
END$$

DROP PROCEDURE IF EXISTS `update_invoice`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_invoice` (IN `i_id` INT, IN `i_balance` INT, IN `i_student_id` INT)  BEGIN

  # declare instance variables
    DECLARE var_id INT;
    DECLARE var_balance INT(11);
    DECLARE var_student_id INT;
    DECLARE result TEXT;
   
    # sets instanced variables
    SET var_id = i_id;
    SET var_balance =  i_balance;
    SET var_student_id  =  i_student_id;

    
    # checks if student exist, if so updates information respectively
    IF (var_id != (SELECT  id  FROM  Student_invoice WHERE  id = var_id) ) THEN
		SET result = 'invoice does not exist';
	ELSE

		 UPDATE Student_invoice SET  balance=var_balance
                                 WHERE Student_invoice.id = var_id;
         SET result = CONCAT('You have updated the balance on the account of the student with invoice id number ', var_id, ' successfully!');
	END IF;
   SELECT result AS 'Invoice result';
   
END$$

DROP PROCEDURE IF EXISTS `update_program`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_program` (IN `p_id` INT, IN `p_Program_names` VARCHAR(150), IN `p_duration` VARCHAR(50), IN `p_cost` VARCHAR(50), IN `p_next_start_date` DATETIME, `p_class_room_id` INT)  BEGIN
	
    # declaring instance variables

                DECLARE var_id INT;
                DECLARE var_Program_name VARCHAR(50);
	DECLARE var_duration VARCHAR(50);
	DECLARE var_cost VARCHAR(50);
	DECLARE var_next_start_date DATETIME;
                DECLARE var_class_room_id INT;
                DECLARE result TEXT;
  
    
    # assign instanced variables 
    SET var_id = p_id;
    SET var_Program_name = p_Program_names;
    SET var_duration = p_duration;
    SET var_cost = p_cost;
    SET var_next_start_date =p_next_start_date;
    SET var_class_room_id=p_class_room_id;
    
    
    # checks if program exists in the program table
    IF (var_id = (SELECT id FROM Programs WHERE id = var_id)) THEN
		UPDATE Programs SET duration =var_duration, cost = var_cost, next_start_date = var_next_start_date, class_room_id = var_class_room_id  WHERE id LIKE var_id;
		SET result = CONCAT('ID number ', var_id, ' has been successfully updated!');
    ELSE
		SET result = 'The id you provided does not exists.';
	END IF;
    
    # displays the results
    SELECT result AS 'Update program result';
    
END$$

DROP PROCEDURE IF EXISTS `update_student`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_student` (IN `s_id` INT, IN `s_First_name` VARCHAR(50), IN `s_Last_name` VARCHAR(50), IN `s_dob` DATETIME, IN `s_Address` VARCHAR(200), IN `s_Email` VARCHAR(200), IN `s_Phone` INT(11), IN `s_status` VARCHAR(50))  BEGIN 
	
    	DECLARE var_firstname VARCHAR(50);
	DECLARE var_lastname VARCHAR(50) ;
	DECLARE var_dob DATETIME;
                DECLARE var_address VARCHAR(200);
	DECLARE var_email VARCHAR(200);
	DECLARE var_phone INT(11);
	DECLARE var_status VARCHAR(50);
	DECLARE var_id INT DEFAULT 0;	
               DECLARE result TEXT;    


    # set instanced variables to student input
	SET var_firstname = s_First_name;
	SET var_lastname = s_Last_name;
	SET var_dob = s_dob;
                SET var_address=s_Address ;
	SET var_email= s_Email;
	SET var_phone=s_Phone ;
	SET var_status= s_status;
	SET var_id = s_id;
    
    # checks to see if student exists and enters correct information
	IF(var_id = (SELECT id FROM students WHERE id = var_id)) THEN
		IF(var_firstname NOT LIKE (SELECT students.First_name FROM students WHERE id = var_id)) THEN
			UPDATE students SET students.First_name = var_firstname WHERE id = var_id;
                                                SET result = 'UPDATE is done.';
        		END IF;
      		  IF(var_lastname NOT LIKE (SELECT Last_name FROM students WHERE id = var_id)) THEN
			UPDATE students SET students.Last_name = var_lastname WHERE id = var_id;
			SET result = 'UPDATE is done.';
       		 END IF;
       		 IF(var_dob NOT LIKE (SELECT dob FROM students WHERE id = var_id)) THEN
			UPDATE students SET students.dob = var_dob WHERE id = var_id;
			SET result = 'UPDATE is done.';
      		  END IF;
       		 IF(var_address NOT LIKE (SELECT students.Address FROM students WHERE id = var_id)) THEN
			UPDATE students SET students.Address = var_address WHERE id = var_id;
			SET result = 'UPDATE is done.';
        		END IF;
		IF(var_status NOT LIKE (SELECT students.status FROM students WHERE id = var_id)) THEN
			UPDATE students SET students.status = var_status WHERE id = var_id;
			SET result = 'UPDATE is done.';
        		END IF;

		IF(var_email NOT LIKE (SELECT students.Email FROM students WHERE id = var_id)) THEN
			UPDATE students SET students.Email = var_email WHERE id = var_id;
			SET result = 'UPDATE is done.';
        		END IF;
		IF(var_phone NOT LIKE (SELECT students.Phone FROM students WHERE id = var_id)) THEN
			UPDATE students SET students.Phone = var_phone WHERE id = var_id;
			SET result = 'UPDATE is done.';
        		END IF;

             ELSE 
                
       	SET result = 'STUDENT does not exists .';

            END IF;
    
    # Displays the student update results
    SELECT result AS 'Update results';
    
END$$

DROP PROCEDURE IF EXISTS `update_Student_profile`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_Student_profile` (IN `sp_student_id` INT, IN `sp_program_id` INT)  BEGIN
	
    # declaring instance variables

                DECLARE var_student_id INT;
                DECLARE var_program_id INT;
                DECLARE result TEXT;
  
    
    # assign instanced variables 
    SET var_student_id= sp_student_id ;
    SET var_program_id=sp_program_id;
    
    
    # checks if Student_profile exists in the Student_profile table
    IF (var_student_id = (SELECT student_id  FROM Student_profile WHERE student_id  = var_student_id)) THEN
		UPDATE Student_profile SET program_id =var_program_id;
		SET result = CONCAT('ID number ', var_student_id, ' has been successfully updated!');
    ELSE
		SET result = 'The id you provided does not exists.';
	END IF;
    
    # displays the results
    SELECT result AS 'Update Student_profile result';
    
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `Student_invoice_sum`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Student_invoice_sum` (`i_student_id` INT) RETURNS INT(11) BEGIN
  DECLARE number_out INT(11);
  DECLARE id_out INT;
  SET  id_out=i_student_id;

    SELECT SUM(balance) INTO number_out
    FROM Student_invoice
    WHERE student_id = id_out;
  
    RETURN (Student_invoice_sum);
END$$

DROP FUNCTION IF EXISTS `Student_invoice_sum1`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Student_invoice_sum1` (`i_student_id` INT) RETURNS INT(11) BEGIN
  DECLARE number_out INT(11);
  DECLARE id_out INT;
  SET  id_out=i_student_id;

    SELECT SUM(balance) INTO number_out
    FROM Student_invoice
    WHERE student_id = id_out;
  
    RETURN (Student_invoice_sum);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `class_rooms`
--

DROP TABLE IF EXISTS `class_rooms`;
CREATE TABLE IF NOT EXISTS `class_rooms` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `room_number` int(11) UNSIGNED DEFAULT NULL,
  `capacity` int(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `class_rooms`
--

INSERT INTO `class_rooms` (`id`, `room_number`, `capacity`) VALUES
(6, 1, 20),
(7, 2, 15),
(8, 3, 10),
(9, 4, 30),
(10, 5, 0);

--
-- Triggers `class_rooms`
--
DROP TRIGGER IF EXISTS `verifycapacity1`;
DELIMITER $$
CREATE TRIGGER `verifycapacity1` BEFORE INSERT ON `class_rooms` FOR EACH ROW BEGIN
  DECLARE result TEXT;
  IF NEW.capacity IS NOT NULL AND  NEW.capacity > 20 THEN
     
    SET NEW.capacity = 0;

  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifycapacity_update1`;
DELIMITER $$
CREATE TRIGGER `verifycapacity_update1` BEFORE UPDATE ON `class_rooms` FOR EACH ROW BEGIN
  DECLARE result TEXT;
  IF NEW.capacity IS NOT NULL AND  NEW.capacity > 20 THEN
     
     SET NEW.capacity = 0;

  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
CREATE TABLE IF NOT EXISTS `programs` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Program_names` varchar(100) NOT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `cost` varchar(50) NOT NULL,
  `next_start_date` datetime NOT NULL,
  `class_room_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `class_room_id` (`class_room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `programs`
--

INSERT INTO `programs` (`id`, `Program_names`, `duration`, `cost`, `next_start_date`, `class_room_id`) VALUES
(2, 'Programing', '15 months', '20000$', '2023-03-01 00:00:00', 6),
(3, 'Networking', '24 months', '15000$', '2023-03-01 00:00:00', 7),
(4, 'Computer support', '12 months', '10000$', '2023-03-01 00:00:00', 8),
(7, 'programing', ' OOPS! Something went wrong, please try again.', '15000$', '2023-05-01 00:00:00', 1);

--
-- Triggers `programs`
--
DROP TRIGGER IF EXISTS `verifyduration`;
DELIMITER $$
CREATE TRIGGER `verifyduration` BEFORE INSERT ON `programs` FOR EACH ROW BEGIN

DECLARE result TEXT;

  IF NEW.duration IS NOT NULL AND NEW.duration NOT LIKE '15 months' AND NEW.Program_names = 'programing'  THEN 
    SET NEW.duration  = ' OOPS! Something went wrong, please try again.';
  END IF;

 IF NEW.duration IS NOT NULL AND NEW.duration NOT LIKE '24 months' AND NEW.Program_names = 'Networking' THEN 
    SET NEW.duration  = ' OOPS! Something went wrong, please try again.';
  END IF;


IF NEW.duration IS NOT NULL AND  NEW.duration NOT LIKE '12 months'  AND NEW.Program_names = 'Computer_suport' THEN 
    SET NEW.duration  = ' OOPS! Something went wrong, please try again.';
  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifyduration_update`;
DELIMITER $$
CREATE TRIGGER `verifyduration_update` BEFORE UPDATE ON `programs` FOR EACH ROW BEGIN

DECLARE result TEXT;
   IF NEW.duration IS NOT NULL AND NEW.duration >15 AND NEW.Program_names = 'programing'  THEN 
    SET NEW.duration = ' OOPS! Something went wrong, please try again.';
  END IF;

 IF NEW.duration IS NOT NULL AND NEW.duration >24 AND NEW.Program_names = 'Networking' THEN 
    SET NEW.duration  = ' OOPS! Something went wrong, please try again.';
  END IF;


IF NEW.duration IS NOT NULL AND  NEW.duration >12  AND NEW.Program_names = 'Computer_suport' THEN 
    SET NEW.duration  = ' OOPS! Something went wrong, please try again.';
  END IF;

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifynext_start_date`;
DELIMITER $$
CREATE TRIGGER `verifynext_start_date` BEFORE INSERT ON `programs` FOR EACH ROW BEGIN
  DECLARE result TEXT;
  IF NEW.next_start_date IS NOT NULL AND NEW.next_start_date != '2022-03-01 00:00:00'   THEN
    SET NEW.next_start_date  = ' 1900-01-01 00:00:00';
  END IF;

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifynext_start_date_update`;
DELIMITER $$
CREATE TRIGGER `verifynext_start_date_update` BEFORE UPDATE ON `programs` FOR EACH ROW BEGIN
  DECLARE result TEXT;
  IF NEW.next_start_date IS NOT NULL    AND NEW.next_start_date != '2022-03-01 00:00:00'  THEN
 SET NEW.next_start_date  = ' 1900-01-01 00:00:00';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
CREATE TABLE IF NOT EXISTS `students` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `First_name` varchar(50) NOT NULL,
  `Last_name` varchar(50) NOT NULL,
  `dob` datetime NOT NULL,
  `Address` varchar(200) NOT NULL,
  `Email` varchar(200) DEFAULT NULL,
  `Phone` int(11) UNSIGNED DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `First_name`, `Last_name`, `dob`, `Address`, `Email`, `Phone`, `status`) VALUES
(2, 'Fatty', 'Bernes', '1890-02-01 00:00:00', '420 rue drummond', 'lucy@yahoo.com', 512638, 'Active'),
(3, 'Lucy', 'Bernes', '1991-02-01 00:00:00', '51000 rue drummond', 'lucy@yahoo.com', 512638, 'Active'),
(4, 'mehr', 'reza', '1985-02-01 00:00:00', '51000 rue forestier', 'mehr@yahoo.com', 512665, 'suspended'),
(5, 'farhad', 'reza', '1977-02-01 00:00:00', '3200 rue forestier', 'farh@yahoo.com', 5612665, 'suspended'),
(6, 'MEGY', 'VOOL', '1980-02-01 00:00:00', '620 rue drummond', 'MEGGY@yahoo.com', 57712638, 'Active'),
(7, 'Lucy', 'Bernes', '1990-02-01 00:00:00', '420 rue drummond', 'lucy.yahoo.com', 512638, 'Active'),
(8, 'Lucy', 'Bernes', '1990-02-01 00:00:00', '420 rue drummond', 'lucy@yahoo.com', 512638, 'Active'),
(9, 'SHAG', 'yerin', '1985-02-01 00:00:00', '420 rue drummond', 'mike@yahoo.com', 51277638, 'Active'),
(10, 'SHAG', 'yerin', '2020-02-01 00:00:00', '420 rue drummond', 'mike@yahoo.com', 51277638, 'Active'),
(11, 'sirin', 'farash', '2022-02-01 00:00:00', '420 rue drummond', 'lolayahoo.com', 51277638, 'Active'),
(12, 'SHIM', 'Fathi', '2020-02-01 00:00:00', '420 rue drummond', 'lucy@yahoo.com', 512638, 'Active'),
(13, 'morid', 'naghmi', '2020-02-01 00:00:00', '4532 rue drummond', 'sisi@yahoo.com', 51222638, 'Active'),
(14, 'malek', 'shahry', '1975-02-01 00:00:00', '420 rueforin', ' wrong email format', 51288638, 'Active'),
(15, 'shery', 'kernes', '1800-01-01 00:00:00', '580 rue ellen', 'shery@yahoo.com', 51662638, 'Active');

--
-- Triggers `students`
--
DROP TRIGGER IF EXISTS `verifydob_student`;
DELIMITER $$
CREATE TRIGGER `verifydob_student` BEFORE INSERT ON `students` FOR EACH ROW BEGIN
DECLARE result TEXT;
 IF NEW.dob > '2012-01-01 00:00:00' THEN SET result= 'dob is not allowed';
END IF; 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifydob_student1`;
DELIMITER $$
CREATE TRIGGER `verifydob_student1` BEFORE INSERT ON `students` FOR EACH ROW BEGIN
DECLARE result TEXT;
 IF NEW.dob > '2012-01-01 00:00:00' THEN 
 SET NEW.dob = NULL;
END IF; 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifydob_update`;
DELIMITER $$
CREATE TRIGGER `verifydob_update` BEFORE UPDATE ON `students` FOR EACH ROW BEGIN
DECLARE result TEXT;
  IF NEW.dob > '2012-01-01 00:00:00' THEN 
SET NEW.dob = NULL; 
END IF; 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifyemail`;
DELIMITER $$
CREATE TRIGGER `verifyemail` BEFORE INSERT ON `students` FOR EACH ROW BEGIN

DECLARE result TEXT;
  IF NEW.email IS NOT NULL AND NEW.email  NOT LIKE '%@%.%' THEN
    SET NEW.email = ' wrong email format';
  END IF;


END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifyemail_update`;
DELIMITER $$
CREATE TRIGGER `verifyemail_update` BEFORE UPDATE ON `students` FOR EACH ROW BEGIN
 DECLARE result TEXT;
  IF NEW.email IS NOT NULL AND NEW.email  NOT LIKE '%@%.%' THEN
    SET NEW.email = ' wrong email format';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `student_invoice`
--

DROP TABLE IF EXISTS `student_invoice`;
CREATE TABLE IF NOT EXISTS `student_invoice` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` int(10) UNSIGNED NOT NULL,
  `balance` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Triggers `student_invoice`
--
DROP TRIGGER IF EXISTS `verifystatus`;
DELIMITER $$
CREATE TRIGGER `verifystatus` BEFORE INSERT ON `student_invoice` FOR EACH ROW BEGIN

  DECLARE result TEXT;
  IF  NEW.status IS NOT NULL  AND  NEW.status != 'Active'  AND  NEW.status != 'Graduated'   AND  NEW.status != 'Suspended'  THEN
     
     SET NEW.status = ' OOPS! Something went wrong, please try again.'; 

  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifystatus_update`;
DELIMITER $$
CREATE TRIGGER `verifystatus_update` BEFORE UPDATE ON `student_invoice` FOR EACH ROW BEGIN
  DECLARE result TEXT;
  IF  NEW.status IS NOT NULL  AND  NEW.status != 'Active'  AND  NEW.status != 'Graduated'   AND  NEW.status != 'Suspended'  THEN
     
     SET NEW.status  = ' OOPS! Something went wrong, please try again.'; 

  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `student_profile`
--

DROP TABLE IF EXISTS `student_profile`;
CREATE TABLE IF NOT EXISTS `student_profile` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` int(10) UNSIGNED NOT NULL,
  `program_id` int(10) UNSIGNED NOT NULL,
  `enrolment_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `program_id` (`program_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Triggers `student_profile`
--
DROP TRIGGER IF EXISTS `verifyprogram_id`;
DELIMITER $$
CREATE TRIGGER `verifyprogram_id` BEFORE INSERT ON `student_profile` FOR EACH ROW BEGIN
 DECLARE result TEXT;
  IF   NEW.program_id  IS NOT NULL AND  NEW.program_id != 1 AND NEW.program_id != 2  AND NEW.program_id != 3   THEN
    SET NEW.program_id = 0;
  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `verifyprogram_id_update`;
DELIMITER $$
CREATE TRIGGER `verifyprogram_id_update` BEFORE UPDATE ON `student_profile` FOR EACH ROW BEGIN
  DECLARE result TEXT;
  IF   NEW.program_id  IS NOT NULL AND  NEW.program_id != 1 AND NEW.program_id != 2  AND NEW.program_id != 3   THEN
    SET NEW.program_id = 0;
  END IF;

END
$$
DELIMITER ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `programs`
--
ALTER TABLE `programs`
  ADD CONSTRAINT `programs_ibfk_1` FOREIGN KEY (`class_room_id`) REFERENCES `class_rooms` (`id`);

--
-- Constraints for table `student_invoice`
--
ALTER TABLE `student_invoice`
  ADD CONSTRAINT `student_invoice_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`);

--
-- Constraints for table `student_profile`
--
ALTER TABLE `student_profile`
  ADD CONSTRAINT `student_profile_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
