wget https://nodejs.org/dist/v20.11.0/node-v20.11.0-linux-x64.tar.xz
tar -xf node-v20.11.0-linux-x64.tar.xz
cd node-v20.11.0-linux-x64/bin
sudo cp node-v20.11.0-linux-x64/bin/node /usr/local/bin
sudo ln -s /usr/local/bin/node /usr/bin/node
node -v
