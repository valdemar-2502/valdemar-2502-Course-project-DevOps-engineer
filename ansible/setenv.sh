#!/bin/bash
# Установите реальные IP адреса ваших серверов
export BASTION_IP="158.160.116.217"
export WEB1_IP="10.0.2.26"
export WEB2_IP="10.0.3.9"
export PROMETHEUS_IP="10.0.2.32"
export ELASTICSEARCH_IP="10.0.2.35"
export GRAFANA_IP="158.160.102.192"
export KIBANA_IP="89.169.144.143"

echo "Environment variables set"
