<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>



<?php

session_start();

$connect = mysql_connect("127.0.0.1:3306","opencv","opencv");
mysql_select_db("opencv_development");


$personid = $_POST['personid'];
$firstname = $_POST['firstname'];
$lastname = $_POST['lastname'];
$age = $_POST['age'];
$location = $_POST['location'];
$notes = $_POST['notes'];


mysql_query("UPDATE persons SET firstnm = '$firstname', lastnm = '$lastname', age = '$age', location = '$location', notes = '$notes' WHERE personid = '$personid'");




mysql_close($connect);


?>

</body>
</html>