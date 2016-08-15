FROM ubuntu:16.04
MAINTAINER Ivan Beauté <kamaradeinanov@gmail.com>

RUN mkdir /data ; apt-get update && apt-get install -y  bash openjdk-8-jdk python curl && apt-get clean
WORKDIR /data

RUN mkdir /spark && curl -SL http://apache.crihan.fr/dist/spark/spark-1.6.2/spark-1.6.2-bin-hadoop2.4.tgz | tar -xz -C /spark
COPY bin /spark/bin
COPY conf /spark/conf

ENV SPARK_MASTER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 \
-Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 \
-Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 \
-Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"
ENV SPARK_WORKER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 \
-Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 \
-Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 \
-Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"

ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_WORKER_PORT 8888
ENV SPARK_WORKER_WEBUI_PORT 8081

EXPOSE 8080 7077 8888 8081 4040 7001 7002 7003 7004 7005 7006 18080

CMD /spark/bin/start.sh
