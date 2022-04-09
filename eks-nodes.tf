resource "aws_eks_node_group"  "k5s_nodes" {
    cluster_name = aws_eks_cluster.k5s_cluster.name
    node_group_name = "${var.aws_default_name}"
    node_role_arn = aws_iam_role.k5s_iam_nodes.arn
    subnet_ids = aws_subnet.k5s_private_subnet[*].id

    ami_type = "AL2_x86_64"
    capacity_type = "ON_DEMAND"
    instance_types = ["t3.micro"]
    disk_size = 20

    scaling_config {
      desired_size = 2
      max_size = 4
      min_size = 1
    }
    
    remote_access {
      source_security_group_ids = [aws_security_group.k5s_sg_bastion.id]
      ec2_ssh_key = aws_key_pair.k5s_key.key_name
    }

    depends_on = [
        aws_iam_role_policy_attachment.k5s_iam_cluster_AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.k5s_iam_cluster_AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.k5s_iam_cluster_AmazonEC2ContainerRegistryReadOnly]
    tags = {
      "Name" = "${var.aws_default_name}-nodes"
    }
}