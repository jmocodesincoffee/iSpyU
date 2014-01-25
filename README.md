***READ ME
Instructions for installing the program.


--REQUIREMENTS

There are three external libraries used for the C++ code applications.  These libraries are included in the "requirements" folder.

The first one is the Boost library (boost v1.49.0) and offers a versatile file management in C++.

The second library is the MySQL library (mysql v5.5.2).  This library comes with the MySQL software needed to be installed to run the database.  
When Installing that software and adding the appropriate paths into the Search Path, then the mysql.h library can be linked into the application.

The third library is the OpenCV version 2.4.  This library has been modified and will need 
further modification according to how you want the threshold of the face recognition function.  
Navigate to the OpenCV2.4/modules/contrib/src/facerec.cpp and in that you will find the function in the Fisherfaces section the following:

	int Fisherfaces::predict(InputArray _src) const

Inside this function there is the integer variable called Threshold.  It is currently set to 2000 so adjust it accordingly to how strict or loose 
you want the prediction to be.  Then install the library.

In addition to the three external libraries is the MySQL Community Server (which includes the mysql library) and the MySQL Workbench application that
is the interface to your database.


--INSTALLATION

The src folder contains all of the source code to be installed.

IPHONE
First start with the mobile application that is in the folder named iphone_project.  Copy the folder inside of the iphone_project to the folder 
containing your Xcode projects.  Then you can click on the .xcodeproj file to open the project.  The only modifications that need to be done 
for running is that you will have to change the defined addresses of the AppDelegate.h file according to your website structure.

WEBSITE
Next is the website.  You must have some PHP and web services running on your computer.  After you have those services running you can copy 
the jason.dev folder to your root directory of your web server.  Some of the php files are there for interaction between the MySQL server and 
the mobile.  The other files are there for a web interface that offers registration for the mobile to access the mobile program, but also 
an interface to generate simulations on face recognition in the case that you do not have an Apple computer.

One important note for the website is that you will have to make sure that permissions for the website directory and files are set correctly 
so that the web service can save and delete files appropriately.  In our case we added the _www user group to the root directory of our website 
with permissions 0755.

MYSQL
The mysql_db folder has two files that are essentially the same.  You can either start MySQL Workbench and import the sql file to create the database
structure, or you can just open the mwb file that is the model of the database and then forward engineer the database to be created from the model.

C++
The two C++ applications are straightforward to install if everything else has been done correctly, particularly the external libraries. 
The only modifications that will be needed will be anything in the main functions that reference directories.  Modification of any statements 
involving directories will need to be changed accordingly.





