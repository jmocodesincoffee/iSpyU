#include "opencv2/opencv.hpp"
#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <stdio.h>
#include <cerrno>
#include <cstring>
#include <iostream>
#include <mysql.h>
#include <boost/filesystem.hpp>
#include "opencv2/contrib/contrib.hpp"

using namespace std;
using namespace cv;
using namespace boost::filesystem;

CvHaarClassifierCascade* cascade = 0;
CvMemStorage* storage = 0;

void detect_faces(IplImage* img, const char* argv[]);

const char* host = "localhost";
const char* usr = "opencv";
const char* pswd = "opencv";
const char* database = "opencv_development";

MYSQL_RES *result;

MYSQL_ROW row;

MYSQL *connection, mysql;

int state;


int main(int argc, const char* argv[])
{
	// Load image and detect faces

	IplImage* img = cvLoadImage(argv[1], 1);

	detect_faces(img, argv);


	// ...Show image...if you wish to see the faces detected from the original photo.
	/*
	cvNamedWindow("image", 1);

	cvShowImage( "image", img );
	cvWaitKey(10000);
	cvDestroyWindow("image");

	cvReleaseImage(&img);
	 */
}


/*
 * Function runs most of the program.  It takes the parameters of the input image and of the arguments passed
 * to the application from the command line.  Particularly the second argument that is the user who submitted
 * and requires these results back.
 *
 *  @param image passed as first argument
 *  @param all the arguments needed for the second argument which is the username
 *
 */
void detect_faces(IplImage* img, const char* argv[])
{

	//declarations for the function
	IplImage* gray;
	//Fisherfaces model;
    Ptr<FaceRecognizer> model = createFisherFaceRecognizer();

	model->load("/Users/jason/Sites/jason.dev/facemodel.yml");
	//model.load("/Users/jason/Sites/jason.dev/facemodel.yml");
	int predicted;
	Mat found_face;

	int unknownRecord;

	/* Load the face detector and create memory storage
    `cascade` and `storage` are global variables */

	//The cascade files are Pre-trained files for object detection so that the detection process
	//	knows what to detect in the photo or video.
	if (!cascade) {
		const char* file = "/usr/local/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml";
		cascade = (CvHaarClassifierCascade*) cvLoad(file, 0, 0, 0);
		storage = cvCreateMemStorage(0);
	}

	/* Convert multichannel to 1-channel for faster processing */
	if (img->nChannels == 1) {
		gray = cvCloneImage(img);
	} else {
		gray = cvCreateImage(cvGetSize(img), img->depth, 1);
		cvCvtColor(img, gray, CV_RGB2GRAY);
	}

	/* detect faces */
	/*
	 * Function detects the objects determined by the cascade file
	 *
	 *  @params the image, the trained cascade file, the memory storage, the scaling factor, minimum neighbors,
	 *  flags, and the size.
	 *
	 */
	CvSeq* faces = cvHaarDetectObjects(
			gray,
			cascade,
			storage,
			1.1,
			3,
			CV_HAAR_DO_CANNY_PRUNING,
			cvSize(20, 20)
	);

	int i;
	//int k = 0;
	int fileid;
	/* Draw red boxes on the faces found */



	string target_path("/Users/jason/Sites/jason.dev/images/proc_images/");
	string folder = argv[2];
	target_path.append(folder);

	path p(target_path);

	//removes existing photos that were submitted and are no longer needed
	if(exists(p) && is_directory(p))
	{
		directory_iterator end;
		for(directory_iterator it(p); it != end; ++it)
		{
			try
			{
				if(is_regular_file(it->status()) && (it->path().extension() == ".jpg"))
				{
					remove(it->path());
				}
			}
			catch(const exception &ex)
			{
				ex;
			}
		}
	}

	//mysql connection
	mysql_init(&mysql);

	connection = mysql_real_connect(&mysql,host, usr, pswd, database,0,0,0);
	if (connection == NULL)
	{
		printf(mysql_error(&mysql));
	}

	//Iterates through each face for processing it into its own image file, then inputs info into DB, and
	//finally compares the face to all photos that were trained from the DB.
	for( i = 0; i < (faces ? faces->total : 0); i++ )
	{
		CvRect* r = (CvRect*)cvGetSeqElem(faces, i);
		r->x += 5;
		r->y += 5;
		r->width -= 5;
		r->height -= 5;


		//		cvRectangle(
		//				img,
		//				cvPoint(r->x, r->y),
		//				cvPoint(r->x + r->width, r->y + r->height),
		//				CV_RGB(255, 0, 0),
		//				1, 8, 0
		//		);

		IplImage* clone = cvCreateImage (cvSize(img->width, img->height),
				IPL_DEPTH_8U, img->nChannels );
		IplImage* gray = cvCreateImage (cvSize(img->width, img->height),
				IPL_DEPTH_8U, 1 );


		IplImage* final = cvCreateImage (cvSize(92, 112), gray->depth, gray->nChannels);

		cvCopy (img, clone, 0);

		cvNamedWindow ("ROI", CV_WINDOW_AUTOSIZE);
		cvCvtColor( clone, gray, CV_RGB2GRAY );


		cvSetImageROI ( gray, *r);

		//// * rectangle  = cvGetImageROI ( clone );
		*r = cvGetImageROI ( gray );
		//cvShowImage ("ROI", gray);


		//TODO need to test if equalizing histogram is better for real world photos, day/night, with mobile
		cvEqualizeHist(gray, gray);

		cvResize(gray, final, CV_INTER_CUBIC);



		//Start connection to mysql database and get the record id from the last photo in the database
		char sql_query[512] = "SELECT photoid FROM photo_db ORDER BY photoid DESC LIMIT 1";

		state = mysql_query(connection, sql_query);
		if (state !=0)
		{
			printf(mysql_error(connection));
		}

		result = mysql_store_result(connection);

		row = mysql_fetch_row(result);

		fileid = atoi(row[0]) + 1;


		char *name=0;

		name=(char*) calloc(512, 1);
		sprintf(name, "/Users/jason/Sites/jason.dev/images/face_library/%d.pgm", fileid);

		//cvSaveImage(name, gray);


		//error checking for saving the final face image file
		if(!cvSaveImage(name, final)) {
			int error = cvGetErrStatus();
			const char * errorMessage = 0;
			if (error) {
				errorMessage = cvErrorStr(error);
			} else {
				error = errno;                   // needs #include <cerrno>
				errorMessage = strerror(error);  //       #include <cstring>
			}
			std::cout << errorMessage << std::endl;
			// with "echo shell_exec("./opencv '$newName'");" in php code.
			//this allows to see an error msg if there are permission problems saving the image.
		}



		char *preview=0;
		preview=(char*) calloc(512, 1);
		sprintf(preview, "/Users/jason/Sites/jason.dev/images/face_library/%d.png", fileid);

		cvSetImageROI ( clone, *r);
		*r = cvGetImageROI ( clone );
		cvSaveImage(preview, clone);


		//Face recognition is performed//

		found_face = imread(name, 0);
		predicted = model->predict(found_face);
		//predicted = model.predict(found_face);

		cout << "This is the predicted personid: " << predicted << endl;

		if(predicted >= 0 && predicted < fileid)
		{

			char *sql_insert = 0;
			sql_insert = (char*) calloc(512, 1);

			sprintf(sql_insert, "INSERT INTO photo_db (photo_path, users_username, persons_personid, last_used, preview_path)"
					" VALUES ('%d.pgm', '%s', %d, '1', '%d.png')", fileid, argv[2], predicted, fileid);

			state = mysql_query(connection, sql_insert);
			if (state !=0)
			{
				printf(mysql_error(connection));
			}

			result = mysql_store_result(connection);
		} else
		{

			char *sql_insert = 0;
			sql_insert = (char*) calloc(512, 1);
			sprintf(sql_insert, "INSERT INTO persons (firstnm) VALUES ('Unknown')");

			state = mysql_query(connection, sql_insert);
			if (state !=0)
			{
				printf(mysql_error(connection));
			}

			result = mysql_store_result(connection);

			char sql_query[512] = "SELECT personid FROM persons ORDER BY personid DESC LIMIT 1";
			state = mysql_query(connection, sql_query);
			if (state !=0)
			{
				printf(mysql_error(connection));
			}
			result = mysql_store_result(connection);
			row = mysql_fetch_row(result);
			unknownRecord = atoi(row[0]);




			sql_insert = (char*) calloc(512, 1);


			sprintf(sql_insert, "INSERT INTO photo_db (photo_path, users_username, persons_personid, last_used, preview_path)"
					" VALUES ('%d.pgm', '%s', %d, '1', '%d.png')", fileid, argv[2], unknownRecord, fileid);

			state = mysql_query(connection, sql_insert);
			if (state !=0)
			{
				printf(mysql_error(connection));
			}

			result = mysql_store_result(connection);
		}








	}

	//Red square is drawn on the original photo...must have the image shown at end of main to see it.
	//Otherwise, this can be commented out for faster performance.
	for( i = 0; i < (faces ? faces->total : 0); i++ )
	{
		CvRect* r = (CvRect*)cvGetSeqElem(faces, i);

		cvRectangle(
				img,
				cvPoint(r->x, r->y),
				cvPoint(r->x + r->width, r->y + r->height),
				CV_RGB(255, 0, 0),
				1, 8, 0
		);
	}
	mysql_free_result(result);
	mysql_close(connection);
}




