<?php
$con = mysql_connect("127.0.0.1:3306", "opencv", "opencv") or  die('Sorry, could not connect to server');
mysql_select_db("opencv_development", $con) or die('Sorry, could not connect to database');
$imagefn = $_GET['imagefn'];
$query = "SELECT firstnm,lastnm,timestamp,age,birthday from persons where imagefn = $imagefn";
$result = mysql_query($query) or die('Sorry, could not find recipe requested');
$row = mysql_fetch_array($result, MYSQL_ASSOC) or die('No records retrieved');
$firstnm = $row['firstnm'];
$lastnm = $row['lastnm'];
$timestamp = $row['timestamp'];
$age = $row['age'];
$birthday = $row['birthday'];
//$ingredients = nl2br($ingredients);
//$directions = nl2br($directions);
echo "<h2>$firstnm $lastnm</h2>\n";
echo "$age <br><br>\n";
echo $birthday . "<br><br>\n";
echo "<h3>Timestamp: $timestamp</h3>\n";


?>
