#VPC 설정
resource "aws_vpc" "k5s_vpc" {
    cidr_block = var.aws_vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = tomap({
    "Name"                                      = "${var.aws_default_name}-VPC",
    "kubernetes.io/cluster/${var.aws_default_name}-CLUSTER" = "shared",
  })
}


#Subnet 생성
#특정 Availability Zone 에 속한 네트워크 그룹으로 VPC 내에서도 나눠진 독립적인 네트워크 구역
#Public Subnet 생성
resource "aws_subnet" "k5s_public_subnet" {
    count = length(var.aws_vpc_public_subnets)
    vpc_id = aws_vpc.k5s_vpc.id
    cidr_block = var.aws_vpc_public_subnets[count.index]
    availability_zone = var.aws_azs[count.index]
    map_public_ip_on_launch = true //EKS node group에 워커노드가 생성되는 즉시 자동으로 eip 할당
    tags = tomap({
    "Name"                                      = "${var.aws_default_name}-PUBLIC${count.index+1}",
    "kubernetes.io/cluster/${var.aws_default_name}-CLUSTER" = "shared",
    "kubernetes.io/role/elb" = 1
  })
}
#Private Subnet 생성
resource "aws_subnet" "k5s_private_subnet" {
    count = length(var.aws_vpc_private_subnets)
    vpc_id = aws_vpc.k5s_vpc.id
    cidr_block = var.aws_vpc_private_subnets[count.index]
    availability_zone = var.aws_azs[count.index]
    tags = tomap({
    "Name"                                      = "${var.aws_default_name}-PRIVATE${count.index+1}",
    "kubernetes.io/cluster/${var.aws_default_name}-CLUSTER" = "shared",
    "kubernetes.io/role/internal-elb" = 1
  })
}

#Internet Gateway 생성
#VPC 내부와 외부 인터넷 통신하기 위한 게이트웨이
#인터넷게이트웨이가 연결된 서브넷 == public subnet
resource "aws_internet_gateway" "k5s_igw" {
    vpc_id = aws_vpc.k5s_vpc.id
    depends_on = [aws_vpc.k5s_vpc]
    tags = {
      "Name"                                      = "${var.aws_default_name}-IGW"
    } 
}

#Route Table 생성
#트래픽을 규칙에 맞게 전달해주기 위해 필요한 일종의 테이블
#퍼블릭 라우트 테이블
#Route the public subnet traffic through the IGW
resource "aws_route_table" "k5s_public_route_table" {
    vpc_id = aws_vpc.k5s_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k5s_igw.id
    }
    tags = {
    "Name"                                      = "${var.aws_default_name}-PUBLIC-ROUTE"
  }
}
#Association을 사용하면, 라우트 테이블을 여러 서브넷에서 동시 사용 가능
#퍼블릭 라우트테이블 서브넷 라우팅
resource "aws_route_table_association" "k5s_route_table_public_routing" {
    count = length(var.aws_vpc_public_subnets)
    subnet_id = aws_subnet.k5s_public_subnet[count.index].id
    route_table_id = aws_route_table.k5s_public_route_table.id
}

#Nat Gateway 생성
#Private 서브넷에서 외부와 통신하기 위해서 필요한 일종의 게이트웨이
#Nat게이트웨이는 public subnet에 있지만, 연결은 private서브넷과 함
#고정IP(Elastic IP)필요
resource "aws_eip" "k5s_nat_eip" {
    vpc = true
    depends_on = [aws_internet_gateway.k5s_igw]
    lifecycle {
        create_before_destroy = true
    }
    tags = {
    "Name"                                      = "${var.aws_default_name}-NAT-EIP"
    }
}
#Nat게이트 웨이 생성
resource "aws_nat_gateway" "k5s_ngw" {
    allocation_id = aws_eip.k5s_nat_eip.id
    subnet_id = aws_subnet.k5s_public_subnet[0].id//public subnet을 연결해야함
    depends_on = [aws_internet_gateway.k5s_igw]
    tags = {
    "Name"                                      = "${var.aws_default_name}-NATGW"
    }
}


#프라이빗 라우트 테이블
resource "aws_route_table" "k5s_route_table_private" {
    vpc_id = aws_vpc.k5s_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.k5s_ngw.id
    }
    tags = {
    "Name"                                      = "${var.aws_default_name}-PRIVATE-ROUTE",
  }
}
#프라이빗 라우트테이블 서브넷 라우팅
resource "aws_route_table_association" "k5s_route_table_private_routing" {
    count = length(var.aws_vpc_private_subnets)
    subnet_id = aws_subnet.k5s_private_subnet[count.index].id
    route_table_id = aws_route_table.k5s_route_table_private.id
}