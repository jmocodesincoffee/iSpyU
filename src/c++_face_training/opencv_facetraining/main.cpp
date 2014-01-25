/*
 * Copyright (c) 2011. Philipp Wagner <bytefish[at]gmx[dot]de>.
 * Released to public domain under terms of the BSD Simplified license.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the organization nor the names of its contributors
 *     may be used to endorse or promote products derived from this software
 *     without specific prior written permission.
 *
 *   See <http://www.opensource.org/licenses/bsd-license>
 */

#include "opencv2/opencv.hpp"
#include "opencv2/contrib/contrib.hpp"

#include <iostream>
#include <fstream>
#include <sstream>
#include <mysql.h>

using namespace cv;
using namespace std;

const char* host = "localhost";
const char* usr = "opencv";
const char* pswd = "opencv";
const char* database = "opencv_development";

MYSQL_RES *result;

MYSQL_ROW row;

MYSQL *connection, mysql;

int state;




/*
 * Reads in data from a formatted csv file that contains the path and label of a directory of photos
 *
 * @params passes the filename, the image vector, the label vector, and the seperating character from the text file.
 */
void read_csv(const string& filename, vector<Mat>& images, vector<int>& labels, char separator = ';') {
    std::ifstream file(filename.c_str(), ifstream::in);
    if (!file)
        throw std::exception();
    string line, path, classlabel;
    while (getline(file, line)) {
        stringstream liness(line);
        getline(liness, path, separator);
        getline(liness, classlabel);
        images.push_back(imread(path, 0));
        labels.push_back(atoi(classlabel.c_str()));
    }
}

/*
 * Reads in data from the MySQL database to be inserted into a vector
 *
 * @params only needs the image and label vectors passed.
 */
void read_database(vector<Mat>& images, vector<int>& labels) {

	mysql_init(&mysql);

	string full_path = "/Users/jason/Sites/jason.dev/images/face_library/";

	connection = mysql_real_connect(&mysql,host, usr, pswd, database,0,0,0);
	if (connection == NULL)
	{
		printf(mysql_error(&mysql));
	}

	char *retrieve = 0;
	retrieve = (char *) calloc(512, 1);

	sprintf(retrieve, "SELECT photo_path, persons_personid FROM photo_db");
	state = mysql_query(connection, retrieve);
	if(state !=0)
	{
		printf(mysql_error(connection));
	}
	result = mysql_store_result(connection);
	int i=0;
	string str = "19.pgm";
	while((row = mysql_fetch_row(result)))
	{

		if(row[i] != str)
		{
		images.push_back(imread(full_path + row[i], 0));
		cout << full_path + row[i];
		i++;
		labels.push_back(atoi(row[i]));
		cout << " " << row[i] << endl;
		i = 0;
		}
	}



	mysql_free_result(result);
	mysql_close(connection);

}




int main(int argc, const char *argv[]) {

    // path to your CSV
    string fn_csv = "/Users/jason/Sites/jason.dev/at.txt";
    // images and corresponding labels
    vector<Mat> images;
    vector<int> labels;

    // read in the data from txt file
/*    try {
        read_csv(fn_csv, images, labels);
    } catch (exception&) {
        cerr << "Error opening file \"" << fn_csv << "\"." << endl;
        exit(1);
    }*/

    //or read in the data from the database
    read_database(images, labels);

    // build the Fisherfaces model
    Ptr<FaceRecognizer> model = createFisherFaceRecognizer();
    model->train(images, labels);
	model->save("/Users/jason/Sites/jason.dev/facemodel.yml");
    //Fisherfaces model;
    //model.train(images, labels);
    //model.save("/Users/jason/Sites/jason.dev/facemodel.yml");

    return 0;
}
