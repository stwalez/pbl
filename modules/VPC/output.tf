output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet" {
  value = aws_subnet.private
}

output "public_subnet" {
  value = aws_subnet.public
}

output "available_azs" {
  value = data.aws_availability_zones.available
}

