output "cluster_name" {
  value = aws_eks_cluster.k5s_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.k5s_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.k5s_cluster.certificate_authority[0].data
}