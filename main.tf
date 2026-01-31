terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

############################
# EC2 VIRTUAL MACHINE
############################
resource "aws_instance" "demo_vm" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"

  tags = {
    Name = "mlops-demo-vm"
  }
}

############################
# SIMPLE CONTAINER (ECS TASK)
############################
resource "aws_ecs_cluster" "demo_cluster" {
  name = "mlops-demo-cluster"
}

resource "aws_ecs_task_definition" "demo_task" {
  family                   = "mlops-demo-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  container_definitions = jsonencode([
    {
      name      = "hello-container"
      image     = "nginx"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
