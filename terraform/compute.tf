# compute.tf

# Bastion Host - обычный инстанс, полная производительность
resource "yandex_compute_instance" "bastion" {
  name        = var.bastion_name
  platform_id = var.bastion_instance_type
  zone        = "ru-central1-a"
  hostname    = var.bastion_name

  resources {
    cores         = 2
    core_fraction = var.bastion_core_fraction  # 100% по умолчанию
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
    user-data = <<-EOF
      #cloud-config
      write_files:
        - path: /etc/sysctl.d/10-ip-forward.conf
          content: |
            net.ipv4.ip_forward=1
            net.ipv6.conf.all.forwarding=1
      runcmd:
        - sysctl -p /etc/sysctl.d/10-ip-forward.conf
        - iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
        - iptables -A FORWARD -i eth0 -o eth0 -j ACCEPT
        - apt-get update
        - apt-get install -y iptables-persistent
        - netfilter-persistent save
      EOF
  }
}

# Web Server 1 - прерываемый с минимальной долей vCPU
resource "yandex_compute_instance" "web_1" {
  name        = var.webserver_names[0]
  platform_id = var.web_instance_type
  zone        = "ru-central1-a"
  hostname    = var.webserver_names[0]

  resources {
    cores         = 2
    core_fraction = var.web_core_fraction  # 5% минимальная доля
    memory        = 2
  }

  scheduling_policy {
    preemptible = var.web_preemptible  # true - прерываемый
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_a.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

# Web Server 2 - прерываемый с минимальной долей vCPU
resource "yandex_compute_instance" "web_2" {
  name        = var.webserver_names[1]
  platform_id = var.web_instance_type
  zone        = "ru-central1-b"
  hostname    = var.webserver_names[1]

  resources {
    cores         = 2
    core_fraction = var.web_core_fraction  # 5% минимальная доля
    memory        = 2
  }

  scheduling_policy {
    preemptible = var.web_preemptible  # true - прерываемый
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_b.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

# Prometheus Server - обычный, средняя производительность
resource "yandex_compute_instance" "prometheus" {
  name        = var.prometheus_name
  platform_id = var.prometheus_instance_type
  zone        = "ru-central1-a"
  hostname    = var.prometheus_name

  resources {
    cores         = 2
    core_fraction = var.prometheus_core_fraction  # 50% средняя производительность
    memory        = 2
  }

  # Prometheus не делаем прерываемым, так как это критично для мониторинга
  scheduling_policy {
    preemptible = var.prometheus_preemptible  # false
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_a.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.prometheus_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

# Grafana Server - обычный, базовая производительность
resource "yandex_compute_instance" "grafana" {
  name        = var.grafana_name
  platform_id = var.grafana_instance_type
  zone        = "ru-central1-a"
  hostname    = var.grafana_name

  resources {
    cores         = 2
    core_fraction = var.grafana_core_fraction  # 20% базовая производительность
    memory        = 2
  }

  scheduling_policy {
    preemptible = var.grafana_preemptible  # false
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.grafana_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

# Elasticsearch Server - обычный, полная производительность
resource "yandex_compute_instance" "elasticsearch" {
  name        = var.elasticsearch_name
  platform_id = var.elasticsearch_instance_type
  zone        = "ru-central1-a"
  hostname    = var.elasticsearch_name

  resources {
    cores         = 4
    core_fraction = var.elasticsearch_core_fraction  # 100% полная производительность
    memory        = 8
  }

  # Elasticsearch НЕ должен быть прерываемым!
  scheduling_policy {
    preemptible = var.elasticsearch_preemptible  # false
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_a.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.elasticsearch_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

# Kibana Server - обычный, базовая производительность
resource "yandex_compute_instance" "kibana" {
  name        = var.kibana_name
  platform_id = var.kibana_instance_type
  zone        = "ru-central1-a"
  hostname    = var.kibana_name

  resources {
    cores         = 2
    core_fraction = var.kibana_core_fraction  # 20% базовая производительность
    memory        = 2
  }

  scheduling_policy {
    preemptible = var.kibana_preemptible  # false
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.kibana_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}
