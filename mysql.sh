source common.sh
if [ -z "${mysql_root_password}" ]; then
echo "missing mysql root password argument"
exit 1
fi

print_head "Disabiling sql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "copying repo files"
cp ${code_dir}/config/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "Installing mysql"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable Systemd Services"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Start systemctl  service"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Verifying password with SQL"
echo show databases | mysql -uroot -pRoboShop@1 &>>${log_file}
if [ $? -ne 0 ]; then
status_check $?

print_head "MySql default passwd changed"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?

