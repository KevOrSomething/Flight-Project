# Flight-Project
A website simulating a flight-scheduling tool.

In order to use this project, you need to have MySQL downloaded. You first need to create the database by running `schema.sql`.

This project uses **Java Server Pages**. You must use **Eclipse IDE for EE developers**. Open the `loginPage` folder as a new project.

Furthermore, you also need to have [Apache Tomcat](https://tomcat.apache.org/download-80.cgi) installed. Once that's done, go back to Eclipse and select the following:

>Windows - Preference - Server - Runtime Environment - Add - Apache Tomcat v8.0 or
Eclipse- Preferences - Server - Runtime Environments - Add - Apache Tomcat v8.0

You also need to set up the server credentials in your project so that they match your MySQL credentials. In the Java project, open the following file: `loginPage\src\com\loginPage\pkg\ApplicationDB.java`. Scroll down until you see the following lines:

```Java
//Create a connection to your DB
connection = DriverManager.getConnection(connectionUrl,"root", "root");
```
Here, you have to replace "root" and "root" with your username and password from MySQL.

Finally, to actually run the website, do the following steps:

>Right click on the project - Run as - Run on Server - Apache – Tomcat8

And you should be good to go!

If you don't want to set up the entire project and just want to see the site in action, go to [this link](https://drive.google.com/drive/folders/1TIaSOpwmPJFRvz0eH57CsxMdlmDz42In?usp=sharing). It holds video tutorials on all of the functionalities. If you specifically want to see my share of the site, select the video with my name.

## Credentials

### Customer Account Credentials
Username: KrustyKrab 
<br>Password: patrick

Username: mrpresident
<br>Password: michelle

Username: testing
<br>Password: password

Username: username123
<br>Password: password

### Customer Representative Account Credentials
Username: george
<br>Password: ilovemyjob

Username: john
<br>Password: ihatemyjob

### Admin Account Credentials
Username: admin
<br>Password: travel