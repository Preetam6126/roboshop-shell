code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

echo -e "\e[36mInstalling Nginx\e[0m"
yum install nginx -y &>>${log_file}

echo -e "\e[36mRemoving files old contents\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log_file}

echo -e "\e[36mDownloading Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file} 

echo -e "\e[36mExtracting Downloaded Frontend\e[0m"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>${log_file}

echo -e "\e[36mCopying Nginx Config for Roboshop\e[0m"

cp ${code_dir}/config/nginx-roboshop.conf /etc/nginx/default.d/roboshop.com &>>${log_file}


echo -e "\e[36mEnabling and Starting Nginx\e[0m"
systemctl enable nginx &>>${log_file}
systemctl start nginx  &>>${log_file}

