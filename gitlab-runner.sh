curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get update && apt-get -y install docker.io && apt-get -y install gitlab-runner=16.4.0 docker.io
echo "gitlab-runner ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
cat /etc/sudoers | grep gitlab
echo '{"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}' | sudo tee /etc/docker/daemon.json
cat /etc/docker/daemon.json
sudo sed -i -e 's|^\(ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock\)|#\1\nExecStart=/usr/bin/dockerd|' /lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl restart gitlab-runner
export REGISTRATION_TOKEN=<replace-me>
sudo gitlab-runner register --url https://gitlab.com --registration-token $REGISTRATION_TOKEN

# Remove/ un-register -
# gitlab-runner verify --delete -t <token> -u https://gitlab.com
