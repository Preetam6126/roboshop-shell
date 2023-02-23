echo -e "\e[35mcopying files to repository\e[0m"
cp config/mongodb.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[35mInstalling mongodb\e[0m"
yum install mongodb-org -y 

echo -e "\e[35m enabling and starting mongodb\e[0m"
systemctl enable mongod 
systemctl start mongod 

#update /etc/mongod.conf file from 127.0.0.1 to 0.0.0.0