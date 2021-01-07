#grab the most recent RHEL AMI
data "aws_ami" "rhel" {
    most_recent = true

    filter {
        name   = "name"
        values = ["RHEL-8*"]
    }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["309956199498"] # Canonical
}

#Create and bootstrap bastion EC2
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.rhel.id
  instance_type               = var.instance-type
  key_name                    = "terraform"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  subnet_id                   = aws_subnet.pubsub-1.id

  tags = {
    Name = "bastion"
  }

  #The code below is ONLY the provisioner block which needs to be
  #inserted inside the resource block for Jenkins EC2 master Terraform
  #Jenkins Master Provisioner:

  provisioner "local-exec" {
    command = <<EOF
  aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id} \
  && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' --private-key ~/PATHTOPROVATEKEY bastion.yml
  EOF
  }

}