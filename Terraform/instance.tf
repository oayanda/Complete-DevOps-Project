resource "aws_instance" "web" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "devops"
  //security_groups = ["ssh-access-sg"]
  vpc_security_group_ids = [aws_security_group.ssh-access-sg.id]
  subnet_id              = aws_subnet.main-public-subnet-1.id
  for_each               = toset(["Jenkins-master", "Build-slave", "Ansible"])
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_security_group" "ssh-access-sg" {
  name        = "ssh-access-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id


  ingress {
    description = "SHH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

# Inbound rule for Jenkins Server
   ingress {
    description = "Jenkins HTTP accesss"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_access"
  }
}