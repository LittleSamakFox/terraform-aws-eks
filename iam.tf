#IAM 유저 생성
resource "aws_iam_user" "k5s_user1" {
  name = "eevvee"
}
#IAM 그룹 생성
resource "aws_iam_group" "k5s_group" {
  name = "pokemon"
}
#IAM 그룹에 IAM 유저 등록
resource "aws_iam_group_membership" "pokemon" {
  name = aws_iam_group.k5s_group.name
  users = [
    aws_iam_user.k5s_user1.name
  ]
  group = aws_iam_group.k5s_group.name
}

#IAM User Policy 생성
#아래는 유저가 모든 권한 가지게 설정한 것
resource "aws_iam_user_policy" "k5s_iam_user_policy" {
    name = "evolution_stone"
    user = aws_iam_user.k5s_user1.name

    policy =  <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}


#EKS Cluster IAM Role 생성
resource "aws_iam_role" "k5s_iam_cluster" {
  name = "${var.aws_default_name}-IAM-CLUSTER"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
#EKS Cluster IAM Policy 생성
resource "aws_iam_role_policy_attachment" "k5s_iam_cluster_AmazonEKSClusterPolicy" {
  role = aws_iam_role.k5s_iam_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "k5s_iam_cluster_AmazonEKSVPCResourceControllery" {
  role = aws_iam_role.k5s_iam_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

#EKS Node IAM Role 생성
resource "aws_iam_role" "k5s_iam_nodes" {
  name = "${var.aws_default_name}-IAM-WORKERNODE"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
#EKS Node IAM Policy 생성
resource "aws_iam_role_policy_attachment" "k5s_iam_cluster_AmazonEKSWorkerNodePolicy" {
  role = aws_iam_role.k5s_iam_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "k5s_iam_cluster_AmazonEKS_CNI_Policy" {
  role = aws_iam_role.k5s_iam_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "k5s_iam_cluster_AmazonEC2ContainerRegistryReadOnly" {
  role = aws_iam_role.k5s_iam_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}