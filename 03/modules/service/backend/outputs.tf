output "clb-dns-name" {
  value = aws_elb.this.dns_name
  description = "The domain name of the load balancer"
}
