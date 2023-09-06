resource "aws_instance" "web" {
  ami = "ami-051f7e7f6c2f40dc1"
  instance_type = "t2.micro"
  key_name = "devops"
  security_groups = [ "ssh-access-sg" ]
}

resource "aws_security_group" "ssh-access-sg" {
  name        = "ssh-access-sg"
  description = "Allow SSH inbound traffic"


  ingress {
    description      = "SHH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
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