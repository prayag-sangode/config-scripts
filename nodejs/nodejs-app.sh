#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Install Node.js
if ! command -v node &> /dev/null
then
    echo "Node.js not found. Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js is already installed."
fi

# Verify installation
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"

# Install pm2 globally
if ! command -v pm2 &> /dev/null
then
    echo "pm2 not found. Installing pm2..."
    sudo npm install -g pm2
else
    echo "pm2 is already installed."
fi

# Variables
APP_DIR="mynodejsapp"
APP_FILE="app.js"
PORT=3000

# Create project directory if it doesn't exist
if [ ! -d "$APP_DIR" ]; then
    mkdir $APP_DIR
    echo "Created project directory: $APP_DIR"
fi
cd $APP_DIR

# Initialize npm project if package.json doesn't exist
if [ ! -f "package.json" ]; then
    npm init -y
    echo "Initialized npm project."
else
    echo "npm project already initialized."
fi

# Install express if not already installed
if [ ! -d "node_modules/express" ]; then
    npm install express
    echo "Installed express."
else
    echo "Express is already installed."
fi

# Create app.js file
cat <<EOL > $APP_FILE
const express = require('express');
const app = express();
const port = $PORT;

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.listen(port, () => {
  console.log(\`Example app listening at http://localhost:\${port}\`);
});
EOL
echo "Created app.js file."

# Start the application using pm2
pm2 start $APP_FILE --name mynodejsapp

# Output the status of the application
pm2 status mynodejsapp
