output "cluster_name" {
  value = aws_eks_cluster.k5s_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.k5s_cluster.endpoint
}

output "bastion_ip" {
  value = aws_eip.k5s_bastion_eip.public_ip
  description = "bastion ec2 EIP, u can access it ssh -i ~/.ssh/[PRIVATE_KEY이름].pem ec2-user@[public ip주소]"
}

/*
output "cluster_ca_certificate" {
  value = aws_eks_cluster.k5s_cluster.certificate_authority[0].data
}
*/

output "cluster_arn" {
  value = aws_eks_cluster.k5s_cluster.arn
}