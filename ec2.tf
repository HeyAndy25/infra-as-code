resource "aws_instance" "website-server" {
  ami                    = "ami-04ea4e8270c27626c" # Amazon Linux 2023 AMI
  instance_type          = "t3.micro"
  key_name               = "sua-chave-ssh"
  vpc_security_group_ids = [aws_security_group.website_sg.id]
  iam_instance_profile   = "EC2-ECR-Role"

  tags = {
    Name        = "website-server"
    Provisioned = "Terraform"
    Environment = "Production"
  }
}

# Security Group
resource "aws_security_group" "website_sg" {
  name        = "website-sg"
  vpc_id      = "vpc-xxxxxxxxx"

  tags = {
    Name        = "website-sg"
    Provisioned = "Terraform"
    Environment = "Production"
  }
}

# Regras de Entrada (Ingress)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4         = "0.0.0.0/0" # Substitua pelo seu IP publico (ex: X.X.X.X/32)
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Regra de Saida (Egress)
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"  
}
