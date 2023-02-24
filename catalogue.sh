source common.sh

print_head "Downloading Repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Installing Nodejs"
yum install nodejs -y &>>${log_file} 

print_head "Adding User Roboshop"
useradd roboshop &>>${log_file}

print_head "creating Apllication Directory"
mkdir /app &>>${log_file}

print_head "cleaning old files"
rm -rf /app/* &>>${log_file}

print_head "Downloading App Content zip file"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}

print_head "changing Directory"
cd /app &>>${log_file}

print_head "Extracting App content"
unzip /tmp/catalogue.zip &>>${log_file}

print_head " installing nodejs support files"
npm install &>>${log_file}

print_head "copying service file to systemd "
cp ${code_dir}/config/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "systemctl reload"
systemctl daemon-reload &>>${log_file}

print_head "Enable catalogue service"
systemctl enable catalogue &>>${log_file}

print_head "Start catalogue service"
systemctl start catalogue &>>${log_file}

print_head "copy mongodb repo files"
cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "install mongodb"
yum install mongodb-org-shell -y &>>${log_file}

print_head "load schema to mongodb"
mongo --host mongodb.devops36.shop </app/schema/catalogue.js &>>${log_file}