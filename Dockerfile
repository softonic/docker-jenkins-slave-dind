FROM docker:19.03-dind

MAINTAINER Viktor Farcic <viktor@farcic.com>

ARG version="0.2.0"
ARG build_date="unknown"
ARG commit_hash="unknown"
ARG vcs_url="unknown"
ARG vcs_branch="unknown"

LABEL org.label-schema.vendor="vfarcic" \
    org.label-schema.name="jenkins-swarm-agent" \
    org.label-schema.description="Jenkins agent based on the Swarm plugin" \
    org.label-schema.usage="/src/README.md" \
    org.label-schema.url="https://github.com/vfarcic/docker-jenkins-slave-dind/blob/master/README.md" \
    org.label-schema.vcs-url=$vcs_url \
    org.label-schema.vcs-branch=$vcs_branch \
    org.label-schema.vcs-ref=$commit_hash \
    org.label-schema.version=$version \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$build_date

ENV SWARM_CLIENT_VERSION="3.17" \
    DOCKER_COMPOSE_VERSION="1.25.0" \
    BUILDX_VERSION="v0.3.1" \
    COMMAND_OPTIONS="" \
    USER_NAME_SECRET="" \
    PASSWORD_SECRET=""

RUN adduser -G root -D jenkins &&\
    apk add --no-cache bash openjdk8-jre git openssh ca-certificates openssl curl python py-pip python-dev libffi-dev openssl-dev gcc libc-dev make &&\
    wget -q https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_CLIENT_VERSION}/swarm-client-${SWARM_CLIENT_VERSION}.jar -P /home/jenkins/ &&\
    pip install docker-compose &&\
    curl -LO https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64 &&\
    ls -la && mkdir -p ~/.docker/cli-plugins &&\
    mv buildx-${BUILDX_VERSION}.linux-amd64 ~/.docker/cli-plugins/docker-buildx &&\
    chmod a+x ~/.docker/cli-plugins/docker-buildx &&\
    docker buildx install

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
