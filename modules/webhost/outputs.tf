# Output the FQDN of the load balancer endpoint
output "lb_endpoint_dns_name" {
  value = aws_lb.webserver.dns_name
}
