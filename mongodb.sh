source common.sh

print_head "Setup MongoDB repository"
cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo
status_check $?

print_head "Installing mongodb"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check $?

print_head "Enabling mongodb service"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "start mongodb service"
systemctl restart mongod &>>${log_file}
status_check $?
#update /etc/mongod.conf file from 127.0.0.1 to 0.0.0.0