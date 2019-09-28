#!/bin/sh
set -e

COUNT_FROM=${COUNT_FROM:-0}

if [ -z "${MAX_SERVERS}" ]; then
  echo "Environent variable MAX_SERVERS is necessary."
  exit 1
fi

if [ -z "${KAFKA_MAIN_ADDRESS}" ]; then
  echo "Environent variable KAFKA_MAIN_ADDRESS is necessary."
  exit 2
fi

if [ -z "${KAFKA_TEMPLATE_ADDRESS}" ]; then
  echo "Environent variable KAFKA_TEMPLATE_ADDRESS is necessary."
  exit 3
fi



CONFIG_FILE=/usr/local/etc/haproxy/haproxy.cfg;

python3 /opt/ha-proxy-kafka-router/fill-kafka-template.py \
           --countFrom ${COUNT_FROM} \
           --maxServers ${MAX_SERVERS} \
           --kafkaMainAddress ${KAFKA_MAIN_ADDRESS} \
           --kafkaTemplateAddress ${KAFKA_TEMPLATE_ADDRESS} > $CONFIG_FILE

echo "Generated config in $CONFIG_FILE"
echo ">>>>>>>>>>"
cat $CONFIG_FILE
echo "<<<<<<<<<<"

readonly RSYSLOG_PID="/var/run/rsyslogd.pid"
rm -f $RSYSLOG_PID
rsyslogd

/docker-entrypoint.sh "$@"