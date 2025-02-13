# The FQDN for the load balancer endpoint
output "lb_fqdn" {
  value = module.webhost.lb_endpoint_dns_name
}
