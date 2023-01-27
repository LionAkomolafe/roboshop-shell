COMPONENT=shipping
source common.sh

PRINT "Install JavaScript"
yum install maven -y &>>$LOG
STAT $?

id roboshop
if [ $? -ne 0 ]; then
  PRINT "Create Application User" &>>$LOG
  useradd roboshop
  STAT $?
fi

cd /home/roboshop
PRINT "Download App Content"
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip" &>>$LOG
STAT $?

unzip -o /tmp/shipping.zip
PRINT "Remove Former Version of App" &>>$LOG
rm -rf shipping
STAT $?

mv shipping-main shipping
cd shipping

PRINT "Clean Package"
mvn clean package &>>$LOG
STAT $?

PRINT "Rename File"
mv target/shipping-1.0.jar shipping.jar &>>$LOG
STAT $?

PRINT "Reconfigure Cart and MySQL Endpoints"
sed -i -e "s/CARTENDPOINT/cart.devopsb69.online/" -e "s/DBHOST/mysql.devopsb69.online/" systemd.service &>>$LOG
STAT $?

PRINT "Rename Destination File"
mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service &>>$LOG
STAT $?

PRINT "Reload Daemon"
systemctl daemon-reload &>>$LOG
STAT $?

PRINT "Enable Shipping Service"
systemctl enable shipping &>>$LOG
STAT $?

PRINT "Start Shipping Service"
systemctl start shipping &>>$LOG
STAT $?