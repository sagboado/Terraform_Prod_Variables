#  Configure VPC
resource "aws_vpc" "TERRAFORM_PROJ" {
  cidr_block       = var.cidr_for_vpc
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "TERRAFORM_PROJ"
  }
}

#  Configure Public Subnet
resource "aws_subnet" "prod_pub_sub_1" {
  vpc_id     = aws_vpc.TERRAFORM_PROJ.id
  cidr_block = var.cidr_for_prod_pub_sub_1

  tags = {
    Name = "prod_pub_sub_1"
  }
}

resource "aws_subnet" "prod_pub_sub_2" {
  vpc_id     = aws_vpc.TERRAFORM_PROJ.id
  cidr_block = var.cidr_for_prod_pub_sub_2

  tags = {
    Name = "prod_pub_sub_2"
  }
}

#  Configure Private Subnet
resource "aws_subnet" "prod_priv_sub_1" {
  vpc_id     = aws_vpc.TERRAFORM_PROJ.id
  cidr_block = var.cidr_for_prod_priv_sub_1

  tags = {
    Name = "prod_priv_sub_1"
  }
}

resource "aws_subnet" "prod_priv_sub_2" {
  vpc_id     = aws_vpc.TERRAFORM_PROJ.id
  cidr_block = var.cidr_for_prod_priv_sub_2

  tags = {
    Name = "prod_priv_sub_2"
  }
}

# Configure Public Route Table
resource "aws_route_table" "prod_pub_route_table" {
  vpc_id = aws_vpc.TERRAFORM_PROJ.id

  tags = {
    Name = "prod_pub_route_table"
  }
}

# Configure Private Route Table
resource "aws_route_table" "prod_priv_route_table" {
  vpc_id = aws_vpc.TERRAFORM_PROJ.id

  tags = {
    Name = "prod_priv_route_table"
  }
}

# Configure Public Route Table Association
resource "aws_route_table_association" "prod_pub_route_table_association_1" {
  subnet_id      = aws_subnet.prod_pub_sub_1.id
  route_table_id = aws_route_table.prod_pub_route_table.id
}

resource "aws_route_table_association" "prod_pub_route_table_association_2" {
  subnet_id      = aws_subnet.prod_pub_sub_2.id
  route_table_id = aws_route_table.prod_pub_route_table.id
}

# Configure Private Route Table Association
resource "aws_route_table_association" "prod_priv_route_table_association_1" {
  subnet_id      = aws_subnet.prod_priv_sub_1.id
  route_table_id = aws_route_table.prod_priv_route_table.id
}

resource "aws_route_table_association" "prod_priv_route_table_association_2" {
  subnet_id      = aws_subnet.prod_priv_sub_2.id
  route_table_id = aws_route_table.prod_priv_route_table.id
}

# Configure Internet Gateway
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.TERRAFORM_PROJ.id

  tags = {
    Name = "prod_igw"
  }
}

# Configure AWS Route
resource "aws_route" "public_internet_gateway_route" {
  route_table_id = aws_route_table.prod_pub_route_table.id
  gateway_id                = aws_internet_gateway.prod_igw.id
  destination_cidr_block    = "0.0.0.0/0"
}

# Configure Elastic IP Address
resource "aws_eip" "Prod_Elastic_IP" {
  tags = {
    Name = "Prod_Elastic_IP"
  }
}

# Configure NAT Gateway
resource "aws_nat_gateway" "Prod_Nat_gateway" {
  allocation_id = aws_eip.Prod_Elastic_IP.id
  subnet_id     = aws_subnet.prod_pub_sub_1.id

  tags = {
    Name = "Prod_Nat_gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.prod_igw]
}


# NAT Associate with Priv route
resource "aws_route" "NAT_gateway_route" {
  route_table_id = aws_route_table.prod_priv_route_table.id
  gateway_id = aws_nat_gateway.Prod_Nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}
