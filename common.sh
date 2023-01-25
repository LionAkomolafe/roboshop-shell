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