provider "aws"{
  region = var.aws_region
} 

resource "aws_vpc" "myapp-vpc"{
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name: "${var.env_prefix}-vpc"
    Environment = "${var.env_prefix}"
  }
}

resource "aws_subnet" "myapp-subnet-1"{
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  map_public_ip_on_launch = true
  tags = {
    Name: "${var.env_prefix}-subnet-1"
    Environment = "${var.env_prefix}"
  }
}

resource "aws_internet_gateway" "myapp-IGW"{
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name: "${var.env_prefix}-IGW"
    Environment = "${var.env_prefix}"
  }
}


data "aws_ami" "latest-amazon-image"{
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh-key"{
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-instance"{
  ami = data.aws_ami.latest-amazon-image.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-SG.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  tags = {
    Name: "${var.env_prefix}-server"
    Environment = "${var.env_prefix}"
  }

}

resource "aws_security_group" "myapp-SG"{
  name = "myapp-SG"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress{
    description = "SSH to Instance"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [var.my_public_ip] 
  }
  ingress{
    description = "SSH to Instance"
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress{
    description = "Outbound request allowed to all ports and destination on any protocol"
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]   
    prefix_list_ids = [] 
  }
  tags = {
    Name: "${var.env_prefix}-SG"
    Environment = "${var.env_prefix}"
  }
}

resource "aws_route_table" "myapp-public-rt"{
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-IGW.id
  }
  tags = {
    Name: "${var.env_prefix}-rt"
    Environment = "${var.env_prefix}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-public-rt.id
}