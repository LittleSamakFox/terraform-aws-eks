resource "aws_db_instance" "k5s_rds_auth" {
  identifier           = "k5s-rds-auth"
  allocated_storage    = 10
  max_allocated_storage = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "k5sDBauth"
  username             = "k5s_rds_admin"
  password             = "k5s_rds_passwd"
  db_subnet_group_name = aws_db_subnet_group.k5s_rds_subnet.name
  vpc_security_group_ids = [ 
    aws_security_group.k5s_sg_RDS.id,
    ]
  skip_final_snapshot  = true
}
resource "aws_db_instance" "k5s_rds_user" {
  identifier           = "k5s-rds-user"
  allocated_storage    = 10
  max_allocated_storage = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "k5sDBuser"
  username             = "k5s_rds_admin"
  password             = "k5s_rds_passwd"
  db_subnet_group_name = aws_db_subnet_group.k5s_rds_subnet.name
  vpc_security_group_ids = [ 
    aws_security_group.k5s_sg_RDS.id,
    ]
  skip_final_snapshot  = true
}
resource "aws_db_instance" "k5s_rds_movie" {
  identifier           = "k5s-rds-movie"
  allocated_storage    = 10
  max_allocated_storage = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "k5sDBmovie"
  username             = "k5s_rds_admin"
  password             = "k5s_rds_passwd"
  db_subnet_group_name = aws_db_subnet_group.k5s_rds_subnet.name
  vpc_security_group_ids = [ 
    aws_security_group.k5s_sg_RDS.id,
    ]
  skip_final_snapshot  = true
}
resource "aws_db_instance" "k5s_rds_review" {
  identifier           = "k5s-rds-review"
  allocated_storage    = 10
  max_allocated_storage = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "k5sDBreview"
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