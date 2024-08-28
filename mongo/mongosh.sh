#!/bin/bash

# Download mongosh tarball
wget -q https://downloads.mongodb.com/compass/mongosh-2.1.4-linux-x64.tgz

# Extract the mongosh tarball
tar -zxvf mongosh-2.1.4-linux-x64.tgz

# Make the mongosh binary executable
chmod +x mongosh-2.1.4-linux-x64/bin/mongosh

# Move the mongosh binary to /usr/local/bin/
cp mongosh-2.1.4-linux-x64/bin/mongosh /usr/local/bin/

# Move the mongosh_crypt_v1.so library to /usr/local/lib/
cp mongosh-2.1.4-linux-x64/bin/mongosh_crypt_v1.so /usr/local/lib/

# Create a symbolic link to the mongosh binary in /usr/local/bin/
ln -s /usr/local/bin/mongosh-2.1.4-linux-x64/bin/* /usr/local/bin/

# Clean up
rm -rf mongosh-2.1.4-linux-x64.tgz mongosh-2.1.4-linux-x64
