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

output "subnet_id" {
  value = aws_subnet.deveqi-public-a.id

}

output "vpc_id" {
  value = aws_vpc.vpc_deveqi.id
}

output "autoscaling_sgid" {

  value = aws_security_group.autoscaling.id
  
}