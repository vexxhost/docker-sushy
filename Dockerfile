# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2025-12-18T01:27:44Z

FROM ghcr.io/vexxhost/openstack-venv-builder:main@sha256:62dc82349660a822d6729e105f2b26e785e3f7ded6fb8a92ea8beb717880cc05 AS build
RUN <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        gunicorn \
        sushy-tools
EOF

FROM ghcr.io/vexxhost/python-base:main@sha256:2e16855b7d95781de7396ac2cac3aef32ca5a83079db724e3f97d4e4be322c94
RUN <<EOF bash -xe
apt-get update -qq
apt-get install -qq -y --no-install-recommends \
    ceph-common dmidecode genisoimage iproute2 libosinfo-bin lsscsi mdevctl ndctl nfs-common nvme-cli openssh-client ovmf python3-libvirt python3-rados python3-rbd qemu-efi-aarch64 qemu-block-extra qemu-utils sysfsutils udev util-linux swtpm swtpm-tools libtpms0
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF
COPY --from=build --link /var/lib/openstack /var/lib/openstack
