packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "source_ami" {
  type = string
  default = "ami-01e444924a2233b07"
}

source "amazon-ebs" "ubuntu" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  region        = var.region
  source_ami    = var.source_ami
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"
  ami_name      = "wordpress-base-ami-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2 php php-mysql libapache2-mod-php",
      "wget https://wordpress.org/latest.tar.gz",
      "tar -xzf latest.tar.gz",
      "sudo mv wordpress /var/www/html/",
      "sudo chown -R www-data:www-data /var/www/html/wordpress",
      "sudo chmod -R 755 /var/www/html/wordpress"
    ]
  }

   provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y software-properties-common",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get install -y ansible"
    ]
  }

  provisioner "file" {
    content = <<EOF
#!/bin/bash
apt-get update
apt-get install -y git
ansible-pull -U https://github.com/rvelichkov/wordpress-devops-project/ansible/playbook.git
EOF
    destination = "/tmp/ansible-pull.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/ansible-pull.sh /var/lib/cloud/scripts/per-instance/ansible-pull.sh",
      "sudo chmod +x /var/lib/cloud/scripts/per-instance/ansible-pull.sh"
    ]
  }

}
