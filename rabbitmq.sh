COMPONENT=shipping
source common.sh

PRINT "Download Erlang Repository"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
STAT $?

PRINT "Install Erlang Repository"
yum install erlang -y
STAT $?

PRINT "Download App Content"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
STAT $?

PRINT "Install RabbitMQ Service"
yum install rabbitmq-server -y
STAT $?

PRINT "Enable RabbitMQ Service"
systemctl enable rabbitmq-server
STAT $?

PRINT "Start RabbitMQ Service"
systemctl start rabbitmq-server
STAT $?

PRINT "Add roboshop user to rabbitmq"
rabbitmqctl add_user roboshop roboshop123
STAT $?

PRINT "Grant roboshop user administrator permissions"
rabbitmqctl set_user_tags roboshop administrator
STAT $?

PRINT "Set permissions for roboshop user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
STAT $?