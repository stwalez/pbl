
locals {
  ami = lookup(var.images, var.region, "ami-0b0af3577fe5e3532")
}
