resource "aws_eip" "nat_eip" {
  # Không cần chỉ định vpc = true nữa
  depends_on = [var.internet_gateway]  # Đảm bảo rằng Internet Gateway được tạo trước
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_az1_id
  tags = {
    Name = "vpc-nat-gateway"
  }

  depends_on = [var.internet_gateway]  # Đảm bảo Internet Gateway được tạo trước
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "-private-route-table"
  }
}
# Gán Route Table Private với Private Subnet
resource "aws_route_table_association" "private_association" {
  subnet_id      = var.private_subnet_az1_id
  route_table_id = aws_route_table.private.id
}