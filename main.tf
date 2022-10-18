
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


# step 1
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.tags
  }
}
# step 2

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.tags
  }
}

#Step 3

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.tags
  }
}

#Step 4 
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = var.tags
  }
}


#step 5: associate route table with subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}

#step 6: create security group to allow 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]

  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
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
    Name = var.tags
  }
}
#step 7: create network interface with an ip that was created in step 4
resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.public.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

  # attachment {
  #   instance     = aws_instance.test.id
  #   device_index = 1
  # }
  tags = {
    Name = var.tags
  }
}

#step 8: Assign an elastic IP
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.test.id
  associate_with_private_ip = "10.0.1.50"
  #depends_on                = [aws_internet_gateway.gw]

  tags = {
    Name = var.tags
  }
}

resource "time_sleep" "wait_20_seconds" {
  depends_on      = [aws_eip.one]
  create_duration = "20s"
}

output "Elastic_ip" {
  value = aws_eip.one.public_ip
}

#step 9: create ubuntu server and install /enable nginx

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }

  # root disk
  root_block_device {
    volume_size           = "16"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = var.tags
    }
  }

  tags = {
    Name = var.tags
  }
}

#step 1: Create VPC
#step 2: Create internet gateway
#step 3: Create route table
#step 4:  Create subnet
#step 5: associate route table with subnet
#step 6: create security group to allow 22,80,443
#step 7: create network interface with an ip that was created in step 4
#step 8: Assign an elastic IP
#step 9: create ubuntu server and install /enable nginx
## Step 8 may show error- just rerun the program
#/home/username/.aws/credentials


