FROM ubuntu:20.04

USER root

# open port 22
EXPOSE 22

RUN apt-get update

# OpenJDK installation
RUN apt-get install -y openjdk-8-jre openjdk-8-jdk openssh-server vim

RUN useradd -m -s /bin/bash hadoop

RUN echo "PubkeyAuthentication yes" >> /etc/ssh/ssh_config
RUN mkdir -p /home/hadoop/.ssh
RUN echo "PubkeyAcceptedKeyTypes +ssh-dss" >> /home/hadoop/.ssh/config
RUN echo "PasswordAuthentication no" >> /home/hadoop/.ssh/config

# copy keys
ADD hadoop/configs/id_rsa.pub /home/hadoop/.ssh/id_rsa.pub
ADD hadoop/configs/id_rsa /home/hadoop/.ssh/id_rsa
RUN chmod 400 /home/hadoop/.ssh/id_rsa
RUN chmod 400 /home/hadoop/.ssh/id_rsa.pub
RUN cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
RUN chown hadoop -R /home/hadoop/.ssh


# get sources
# RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-3.3.1/hadoop-3.3.1.tar.gz -P /home/hadoop/
COPY hadoop/resources/hadoop-3.3.1.tar.gz /home/hadoop/hadoop-3.3.1.tar.gz
RUN tar -xzf /home/hadoop/hadoop-3.3.1.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/hadoop-3.3.1 /home/hadoop/hadoop
RUN rm -rf /home/hadoop/hadoop-3.3.1*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME /home/hadoop/hadoop
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HADOOP_MAPRED_HOME $HADOOP_HOME 
ENV HADOOP_COMMON_HOME $HADOOP_HOME 
ENV HADOOP_HDFS_HOME $HADOOP_HOME 
ENV HADOOP_YARN_HOME $HADOOP_HOME 
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV YARN_HOME $HADOOP_HOME
ENV PATH $JAVA_HOME/bin:$PATH
ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# set hadoop-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_CONF_DIR=/home/hadoop/hadoop/etc/hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HDFS_NAMENODE_USER=hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HDFS_DATANODE_USER=hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HDFS_SECONDARYNAMENODE_USER=hadoop" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_COMMON_LIB_NATIVE_DIR=/home/hadoop/hadoop/lib/native" >> /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh


# create folders for nodes
RUN mkdir -p /home/hadoop/data/nameNode /home/hadoop/data/dataNode /home/hadoop/data/nameNodeSecondary /home/hadoop/data/tmp
RUN mkdir -p /home/hadoop/hadoop/logs
ADD hadoop/configs/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD hadoop/configs/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD hadoop/configs/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD hadoop/configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD hadoop/configs/capacity-scheduler.xml $HADOOP_HOME/etc/hadoop/capacity-scheduler.xml
ADD hadoop/configs/workers $HADOOP_HOME/etc/hadoop/workers

# permissions
RUN chown hadoop -R /home/hadoop/data
RUN chown hadoop -R /home/hadoop/hadoop

CMD service ssh start && bash
