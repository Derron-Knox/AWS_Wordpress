# output public IPs to CLI
output "bastion-Public-IP" {
  value = aws_instance.bastion.public_ip
}

output "wordpress-web-IP" {
  value = aws_instance.wordpress-web.private_ip
}

output "wordpress-data-IP" {
  value = aws_instance.wordpress-data.private_ip
}

# Output Loadbalancer DNS to CLI
output "LB-DNS-NAME" {
  value = aws_lb.application-lb.dns_name
}