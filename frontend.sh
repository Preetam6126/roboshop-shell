source common.sh

print_head "Installing Nginx"
yum install nginx -y &>>${log_file}

print_head "Removing files old contents"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file} 

print_head "Extracting Downloaded Frontend"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying Nginx Config for Roboshop"

cp ${code_dir}/config/nginx-roboshop.conf /etc/nginx/default.d/roboshop.com &>>${log_file}


print_head "Enabling and Starting Nginx"
systemctl enable nginx &>>${log_file}
systemctl start nginx  &>>${log_file}

