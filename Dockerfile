# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2025-12-18T01:27:44Z

FROM ghcr.io/vexxhost/openstack-venv-builder:main@sha256:072fc465aaa7e210e09b9b11587dbdd455e9d0669b2aec0bb3443bd174f95842 AS build
RUN <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        gunicorn \
        sushy-tools
EOF

FROM ghcr.io/vexxhost/python-base:main@sha256:4b059ab6b98106cd89ff1f79ff388c2e00fed5d96375ce4fb9c4415fa65a71bc
RUN <<EOF bash -xe
apt-get update -qq
apt-get install -qq -y --no-install-recommends \
    ceph-common dmidecode genisoimage iproute2 libosinfo-bin lsscsi mdevctl ndctl nfs-common nvme-cli openssh-client ovmf python3-libvirt python3-rados python3-rbd qemu-efi-aarch64 qemu-block-extra qemu-utils sysfsutils udev util-linux swtpm swtpm-tools libtpms0
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF
COPY --from=build --link /var/lib/openstack /var/lib/openstack
