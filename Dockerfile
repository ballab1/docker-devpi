#
FROM ${DOCKER_REGISTRY:-}docker.io/python:3.14.0b3-alpine3.21
LABEL Maintainers="bobb@k8s.home"


ENV DEVPI_HOME=/data

ARG GID=1000
ARG UID=1000
ARG PYTHON_PIP_VERSION=23.0.1
ENV PIP_NO_CACHE_DIR="off"
ENV PIP_INDEX_URL="https://pypi.python.org/simple"
ENV PIP_TRUSTED_HOST="127.0.0.1"
ENV VIRTUAL_ENV /env

# devpi user
RUN apk update \
    && apk add bash \
    && addgroup --system --gid $GID devpi \
    && adduser -D -S -u $UID -G devpi -h $DEVPI_HOME -s /sbin/nologin devpi

EXPOSE 3141
VOLUME $DEVPI_HOME

COPY requirements.txt /tmpp/requirements.txt
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# create a virtual env in $VIRTUAL_ENV, ensure it respects pip version
RUN pip install --upgrade pip \
    && pip install virtualenv \
    && virtualenv $VIRTUAL_ENV \
    && pip install --upgrade setuptools \
    && rm -rf /root/.local/share/virtualenv
ENV PATH $VIRTUAL_ENV/bin:$PATH

RUN pip install -r /tmp/requirements.txt \
    && chown -R devpi:devpi $VIRTUAL_ENV \
    && rm -rf /tmp/*

USER devpi
ENV HOME $DEVPI_HOME
WORKDIR $DEVPI_HOME

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["devpi"]
