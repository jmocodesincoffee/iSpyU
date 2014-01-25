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

//assuming upload.php and upload folder are in the same dir
$uploaddir = 'images/proc_images/';
$uploadedfile = basename($_FILES['uploadedfile']['name']);
//$uploadfile = $uploaddir . $file;
//$uploadfile = $file;
$stamp = date("YmdHis");
$random = rand(0, 999);
$u = $_POST['username'];

if($_FILES['uplaodedfile']['type'] = "image/jpeg")
{
	$ext = ".jpg";
}
else if($_FILES['uploadedfile']['type'] = "image/png")
{
	$ext = ".png";
}

$newName = $uploaddir . $u . '/' . $stamp . $random . $ext;

/*
if ($_FILES['uploadedfile']['size']> 300000)     //Limiting image at 300K
{
    exit("Your file is too large."); 
}
*/
// Add support here for PNG files:
if ((!($_FILES['uploadedfile']['type'] = "image/png")) &&
	(!($_FILES['uploadedfile']['type'] = "image/jpeg")))
	
{
    exit; 
}

if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $newName)) {
    //echo "The file ".  basename( $_FILES['uploadedfile']['name']). " has been uploaded";
} else{
    //echo "There was an error uploading the file, please try again!";
}

mysql_query("UPDATE photo_db SET last_used = 0 WHERE users_username='$u'");



echo shell_exec("./opencv '$newName' '$u'");

/*

$get_photo = mysql_query("SELECT photo_path, persons_personid FROM photo_db WHERE last_used='1' AND users_username='$u'");



$all_photos = array();
$result = array();

while($row=mysql_fetch_array($get_photo))
{	
	$path = $row['photo_path'];
	$person = $row['persons_personid'];
	
	$get_person = mysql_query("SELECT firstnm, lastnm, age, location, notes FROM persons WHERE personid = '$person'");
	$row2 = mysql_fetch_array($get_person);
	
	$fn = $row2['firstnm'];
	$ln = $row2['lastnm'];
	$age = $row2['age'];
	$loc = $row2['location'];
	$not = $row2['notes'];
	
	
	
	$all_photos[] = array('photo_path' => $path, 'persons_personid' => $person, 'firstnm' => $fn, 'lastnm' => $ln, 'age' => $age, 'location' => $loc, 'notes' => $not);
	
	
	
}

$result['photos'] = $all_photos;
$pathtodir = 'json/';
$jsonfile = $pathtodir . $u . '.json';

$fp = fopen($jsonfile, 'w');
fwrite($fp, json_encode($result));
fclose($fp);

*/


mysql_close($connect);

?>


</body>
</html>