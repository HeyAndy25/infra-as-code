resource "aws_instance" "website-server" {
  ami           = "ami-04ea4e8270c27626c" #Amazon Linux 2023 AMI 2023.12.20260710.0 x86_64 HVM kernel-6.18
  instance_type = "t3.micro"
  key_name = "chave-site-prod"
  vpc_security_group_ids = [aws_security_group.website_sg.id]
  iam_instance_profile = "ECR-EC2-Role"



  tags = {
    Name = "website-server"
    Provisioned = "Terraform"
    Cliente = "Anderson"
  }
}

# Security Group
resource "aws_security_group" "website_sg" {
  name        = "website-sg"
  vpc_id      = "vpc-0be72824e98acde3b"

  tags = {
    Name = "website-sg"
    Provisioned = "Terraform"
    Cliente = "Anderson"
  }
}

#Aqui vamos adicionar as regras de entrada, habilitando para http,https, e IP privado
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4   = "45.189.49.41/32" #seu ip aqui
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

#Regras de saída, definir que a instancia possa acessar qualquer IP

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.website_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"  
}