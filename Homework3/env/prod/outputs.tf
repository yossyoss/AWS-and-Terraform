output "db_servers_private_ips" {
  value = module.app.db_servers_private_ips
}

output "web_servers_public_ips" {
  value = module.app.web_servers_public_ips
}

output "alb_public_dns" {
  value = module.app.alb_public_dns
}