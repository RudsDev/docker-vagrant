
FROM ubuntu:18.04

# Set runtime variables
ARG JDK_TYPE=openjdk-8-jdk
ARG JDK_VERSION=java-1.8.0-openjdk-amd64
ARG TOMCAT_VERSION=8.5.56
ARG URL=http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Set environment
ENV JAVA_HOME /usr/lib/jvm/${JDK_VERSION}/jre
ENV PATH ${PATH}:${JAVA_HOME}/bin
ENV JAVA_PACKAGE server-jre
ENV CATALINA_HOME /opt/tomcat

# Download and install Java
RUN apt-get update &&\ 
  apt -y install ${JDK_TYPE} &&\
  java -version &&\
  javac -version &&\
  #Create tomcat group and user
  groupadd tomcat &&\
  useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat &&\
  # Download and install Tomcat
  apt -y install wget &&\
  wget --progress=bar:force $URL &&\
  # create folder and extract
  mkdir /opt/tomcat &&\
  tar xzvf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat --strip-components=1 &&\
  # give the tomcat group ownership over the entire installation directory
  cd /opt/tomcat &&\
  chgrp -R tomcat /opt/tomcat &&\
  # give the tomcat group read access to the conf directory
  chmod -R g+r conf &&\
  chmod g+x conf &&\
  # make the tomcat user the owner of the webapps, work, temp, and logs directories
  chown -R tomcat webapps/ work/ temp/ logs/ &&\
  #Clean
  rm ../../apache-tomcat-${TOMCAT_VERSION}.tar.gz &&\
  apt -y remove wget &&\
  apt-get clean

# Expose Web Port
EXPOSE 8282

ADD /sync_files/docker/tomcat/tomcat-configs/tomcat.service /etc/systemd/system/
ADD /sync_files/docker/tomcat/tomcat-configs/tomcat-users.xml /opt/tomcat/conf 
ADD /sync_files/docker/tomcat/tomcat-configs/server.xml /opt/tomcat/conf/server.xml
ADD /sync_files/docker/tomcat/tomcat-configs/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml

LABEL version="0.2"
LABEL mantainer="ruds.devel@gmail.com"

# Launch Tomcat on startup
CMD ${CATALINA_HOME}/bin/catalina.sh run