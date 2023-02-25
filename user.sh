source common.sh

print_head "Downloading Repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Installing Nodejs"
yum install nodejs -y &>>${log_file} 
status_check $?

print_head "Adding User Roboshop"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
useradd roboshop &>>${log_file}
fi
status_check $?

print_head "creating Apllication Directory"
if [ ! -d /app ]; then
mkdir /app &>>${log_file}
fi
status_check $?

print_head "cleaning old files"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Downloading App Content zip file"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
status_check $?

print_head "changing Directory"
cd /app &>>${log_file}
status_check $?

print_head "Extracting App content"
unzip /tmp/user.zip &>>${log_file}
status_check $?

print_head " installing nodejs support files"
npm install &>>${log_file}
status_check $?

print_head "copying service file to systemd "
cp ${code_dir}/config/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "systemctl reload"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable catalogue service"
systemctl enable user &>>${log_file}
status_check $?

print_head "Start catalogue service"
systemctl start user &>>${log_file}
status_check $?


print_head "copy mongodb repo files"
cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "install mongodb"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "load schema to mongodb"
mongo --host mongodb.devops36.shop </app/schema/catalogue.js &>>${log_file}
status_check $?