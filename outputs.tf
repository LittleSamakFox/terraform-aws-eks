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

output "jenkins_ip" {
  value = aws_eip.k5s_jenkins_eip.public_ip
  description = "jenkins ec2 EIP, u can access it ssh -i ~/.ssh/[PRIVATE_KEY이름].pem ec2-user@[public ip주소]"
}

output "rds_user_endpoint" {
  value = aws_db_instance.k5s_rds_user.endpoint
  description = "RDS Endpoint"
}
output "rds_auth_endpoint" {
  value = aws_db_instance.k5s_rds_auth.endpoint
  description = "RDS Endpoint"
}
output "rds_movie_endpoint" {
  value = aws_db_instance.k5s_rds_movie.endpoint
  description = "RDS Endpoint"
}
output "rds_review_endpoint" {
  value = aws_db_instance.k5s_rds_review.endpoint
  description = "RDS Endpoint"
}

/*
output "cluster_ca_certificate" {
  value = aws_eks_cluster.k5s_cluster.certificate_authority[0].data
}
*/

/*
output "cluster_arn" {
  value = aws_eks_cluster.k5s_cluster.arn
}
*/