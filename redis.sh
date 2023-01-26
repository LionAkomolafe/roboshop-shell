COMPONENT=redis
source common.sh

PRINT "Install Redis Repository"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG
STAT $?

PRINT "Enable Redis Repo"
dnf module enable redis:remi-6.2 -y &>>$LOG
STAT $?

PRINT "Install Redis Service"
yum install redis -y &>>$LOG
STAT $?

PRINT "Reconfigure Redis Enpoints"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>$LOG
STAT $?

PRINT "Enable Redis Service"
systemctl enable redis &>>$LOG
STAT $?

PRINT "Restart Redis Service"
systemctl restart redis &>>$LOG
STAT $?