source common.sh

PRINT "Install NodeJS Repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
STAT $?

PRINT "Install NodeJS"
yum install nodejs -y
STAT $?

PRINT "Create User Application"
useradd roboshop
STAT $?

PRINT "Download App Content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
STAT $?

PRINT "Remove Previous Version of App"
cd /home/roboshop
rm -rf cart
STAT $?

unzip -o /tmp/cart.zip
mv cart-main cart
cd cart

PRINT "Install NodeJS Dependencies"
npm install
STAT $?

PRINT "Reconfigure Endpoints for SystemD Configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' /home/roboshop/cart/systemd.service
STAT $?

PRINT "Rename Configuration"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
STAT $?

PRINT "Reload SystemD"
systemctl daemon-reload
STAT $?

PRINT "Restart Cart"
systemctl restart cart
STAT $?

PRINT "Enable Cart Service"
systemctl enable cart
STAT $?