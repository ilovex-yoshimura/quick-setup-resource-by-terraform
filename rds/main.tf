# subnet group
resource "aws_db_subnet_group" "default" {
  name = "${var.prefix}-db-subnet"

  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]
}

# parameter group
resource "aws_db_parameter_group" "default" {
  name   = "${var.prefix}-db-parameter-group"
  family = "aurora-postgresql10"
}

# option group
resource "aws_db_option_group" "default" {
  name                 = "${var.prefix}-db-option-group"
  engine_name          = "aurora-postgresql"
  major_engine_version = "10"
}

resource "aws_rds_cluster_parameter_group" "default" {
  name   = "${var.prefix}-rds-cluster-parameter-group"
  family = "aurora-postgresql10"
}

resource "aws_rds_cluster" "default" {
  engine                          = "aurora-postgresql"
  engine_version                  = "10.12"
  availability_zones              = ["ap-northeast-1a", "ap-northeast-1c"]
  database_name                   = "test"
  master_username                 = "yoshimura"
  master_password                 = "password"
  skip_final_snapshot             = true
  db_subnet_group_name            = aws_db_subnet_group.default.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.default.id
  vpc_security_group_ids          = [aws_security_group.rds_sg.id]
  tags = {
    Name = "${var.prefix}-rds-cluster"
  }
}

resource "aws_rds_cluster_instance" "default" {
  count                        = 2
  cluster_identifier           = aws_rds_cluster.default.id
  engine                       = "aurora-postgresql"
  instance_class               = "db.t2.micro"
  publicly_accessible          = false
  db_parameter_group_name      = aws_db_parameter_group.default.id
  auto_minor_version_upgrade   = false                                             # マイナーバージョンの自動アップグレードを無効化
  tags = {
    Name = "${var.prefix}-rds-cluster-instance"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.prefix}-rds-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-rds-sg"
  }
}

resource "aws_security_group_rule" "default" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
}