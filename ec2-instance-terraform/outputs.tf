output "aws_instance_arn" {
  value = aws_instance.hello_world.arn
}

output "aws_instance_ip" {
  value = aws_instance.hello_world.private_ip
}

output "aws_instance" {
  value = aws_instance.hello_world
}