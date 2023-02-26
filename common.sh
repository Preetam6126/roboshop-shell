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
 
 systemd_setup() {
  
print_head "Copying service file to systemd "
cp ${code_dir}/config/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_password}" /etc/systemd/system/${component}.service &>>${log_file}

print_head "Systemctl reload"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable ${component} service"
systemctl enable ${component} &>>${log_file}
status_check $?

print_head "Start ${component} service"
systemctl restart ${component} &>>${log_file}
status_check $?
 }
 
schema_setup() { 
 if [ "${schema_type}" == "mongo" ]; then
 print_head "Copy mongodb repo files"
 cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
 status_check $?

 print_head "Install mongodb client"
 yum install mongodb-org-shell -y &>>${log_file}
 status_check $?

 print_head "Load schema to mongodb"
 mongo --host mongodb.devops36.shop </app/schema/${component}.js &>>${log_file}
 status_check $?
 elif [ "${schema_type}" == "mysql" ]; then
 
 print_head "Install MySql Client"
 yum install mysql -y &>>${log_file}
 status_check $?
 
 print_head "Applying password to MySql password and Loading Schema"
 mysql -h mysql.devops36.shop -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
 status_check $?
 fi
}


app_prereq_setup() {
 
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
}
 
NODEJS() {
  
print_head "Downloading Repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Installing Nodejs"
yum install nodejs -y &>>${log_file} 
status_check $?

app_prereq_setup

print_head "Installing nodejs support files"
npm install &>>${log_file}
status_check $?

schema_setup

systemd_setup
}

java() {

print_head "Installing Maven"
yum install maven -y &>>${log_file}
status_check $?

app_prereq_setup

print_head "Download Dependencies & Packages"
mvn clean package &>>${log_file} 
status_check $?

print_head " Moving files to original name"
mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
status_check $?

#Schema Set-UP Function
schema_setup

#SystemD Set-Up Function
systemd_setup

}

python() {

print_head "Installing Pythong"
yyum install python36 gcc python3-devel -y &>>${log_file}
status_check $?

app_prereq_setup

print_head "Download Dependencies"
pip3.6 install -r requirements.txt &>>${log_file} 
status_check $?

#SystemD Set-Up Function
systemd_setup

}