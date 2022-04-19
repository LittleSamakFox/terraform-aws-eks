#VPC Default SecurityGroup
resource "aws_default_security_group" "k5s_vpc_sg_default"{
    vpc_id = aws_vpc.k5s_vpc.id
    ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

#Bastion 보안 그룹 설정
resource "aws_security_group" "k5s_sg_bastion" {
    vpc_id = aws_vpc.k5s_vpc.id
    name = "${var.aws_default_name}-SG-BASTION"
    description = "Security group for bastion instance"
    ingress { //SSH
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { //HTTP
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    ingress { //HTTPS
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    ingress { //ICMP
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      "Name" = "${var.aws_default_name}-Bastion-SG"
    }
}

#RDS 보안 그룹 설정
resource "aws_security_group" "k5s_sg_RDS" {
    vpc_id = aws_vpc.k5s_vpc.id
    name = "${var.aws_default_name}-SG-RDS"
    description = "Security group for RDS instance"
    tags = {
      "Name" = "${var.aws_default_name}-RDS-SG"
    }
}
resource "aws_security_group_rule" "k5s_sg_RDS_inbound" {
    security_group_id = aws_security_group.k5s_sg_RDS.id
    source_security_group_id = aws_security_group.k5s_sg_bastion.id
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    description = "Allow communicate with RDS"   
}
resource "aws_security_group_rule" "k5s_sg_RDS_outbound" {
    security_group_id = aws_security_group.k5s_sg_RDS.id
    source_security_group_id = aws_security_group.k5s_sg_bastion.id
    type = "egress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    description = "Allow communicate with RDS"   
}

#클러스터 보안 그룹 생성
resource "aws_security_group" "k5s_sg_controlplane" {
    vpc_id = aws_vpc.k5s_vpc.id
    name = "${var.aws_default_name}-SG-ControlPlane"
    description = "Communication between the control plane and worker nodegroups"
    tags = {
      "Name" = "${var.aws_default_name}-ControlPlane-SG"
    }
}
resource "aws_security_group_rule" "k5s_sg_cluster_inbound" { #ingress룰 추가
    security_group_id = aws_security_group.k5s_sg_controlplane.id
    source_security_group_id = aws_security_group.k5s_sg_nodes.id
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "Allow nodes to communicate with the cluster API Server"
}
resource "aws_security_group_rule" "k5s_sg_cluster_outbound" {
    security_group_id = aws_security_group.k5s_sg_controlplane.id
    source_security_group_id = aws_security_group.k5s_sg_nodes.id
    type = "egress"
    from_port = 1025
    to_port = 65535
    protocol = "tcp"
    description = "Allow Cluster API Server to communicate with the worker nodes"
}
resource "aws_security_group_rule" "k5s_sg_cluster_bastion" { //바스티온 통신 추가
    security_group_id = aws_security_group.k5s_sg_controlplane.id
    source_security_group_id = aws_security_group.k5s_sg_bastion.id
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "Allow bastion nodes to communicate with the cluster API Server"   
}

#노드그룹 보안 그룹 생성
resource "aws_security_group" "k5s_sg_nodes" {
    vpc_id = aws_vpc.k5s_vpc.id
    name = "${var.aws_default_name}-SG-NodeGroup"
    description = "Security group for worker nodes in Cluster"
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = tomap({
    "Name"                                      = "${var.aws_default_name}-NodeGroup-SG",
    "kubernetes.io/cluster/${var.aws_default_name}-cluster" = "owned",
  })
}
resource "aws_security_group_rule" "k5s_sg_nodes_internal" {
    security_group_id = aws_security_group.k5s_sg_nodes.id
    source_security_group_id = aws_security_group.k5s_sg_nodes.id
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    description = "Allow nodes to communicate with each other"
}
resource "aws_security_group_rule" "k5s_sg_nodes_inbound" {
    security_group_id = aws_security_group.k5s_sg_nodes.id
    source_security_group_id = aws_security_group.k5s_sg_controlplane.id
    type = "ingress"
    from_port = 1025
    to_port = 65535
    protocol = "tcp"
    description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"   
}
resource "aws_security_group_rule" "k5s_sg_nodes_ssh_inbound" {
    security_group_id = aws_security_group.k5s_sg_nodes.id
    source_security_group_id = aws_security_group.k5s_sg_controlplane.id
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "Allow ssh worker Kubelets and pods to receive communication from the cluster control plane"   
}