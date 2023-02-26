source common.sh
roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
echo -e "\e[31mMissing mysql root password argument\e[0m"
exit 1
fi


print_head "Setup Erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Setup RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Install Erlang & RabbitMQ"
yum install rabbitmq-server -y &>>${log_file}
status_check $?

print_head "Enable RabbitMQ Service"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "Start RabbitMQ Server"
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "Add Application User"
rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
status_check $?

print_head "Configure Permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?