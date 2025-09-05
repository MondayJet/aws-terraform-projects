variable "instance_type" {
  type = string
  description = "The type of instance to launch."
  default = "t2.micro"
}

variable "server_port" {
  description = "The port whence the instance can be accessed"

  type = number

  default = 22
}
