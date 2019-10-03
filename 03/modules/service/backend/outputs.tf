output "clb_dns_name" {
  description = "The domain name of the load balancer"
  value = aws_elb.this.dns_name
}
