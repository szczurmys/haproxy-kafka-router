#!/usr/bin/python3

import multiprocessing
import argparse
from mako.template import Template

parser = argparse.ArgumentParser(description='Create nginx config for kafka.', add_help=True)
parser.add_argument('--countFrom', type=int, help='', default=0)
parser.add_argument('--maxServers', type=int, required=True)
parser.add_argument('--baseKafkaPort', type=int, default=9092)
parser.add_argument('--kafkaMainAddress', type=str, required=True)
parser.add_argument('--specificKafkaPort', type=int, default=9093)
parser.add_argument('--kafkaTemplateAddress', type=str, required=True)
parser.add_argument('--haProxyTemplateFile', type=str, default='/opt/ha-proxy-kafka-router/haproxy.cfg.template')

parser.add_argument('--timeoutConnect', type=str, default='15s')
parser.add_argument('--timeoutServer', type=str, default='1m')
parser.add_argument('--timeoutClient', type=str, default='1m')

args = parser.parse_args()



template = Template(filename=args.haProxyTemplateFile)


print(template.render(
    countFrom=args.countFrom,
    maxServers=args.maxServers,
    baseKafkaPort=args.baseKafkaPort,
    kafkaMainAddress=args.kafkaMainAddress,
    specificKafkaPort=args.specificKafkaPort,
    kafkaTemplateAddress=args.kafkaTemplateAddress,
    timeoutConnect=args.timeoutConnect,
    timeoutServer=args.timeoutServer,
    timeoutClient=args.timeoutClient,
    cpuCount=multiprocessing.cpu_count(),
))
