resource "yandex_container_registry" "registry" {
  name      = "project-registry"
  folder_id = var.folder_id
}

output "registry_id" {
  value = yandex_container_registry.registry.id
}
