/*
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
    aws_subnet.k5s_public_subnet[0].id,
    aws_subnet.k5s_public_subnet[1].id,
    aws_subnet.k5s_public_subnet[2].id,
    ]
  ingress { //HTTP
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    rule_no = 100
  }
  ingress { //HTTPS
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    rule_no = 110
  }
  ingress { //SSH
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    rule_no = 120
  }
  ingress { //RDP
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    rule_no = 130
  }
  ingress { //CustomTCP
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    protocol = "tcp"
    rule_no = 140
  }
  ingress { //ICMP
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    protocol = "icmp"
    rule_no = 1
  }
  egress { //HTTP
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    rule_no = 100
  }
  egress { //HTTPS
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    rule_no = 110
  }
  egress { //SSH
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    protocol = "tcp"
    rule_no = 120
  }
  egress { //CustomTCP
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    protocol = "tcp"
    rule_no = 140
  }
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = -1
    rule_no    = 2
  }
}

#프라이빗 서브넷에서 사용할 ACL 규칙 추가
resource "aws_network_acl" "k5s_acl_private" {
    vpc_id = aws_vpc.k5s_vpc.id
    subnet_ids = [
      aws_subnet.k5s_private_subnet[0].id,
      aws_subnet.k5s_private_subnet[1].id,
      aws_subnet.k5s_private_subnet[2].id,
    ]
    ingress {//NAT Ingress
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      rule_no = 140
    }
    ingress {
      action = "allow"
      cidr_block = aws_vpc.k5s_vpc.cidr_block
      from_port = 0
      to_port = 0
      protocol = -1
      rule_no = 100
    }
    egress { //http
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      rule_no = 100
    }
    egress { //https
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      rule_no = 110
    }
    egress {
      action = "allow"
      cidr_block = aws_vpc.k5s_vpc.cidr_block
      from_port = 0
      to_port = 0
      protocol = -1
      rule_no = 2
    }
}
*/
