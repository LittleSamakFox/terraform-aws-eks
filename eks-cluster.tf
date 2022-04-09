resource "aws_eks_cluster"  "k5s_cluster" {
    name = "${var.aws_default_name}-CLUSTER"
    role_arn = aws_iam_role.k5s_iam_cluster.arn
    version = "1.21"

    enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

    vpc_config{
        security_group_ids = [aws_security_group.k5s_sg_cluster.id, aws_security_group.k5s_sg_nodes.id]
        subnet_ids = flatten([aws_subnet.k5s_public_subnet[*].id, aws_subnet.k5s_private_subnet[*].id])
        endpoint_private_access = true
        endpoint_public_access = true
        public_access_cidrs = ["0.0.0.0/0"]
    }
    depends_on = [
        aws_iam_role_policy_attachment.k5s_iam_cluster_AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.k5s_iam_cluster_AmazonEKSVPCResourceControllery]
    tags = {
      "Name" = "${var.aws_default_name}-cluster"
    }
}