<?php
$connect = mysql_connect("127.0.0.1:3306","opencv","opencv");
mysql_select_db("opencv_development");

$u = $_GET['username'];
$pw = $_GET['password'];

$check = "SELECT username, password FROM users WHERE username='$u' AND password= PASSWORD('$pw')";



$login = mysql_query($check, $connect) or die('error:)');


if (mysql_num_rows($login) == 1) {
$row = mysql_fetch_assoc($login);
echo 'Yes';exit;


} else {


echo 'No';exit;

}

mysql_close($connect);


?>