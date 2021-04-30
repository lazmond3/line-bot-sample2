variable "app-name" {} # line-bot-sample

variable "azs" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

# VPC
# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.app-name
  }
}


resource "aws_subnet" "publics" {
  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  availability_zone = var.azs[count.index]
  cidr_block        = var.public_subnet_cidrs[count.index]

  tags = {
    Name = "${var.app-name}-public-${count.index}"
  }
}


# インターネット ゲートウェイ
# Internet Gateway
# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.app-name
  }
}

# NAT ゲートウェイ 用 Elastic IP付与 (public に NAT ゲートウェイを接続)
# resource "aws_eip" "nat" {
#   count = length(var.public_subnet_cidrs)

#   vpc = true

#   tags = {
#     Name = "${var.app-name}-natgw-${count.index}"
#   }
# }

# # NAT ゲートウェイ
# resource "aws_nat_gateway" "this" {
#   count = length(var.public_subnet_cidrs)

#   subnet_id     = element(aws_subnet.publics.*.id, count.index)
#   allocation_id = element(aws_eip.nat.*.id, count.index) # ここで eip をつないでいる

#   tags = {
#     Name = "${var.app-name}-${count.index}"
#   }
# }

# ルートテーブル
# Route Table
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app-name}-public"
  }
}

# Route
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}

# Association
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = element(aws_subnet.publics.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# output
output "public_subnet_ids" {
  value = ["${aws_subnet.publics.*.id}"]
}


# プライベートサブネットの登録を忘れていた
# Private Subnet
resource "aws_subnet" "privates" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "${var.app-name}-private-${count.index}"
  }
}

resource "aws_route_table" "privates" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app-name}-private-${count.index}"
  }
}

# NATをオフにする
# resource "aws_route" "privates" {
#   count = length(var.private_subnet_cidrs)

#   destination_cidr_block = "0.0.0.0/0"

#   route_table_id = element(aws_route_table.privates.*.id, count.index)
#   nat_gateway_id = element(aws_nat_gateway.this.*.id, count.index)
# }

resource "aws_route_table_association" "privates" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = element(aws_subnet.privates.*.id, count.index)
  route_table_id = element(aws_route_table.privates.*.id, count.index)
}
