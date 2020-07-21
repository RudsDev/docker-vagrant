
echo " ----- Update packages[0]"
sleep 1
apt-get update

echo "------ WGET"
apt -y install wget

echo " ----- Install Java ."
sleep 1
export JDK_TYPE=openjdk-8-jdk
export JDK_VERSION=java-1.8.0-openjdk-amd64

apt -y install ${JDK_TYPE}

java -version
javac -version
sleep 1

export JAVA_HOME=/usr/lib/jvm/${JDK_VERSION}/jre

echo " ----- Create tomcat group and user and install and configure Apache Tomcat"
sleep 1
groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

export VER=8.5.56
export URL=http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-8/v$VER/bin/apache-tomcat-$VER.tar.gz

wget --progress=bar:force $URL

# create folder and extract
mkdir /opt/tomcat
tar xzvf apache-tomcat-$VER.tar.gz -C /opt/tomcat --strip-components=1

# give the tomcat group ownership over the entire installation directory
cd /opt/tomcat
chgrp -R tomcat /opt/tomcat

# give the tomcat group read access to the conf directory
chmod -R g+r conf
chmod g+x conf

# make the tomcat user the owner of the webapps, work, temp, and logs directories
chown -R tomcat webapps/ work/ temp/ logs/


# clean
echo " ----- Limpando a bagunça"

rm ../../apache-tomcat-$VER.tar.gz
rm ../../tomcat.sh

apt -y remove wget
apt-get clean

#Start Tomcat
echo " ----- Start Tomcat"
systemctl status tomcat
systemctl start tomcat
systemctl status tomcat

echo "Finished!"
sleep 1
