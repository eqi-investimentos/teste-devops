output "sg_deveqi_api_id" {
  value = aws_security_group.sg-deveqi.id
}

output "sg_alb_id" {
  value = aws_security_group.alb.id
}

output "sg_mongodb_id" {
  value = aws_security_group.mongodb.id
}

output "alb_id" {
  value = aws_lb.alb.id
}