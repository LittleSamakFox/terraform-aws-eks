resource "aws_db_instance" "k5s_rds" {
  identifier           = "k5s-rds"
  allocated_storage    = 10
  max_allocated_storage = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "k5sDB"
  username             = "k5s_rds_admin"
  password             = "k5s_rds_passwd"
  db_subnet_group_name = aws_db_subnet_group.k5s_rds_subnet.name
  vpc_security_group_ids = [ 
    aws_security_group.k5s_sg_RDS.id,
    ]
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "k5s_rds_subnet" {
  name       = "k5s_rds_subnet"
  subnet_ids = aws_subnet.k5s_private_subnet[*].id

  tags = {
    Name = "My k5s_rds subnet group"
  }
}