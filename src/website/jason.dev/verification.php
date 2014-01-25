<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>



<?php



$connect = mysql_connect("127.0.0.1:3306","opencv","opencv");
mysql_select_db("opencv_development");

$u = $_GET['username'];

$getVerified = mysql_query("SELECT persons_personid, preview_path FROM photo_db WHERE verified = 0 ORDER BY photoid DESC");

$confirm = array();
$result = array();

while($row=mysql_fetch_array($getVerified))
{	
	$path = $row['preview_path'];
	$person = $row['persons_personid'];
	
	$get_person = mysql_query("SELECT firstnm, lastnm, age, location, notes FROM persons WHERE personid = '$person'");
	$row2 = mysql_fetch_array($get_person);
	
	$fn = $row2['firstnm'];
	$ln = $row2['lastnm'];
	$age = $row2['age'];
	$loc = $row2['location'];
	$not = $row2['notes'];
	
	
	
	$confirm[] = array('preview_path' => $path, 'persons_personid' => $person, 'firstnm' => $fn, 'lastnm' => $ln, 'age' => $age, 'location' => $loc, 'notes' => $not);
	
	
	
}

$result['verify'] = $confirm;

$pathtodir = 'json/';
$jsonfile = $pathtodir . $u . '_verification.json';

$fp = fopen($jsonfile, 'w');
fwrite($fp, json_encode($result));
fclose($fp);

echo 'Success';



mysql_close($connect);






?>













</body>
</html>