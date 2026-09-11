#!/bin/bash

set -euxo pipefail

echo "=== Stop services ==="

systemctl stop gitlab-runner || true
systemctl stop docker || true

echo "=== Unregister runners ==="

gitlab-runner unregister --all-runners || true

echo "=== Remove runner configuration ==="

rm -f /etc/gitlab-runner/config.toml

echo "=== Remove runner service ==="

gitlab-runner uninstall || true

echo "=== Remove runner binary ==="

rm -f /usr/local/bin/gitlab-runner

echo "=== Remove runner user ==="

userdel -r gitlab-runner || true


echo "=== Remove docker ==="
apt-get purge -y docker.io containerd runc
apt-get autoremove -y

echo "=== Remove Docker custom configuration ==="

rm -f /etc/docker/daemon.json
rm -rf /etc/systemd/system/docker.service.d

echo "=== Remove Docker data ==="

rm -rf /var/lib/docker
rm -rf /var/lib/containerd

echo "=== Remove Docker runtime directories ==="

rm -rf /run/docker
rm -f /var/run/docker.sock

echo "=== Remove Docker service state ==="

systemctl daemon-reload

echo "=== Verify cleanup ==="

which docker || true
which gitlab-runner || true

ls -l /etc/gitlab-runner || true
ls -l /etc/docker || true

echo "=== Cleanup complete ==="
