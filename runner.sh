#!/bin/bash

exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1
set -euxo pipefail

echo "=== Installing packages ==="

apt-get update
apt-get install -y curl unzip docker.io

echo "=== Starting Docker ==="

systemctl enable docker
systemctl start docker

until docker info >/dev/null 2>&1; do
  echo "Waiting for Docker..."
  sleep 2
done

echo "=== Docker ready ==="

echo "=== Installing GitLab Runner ==="

curl -L \
  --output /usr/local/bin/gitlab-runner \
  https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

chmod +x /usr/local/bin/gitlab-runner

id gitlab-runner >/dev/null 2>&1 || \
useradd \
  --comment "GitLab Runner" \
  --create-home \
  --shell /bin/bash \
  gitlab-runner

grep -q "^gitlab-runner ALL=(ALL) NOPASSWD:ALL" /etc/sudoers || \
echo "gitlab-runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "=== Installing GitLab Runner service ==="

gitlab-runner install \
  --user=gitlab-runner \
  --working-directory=/home/gitlab-runner || true

gitlab-runner start

echo "=== Registering Runner ==="

gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.devops.telekom.de" \
  --token "glrt-SkUbOPxaIfxzTLXO4wKAMG86MQpwOmJlZnUKdDozCnU6cGt6FA.01.1e07pwxzj" \
  --executor "docker" \
  --docker-image "alpine:latest" \
  --description "tcp-lz-runner"

systemctl enable gitlab-runner
systemctl restart gitlab-runner

echo "=== Installed Runners ==="
gitlab-runner list

echo "=== Completed ==="
