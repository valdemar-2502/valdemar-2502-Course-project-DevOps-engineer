output "bastion_public_ip" {
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  description = "Public IP address of bastion host"
}

output "load_balancer_ip" {
  value = one([
    for spec in one(yandex_lb_network_load_balancer.web_nlb.listener).external_address_spec : spec.address
  ])
  description = "Public IP address of Network Load Balancer"
}

output "grafana_public_ip" {
  value       = yandex_compute_instance.grafana.network_interface[0].nat_ip_address
  description = "Public IP address of Grafana"
}

output "kibana_public_ip" {
  value       = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
  description = "Public IP address of Kibana"
}

output "web_servers_private_ips" {
  value = {
    web_1 = yandex_compute_instance.web_1.network_interface[0].ip_address
    web_2 = yandex_compute_instance.web_2.network_interface[0].ip_address
  }
  description = "Private IP addresses of web servers"
}

output "prometheus_private_ip" {
  value       = yandex_compute_instance.prometheus.network_interface[0].ip_address
  description = "Private IP address of Prometheus"
}

output "elasticsearch_private_ip" {
  value       = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
  description = "Private IP address of Elasticsearch"
}
