resource "aws_instance" "instance" {
  count                  = var.INSTANCE_COUNT
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.INSTANCE_TYPE
  subnet_id              = var.PRIVATE_SUBNET_IDS[0]
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile   = aws_iam_instance_profile.allow-secret-manager-read-access.name

  tags = {
    Name = local.TAG_PREFIX
  }
}

resource "aws_ec2_tag" "name-tag" {
  count       = var.INSTANCE_COUNT
  resource_id = aws_instance.instance.*.id[count.index]
  key         = "Name"
  value       = local.TAG_PREFIX
}

resource "aws_ec2_tag" "monitor-tag" {
  count       = var.INSTANCE_COUNT
  resource_id = aws_instance.instance.*.id[count.index]
  key         = "Monitor"
  value       = "yes"
}

resource "null_resource" "ansible" {
#  triggers = {
#    abc = timestamp()
#  }
  count        = var.INSTANCE_COUNT
  provisioner "remote-exec" {
    connection {
      user     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_PASS"]
      host     = aws_instance.instance.*.private_ip[count.index]
    }
    inline = [
      "ansible-pull -U https://github.com/krishnavamsi7616/roboshop-ansible.git roboshop.yml -e HOST=localhost -e ROLE=${var.COMPONENT} -e ENV=${var.ENV} -e DOCDB_ENDPOINT=${var.DOCDB_ENDPOINT} -e REDIS_ENDPOINT=${var.REDIS_ENDPOINT} -e MYSQL_ENDPOINT=${var.MYSQL_ENDPOINT}",
    ]
  }
}