<?php

$con = mysql_connect("127.0.0.1:3306","opencv","opencv");
if (!$con)
		{
		echo "<h2>Sorry, we cannot process your request at this time, please try again later</h2>\n";
		echo "<a href=\"index.php?content=register\">Try again</a><br>\n"; echo "<a href=\"index.php\">Return to Home</a>\n"; exit;
		}

mysql_select_db("opencv_development", $con) or die('Could not connect to database');

$username = $_POST['username'];
$password = $_POST['password'];
$password2 = $_POST['password2'];
$email = $_POST['email'];
$baduser = 0;

// Check if userid was entered 
if (trim($username) == '')
{
	echo "<h2>Sorry, you must enter a user name.</h2><br>\n";
	echo "<a href=\"index.php?content=register\">Try again</a><br>\n";
	echo "<a href=\"index.php\">Return to Home</a>\n";
	$baduser = 1;
	}

//Check if password was entered 
if (trim($password) == '')
{
	echo "<h2>Sorry, you must enter a password.</h2><br>\n";
	echo "<a href=\"index.php?content=register\">Try again</a><br>\n";
	echo "<a href=\"index.php\">Return to Home</a>\n";
	$baduser = 1;
	}

//Check if password and confirm password match 
if ($password != $password2)
{
	echo "<h2>Sorry, the passwords you entered did not match.</h2><br>\n";
	echo "<a href=\"index.php?content=register\">Try again</a><br>\n";
	echo "<a href=\"index.php\">Return to Home</a>\n";
	$baduser = 1;
	}

//Check if userid is already in database 
$query = "SELECT username from users where username = '$username'";
$result = mysql_query($query);
$row = mysql_fetch_array($result, MYSQL_ASSOC);

if ($row['username'] == $username)
{
	echo "<h2>Sorry, that user name is already taken.</h2><br>\n";
	echo "<a href=\"index.php?content=register\">Try again</a><br>\n";
	echo "<a href=\"index.php\">Return to Home</a>\n";
	$baduser = 1;
	}

if ($baduser != 1)
{
	//Everything passed, enter userid in database 
	$query = "INSERT into users (username, password, email) VALUES ('$username', PASSWORD('$password'), '$email')";
	$result = mysql_query($query) or die('Sorry, we are unable to process your request.' . mysql_error());

if ($result)
{
	$dir = getcwd() . "/images/proc_images/" . $username; 
	mkdir($dir);
	chmod($dir, 0777);
	
	echo "<h2>Your registration request has been approved!</h2>\n";
	echo "<a href=\"index.php\">Return to Home</a>\n";
	exit;
	} else 
	{
	echo "<h2>Sorry, there was a problem processing your login request</h2><br>\n";
	echo "<a href=\"index.php?content=register\">Try again</a><br>\n";
	echo "<a href=\"index.php\">Return to Home</a>\n";
	}
}
?>