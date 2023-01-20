curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
rm -rf catalogue
unzip -o /tmp/catalogue.zip
mv catalogue-main catalogue
npm install


# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue

