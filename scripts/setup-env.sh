#!/bin/bash

# Setup environment variables for Ansible
# This script should be sourced before running Ansible playbooks

# Check if Terraform outputs exist
if [ ! -f terraform_outputs.txt ]; then
    echo "Please run 'terraform output > terraform_outputs.txt' first"
    exit 1
fi

# Parse Terraform outputs
export BASTION_IP=$(grep 'bastion_public_ip' terraform_outputs.txt | awk '{print $3}' | tr -d '"')
export LOAD_BALANCER_IP=$(grep 'load_balancer_ip' terraform_outputs.txt | awk '{print $3}' | tr -d '"')
export GRAFANA_IP=$(grep 'grafana_public_ip' terraform_outputs.txt | awk '{print $3}' | tr -d '"')
export KIBANA_IP=$(grep 'kibana_public_ip' terraform_outputs.txt | awk '{print $3}' | tr -d '"')

# Extract private IPs from JSON output
export WEB1_IP=$(grep -A2 'web_servers_private_ips' terraform_outputs.txt | grep 'web_1' | awk '{print $3}' | tr -d '",')
export WEB2_IP=$(grep -A2 'web_servers_private_ips' terraform_outputs.txt | grep 'web_2' | awk '{print $3}' | tr -d '",')
export PROMETHEUS_IP=$(grep 'prometheus_private_ip' terraform_outputs.txt | awk '{print $3}' | tr -d '"')
export ELASTICSEARCH_IP=$(grep 'elasticsearch_private_ip' terraform_outputs.txt | awk '{print $3}' | tr -d '"')

# Display extracted values
echo "Environment variables set:"
echo "BASTION_IP: $BASTION_IP"
echo "WEB1_IP: $WEB1_IP"
echo "WEB2_IP: $WEB2_IP"
echo "PROMETHEUS_IP: $PROMETHEUS_IP"
echo "ELASTICSEARCH_IP: $ELASTICSEARCH_IP"
echo "GRAFANA_IP: $GRAFANA_IP"
echo "KIBANA_IP: $KIBANA_IP"
echo "LOAD_BALANCER_IP: $LOAD_BALANCER_IP"

# Create Ansible inventory with actual IPs
cat > ansible/inventory/dynamic.yml << EOL
all:
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: "\${HOME}/.ssh/id_rsa"
    ansible_ssh_common_args: '-o ProxyCommand="ssh -W %h:%p -q ubuntu@${BASTION_IP}"'
    
    # Service URLs
    elasticsearch_deb_url: "https://mirror.yandex.ru/mirrors/elastic/9/pool/main/e/elasticsearch/elasticsearch-9.2.4-amd64.deb"
    kibana_deb_url: "https://mirror.yandex.ru/mirrors/elastic/9/pool/main/k/kibana/kibana-9.2.4-amd64.deb"
    filebeat_deb_url: "https://mirror.yandex.ru/mirrors/elastic/9/pool/main/f/filebeat/filebeat-9.2.4-amd64.deb"
    grafana_deb_url: "https://mirror.yandex.ru/mirrors/packages.grafana.com/oss/deb/pool/main/g/grafana/grafana_12.3.1_20271043721_linux_amd64.deb"
    node_exporter_deb_url: "https://mirror.yandex.ru/debian/pool/main/p/prometheus-node-exporter/prometheus-node-exporter_1.10.2-1_amd64.deb"
    nginx_log_exporter_deb_url: "https://github.com/martin-helmich/prometheus-nginxlog-exporter/releases/download/v1.11.0/prometheus-nginxlog-exporter_1.11.0_linux_amd64.deb"
    prometheus_deb_url: "https://mirror.yandex.ru/debian/pool/main/p/prometheus/prometheus_2.53.5+ds1-3_amd64.deb"

  children:
    bastion:
      hosts:
        bastion:
          ansible_host: "${BASTION_IP}"
          ansible_ssh_common_args: ""
    
    webservers:
      hosts:
        web-1:
          ansible_host: "${WEB1_IP}"
        web-2:
          ansible_host: "${WEB2_IP}"
    
    monitoring:
      hosts:
        prometheus:
          ansible_host: "${PROMETHEUS_IP}"
        grafana:
          ansible_host: "${GRAFANA_IP}"
    
    logging:
      hosts:
        elasticsearch:
          ansible_host: "${ELASTICSEARCH_IP}"
        kibana:
          ansible_host: "${KIBANA_IP}"
EOL

echo "Dynamic inventory created at ansible/inventory/dynamic.yml"
echo "To use it, set ANSIBLE_INVENTORY=ansible/inventory/dynamic.yml"
echo "Or update ansible.cfg to point to dynamic.yml"
