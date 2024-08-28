TF_VERSION="1.5.7"
curl -LO "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
unzip "terraform_${TF_VERSION}_linux_amd64.zip" -d /usr/local/bin/
sudo unzip "terraform_${TF_VERSION}_linux_amd64.zip" -d /usr/local/bin/
terraform --version
