resource "aws_instance" "test-server" {
  ami = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  key_name = "keymynew"
  vpc_security_group_ids = ["sg-020e594449ba356ee"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./mykeynew.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/bankingproj/terraform-files/ansibleplaybook.yml"
     }
  }
