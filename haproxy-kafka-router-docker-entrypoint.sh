#!/bin/sh
set -e

COUNT_FROM=${COUNT_FROM:-0}
TIMEOUT_CONNECT=${TIMEOUT_CONNECT:-15s}
TIMEOUT_SERVER=${TIMEOUT_SERVER:-1m}
TIMEOUT_CLIENT=${TIMEOUT_CLIENT:-1m}

BASE_KAFKA_PORT=${BASE_KAFKA_PORT:-9092}
SPECIFIC_KAFKA_PORT=${SPECIFIC_KAFKA_PORT:-9093}

HA_PROXY_TEMPLATE_FILE=${HA_PROXY_TEMPLATE_FILE:-/opt/ha-proxy-kafka-router/haproxy.cfg.template}

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
           --kafkaTemplateAddress ${KAFKA_TEMPLATE_ADDRESS} > $CONFIG_FILE \
           --timeoutConnect ${TIMEOUT_CONNECT} \
           --timeoutServer ${TIMEOUT_SERVER} \
           --timeoutClient ${TIMEOUT_CLIENT} \
           --baseKafkaPort ${BASE_KAFKA_PORT} \
           --specificKafkaPort ${SPECIFIC_KAFKA_PORT} \
           --haProxyTemplateFile ${HA_PROXY_TEMPLATE_FILE}

echo "Generated config in $CONFIG_FILE"
echo ">>>>>>>>>>"
cat $CONFIG_FILE
echo "<<<<<<<<<<"

readonly RSYSLOG_PID="/var/run/rsyslogd.pid"
rm -f $RSYSLOG_PID
rsyslogd

/docker-entrypoint.sh "$@"