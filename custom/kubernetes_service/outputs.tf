output "service_name" {
  value = kubernetes_service.this.metadata[0].name
}

output "service_port" {
  value = kubernetes_service.this.spec[0].port[0].port
}
