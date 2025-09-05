resource "aws_instance" "hello_world" {
    ami = data.aws_ami.ubuntu.id
    subnet_id = data.aws_subnets.default.ids[0]
    instance_type = var.instance_type


    vpc_security_group_ids = [aws_security_group.instance.id]

    tags = {
      Name = "jenkins"
    }


}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"


  ingress{
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

}



