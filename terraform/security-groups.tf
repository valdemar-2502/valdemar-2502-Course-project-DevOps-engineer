# Bastion Security Group
resource "yandex_vpc_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  description = "Security group for bastion host"  
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "SSH from anywhere"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web Servers Security Group
resource "yandex_vpc_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Security group for web servers"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "HTTP from Load Balancer"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Node Exporter from Prometheus"
    protocol       = "TCP"
    port           = 9100
    security_group_id = yandex_vpc_security_group.prometheus_sg.id
  }

  ingress {
    description    = "Nginx Log Exporter from Prometheus"
    protocol       = "TCP"
    port           = 4040
    security_group_id = yandex_vpc_security_group.prometheus_sg.id
  }

  ingress {
    description    = "SSH from Bastion"
    protocol       = "TCP"
    port           = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  # УДАЛИТЕ этот ingress - web серверы НЕ должны принимать входящие подключения на 9200
  # Вместо этого добавьте egress для исходящих подключений
  # ingress {
  #   description    = "Filebeat to Elasticsearch"
  #   protocol       = "TCP"
  #   port           = 9200
  #   security_group_id = yandex_vpc_security_group.elasticsearch_sg.id
  # }

  egress {
    description    = "Filebeat to Elasticsearch"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = [var.private_subnet_cidr_a]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Prometheus Security Group
resource "yandex_vpc_security_group" "prometheus_sg" {
  name        = "prometheus-security-group"
  description = "Security group for Prometheus"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "Prometheus UI from Grafana"
    protocol       = "TCP"
    port           = 9090
    security_group_id = yandex_vpc_security_group.grafana_sg.id
  }

  ingress {
    description    = "SSH from Bastion"
    protocol       = "TCP"
    port           = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Grafana Security Group
resource "yandex_vpc_security_group" "grafana_sg" {
  name        = "grafana-security-group"
  description = "Security group for Grafana"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "Grafana UI from anywhere"
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH from Bastion"
    protocol       = "TCP"
    port           = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Elasticsearch Security Group
resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name        = "elasticsearch-security-group"
  description = "Security group for Elasticsearch"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "Elasticsearch API from Kibana"
    protocol       = "TCP"
    port           = 9200
    security_group_id = yandex_vpc_security_group.kibana_sg.id
  }

  # ИЗМЕНИТЕ: вместо security_group_id используйте v4_cidr_blocks
  ingress {
    description    = "Filebeat from Web Servers"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = [var.private_subnet_cidr_a, var.private_subnet_cidr_b]
  }

  ingress {
    description    = "SSH from Bastion"
    protocol       = "TCP"
    port           = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Kibana Security Group
resource "yandex_vpc_security_group" "kibana_sg" {
  name        = "kibana-security-group"
  description = "Security group for Kibana"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "Kibana UI from anywhere"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH from Bastion"
    protocol       = "TCP"
    port           = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Load Balancer Security Group
resource "yandex_vpc_security_group" "lb_sg" {
  name        = "load-balancer-security-group"
  description = "Security group for Load Balancer"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "HTTP from anywhere"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
