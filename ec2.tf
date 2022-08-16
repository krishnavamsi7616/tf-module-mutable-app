#resource "aws_spot_instance_request" "instance" {
#  count                  = var.INSTANCE_COUNT
#  ami                    = data.aws_ami.ami.image_id
#  spot_price             = data.aws_ec2_spot_price.spot_price.spot_price
#  instance_type          = var.INSTANCE_TYPE
#  wait_for_fulfillment   = true
#  subnet_id              = var.PRIVATE_SUBNET_IDS[0]
#  vpc_security_group_ids = [aws_security_group.main.id]
#  iam_instance_profile   = aws_iam_instance_profile.allow-secret-manager-read-access.name
#
#  tags = {
#    Name = local.TAG_PREFIX
#  }
#}

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


resource "null_resource" "ansible" {
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