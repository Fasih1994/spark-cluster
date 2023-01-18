FROM fashi/hadoop:3.3.1

USER root

RUN apt install -y python3-pip
#RUN python --version
RUN pip install notebook


COPY spark/resources/spark-3.3.1-bin-hadoop3.tgz /home/hadoop/spark-3.3.1-bin-hadoop3.tgz
RUN tar -xzf /home/hadoop/spark-3.3.1-bin-hadoop3.tgz 
RUN mv spark-3.3.1-bin-hadoop3 /home/hadoop/spark
RUN rm /home/hadoop/spark-3.3.1-bin-hadoop3.tgz

# RUN hdfs dfs -mkdir /spark-jars
# RUN hdfs dfs -mkdir /spark-logs
# RUN hdfs dfs -put /home/hadoop/spark/jars/* /spark-jars 



# RUN mkdir /home/hadoop/spark/logs
# RUN chown hadoop -R /home/hadoop/spark/logs

ENV SPARK_HOME /home/hadoop/spark
ENV PYTHONPATH=$SPARK_HOME/python/:$SPARK_HOME/python/lib/py4j-0.10.9.5-src.zip:$SPARK_HOME/python/build:$PYTHONPATH
# ENV SPARK_LOG_DIR /home/hadoop/spark/logs
# ENV SPARK_DIST_CLASSPATH $(hadoop classpath) does not work
# RUN export SPARK_DIST_CLASSPATH=$(hadoop classpath)
ENV PATH $SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
RUN mv /home/hadoop/spark/conf/spark-env.sh.template /home/hadoop/spark/conf/spark-env.sh
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/spark/conf/spark-env.sh
RUN echo "export HADOOP_CONF_DIR=/home/hadoop/hadoop/etc/hadoop" >> /home/hadoop/spark/conf/spark-env.sh
RUN echo "export YARN_CONF_DIR=/home/hadoop/hadoop/etc/hadoop" >> /home/hadoop/spark/conf/spark-env.sh
RUN echo "export PYSPARK_PYTHON=python3" >> /home/hadoop/spark/conf/spark-env.sh
RUN mv /home/hadoop/spark/conf/spark-defaults.conf.template /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.eventLog.enabled true" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.eventLog.dir file:/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.history.fs.logDirectory file:/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-defaults.conf
ADD hadoop/configs/workers /home/hadoop/spark/conf/workers
ADD spark/resources/spark-defaults.conf /home/hadoop/spark/conf/spark-defaults.conf
RUN chown hadoop -R /home/hadoop/spark
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native
