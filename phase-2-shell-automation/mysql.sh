#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_DIR="./logs"
mkdir -p $LOGS_DIR
LOGFILE="$LOGS_DIR/mysql-$TIMESTAMP.log"

echo "Please enter DB password:"
read -s mysql_root_password
echo
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
    exit 1
else
    echo "You are super user."
fi

# Install MySQL
apt install mysql-server -y >>$LOGFILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysql >>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysql >>$LOGFILE
VALIDATE $? "Starting MySQL Server"

# ✅ Step 1: Check if root password works
mysql -uroot -p${mysql_root_password} -e "SELECT 1;" &>/dev/null

if [ $? -ne 0 ]
then
    echo "Setting MySQL root password..."
    mysql_secure_installation --set-root-pass ${mysql_root_password}
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL root password already set...$Y SKIPPING $N"
fi

# ✅ Step 2: Create DB and user
mysql -uroot -p${mysql_root_password} <<EOF
CREATE DATABASE IF NOT EXISTS appdb;

CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'app123';
GRANT ALL PRIVILEGES ON appdb.* TO 'appuser'@'%';

FLUSH PRIVILEGES;
EOF

VALIDATE $? "Database and user setup"