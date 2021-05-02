resource "aws_vpc" "debug" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "handson"
  }
}

resource "aws_subnet" "debug_public_1a" {
  # 先程作成したVPCを参照し、そのVPC内にSubnetを立てる
  vpc_id = aws_vpc.debug.id

  # Subnetを作成するAZ
  availability_zone = "ap-northeast-1a"

  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "debug-handson-public-1a"
  }
}
resource "aws_subnet" "debug_private_1a" {
  vpc_id = aws_vpc.debug.id

  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.10.0/24"

  tags = {
    Name = "debug_handson-private-1a"
  }
}


resource "aws_internet_gateway" "debug-ec2-main" {
  vpc_id = aws_vpc.debug.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "handson_debug_public_eip" {
  vpc      = true
  instance = aws_instance.handson_public.id
}

resource "aws_eip" "nat_1a" {
  vpc = true

  tags = {
    Name = "handson-natgw-1a"
  }
}

# NAT Gateway
# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
resource "aws_nat_gateway" "nat_1a" {
  subnet_id     = aws_subnet.debug_public_1a.id # NAT Gatewayを配置するSubnetを指定
  allocation_id = aws_eip.nat_1a.id             # 紐付けるElasti IP

  tags = {
    Name = "handson-1a"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.debug.id

  tags = {
    Name = "handson-public"
  }
}

# Route
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.debug-ec2-main.id
}

# Association
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.debug_public_1a.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.debug.id

  tags = {
    Name = "handson-private-1a"
  }
}

# Route (Private)
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "private_1a" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_1a.id
  nat_gateway_id         = aws_nat_gateway.nat_1a.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.debug_private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

## EC2

resource "aws_security_group" "main" {
  name   = "handson_all_ec2_bastian"
  vpc_id = aws_vpc.debug.id

  #   ingress {
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"] # 本当は 0.0.0.0 で設定してみてもいいけど
  #   }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 本当は 0.0.0.0 で設定してみてもいいけど
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # 本当は 0.0.0.0 で設定してみてもいいけど
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # 本当は 0.0.0.0 で設定してみてもいいけど
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_network_interface" "handson_public_interface_debug" {
  subnet_id       = aws_subnet.debug_public_1a.id
  security_groups = [aws_security_group.main.id]
  tags = {
    Name = "handson_public_debug_network_interface"
  }
}
resource "aws_network_interface" "handson_private_interface_debug" {
  subnet_id       = aws_subnet.debug_private_1a.id
  security_groups = [aws_security_group.main.id]

  tags = {
    Name = "handson_private_debug_network_interface"
  }
}

resource "aws_instance" "handson_public" {
  ami           = "ami-0f037327d64de9e49" # Amazon Linux 2 x86-64
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mmm2.key_name

  credit_specification {
    cpu_credits = "unlimited"
  }

  network_interface {
    network_interface_id = aws_network_interface.handson_public_interface_debug.id
    device_index         = 0
  }
  tags = {
    Name = "handson-LINE-public-bastiation-1"
  }
}

resource "aws_instance" "handson_private" {
  ami           = "ami-0f037327d64de9e49" # Amazon Linux 2 x86-64
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mmm2.key_name

  credit_specification {
    cpu_credits = "unlimited"
  }

  network_interface {
    network_interface_id = aws_network_interface.handson_private_interface_debug.id
    device_index         = 0
  }

  tags = {
    Name = "handson-LINE-private-1"
  }
}
