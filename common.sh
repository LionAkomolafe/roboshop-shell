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

DOWNLOAD_APP_CODE() {
  PRINT "Download App Content"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>$LOG
    STAT $?

    PRINT "Remove Previous Version of App"
    cd $APP_LOC &>>$LOG
    rm -rf $CONTENT &>>$LOG
    STAT $?

    PRINT "Extracting App Content"
    unzip -o /tmp/$COMPONENT.zip &>>$LOG
    STAT $?
}

NODEJS() {
  APP_LOC=/home/roboshop
  CONTENT=$COMPONENT
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

  DOWNLOAD_APP_CODE

  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT "Install NodeJS Dependencies"
  npm install &>>LOG
  STAT $?

  PRINT "Reconfigure Endpoints for SystemD Configuration"
  sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' /home/roboshop/${COMPONENT}/systemd.service &>>LOG
  STAT $?

  #PRINT "Rename Configuration"
  #mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>$LOG
  #STAT $?

  PRINT "Reload SystemD"
  systemctl daemon-reload &>>$LOG
  STAT $?

  PRINT "Restart ${COMPONENT}"
  systemctl restart ${COMPONENT} &>>$LOG
  STAT $?

  PRINT "Enable ${COMPONENT} Service"
  systemctl enable ${COMPONENT} &>>$LOG
  STAT $?

}