# Snapshot schedule for all instances
resource "yandex_compute_snapshot_schedule" "daily_backup" {
  name = "daily-backup-schedule"

  schedule_policy {
    expression = "0 2 * * *" # Daily at 02:00
  }

  retention_period = "168h" # 7 days in hours

  snapshot_count = 7 # Keep 7 snapshots

  snapshot_spec {
    description = "Daily backup"
  }

  # Attach all instance disks
  disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.web_1.boot_disk[0].disk_id,
    yandex_compute_instance.web_2.boot_disk[0].disk_id,
    yandex_compute_instance.prometheus.boot_disk[0].disk_id,
    yandex_compute_instance.grafana.boot_disk[0].disk_id,
    yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id,
  ]
}
