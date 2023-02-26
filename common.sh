code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
    echo -e "\e[36m$1\e[0m"
    }
    
status_check() {
 if [ $1 -eq 0 ]; then
  echo Success
 else
  echo Failure
  echo "Read the log file ${log_file} for more information"
  exit 1
 fi
 }    
 
 NODEJS() {
  
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
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
status_check $?

print_head "Changing Directory"
cd /app &>>${log_file}
status_check $?

print_head "Extracting App content"
unzip /tmp/${component}.zip &>>${log_file}
status_check $?

print_head "Installing nodejs support files"
npm install &>>${log_file}
status_check $?

print_head "Copying service file to systemd "
cp ${code_dir}/config/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

print_head "Systemctl reload"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable ${component} service"
systemctl enable ${component} &>>${log_file}
status_check $?

print_head "Start ${component} service"
systemctl start ${component} &>>${log_file}
status_check $?


print_head "Copy mongodb repo files"
cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install mongodb"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load schema to mongodb"
mongo --host mongodb.devops36.shop </app/schema/${component}.js &>>${log_file}
status_check $?
 }