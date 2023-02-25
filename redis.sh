source common.sh

print_head "Installing Redis Repo files"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "Chossing & Enabling module 6.2"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head "Installing Redis"
yum install redis -y &>>${log_file}
status_check $?

print_head "configuring to  Listen to everyone"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?

print_head "Enable System services"
systemctl enable redis &>>${log_file}
status_check $?

print_head " Start redis system servcies"
systemctl start redis &>>${log_file}
status_check $?





