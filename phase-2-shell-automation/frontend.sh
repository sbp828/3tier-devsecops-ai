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
REPO="/home/ubuntu/localhelp-frontend"
NGINX_CONF_SOURCE="/home/ubuntu/localhelp.conf"
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

echo "================ CHECKING ROOT ================="

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1
else
    echo "You are super user."
fi

echo "================ INSTALLING NGINX ================="

apt install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting nginx"

echo "================ INSTALLING NODEJS ================="

curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &>>$LOGFILE
VALIDATE $? "Adding NodeSource repo"

dnf install -y nodejs &>>$LOGFILE
VALIDATE $? "Installing Node.js"

node -v &>>$LOGFILE
npm -v &>>$LOGFILE

echo "================ FETCHING REACT CODE ================="

if [ -d "$REPO" ]
then
    echo "Repo exists → pulling latest code"
    cd $REPO
    git pull &>>$LOGFILE
else
    echo "Cloning repository"
    git clone https://github.com/sbp828/localhelp-frontend.git $REPO &>>$LOGFILE
fi

VALIDATE $? "Fetching frontend code"

cd $REPO

echo "================ BUILDING REACT APP ================="

rm -rf node_modules package-lock.json
npm install &>>$LOGFILE
VALIDATE $? "npm install"

npm run build &>>$LOGFILE
VALIDATE $? "React build"

echo "================ DEPLOYING BUILD ================="

rm -rf $APP_DIR
mkdir -p $APP_DIR

cp -r build/* $APP_DIR/
VALIDATE $? "Deploying React build"

echo "================ CONFIGURING NGINX ================="

cp $NGINX_CONF_SOURCE $NGINX_CONF_DEST
VALIDATE $? "Copying nginx config"

nginx -t &>>$LOGFILE
VALIDATE $? "Nginx config test"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"

echo "================ DEPLOYMENT DONE ================="

echo "🎉 Frontend deployed successfully!"
echo "👉 http://<EC2-PUBLIC-IP>"
