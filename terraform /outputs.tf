
output "ec2_public_ip" {
  description = "Public IP of Python application"
  value       = aws_instance.python_app.public_ip
}

output "application_url" {
  description = "Python application URL"
  value       = "http://${aws_instance.python_app.public_ip}"
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.python_app.id
}

