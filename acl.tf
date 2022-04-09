#VPC Default ACL
resource "aws_default_network_acl" "k5s_vpc_acl_default" {
  default_network_acl_id = aws_vpc.k5s_vpc.default_network_acl_id
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

#퍼블릭 서브넷에서 사용할 네트워크 ACL 생성
resource "aws_network_acl" "k5s_acl_public" {
    vpc_id = aws_vpc.k5s_vpc.id
    subnet_ids = [
      aws_subnet.k5s_public_subnet.0.id,
      aws_subnet.k5s_public_subnet.1.id,
    ]
}
#퍼블릭 서브넷 용 네트워크 ACL 규칙 추가
resource "aws_network_acl_rule" "k5s_acl_public_http_ingress" {
  network_acl_id = aws_network_acl.k5s_acl_public.id
  rule_number = 100
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}
resource "aws_network_acl_rule" "k5s_acl_public_http_egress" {
  network_acl_id = aws_network_acl.k5s_acl_public.id
  rule_number = 100
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}
resource "aws_network_acl_rule" "k5s_acl_public_https_ingress" {
  network_acl_id = aws_network_acl.k5s_acl_public.id
  rule_number = 110
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}
resource "aws_network_acl_rule" "k5s_acl_public_https_egress" {
  network_acl_id = aws_network_acl.k5s_acl_public.id
  rule_number = 110
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}
resource "aws_network_acl_rule" "k5s_acl_public_ssh_ingress" {
  network_acl_id = aws_network_acl.k5s_acl_public.id
  rule_number = 120
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 22
  to_port = 22
}
resource "aws_network_acl_rule" "k5s_acl_public_ssh_egress" {
  network_acl_id = aws_network_acl.k5s_acl_public.id
  rule_number = 120
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = aws_vpc.k5s_vpc.cidr_block //cidr블록으로 설정
  from_port = 22
  to_port = 22
}
resource "aws_network_acl_rule" "k5s_acl_public_customtcp_ingress" {
  network_acl_id = aws_network_acl.k5s_acl_public.id
  rule_number = 140
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 1024 //NAT게이트웨이 포트는 1024부터 사용
  to_port = 65535
}
resource "aws_network_acl_rule" "k5s_acl_public_customtcp_egress" {
  network_acl_id = aws_network_acl.k5s_acl_public.id
  rule_number = 140
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}


#프라이빗 서브넷에서 사용할 ACL 규칙 추가
resource "aws_network_acl" "k5s_acl_private" {
    vpc_id = aws_vpc.k5s_vpc.id
    subnet_ids = [
      aws_subnet.k5s_private_subnet.0.id,
      aws_subnet.k5s_private_subnet.1.id,
    ]
}
#프라이빗 서브넷 용 네트워크 ACL 규칙 추가
resource "aws_network_acl_rule" "k5s_acl_private_ingress" {
    network_acl_id = aws_network_acl.k5s_acl_private.id
    rule_number = 100
    rule_action = "allow"
    egress = false
    protocol = -1
    cidr_block = aws_vpc.k5s_vpc.cidr_block
    from_port = 0
    to_port = 0
}
resource "aws_network_acl_rule" "k5s_acl_private_egress" {
    network_acl_id = aws_network_acl.k5s_acl_private.id
    rule_number = 100
    rule_action = "allow"
    egress = true
    protocol = -1
    cidr_block = aws_vpc.k5s_vpc.cidr_block
    from_port = 0
    to_port = 0
}
resource "aws_network_acl_rule" "k5s_acl_private_nat_ingress" {
  network_acl_id = aws_network_acl.k5s_acl_private.id
  rule_number = 110
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}
resource "aws_network_acl_rule" "k5s_acl_private_http_egress" {
    network_acl_id = aws_network_acl.k5s_acl_private.id
    rule_number = 120
    rule_action = "allow"
    egress = true
    protocol = "tcp"
    cidr_block = aws_vpc.k5s_vpc.cidr_block
    from_port = 80
    to_port = 80
}
resource "aws_network_acl_rule" "k5s_acl_private_https_egress" {
  network_acl_id = aws_network_acl.k5s_acl_private.id
  rule_number = 130
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}