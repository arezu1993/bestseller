
resource "aws_instance" "web" {
  count = var.instance_count

  ami             = data.aws_ami.amzlinux2.id
  #ami = "ami-008677ef1baf82eaf"
  
  instance_type   = var.instance_type
  subnet_id       = element(var.subnet_ids, count.index)
  security_groups  = [var.sg_id]
  user_data = file("${path.module}/script.sh")

  associate_public_ip_address = true
  

  tags = {
    name = "webserver-${count.index}"
  }

 
}


                        
