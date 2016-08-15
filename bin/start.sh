#!/bin/bash
export SPARK_LOCAL_IP=$(curl http://rancher-metadata/2015-07-25/self/container/primary_ip)

case $1 in
  master)
    export SPARK_MASTER_IP=$SPARK_LOCAL_IP
    /spark/sbin/start-master.sh \
      --properties-file /spark/conf/spark-defaults.conf \
      -i $SPARK_LOCAL_IP
    mkdir /tmp/spark-events
    sleep 10
    /spark/sbin/start-history-server.sh
    ;;

  slave)
    /spark/sbin/start-slave.sh \
      --properties-file /spark/conf/spark-defaults.conf \
      -i $SPARK_LOCAL_IP \
      $2
    mkdir /tmp/spark-events
    ;;
  help|--help|-h)
    echo "$0 [master|slave] [opt]"
    exit
    ;;
  *)
    echo "Unrecognized command $1" >&2
    exit 1
    ;;
esac

sleep 5

tail -f /spark/logs/*
