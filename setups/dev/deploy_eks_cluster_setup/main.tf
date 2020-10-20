data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
provider kubernetes {
     host                   = data.aws_eks_cluster.cluster.endpoint
     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
     token                  = data.aws_eks_cluster_auth.cluster.token
     load_config_file       = false
     version                = "1.11.1" 
}

provider helm {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}

locals {
  cluster_name = "${local.env}-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "2.47.0"
  azs                  = data.aws_availability_zones.available.names
  name                 = "${local.env}-vpc"
  cidr                 = "10.0.0.0/16"
  public_subnets       = ["10.0.1.0/24","10.0.2.0/24"]
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "13.0.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.public_subnets
  enable_irsa     = true

  tags = {
    Environment = "${local.env}"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-linux"
      instance_type                 = var.lnx_instance_type
      asg_desired_capacity          = var.lnx_asg_desired_capacity
      asg_min_size                  = var.lnx_asg_min_size
      asg_max_size                  = var.lnx_asg_max_size
      platform                      = "linux"
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"  
          "propagate_at_launch" = "false"
          "value"               = "true"     
        } 
      ]
    },
   {
      name                          = "worker-group-windows"
      instance_type                 = var.win_instance_type
      asg_desired_capacity          = var.win_asg_desired_capacity
      asg_min_size                  = var.win_asg_min_size
      asg_max_size                  = var.win_asg_max_size
      platform                      = "windows"
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        }
      ]
    }

  ]

  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts
}
