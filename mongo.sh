COMPONENT=mongodb
source common.sh

PRINT "Downloading Mongo Repository"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
STAT $?

PRINT "Install Code Repo"
yum install mongodb-org -y &>>$LOG
STAT $?

PRINT "Reconfigure Mongo Enpoints"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG
STAT $?

PRINT "Enable Mongod Service"
systemctl enable mongod &>>$LOG
STAT $?

PRINT "Start Mongod Service"
systemctl start mongod &>>$LOG
STAT $?

APP_LOC=/tmp
CONTENT=mongodb-main
DOWNLOAD_APP_CODE

cd mongodb-main &>>$LOG

PRINT "Load Catalogue Schema"
mongo < catalogue.js &>>$LOG
STAT $?

PRINT "Load User Schema"
mongo < users.js &>>$LOG
STAT $?
