packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# ebs backed paccker image
source "amazon-ebs" "ubuntu"{
  ami_name = "my-first-ubuntu-packer-iamge"
  instance_type = t2.micro
  ami_id = 
}
