#
FROM s2.ubuntu.home:5000/docker.io/python:3.13.2-alpine3.21
LABEL maintainer="https://github.com/muccg/"

ARG ARG_DEVPI_COMMON_VERSION=4.0.4
ARG ARG_DEVPI_SERVER_VERSION=6.14.0
ARG ARG_DEVPI_WEB_VERSION=4.3.0
ARG ARG_DEVPI_CLIENT_VERSION=7.2.0
#ARG ARG_DEVPI_THEME_VERSION=2.1.0
ARG ARG_DEVPI_JENKINS_VERSION=3.0.1
ARG PYTHON_PIP_VERSION=23.0.1

ENV DEVPI_HOME=/data
ENV DEVPI_COMMON_VERSION $ARG_DEVPI_COMMON_VERSION
ENV DEVPI_SERVER_VERSION $ARG_DEVPI_SERVER_VERSION
ENV DEVPI_WEB_VERSION $ARG_DEVPI_WEB_VERSION
ENV DEVPI_CLIENT_VERSION $ARG_DEVPI_CLIENT_VERSION
#ENV DEVPI_THEME_VERSION $ARG_DEVPI_THEME_VERSION
ENV DEVPI_JENKINS_VERSION $ARG_DEVPI_JENKINS_VERSION
ENV PIP_NO_CACHE_DIR="off"
ENV PIP_INDEX_URL="https://pypi.python.org/simple"
ENV PIP_TRUSTED_HOST="127.0.0.1"
ENV VIRTUAL_ENV /env

# devpi user
RUN apk update \
    && apk add bash \
    && addgroup --system --gid 1000 devpi \
    && adduser -D -S -u 1000 -G devpi -h $DEVPI_HOME -s /sbin/nologin devpi

EXPOSE 3141
VOLUME $DEVPI_HOME

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

#    && $VIRTUAL_ENV/bin/pip install pip==$PYTHON_PIP_VERSION \

# create a virtual env in $VIRTUAL_ENV, ensure it respects pip version
RUN pip install --upgrade pip \
    && pip install virtualenv \
    && virtualenv $VIRTUAL_ENV \
    && pip install --upgrade setuptools \
    && rm -rf /root/.local/share/virtualenv
ENV PATH $VIRTUAL_ENV/bin:$PATH

#    "devpi-theme-16==${DEVPI_THEME_VERSION}" \
RUN pip install \
    "devpi-common==${DEVPI_COMMON_VERSION}" \
    "devpi-client==${DEVPI_CLIENT_VERSION}" \
    "devpi-web==${DEVPI_WEB_VERSION}" \
    "devpi-server==${DEVPI_SERVER_VERSION}" \
    "devpi-jenkins==${DEVPI_JENKINS_VERSION}" \
    && chown -R devpi:devpi $VIRTUAL_ENV \
    && rm -rf /tmp/*

USER devpi
ENV HOME $DEVPI_HOME
WORKDIR $DEVPI_HOME

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["devpi"]
