provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "creditor-assessment-vpc"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 1
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "creditor-assessment-public-subnet"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_subnet" "private_subnets" {
  count = 2
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "creditor-assessment-private-subnet"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_vpc_endpoint" "ec2_endpoint" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"

  tags = {
    Name = "creditor-assessment-ec2-endpoint"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_vpc_endpoint" "ecr_endpoint" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"

  tags = {
    Name = "creditor-assessment-ecr-api-endpoint"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Interface"

  tags = {
    Name = "creditor-assessment-s3-endpoint"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_vpc_endpoint" "elb_endpoint" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.elasticloadbalancing"
  vpc_endpoint_type = "Interface"

  tags = {
    Name = "creditor-assessment-elb-endpoint"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_vpc_endpoint" "logs_endpoint" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"

  tags = {
    Name = "creditor-assessment-cloudwatch-logs-endpoint"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_vpc_endpoint" "sts_endpoint" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type = "Interface"

  tags = {
    Name = "creditor-assessment-sts-endpoint"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_vpc_endpoint" "endpoints" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  tags = {
    Name = "creditor-assessment-ecr-endpoint"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

#Mostly not required
resource "aws_security_group" "allow_public_to_private" {
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr_blocks[0], var.private_subnet_cidr_blocks[1]]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [element(var.public_subnet_cidr_blocks, 0)]
  }

  tags = {
    Name = "creditor-assessment-sg-endpoint"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "creditor-assessment-private-rt"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
    count          = 1
    subnet_id      = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
}
