FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker

RUN apt-get -qq update && \
    apt-get -qqy install systemd findutils lsb-release curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -print0 | xargs -0 rm -vf

RUN . /etc/os-release \
    && curl -fLO "https://apt.voxpupuli.org/openvox8-release-ubuntu${VERSION_ID}.deb" \
    && apt-get install -y "./openvox8-release-ubuntu${VERSION_ID}.deb" \
    && rm -f "openvox8-release-ubuntu${VERSION_ID}.deb" \
    && apt-get update -qq \
    && apt-get install -qqy --no-install-recommends openvox-agent
ENV PATH=/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:$PATH

VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/lib/systemd/systemd"]