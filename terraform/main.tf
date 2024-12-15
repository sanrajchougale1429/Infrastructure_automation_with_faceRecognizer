resource "aws_instance" "instance" {
  ami = "ami-02b49a24cfb95941c"
  instance_type = "t2.micro"

  tags = {
    Name = "Face-detect-infra"
  }

}

resource "aws_vpc" "first-asp" {
  cidr_block       = "12.0.0.0/22"
  instance_tenancy = "default"

  tags = {
    Name = "first-asp"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.first-asp.id
  cidr_block = "12.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.first-asp.id
  cidr_block = "12.0.2.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.first-asp.id
  
  tags = {
    Name = "igw"
  }
}
resource "aws_eip" "lb1" {
  instance = aws_instance.instance.id
  domain   = "vpc"
}

# resource "aws_nat_gateway" "nat-gw" {
#   subnet_id     = aws_subnet.private.id
#   allocation_id = aws_eip.lb1.id
#   tags = {
#     Name = "gw-NAT"
#   }
#   depends_on = [aws_internet_gateway.gw]
# }

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.first-asp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "rt-public"
  }
}
resource "aws_route_table_association" "asso-public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt-public.id
}

# resource "aws_route_table" "rt-private" {
#   vpc_id = aws_vpc.first-asp.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat-gw.id
#   }
#   tags = {
#     Name = "rt-private"
#   }
# }
# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.rt-private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat-gw.id
# }
# resource "aws_route_table_association" "asso-private" {
#   subnet_id      = aws_subnet.private.id
#   route_table_id = aws_route_table.rt-private.id
# }


