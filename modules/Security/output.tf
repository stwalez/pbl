output "ext-alb-sg" {
  value = aws_security_group.ext-alb-sg
}

output "int-alb-sg" {
  value = aws_security_group.int-alb-sg
}

output "bastion_sg" {
  value = aws_security_group.bastion_sg
}

output "webserver_sg" {
  value = aws_security_group.webserver-sg
}

output "nginx_sg" {
  value = aws_security_group.nginx-sg
}

output "datalayer_sg" {
  value = aws_security_group.datalayer-sg
}