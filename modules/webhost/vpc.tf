# define base VPC related resources for the project

# VPC itself
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(
    local.global_tags,
    { Name = "primary-vpc-${var.environment}" }
  )
}

# first public subnet
resource "aws_subnet" "public_1_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.sub1_cidr
  availability_zone = var.sub1_az

  tags = merge(
    local.global_tags,
    { Name = "public-subnet-1a" }
  )
}

# second public subnet
resource "aws_subnet" "public_2_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.sub2_cidr
  availability_zone = var.sub2_az

  tags = merge(
    local.global_tags,
    { Name = "public-subnet-2b" }
  )
}

# IGW for VPC communications
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.global_tags,
    { Name = "primary-igw-${var.environment}" }
  )
}

# Route traffic to the internet via IGW
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.global_tags,
    { Name = "${var.namespace}-${var.environment}-rt-main" }
  )
}

# Associate the RT with the subnets
resource "aws_route_table_association" "subnet_1a" {
  subnet_id      = aws_subnet.public_1_a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_2b" {
  subnet_id      = aws_subnet.public_2_b.id
  route_table_id = aws_route_table.main.id
}

## SECURITY

# VPC flow log to keep track of all traffic flows (good to have this in production)
# !! not added for this project due to time constraints !!

#resource "aws_flow_log" "primary" {
#  count                = var.environment == "prod" ? 1 : 0
#  log_destination      = aws_s3_bucket.vpc_flow_logs[0].arn
#  log_destination_type = "s3"
#  traffic_type         = "ALL"
#  vpc_id               = aws_vpc.main.id
#}
