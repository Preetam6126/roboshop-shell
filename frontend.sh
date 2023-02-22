echo -e "\e[36mInstalling Nginx\e[0m"
yum install nginx -y 

echo -e "\e[36mRemoving files old contents\e[0m"
rm -rf /usr/share/nginx/html/* 

echo-e "\e[36mDownloading Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 

echo -e "\e[36mExtracting Downloaded Frontend\e[0m"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip

echo -e "\e[36mCopying Nginx Config for Roboshop\e[0m"
cp config/nginx-roboshop.conf /etc/nginx/default.d/roboshop.com

echo -e "\e[36mEnabling and Starting Nginx\e[0m"
systemctl enable nginx 
systemctl start nginx 
