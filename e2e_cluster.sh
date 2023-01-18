#!/bin/bash

# Bring the services up
function startServices {
  docker start nodemaster worker1 worker2
  sleep 5
  echo ">> Starting hdfs ..."
  docker exec -u hadoop -d nodemaster start-dfs.sh
  sleep 5
  echo ">> Starting yarn ..."
  docker exec -u hadoop -d nodemaster start-yarn.sh
  sleep 5
  echo ">> Starting MR-JobHistory Server ..."
  docker exec -u hadoop -d nodemaster mr-jobhistory-daemon.sh start historyserver
  sleep 5
  echo ">> Starting Spark ..."
  docker exec -u hadoop -d nodemaster start-master.sh
  docker exec -u hadoop -d worker1 start-worker.sh nodemaster:7077
  docker exec -u hadoop -d worker2 start-worker.sh nodemaster:7077
  sleep 5

  docker exec -u hadoop -i nodemaster hdfs dfsadmin -safemode leave
  echo ">> creating logs and jars in hdfs ..."
  docker exec -u hadoop -i nodemaster hdfs dfs -mkdir /spark-jars
  docker exec -u hadoop -i nodemaster hdfs dfs -mkdir /spark-logs
  sleep 5

  echo ">> Moving jars from SPARK_HOME to HDFS ..."
  docker exec -u hadoop -it nodemaster sh -c "hdfs dfs -put /home/hadoop/spark/jars/* /spark-jars"

  echo ">> Starting Spark History Server ..."
  docker exec -u hadoop -d nodemaster start-history-server.sh
  sleep 5
  #echo ">> Starting jupyter notebook"
  #docker exec -u hadoop -d nodemaster jupyter notbook --ip 0.0.0.0 --allow-root --NotebookApp.token='' --NotebookApp.password=''
}

function stopServices {
  echo ">> Stopping Spark Master and Workers ..."
  docker exec -u hadoop -d nodemaster stop-master.sh
  docker exec -u hadoop -d worker1 stop-worker.sh
  docker exec -u hadoop -d worker2 stop-worker.sh
  docker stop nodemaster worker1 worker2
}

if [[ $1 = "install" ]]; then
  docker network create --subnet=172.20.0.0/16 hadoopnet # create custom network
  
  # 3 nodes
  echo ">> Starting master and worker nodes ..."
  docker run -d \
	  --net hadoopnet \
	  --ip 172.20.1.1 \
	  -p 8088:8088 -p 4040:4040 -p 18080:18080 -p 8080:8080 -p 8888:8888 -p 9870:9870\
	  --mount type=bind,source=/home/fasih/e2e_pyspark,target=/home/hadoop/e2e_pyspark \
	  --hostname nodemaster --add-host worker1:172.20.1.2 --add-host worker2:172.20.1.3 \
	  --name nodemaster \
	  -it fashi/spark:3.3.1
  docker run -d --net hadoopnet --ip 172.20.1.2 --hostname worker1 --add-host nodemaster:172.20.1.1 --add-host worker2:172.20.1.3 --name worker1 -it fashi/spark:3.3.1
  docker run -d --net hadoopnet --ip 172.20.1.3 --hostname worker2 --add-host nodemaster:172.20.1.1 --add-host worker1:172.20.1.2 --name worker2 -it fashi/spark:3.3.1
  # Format nodemaster
  echo ">> Formatting hdfs ..."
  docker exec -u hadoop -d nodemaster hdfs namenode -format
  startServices
    
  exit
fi


if [[ $1 = "stop" ]]; then
  stopServices
  exit
fi


if [[ $1 = "uninstall" ]]; then
  stopServices
  echo ">> removing containers ..."
  docker rm worker1 worker2 nodemaster
  docker network rm hadoopnet
  exit
fi

if [[ $1 = "start" ]]; then  
  docker start nodemaster worker1 worker2 
  startServices
  exit
fi

if [[ $1 = "pull_images" ]]; then  
  docker pull fashi/spark:3.3.1
  exit
fi

echo "Usage: cluster.sh pull_images|install|start|stop|uninstall"
echo "                 pull_images - download all docker images"
echo "                 install - Prepare to run and start for first time all containers"
echo "                 start  - start existing containers"
echo "                 stop   - stop running processes"
echo "                 uninstall - remove all docker images"

