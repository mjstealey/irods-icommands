FROM debian:stretch
MAINTAINER Michael J. Stealey <michael.j.stealey@gmail.com>

ENV IRODS_VERSION=4.2.3

# set user/group IDs for irods account
RUN groupadd -r irods --gid=998 \
  && useradd -r -g irods -d /var/lib/irods --uid=998 irods

# install iRODS v4.2.3
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" \
  > /etc/apt/sources.list.d/jessie-backports.list \
  && apt-get update && apt-get install -y \
  wget \
  gnupg2 \
  apt-transport-https \
  sudo \
  jq \
  libxml2 \
  && wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
  && echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" \
  > /etc/apt/sources.list.d/renci-irods.list \
  && apt-get update && apt-get install -y \
  irods-icommands=${IRODS_VERSION}

# default iRODS environment variables
ENV IRODS_PORT=1247 \
  IRODS_PORT_RANGE_BEGIN=20000 \
  IRODS_PORT_RANGE_END=20199 \
  IRODS_CONTROL_PLANE_PORT=1248 \
  IRODS_HOST=provider \
  IRODS_USER_NAME=rods \
  IRODS_ZONE_NAME=tempZone \
  IRODS_PASSWORD=rods \
  IRODS_DEFAULT_RESOURCE=demoResc \
  UID_IRODS=998 \
  GID_IRODS=998

# create irods.tar.gz
RUN cd /var/lib/irods \
  && tar -czvf /irods.tar.gz . \
  && cd /

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
VOLUME /var/lib/irods /etc/irods /data

EXPOSE $IRODS_PORT $IRODS_CONTROL_PLANE_PORT $IRODS_PORT_RANGE_BEGIN-$IRODS_PORT_RANGE_END
ENTRYPOINT ["/docker-entrypoint.sh"]
WORKDIR "/data"

CMD ["ihelp"]
