
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_network_interface" "public_interface_debug" {
  count     = length(var.aws_lb_public_ids)
  subnet_id = var.aws_lb_public_ids[count.index]

  tags = {
    Name = "public_debug_network_interface"
  }
}
resource "aws_network_interface" "private_interface_debug" {
  count     = length(var.aws_lb_private_ids)
  subnet_id = var.aws_lb_private_ids[count.index]

  tags = {
    Name = "private_debug_network_interface"
  }
}


# EC2の設定は下をコメントアウトすると削除できる
resource "aws_eip" "public_eip" {
  count    = length(aws_instance.public)
  vpc      = true
  instance = aws_instance.public[count.index].id
}

resource "aws_instance" "public" {
  ami = "ami-0f037327d64de9e49" # Amazon Linux 2 x86-64
  # ami           = data.aws_ami.ubuntu.id
  count         = length(var.aws_lb_public_ids)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mmm2.key_name

  credit_specification {
    cpu_credits = "unlimited"
  }

  network_interface {
    network_interface_id = aws_network_interface.public_interface_debug[count.index].id
    device_index         = 0
  }
  tags = {
    Name = "LINE-public-bastiation-${count.index}"
  }
}

resource "aws_instance" "private" {
  ami = "ami-0f037327d64de9e49" # Amazon Linux 2 x86-64
  # ami           = data.aws_ami.ubuntu.id
  count         = length(var.aws_lb_private_ids)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mmm2.key_name

  credit_specification {
    cpu_credits = "unlimited"
  }

  network_interface {
    network_interface_id = aws_network_interface.private_interface_debug[count.index].id
    device_index         = 0
  }

  tags = {
    Name = "LINE-private-${count.index}"
  }
}

output "public_ips" {
  value = [aws_eip.public_eip.*.public_ip]
}
