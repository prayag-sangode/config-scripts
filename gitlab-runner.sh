sudo apt-get update && apt-get -y install docker.io
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
apt-get update
echo "gitlab-runner ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
echo '{"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}' | sudo tee /etc/docker/daemon.json
sudo sed -i -e 's|^\(ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock\)|#\1\nExecStart=/usr/bin/dockerd|' /lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl restart gitlab-runner
export REGISTRATION_TOKEN=<replace-me>
sudo gitlab-runner register --url https://gitlab.devops.telekom.de/ --registration-token $REGISTRATION_TOKEN
