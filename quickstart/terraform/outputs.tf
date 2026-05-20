output "api_vm_public_ip" {
  description = "Public IP of API VM"
  value       = aws_instance.api_vm.public_ip
}

output "api_vm_private_ip" {
  description = "Private IP of API VM"
  value       = aws_instance.api_vm.private_ip
}

output "inference_vm_private_ip" {
  description = "Private IP of inference VM"
  value       = aws_instance.inference_vm.private_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.project_vpc.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = aws_subnet.private_subnet.id
}