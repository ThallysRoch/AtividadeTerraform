terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_key_pair" "ssh" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }

}


resource "aws_instance" "web" {
  provisioner "remote-exec" {

    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo service httpd start"
    ]
  }
  tags = {
    Name = "Atividade-Virtualizacao"
  }
}


terraform {
  backend "s3" {
    bucket     = "tfs-th"
    key        = "terraform.tfstate"
    region     = "us-east-2"
    access_key = ""
    secret_key = ""
  }
}
