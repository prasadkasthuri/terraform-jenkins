terraform {
  backend "s3" {
    bucket = "terraform-s3-bucket-prasad"
    key = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}

resource "aws_vpc" "DevVPC" {
  
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = false
  tags = {
    Name = var.vpc_name
  }


}

resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.DevVPC.id
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  cidr_block = "172.17.1.0/24"
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.DevVPC.id
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  cidr_block = "172.17.2.0/24"
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "public-subnet-3" {
  vpc_id = aws_vpc.DevVPC.id
  map_public_ip_on_launch = true
  availability_zone = "us-east-1c"
  cidr_block = "172.17.3.0/24"
  tags = {
    Name = "public-subnet-3"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.DevVPC.id
  availability_zone = "us-east-1a"
  cidr_block = "172.17.4.0/24"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id = aws_vpc.DevVPC.id
  availability_zone = "us-east-1b"
  cidr_block = "172.17.5.0/24"
  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-3" {
  vpc_id = aws_vpc.DevVPC.id
  availability_zone = "us-east-1c"
  cidr_block = "172.17.6.0/24"
  tags = {
    Name = "private-subnet-3"
  }
}

resource "aws_route_table" "public-rtbl" {
  vpc_id = aws_vpc.DevVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.DevVPC-IGW.id
  }
  tags = {
    Name = "public-rtbl"
  }
}

resource "aws_route_table" "private-rtbl" {
  vpc_id = aws_vpc.DevVPC.id
  tags = {
    Name = "private-rtbl"
  }
}

resource "aws_internet_gateway" "DevVPC-IGW" {
  vpc_id = aws_vpc.DevVPC.id
  tags = {
    Name = "DevVPC-IGW"
  }
}

resource aws_route_table_association "public-subnet-1-association"{
    subnet_id = aws_subnet.public-subnet-1.id
    route_table_id = aws_route_table.public-rtbl.id
}

resource aws_route_table_association "public-subnet-2-association"{
    subnet_id = aws_subnet.public-subnet-2.id
    route_table_id = aws_route_table.public-rtbl.id
}
resource aws_route_table_association "public-subnet-3-association"{
    subnet_id = aws_subnet.public-subnet-3.id
    route_table_id = aws_route_table.public-rtbl.id
}

resource aws_route_table_association "private-subnet-1-association"{
    subnet_id = aws_subnet.private-subnet-1.id
    route_table_id = aws_route_table.private-rtbl.id
}

resource aws_route_table_association "private-subnet-2-association"{
    subnet_id = aws_subnet.private-subnet-2.id
    route_table_id = aws_route_table.private-rtbl.id
}
resource aws_route_table_association "private-subnet-3-association"{
    subnet_id = aws_subnet.private-subnet-3.id
    route_table_id = aws_route_table.private-rtbl.id
}

resource "aws_security_group" "Allow_all_SG" {
  name = "Allow_all_SG"
  description = "Allow all inbound traffic"
  vpc_id = aws_vpc.DevVPC.id
  tags = {
    Name = "Allow_all_SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "name" {
  security_group_id = aws_security_group.Allow_all_SG.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
  description = "Allowing the internet traffic"
}

resource "aws_vpc_security_group_egress_rule" "name" {
    security_group_id = aws_security_group.Allow_all_SG.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
    description = "Allowing all outbound traffic"
}

resource "aws_key_pair" "Laptop-KeyPair" {
  key_name = "Laptop-KeyPair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDP7Ef+cc8kvg3xMN/OB1O+oCSWYAGkttreKYBQbPZrQ/F+3DM/wAjKGuxgarW3oTi3memBetoRTuAfshQxNjhsnSf0XB46gKTyh+fv0Pv7NfEiNKLR/d0fk3F9BaUqnYBwxuvVef7tGIuhZLNN1V6H5/cFrIekJGHg8FJKOaNzUeuC0g6Hnja4QOZRbbLdIrjB4Q43KJfWgH2eOYuLUW1WqQUcYzWhgk38+m0mUWI9yBlCiTQFe5mCy9hoYhNLaaD3XMZDP3j06FFKE+7j77vfACDHO8Nv9WqV359stsDwxsRR6XQZuc1H259HktomNg3NkufU83kchH6N/GTXg4K47sOebeY66lTmynit4SaNigK8xQm7qDUVS2OapOfgQL/0baWrE1zggueRV7YzBUkCe3rs9LL4HKi+AIDGfQuxLc5esIMMXA89ZiNWVoZsCKWX9dhe4pzyMECHxfI9vWD7vCFw+GA0+s0GwEhCPWFREJgGC8wzfY9+81lpYXNAHXc= prasadkasthuri@PRASADs-MacBook-Pro.local"
}

resource "aws_instance" "server-1" {
ami= "ami-0ecb62995f68bb549"
instance_type = "t3.micro"
key_name = aws_key_pair.Laptop-KeyPair.key_name
subnet_id = aws_subnet.public-subnet-1.id
vpc_security_group_ids = [aws_security_group.Allow_all_SG.id]
user_data = file("user_data.sh")
  tags = {
    Name = "server-1"
  }
}