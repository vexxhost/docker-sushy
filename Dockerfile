# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2025-12-18T01:27:44Z

FROM ghcr.io/vexxhost/openstack-venv-builder:main@sha256:64a2fe2bb35d6274efa3bfd3fbc4f2fdd9a581e8e578e13e1e398a8f38bd2a27 AS build
RUN <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        gunicorn \
        sushy-tools
EOF

FROM ghcr.io/vexxhost/python-base:main@sha256:fda9b0d33fbd314c6081a336df4a416456062b0ff661b314eef8de80dd9211fe
RUN <<EOF bash -xe
apt-get update -qq
apt-get install -qq -y --no-install-recommends \
    ceph-common dmidecode genisoimage iproute2 libosinfo-bin lsscsi mdevctl ndctl nfs-common nvme-cli openssh-client ovmf python3-libvirt python3-rados python3-rbd qemu-efi-aarch64 qemu-block-extra qemu-utils sysfsutils udev util-linux swtpm swtpm-tools libtpms0
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF
COPY --from=build --link /var/lib/openstack /var/lib/openstack
