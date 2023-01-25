COMPONENT=catalogue
source common.sh

PRINT "Download NodeJS Repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
STAT $?

PRINT "Install NodeJS Repo"
yum install nodejs -y &>>$LOG
STAT $?

PRINT "Add Application User"
useradd roboshop &>>$LOG
STAT $?

PRINT "Download App Content"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
STAT $?

PRINT "Delete former version of App"
cd /home/roboshop
rm -rf catalogue &>>$LOG
STAT $?

PRINT "Extract App Content"
unzip -o /tmp/catalogue.zip &>>$LOG
STAT $?

mv catalogue-main catalogue
cd catalogue

PRINT "Install NodeJS Dependencies"
npm install &>>$LOG
STAT $?

PRINT "Reconfigure Endpoints for SystemD Configuration"
sed -i -e 's/MONGO_DNSNAME/mongodb.devopsb69.online/' systemd.service &>>$LOG
STAT $?

PRINT "Rename Configuration"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG
STAT $?

PRINT "Reload SystemD"
systemctl daemon-reload &>>$LOG
STAT $?

PRINT "Restart Service"
systemctl restart catalogue &>>$LOG
STAT $?

PRINT "Enable Service"
systemctl enable catalogue &>>$LOG
STAT $?
