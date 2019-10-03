output "clb_dns_name" {
  value = module.webserver_backend_cluster.clb_dns_name
  description = "The domain name of the load balancer"
}
