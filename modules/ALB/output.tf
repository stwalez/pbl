output "alb_dns_name" {
  value = aws_lb.ext-alb.dns_name
}

output "alb_nginx_tg_arn" {
  value = aws_lb_target_group.nginx-tgt.arn
}

output "alb_wordpress_tg_arn" {
  value = aws_lb_target_group.wordpress-tgt.arn
}

output "alb_tooling_tg_arn" {
  value = aws_lb_target_group.tooling-tgt.arn
}
