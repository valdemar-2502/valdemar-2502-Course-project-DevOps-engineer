# Target Group for web servers
resource "yandex_lb_target_group" "web" {
  name = "web-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.private_a.id
    address    = yandex_compute_instance.web_1.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.private_b.id
    address    = yandex_compute_instance.web_2.network_interface.0.ip_address
  }
}

# Network Load Balancer
resource "yandex_lb_network_load_balancer" "web_nlb" {
  name = "web-network-load-balancer"
  type = "external"

  listener {
    name = "web-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web.id

    healthcheck {
      name                = "http"
      interval            = 2
      timeout             = 1
      unhealthy_threshold = 2
      healthy_threshold   = 2

      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
