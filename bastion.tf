resource "aws_instance" "k5s_bastion" {
    ami = "ami-033a6a056910d1137"
    availability_zone = aws_subnet.k5s_public_subnet[0].availability_zone
    instance_type = "t2.micro"
    key_name = aws_key_pair.k5s_key.key_name
    vpc_security_group_ids = [
        aws_default_security_group.k5s_vpc_sg_default.id,
        aws_security_group.k5s_sg_bastion.id
    ]
    subnet_id = aws_subnet.k5s_public_subnet[0].id
    associate_public_ip_address = true

    tags = {
      "Name" = "${var.aws_default_name}-BastionHost"
    }
}

resource "aws_eip" "k5s_bastion_eip" {
    vpc = true
    instance = aws_instance.k5s_bastion.id
    depends_on = [aws_internet_gateway.k5s_igw]
}