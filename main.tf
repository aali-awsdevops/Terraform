module "vpc" {
  source	 = "../..//modules/networking/vpc-app"
  infra_env	 = var.infra_env
  project	 = var.project
  vpc_cidr	 = var.vpc_cidr
  private_subnet_numbers = var.private_subnet_numbers
  public_subnet_numbers =  var.public_subnet_numbers
}


# iamroles are specific to the infra_env: BASTIONS/DEV/UAT/PRD
# though they have similar policy rules, they are dependent on the env to make them unique.

 module "iamroles" {
  source 	= "../../modules/authentication/iamroles/ssm-access"
  infra_env 	= var.infra_env

 }

##########################################################################################
# RDS and Prime
##########################################################################################


 module "app_servers_sg" {
  source        = "../../modules/security/app-servers-sg"
  infra_env     = var.infra_env
  vpc_id        = module.vpc.vpc_id
  vpc_cidr      = module.vpc.vpc_cidr
  private_cidrs = var.allowed_cidr_ranges_private_sg
 }


# Postgres module

 module "rds-postgres" {
   source    = "../../modules/servers/rds-postgres"
   infra_env = var.infra_env
   # As we know where this linux box must be placed, give the CIDR to get the IDs of the private subnets
   # note: though we need to specify the subnets the rds instance will be created in us-east-1b based on rds_availability_zone setting
   rds_private_subnet_ids = [module.vpc.vpc_private_subnets_id["10.112.24.0/24"],module.vpc.vpc_private_subnets_id["10.112.25.0/24"],module.vpc.vpc_private_subnets_id["10.112.26.0/24"]]
   rds_snapshot_identifier = var.rds_snapshot_identifier
   rds_instance_type       = var.rds_instance_type
   #  rds_db_allocated_storage = var.rds_db_allocated_storage
   rds_availability_zone = var.rds_availability_zone
   #  rds_db_name = var.rds_db_name
   #  rds_username = var.rds_username
   #  rds_password = var.rds_password
   rds_security_group_ids = [module.app_servers_sg.private_sg]
 }


 module "prime" {
   source = "../../modules/servers/prime"
   infra_env = var.infra_env
   # As we know where this box must be placed, give the CIDR to get the ID of the subnet
   subnet_id = module.vpc.vpc_private_subnets_id["10.112.24.0/24"]
   prime_ami = var.prime_ami
   keypair = var.keypair
   prime_private_ips = var.prime_private_ips
   private_sg = [module.app_servers_sg.private_sg]
   prime_instance_type = var.prime_instance_type
   instance_profile = module.iamroles.ssmaccess_linux_ec2_profile.name

 }


# ##################################################################
# # EKS cluster
# ##################################################################

#  module "eks" {
#    source             = "../../modules/eks"
#    infra_env          = var.infra_env
#    subnet_ids         = [module.vpc.vpc_private_subnets_id["10.112.24.0/24"],module.vpc.vpc_private_subnets_id["10.112.25.0/24"],module.vpc.vpc_private_subnets_id["10.112.26.0/24"]]
#    node_instance_type = var.eks_node_instance_type
#    keypair            = var.keypair
#    cluster_version    = var.kubernetes_cluster_version
#    desired_size       = var.desired_size
#    max_size           = var.max_size
#    min_size           = var.min_size
#    endpoint_public_access = var.endpoint_public_access
#    endpoint_private_access = var.endpoint_private_access
#     cluster_addons = {
#       coredns = {
#         preserve = true
#         most_recent = true

#         timeouts = {
#           create = "25m"
#           delete = "10m"
#         }
#       }
#       kube-proxy = {
#         most_recent = true
#       }
#       vpc-cni = {
#         most_recent = true
#       }
#     }
# }

#############################################################################################################################################################
########################################################## Using official EKS module ###################################################################################
#############################################################################################################################################################


locals {
  node_groups = {
    DEV-OPS360-NODEGROUP-BDMS-SCRIPT = {
      instance_types = ["m5a.xlarge"]
      disk_size      = 80
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      labels = {
        Apps           = "ops360"
        ops360-group-1 = "bdms-script"
        Terraform = "true"
      }
    }
    DEV-OPS360-NODEGROUP-ISSUE-PUBLISHER = {
      instance_types = ["m5a.xlarge"]
      disk_size      = 80
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      labels = {
        Apps           = "ops360"
        ops360-group-2 = "issue-ingestion-publisher"
        Terraform = "true"
      }
    }
    DEV-OPS360-NODEGROUP-ISSUE-PROCESS = {
      instance_types = ["m5a.xlarge"]
      disk_size      = 80
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      labels = {
        Apps           = "ops360"
        ops360-group-3 = "issue-service-process-tracking"
        Terraform = "true"
      }
    }
    DEV-ALPHA-NODEGROUP-ACXREST-METADATA = {
      instance_types = ["m5a.xlarge"]
      disk_size      = 80
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      labels = {
        Apps        = "Alpha"
        acx-group-1 = "acx-fast-rest-metadata"
        Terraform = "true"
      }
    }
    DEV-ALPHA-NODEGROUP-ACXINDEXUPDATER = {
      instance_types = ["m5a.xlarge"]
      disk_size      = 80
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      labels = {
        Apps        = "Alpha"
        acx-group-2 = "acx-index-updater"
        Terraform = "true"
      }
    }
    DEV-ALPHA-NODEGROUP-ACXRETRY-TXN = {
      instance_types = ["m5a.xlarge"]
      disk_size      = 80
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      labels = {
        Apps        = "Alpha"
        acx-group-3 = "acx-retry-txn"
        Terraform = "true"
      }
    }
  }
}

module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.37.1" # Check for the latest version
  cluster_name    = var.infra_env
  cluster_version = var.kubernetes_cluster_version
  iam_role_arn    = var.cluster_iam_role_arn
  create_iam_role = false
  vpc_id          = module.vpc.vpc_id
  cluster_endpoint_public_access = var.endpoint_public_access
  cluster_endpoint_private_access = var.endpoint_private_access
  subnet_ids      = [module.vpc.vpc_private_subnets_id["10.112.24.0/24"],module.vpc.vpc_private_subnets_id["10.112.25.0/24"],module.vpc.vpc_private_subnets_id["10.112.26.0/24"]]
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    for name, config in local.node_groups : name => {
      name = name
      iam_role_arn = var.iam_role_arn
      create_iam_role = false
      desired_size = config.desired_size
      max_size     = config.max_size
      min_size     = config.min_size
      instance_types = config.instance_types
      subnet_ids        = var.subnet_ids
      vpc_security_group_ids = [var.cluster_security_group_id]
      cluster_primary_security_group_id = var.cluster_primary_security_group_id
      use_custom_launch_template = false
      disk_size = config.disk_size
      remote_access = {
        ec2_ssh_key               = var.eks_ssh_key
        source_security_group_ids = [aws_security_group.remote_access.id]
      }
      labels = config.labels
      tags = {
        Name = name
      }
    }
  }
}


#############################################################################################################################################################
########################################################## New Nodegroups ###################################################################################
#############################################################################################################################################################

resource "aws_security_group" "remote_access" {
  name_prefix = "${local.name}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = var.vpc_id
 
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16", "10.11.0.0/16", "172.24.0.0/16"]
  }
 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  tags = merge(local.tags, { Name = "${local.name}-remote" })
}



locals {
  name = "DEV-Nodegroup"
  tags = {
    Environment = "DEV"
    Terraform   = "true"
  }
}


#NODEGROUP-OPS360

# module "ops360_node_group_v31" {
#   source = "../../modules/eks-managed-node-group/"

#   name            = "DEV-OPS360-NODEGROUP-V31"
#   cluster_name    = "DEV"
#   cluster_version = var.kubernetes_cluster_version
#   iam_role_arn    = var.iam_role_arn
#   create_iam_role = false
#   subnet_ids = var.subnet_ids

#   // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
#   // Without it, the security groups of the nodes are empty and thus won't join the cluster.
#   vpc_security_group_ids = [
#     var.cluster_security_group_id
#   ]
#   cluster_primary_security_group_id = var.cluster_primary_security_group_id

#   // Note: `disk_size`, and `remote_access` can only be set when using the EKS managed node group default launch template
#   // This module defaults to providing a custom launch template to allow for custom security groups, tag propagation, etc.
#    use_custom_launch_template = false
#    disk_size = 80
#   //
#   //  # Remote access cannot be specified with a launch template

#     remote_access = {
#       ec2_ssh_key               = "exp-keypair"
#       #ec2_ssh_key               = data.aws_key_pair.exp_keypair.id
#       source_security_group_ids = [aws_security_group.remote_access.id]
#     }



#   min_size     = 3
#   max_size     = 3
#   desired_size = 3

#   instance_types = ["m5a.xlarge"]

#   labels = {
#     Environment = "DEV"
#     Apps       = "ops360"

#   }

#   tags = {
#     Name = "DEV-OPS360-NODEGROUP-V31"
#     Environment = "DEV"
#     Terraform   = "true"
#   }
# }




#ALPHA NODE-GROUP

# module "alpha_node_group_v31" {
#   source = "../../modules/eks-managed-node-group/"

#   name            = "DEV-ALPHA-NODEGROUP-V31"
#   cluster_name    = "DEV"
#   cluster_version = var.kubernetes_cluster_version
#   iam_role_arn    = var.iam_role_arn
#   create_iam_role = false
#   subnet_ids = var.subnet_ids

#   // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
#   // Without it, the security groups of the nodes are empty and thus won't join the cluster.
#   vpc_security_group_ids = [
#     var.cluster_security_group_id
#   ]
#   cluster_primary_security_group_id = var.cluster_primary_security_group_id

#   // Note: `disk_size`, and `remote_access` can only be set when using the EKS managed node group default launch template
#   // This module defaults to providing a custom launch template to allow for custom security groups, tag propagation, etc.
#    use_custom_launch_template = false
#    disk_size = 80

#   //  # Remote access cannot be specified with a launch template
#     remote_access = {
#       ec2_ssh_key               = "exp-keypair"
#       source_security_group_ids = [aws_security_group.remote_access.id]
#     }

#   min_size     = 3
#   max_size     = 3
#   desired_size = 3

#   instance_types = ["m5a.xlarge"]

#   labels = {
#     Environment = "DEV"
#     Apps       = "Alpha"

#   }
#  tags = {
#     Name = "DEV-ALPHA-NODEGROUP-V31"
#     Environment = "DEV"
#     Terraform   = "true"
#   }
# }

module "eks-aws-auth" {
  source  = "../../modules/aws-auth/"

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::995179693454:role/AWSReservedSSO_AdministratorAccess_6dc994581e263420"
      username = "aadegboye"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:sts::995179693454:assumed-role/AWSReservedSSO_AdministratorAccess_6dc994581e263420"
      username = "stchamga"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::995179693454:role/AWSReservedSSO_AdministratorAccess_6dc994581e263420/aadegboye"
      username = "aadegboye"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::995179693454:role/AWSReservedSSO_AdministratorAccess_6dc994581e263420/stchamga"
      username = "stchamga"
      groups   = ["system:masters"]
    },
  ]

}
