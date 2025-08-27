data "aws_vpc" "default" {
default = true
}

data "aws_subnets" "default" {
    filter {
      name ="vpc-id"
      values = [data.aws_vpc.default.id]
    }
  
}

data "template_file" "file" {
  template = <<-EOF
#!/bin/bash
echo "Hello, World" > index.html
nohup busybox httpd -f -p ${var.server_port} &
EOF
  
}