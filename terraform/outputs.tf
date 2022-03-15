output "aws_ami_id" {
  value       = data.aws_ami.latest-amazon-image.id
  description = "To get aws ami id"

}

output "aws_ec2_public_ip"{
  value = aws_instance.myapp-instance.public_ip
}