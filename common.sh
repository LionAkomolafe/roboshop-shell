PRINT() {
  echo ------------ $1 ------------ >>$LOG
  echo -e "\e[33m$1\e[0m"
}

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo View the error in $LOG file
    exit
  fi
}

LOG=/tmp/$COMPONENT.log
rm -f $LOG

NODEJS() {
  COMPONENT=cart
  source common.sh

  PRINT "Install NodeJS Repository"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
  STAT $?

  PRINT "Install NodeJS"
  yum install nodejs -y &>>$LOG
  STAT $?

  PRINT "Create User Application"
  id roboshop &>>$LOG
  if [ $? -ne 0 ]; then
    useradd roboshop &>>$LOG
  fi
  STAT $?

  PRINT "Download App Content"
  curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>$LOG
  STAT $?

  PRINT "Remove Previous Version of App"
  cd /home/roboshop &>>$LOG
  rm -rf cart &>>$LOG
  STAT $?

  PRINT "Extracting App Content"
  unzip -o /tmp/cart.zip &>>$LOG
  STAT $?

  mv cart-main cart
  cd cart

  PRINT "Install NodeJS Dependencies"
  npm install &>>LOG
  STAT $?

  PRINT "Reconfigure Endpoints for SystemD Configuration"
  sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' /home/roboshop/cart/systemd.service &>>LOG
  STAT $?

  #PRINT "Rename Configuration"
  #mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>$LOG
  #STAT $?

  PRINT "Reload SystemD"
  systemctl daemon-reload &>>$LOG
  STAT $?

  PRINT "Restart Cart"
  systemctl restart cart &>>$LOG
  STAT $?

  PRINT "Enable Cart Service"
  systemctl enable cart &>>$LOG
  STAT $?
}