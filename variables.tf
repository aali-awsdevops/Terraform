#Keypair for all the machines
variable "keypair" {
  type        = string
  description = "keypair"
}
########################################
variable "project" {
  type        = string
  description = "Project Name"
}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "node_instance_type" {
  
}



variable "private_subnet_numbers" {
  type = map(number)

}

variable "public_subnet_numbers" {
  type = map(number)

}

variable "endpoint_private_access" {
  type        = bool
  description = "endpoint_private_access variable"
}

variable "endpoint_public_access" {
  type        = bool
  description = "endpoint_public_access variable"
}
variable "ops360_env" {
  type        = string
  description = "infrastructure environment"
}
variable "alpha_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR of vpc required"
}

variable "cluster_endpoint" {
  type        = string
  description = "Cluster Endpoint"
}

variable "cluster_auth_base64" {
  type        = string
  description = "Cluster Auth"
}


# variable "cluster_primary_security_group_id" {
#   type = string
# }

variable "cluster_security_group_id" {
  type = string
}

variable "iam_role_arn" {
  type = string

}
variable "cluster_primary_security_group_id" {
      type = string

}

variable "allowed_cidr_ranges_private_sg" {
  type = list
  description = "allowed CIDR ranges to reach openvpn servers"
  default = ["0.0.0.0/0"]
}

variable "subnet_ids" {
  type = set(string)
}


#########################################################################


# rds postgres related variables

 variable "rds_snapshot_identifier" {
   type        = string
   description = "rds snapshot name/ami"
 }


variable "rds_instance_type" {
  type        = string
  description = "rds instance type"
}

variable "rds_availability_zone" {
  type        = string
  description = "rds availability zone"
}

#variable "rds_db_allocated_storage" {
#  type        = number
#  description = "EBS volume size"
#}


#variable "rds_db_name" {
#  type        = string
#  description = "db name created within rds"
#}


#variable "rds_username" {
#  type        = string
#  description = "rds username"
#}


#variable "rds_password" {
#  type        = string
#  description = "rds password for the user you created"
#}


# variable "rds_security_group_ids" {
#  type        = set(string)
#  description = "rds security group ids"
# }

# variable "rds_private_subnet_ids" {
#  type        = string
#  description = "rds private subnet ids"
# }

#########################################################################
# Prime server variables
#########################################################################

variable "prime_private_ips" {
  type        = set(string)
  description = "private ip of prime"
}

variable "prime_ami" {
  type        = string
  description = "prime ami id"
}

variable "prime_instance_type" {
  type        = string
  description = "prime instance type"
}

########################################################################
# EKS related variables
########################################################################

variable "eks_node_instance_type" {
  type        = string
  description = "instance type of eks nodes"
}

variable "kubernetes_cluster_version" {
  type        = string
  description = "EKS Cluster version"
}


#################################################################################



variable "vpc_id" {
  type =  string
  description = " VPC id "
  
}

variable "profile" {
  type        = string
  description = "profile"
}

#####################################################################################
########################EKS Cluster related values####################################

variable "instance_types" {
  type = list(string)
  description = "instance types"
}
variable "ops360_node_group_name" {
  type = string
  description = "ops360 node group name"
}
variable "alpha_node_group_name" {
  type = string
  description = "alpha node group name"
}
variable "desired_size" {
  type        = string
  description = "desired_size of nodes"
}

variable "max_size" {
  type        = string
  description = "max_size of nodes"
}

variable "min_size" {
  type        = string
  description = "min_size of nodes"
}

variable "eks_ssh_key" {
  description = "SSH key name for EKS access"
  type        = string
}

variable "cluster_iam_role_arn" {
  type        = string
  description = "IAM role ARN for EKS cluster"
}