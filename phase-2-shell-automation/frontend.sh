#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

APP_DIR="/var/www/localhelp"
NGINX_CONF_SOURCE="/home/ubuntu/3tier-devsecops-ai/phase-2-shell-automation/localhelp.conf"
NGINX_CONF_DEST="/etc/nginx/conf.d/localhelp.conf"

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

echo "================ CHECKING ROOT =================" | tee -a $LOGFILE

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access." | tee -a $LOGFILE
    exit 1
else
    echo "You are super user." | tee -a $LOGFILE
fi

echo "================ INSTALLING NGINX =================" | tee -a $LOGFILE

apt install nginx -y 2>&1 | tee -a $LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx 2>&1 | tee -a $LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx 2>&1 | tee -a $LOGFILE
VALIDATE $? "Starting nginx"

echo "================ INSTALLING NODEJS =================" | tee -a $LOGFILE

curl -fsSL https://deb.nodesource.com/setup_20.x | bash - 2>&1 | tee -a $LOGFILE
VALIDATE $? "Adding NodeSource repo"

apt install -y nodejs 2>&1 | tee -a $LOGFILE
VALIDATE $? "Installing Node.js"

node -v | tee -a $LOGFILE
npm -v | tee -a $LOGFILE

echo "================ FETCHING REACT CODE =================" | tee -a $LOGFILE

rm -rf /tmp/localhelp-frontend
git clone https://github.com/sbp828/localhelp-frontend.git /tmp/localhelp-frontend 2>&1 | tee -a $LOGFILE
VALIDATE $? "Cloning frontend repo"

cd /tmp/localhelp-frontend

echo "================ BUILDING REACT APP =================" | tee -a $LOGFILE

rm -rf node_modules package-lock.json
npm install 2>&1 | tee -a $LOGFILE
VALIDATE $? "npm install"

npm run build 2>&1 | tee -a $LOGFILE
VALIDATE $? "React build"

echo "================ DEPLOYING BUILD =================" | tee -a $LOGFILE

rm -rf $APP_DIR
mkdir -p $APP_DIR

cp -r build/* $APP_DIR/
VALIDATE $? "Deploying React build"

echo "================ CONFIGURING NGINX =================" | tee -a $LOGFILE

cp $NGINX_CONF_SOURCE $NGINX_CONF_DEST
VALIDATE $? "Copying nginx config"

nginx -t 2>&1 | tee -a $LOGFILE
VALIDATE $? "Nginx config test"

systemctl restart nginx 2>&1 | tee -a $LOGFILE
VALIDATE $? "Restarting nginx"

echo "================ CLEANUP =================" | tee -a $LOGFILE

rm -rf /tmp/localhelp-frontend

echo "================ DEPLOYMENT DONE =================" | tee -a $LOGFILE

echo "🎉 Frontend deployed successfully!"
echo "👉 http://<EC2-PUBLIC-IP>"
