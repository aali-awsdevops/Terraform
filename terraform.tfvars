project 	= "ExodusPoint"
profile = "exp"
infra_env 	= "DEV"
vpc_cidr 	= "10.112.16.0/20"

ops360_env = "EXP-DEV-EKS-OPS360-NODEGROUP"
alpha_env = "EXP-DEV-EKS-ALPHA-NODEGROUP"


cluster_primary_security_group_id = "sg-02fba9b50d5423a02"

#only can login to the prime. Below order - from within the private subnet 1, private subnet2, private subnet 3 (bastions). 
#alveo VPN in public subnet 1 is not allowed. login from SFTP server box is allowed. #but this is of no use. because ssh is allowed only for the master user.

# Allow from the bastions "10.112.1.0/26". Disallow from 0.0/26 or the entire 0.0/23 because we don't want OpenVPN directly
# reach us# Allow from Ansible-Controller [BASTIONS-Public subnet-2], BASTIONS-Private subnet1 [Linux and Windows bastions],
# and from within this VPC - 2.0/23 # WARN: Don't allow from 10.112.0.0/26 - THIS WILL ALLOW OPENVPN CONNECT TO PRIME SERVERS WITHOUT GOING THROUGH BASTIONS **

allowed_cidr_ranges_private_sg = ["10.112.0.64/26","10.112.1.0/26","10.112.16.0/20"]

#common keypair for all the vms
keypair = "exp-keypair"


endpoint_private_access = false
endpoint_public_access = true

# rds postgres related values

rds_snapshot_identifier = "dev-postgres-db-manual-snapshot-5th-august"  # comment/uncomment
rds_instance_type 	= "db.m5.xlarge"
rds_availability_zone 	= "us-east-1b" # This is will allow to create in private subnet 2 # fixing the same zone for prime 
#rds_db_name = "acdba"
#rds_username = "acdba"
#rds_password = "welcome123"
#rds_db_allocated_storage = 100

# Prime server related values
prime_private_ips	= ["10.112.24.12"]
prime_ami		= "ami-0ea23d95722d4f27d" # use this line to specify custom AMI after built
prime_instance_type 	= "r6a.xlarge"

# EKS and EKS noder related values
eks_node_instance_type = "m5a.xlarge"
kubernetes_cluster_version = "1.31"

node_instance_type = "m5a.large"
#

cluster_auth_base64 = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJSW52Zkt4N0JiREl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpBNE1qRXhNVEkxTlRaYUZ3MHpNekE0TVRneE1USTFOVFphTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUN3WEdyRjMvSk9JdVhJSGNoQTErQmhLRFpQbTd4UUhta3FQaVVFWTFMczhiRjlwcEVGNittL2NpSmEKSUtVZG5SZnZGbDJSRVo5b3NpNmJIdXVTVnM2M3Y4SkJuZ3EvKzAzMDk1bWsrZXdRWjhpZ2h5V293bXBLKzRtNAo3Zi9URVpCVGppaThaNnpCN3NoWGN1WHlMVko5ZHcrbVpoRlI1MWhVT0tpRVhRSkFFQjVPcEJjRzJUNVdVa25TCk4yOEl4Z1pMS25zMTRKTVpaWnBnM0l0dEVKaXJPalZxSlcwbGNabFYxcEY3dzNEYmNUU0hiUlNXQmkyNm9NQ3AKMDlMUnVnV0VySUJtM1NiVEt2c1V0QXZpRHdoNXhqOTdyU0o2bzcrdUdYK2pVU2VhL0doQ1Z3M0wyVVdtRFdGZQpBeWNyRXM5YUFRUVlpR2lFM1BDdTNKL2c1dEE3QWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUNWJRVEF4Q05hTVYzeDZOV1BBZWlCTFl0K0tqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQnQvWWhrOUNGbwpVNkVEaXh1OHlUZE9idlhicEtLdkY3dlAvVncxQ09HWnZCcDNwOHNBYnNudFZvU0xNRVd4Ymc1OFpFdFR3V3lKCnJmQlExOWI0cHhjUU8wZzB1OGlmSkNzNFVMZ0NDbyt2UVkwZzVjUXZXWnFXaG5ieXBMeGtLVzNhRDhxbWh0OVkKWHdjd0s3L2EwcFRZWjRqUFVQWnhFZld4ZDhUVFJTSDNlNVArNnBYRnJOZEQrLzlUaDNmeTF2RTFoa0FTMGZhMwpDTk5YRE1XYmdnZjVWbnJib0J6WDVXV1VWQUtHTEZpV3JXSUxBQ0JtbUpVQUMzWG42a080UW1PNzRSdzlLVSt4CnNWOVVQbnFzKzVHVUF4RnUyNmIrK0x0MlNITGdDcjZRMjl3K3VwTWFnOGtXVHpIQ1BQRkxBRzV0ZzN1dkYxM0UKUW5jbTNWZmVyZjc1Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

cluster_endpoint = "https://34F334866392B6A7C5B38F091A30EB39.gr7.us-east-1.eks.amazonaws.com"

cluster_security_group_id = "sg-04407fc749cc2272f"

subnet_ids = [ "subnet-0e8e17202117a943e", "subnet-078a0c75c21960112" , "subnet-0169ceff8ba44b137" ]


iam_role_arn = "arn:aws:iam::995179693454:role/DEV-Worker-Role"

vpc_id = "vpc-0fee883a7196ba253"

max_size = "3"
min_size = "3"
desired_size = "3"

public_subnet_numbers = {
    "us-east-1b" = 0 # Public subnet use1-az4
    "us-east-1c" = 1 # Public subnet use1-az6
    "us-east-1d" = 2 # Public subnet use1-az6
  
}
private_subnet_numbers = {
    "us-east-1b" = 8 # Private subnet use1-az4
    "us-east-1c" = 9 # Private subnet use1-az6
    "us-east-1d" = 10 # Private subnet use1-az6
}


#####################################################################################
########################EKS Cluster related values####################################

instance_types = ["m5a.xlarge"]
ops360_node_group_name = "DEV-OPS360-NODEGROUP-V31"
alpha_node_group_name = "DEV-ALPHA-NODEGROUP-V31"

#####################################################################################
########################EKS Cluster related values####################################



eks_ssh_key = "exp-keypair"

cluster_iam_role_arn = "arn:aws:iam::995179693454:role/DEV-EKS-iam-role"