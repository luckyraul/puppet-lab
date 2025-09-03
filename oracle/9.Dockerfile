FROM oraclelinux:9

ENV container=docker

# Install required packages
RUN dnf -y install systemd findutils && \
    dnf clean all

# Set PATH so puppet commands are available
ENV PATH="/opt/puppetlabs/bin:${PATH}"

# Add Puppet official repo
RUN EL_VERSION=$(rpm -E %{rhel}) && \
    RPM="puppet8-release-el-${EL_VERSION}.noarch.rpm" && \
    curl -O "https://yum.puppet.com/${RPM}" && \
    rpm -Uvh "${RPM}" && \
    rm -f "${RPM}"

RUN dnf -y install puppet-agent && dnf clean all

RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -print0 | xargs -0 rm -vf

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT [ "/usr/sbin/init" ]