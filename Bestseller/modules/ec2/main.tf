#Create 2 instance in 2 diffrent AZ for fault tolerance, high availability, and disaster recovery  
resource "aws_instance" "web" {
  count = var.instance_count
  ami             = var.iam_id
  instance_type   = var.instance_type
  subnet_id       = element(var.subnet_ids, count.index)
  vpc_security_group_ids  = [var.sg_id]
  iam_instance_profile   = var.iam_instance_profile_name
  #key_name               = "test" 
  user_data = file("${path.module}/script.sh")
  
  tags = {
    name = "webserver-${count.index}"
  }

}