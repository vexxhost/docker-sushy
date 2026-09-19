# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2025-12-18T01:27:44Z

FROM ghcr.io/vexxhost/openstack-venv-builder:main@sha256:529281408224741867b6399aa4c73a62e465a28485fdffa1bb7e0d583c7208e0 AS build
RUN <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        gunicorn \
        sushy-tools
EOF

FROM ghcr.io/vexxhost/python-base:main@sha256:8c06241946c246726fc493b2eb3c2abc286d4323d550a4abd8c41581346f2010
RUN <<EOF bash -xe
apt-get update -qq
apt-get install -qq -y --no-install-recommends \
    ceph-common dmidecode genisoimage iproute2 libosinfo-bin lsscsi mdevctl ndctl nfs-common nvme-cli openssh-client ovmf python3-libvirt python3-rados python3-rbd qemu-efi-aarch64 qemu-block-extra qemu-utils sysfsutils udev util-linux swtpm swtpm-tools libtpms0
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF
COPY --from=build --link /var/lib/openstack /var/lib/openstack
