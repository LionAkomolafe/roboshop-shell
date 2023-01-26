COMPONENT=frontend
source common.sh
CONTENT="*"

PRINT "Install Nginx"
yum install nginx -y
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE
exit

mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl restart nginx
