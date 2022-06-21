
#!/bin/bash
# Author : Prayag Sangode
# Bash script to upgrade RHEL8 to RHEL9
cat /etc/redhat-release
sudo rm -rf /root/tmp_leapp_py3
sudo subscription-manager list --installed
sudo subscription-manager repos --enable rhel-8-for-x86_64-baseos-rpms --enable rhel-8-for-x86_64-appstream-rpms
sudo subscription-manager release --set 8.6
sudo dnf update -y
sudo dnf install leapp-upgrade -y
sudo dnf versionlock clear
sudo sed -i 's|.*AllowZoneDrifting*|#&|g' /etc/firewalld/firewalld.conf
cat /etc/firewalld/firewalld.conf | grep AllowZoneDrifting
sudo leapp preupgrade --target 9.0
sudo leapp upgrade --target 9.0
cat /etc/redhat-release
uname -a
sudo subscription-manager list --installed
