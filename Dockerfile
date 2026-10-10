# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2025-12-18T01:27:44Z

FROM ghcr.io/vexxhost/openstack-venv-builder:main@sha256:19c9ce478b55fc1a826d68b3eb78c94a4e13466c082b2fb4d2b5031595810399 AS build
RUN <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        gunicorn \
        sushy-tools
EOF

FROM ghcr.io/vexxhost/python-base:main@sha256:1c8db9b02f8ddd9419c36b9bad5f6a87d03a8bd20ae7f5a0f45879bedccc1187
RUN <<EOF bash -xe
apt-get update -qq
apt-get install -qq -y --no-install-recommends \
    ceph-common dmidecode genisoimage iproute2 libosinfo-bin lsscsi mdevctl ndctl nfs-common nvme-cli openssh-client ovmf python3-libvirt python3-rados python3-rbd qemu-efi-aarch64 qemu-block-extra qemu-utils sysfsutils udev util-linux swtpm swtpm-tools libtpms0
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF
COPY --from=build --link /var/lib/openstack /var/lib/openstack
