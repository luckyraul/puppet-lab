FROM ubuntu:22.04

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

RUN curl -sLO https://apt.puppetlabs.com/puppet8-release-$(lsb_release -cs 2>/dev/null).deb && \
    dpkg -i puppet8-release-$(lsb_release -cs 2>/dev/null).deb && \
    rm puppet8-release-$(lsb_release -cs 2>/dev/null).deb
ENV PATH=/opt/puppetlabs/bin:$PATH

RUN apt-get update -qq && \
    apt-get install -qqy puppet-agent && \
    apt-get clean

VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/lib/systemd/systemd"]