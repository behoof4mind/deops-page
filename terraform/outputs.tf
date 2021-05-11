output "devops_page_url" {
  value       = aws_elb.devops-page.dns_name
  description = "The domain name of the load balancer"
}