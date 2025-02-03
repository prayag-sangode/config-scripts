#!/bin/bash

JENKINS_HOME=/var/lib/jenkins
PLUGIN_DIR=$JENKINS_HOME/plugins
JENKINS_CLI="http://localhost:8080/jnlpJars/jenkins-cli.jar"

# List of required plugins
PLUGINS=(
  "git"                     # Git Plugin
  "docker-workflow"          # Docker Pipeline Plugin
  "kubernetes"               # Kubernetes Plugin
  "sonar"                    # SonarQube Scanner Plugin
  "snyk-security-scanner"    # Snyk Secruity Plugin
  "workflow-aggregator"      # Pipeline Aggregator Plugin
  "blueocean"                # Blue Ocean UI Plugin
  "credentials-binding"      # Credentials Binding Plugin
  "git-parameter"            # Git Parameter Plugin (optional, for GitHub integration)
  "email-ext"                # Email Extension Plugin (optional)
  "slack"                    # Slack Notification Plugin (optional)
)

echo "Downloading Jenkins CLI..."
wget -q $JENKINS_CLI -O /tmp/jenkins-cli.jar

# Install the plugins
for plugin in "${PLUGINS[@]}"; do
    echo "Installing $plugin plugin..."
    java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth prayag:pwadmin install-plugin $plugin
done

# Restart Jenkins after plugin installation
echo "Restarting Jenkins..."
java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth prayag:pwadmin safe-restart

echo "Jenkins plugins installed and Jenkins restarted successfully!"
