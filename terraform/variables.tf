# variables.tf

# Yandex Cloud credentials
variable "yc_token" {
  type        = string
  sensitive   = true
  description = "Yandex Cloud OAuth token"
}

variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud folder ID"
}

# SSH and Image
variable "ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to SSH public key"
}

variable "ubuntu_image_id" {
  type        = string
  default     = "fd804teg9bthv0h96s8v"  # Ubuntu 22.04 LTS
  description = "Ubuntu 22.04 LTS image ID"
}

# Network variables
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Public subnet CIDR"
}

variable "private_subnet_cidr_a" {
  type        = string
  default     = "10.0.2.0/24"
  description = "Private subnet A CIDR"
}

variable "private_subnet_cidr_b" {
  type        = string
  default     = "10.0.3.0/24"
  description = "Private subnet B CIDR"
}

# Instance names
variable "bastion_name" {
  type        = string
  default     = "bastion"
  description = "Bastion host name"
}

variable "webserver_names" {
  type        = list(string)
  default     = ["web-1", "web-2"]
  description = "Web server names"
}

variable "prometheus_name" {
  type        = string
  default     = "prometheus"
  description = "Prometheus server name"
}

variable "grafana_name" {
  type        = string
  default     = "grafana"
  description = "Grafana server name"
}

variable "elasticsearch_name" {
  type        = string
  default     = "elasticsearch"
  description = "Elasticsearch server name"
}

variable "kibana_name" {
  type        = string
  default     = "kibana"
  description = "Kibana server name"
}

# Instance types
variable "bastion_instance_type" {
  type        = string
  default     = "standard-v2"
  description = "Bastion instance type"
}

variable "web_instance_type" {
  type        = string
  default     = "standard-v2"
  description = "Web server instance type"
}

variable "prometheus_instance_type" {
  type        = string
  default     = "standard-v2"
  description = "Prometheus instance type"
}

variable "grafana_instance_type" {
  type        = string
  default     = "standard-v2"
  description = "Grafana instance type"
}

variable "elasticsearch_instance_type" {
  type        = string
  default     = "standard-v2"
  description = "Elasticsearch instance type"
}

variable "kibana_instance_type" {
  type        = string
  default     = "standard-v2"
  description = "Kibana instance type"
}

# vCPU Core fractions (5, 20, 50, 100)
variable "bastion_core_fraction" {
  type        = number
  default     = 100
  description = "Bastion vCPU fraction (5, 20, 50, 100)"
}

variable "web_core_fraction" {
  type        = number
  default     = 5
  description = "Web servers vCPU fraction (5, 20, 50, 100)"
}

variable "prometheus_core_fraction" {
  type        = number
  default     = 50
  description = "Prometheus vCPU fraction (5, 20, 50, 100)"
}

variable "grafana_core_fraction" {
  type        = number
  default     = 20
  description = "Grafana vCPU fraction (5, 20, 50, 100)"
}

variable "elasticsearch_core_fraction" {
  type        = number
  default     = 100
  description = "Elasticsearch vCPU fraction (5, 20, 50, 100)"
}

variable "kibana_core_fraction" {
  type        = number
  default     = 20
  description = "Kibana vCPU fraction (5, 20, 50, 100)"
}

# Preemptible instances flags
variable "web_preemptible" {
  type        = bool
  default     = true
  description = "Make web servers preemptible (spot instances)"
}

variable "prometheus_preemptible" {
  type        = bool
  default     = false
  description = "Make Prometheus preemptible"
}

variable "grafana_preemptible" {
  type        = bool
  default     = false
  description = "Make Grafana preemptible"
}

variable "elasticsearch_preemptible" {
  type        = bool
  default     = false
  description = "Make Elasticsearch preemptible"
}

variable "kibana_preemptible" {
  type        = bool
  default     = false
  description = "Make Kibana preemptible"
}
