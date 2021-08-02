resource "aws_vpc" "serendipity_exercise_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.tags, { "Name" : "${terraform.workspace}-exercise-vpc" })
}

resource "aws_subnet" "serendipity_exercise_vpc" {
  vpc_id                  = aws_vpc.serendipity_exercise_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags                    = merge(local.tags, { "Name" : "${terraform.workspace}-exercise-subnet" })
}

resource "aws_internet_gateway" "serendipity_exercise_igw" {
  vpc_id = aws_vpc.serendipity_exercise_vpc.id

}

resource "aws_security_group" "serendipity_exercise_sg" {
  name        = "${terraform.workspace}-exercise-sg"
  description = "SSH from the internet, HTTPS inbound, all outbound"
  vpc_id      = aws_vpc.serendipity_exercise_vpc.id

  dynamic ingress {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { "Name" : "${terraform.workspace}-exercise-security-group" })
}

resource "aws_route_table" "serendipity_exercise_route_table" {
  vpc_id = aws_vpc.serendipity_exercise_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.serendipity_exercise_igw.id
  }

  tags = merge(local.tags, { "Name" : "${terraform.workspace}-exercise-security-route-table" })
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.serendipity_exercise_vpc.id
  route_table_id = aws_route_table.serendipity_exercise_route_table.id
}
