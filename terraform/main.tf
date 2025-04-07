terraform{
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
    backend "s3" {
    bucket         = "aws-t-test"               
    key            = "terraform/state.tfstate"  
    
    region         = "ap-northeast-1"           
    encrypt        = true    
    dynamodb_table = "terraform-locks"  # Critical for locking            
  }
}

provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_instance" "server"{
    ami = "ami-0dc842020ce781bc9" #ami-077e6af23daa7a15a,0dc842020ce781bc9
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.maingroup.id]
    iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = var.private_key
        timeout = "4m"
    }
    tags = {
        "name" = "DeployVM"
    }
}
resource "aws_iam_instance_profile" "ec2-profile"{
    name = "ec2-profile"
    role = "EC2-ECR-AUTH"
}
resource "aws_security_group" "maingroup" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "SSH access"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "HTTP access"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
}

resource "aws_key_pair" "deployer" {
    key_name = var.key_name
    public_key = var.public_key
}

output "instance_public_ip" {
  value = aws_instance.server.public_ip
  sensitive = true
}