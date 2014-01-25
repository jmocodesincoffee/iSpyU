<?php

session_start();

$connect = mysql_connect("127.0.0.1:3306","opencv","opencv");
mysql_select_db("opencv_development");

$u = $_POST['username'];


$get_photo = mysql_query("SELECT preview_path, persons_personid FROM photo_db WHERE last_used='1' AND users_username='$u'");

$all_photos = array();
$result = array();

while($row=mysql_fetch_array($get_photo))
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
	
	
	
	$all_photos[] = array('preview_path' => $path, 'persons_personid' => $person, 'firstnm' => $fn, 'lastnm' => $ln, 'age' => $age, 'location' => $loc, 'notes' => $not);
}

$result['photos'] = $all_photos;
$pathtodir = 'json/';
$jsonfile = $pathtodir . $u . '.json';

$fp = fopen($jsonfile, 'w');
fwrite($fp, json_encode($result));
fclose($fp);

echo '1';

mysql_close($connect);


?>