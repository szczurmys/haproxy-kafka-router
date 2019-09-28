FROM haproxy:2.0-alpine

RUN apk add --no-cache --update \
    python3 \
    py3-setuptools \
    rsyslog \
    && mkdir -p /etc/rsyslog.d \
    && touch /var/log/haproxy.log \
    && ln -sf /dev/stdout /var/log/haproxy.log

RUN pip3 install --upgrade pip \
    && pip3 install pipenv

COPY haproxy.cfg.template /opt/ha-proxy-kafka-router/haproxy.cfg.template
COPY fill-kafka-template.py /opt/ha-proxy-kafka-router/fill-kafka-template.py
COPY Pipfile /opt/ha-proxy-kafka-router/Pipfile
COPY Pipfile.lock /opt/ha-proxy-kafka-router/Pipfile.lock
COPY rsyslog.conf /etc/rsyslog.d/

RUN cd /opt/ha-proxy-kafka-router/ \
    && pipenv install --system


COPY haproxy-kafka-router-docker-entrypoint.sh /
ENTRYPOINT ["/haproxy-kafka-router-docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
