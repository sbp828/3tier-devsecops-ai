#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=./logs/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
DB_HOST="db.localhelp.store"
echo "Please enter DB password:"
read mysql_root_password
LOGS_DIR="./logs"
mkdir -p $LOGS_DIR

LOGFILE="$LOGS_DIR/mysql-$(date +%F-%H-%M-%S).log"

echo "logfile location = $LOGFILE"

exec > >(tee -a "$LOGFILE") 2>&1

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi


apt install mysql-server -y  >>$LOGFILE
VALIDATE $? "Installing MySQL Server" 

systemctl enable mysql >>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysql >>$LOGFILE
VALIDATE $? "Starting MySQL Server"

#mysql_secure_installation --set-root-pass suri &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h ${DB_HOST} -uroot -p${mysql_root_password} -e "SHOW DATABASES;">>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password}
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi
