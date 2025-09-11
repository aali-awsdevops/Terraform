# Note if you comment this backend out, the terraform statefile will be created
# locally
# Setting encrypt to true ensures that your Terraform state will be encrypted on disk
# when stored in S3. We already enabled default encryption in the S3 bucket itself,
# so this is here as a second layer to ensure that the data is always encrypted.

# you need to put this in the root config directory where you are calling from

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "exoduspoint-alveo-ops360-nvirginia-tfstate-dev"
    key            = "global/s3/dev/terraform.tfstate.dev"
    region         = "us-east-1"
    profile        = "exp"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "nvirginia_tfstate_locks_dev"
    encrypt        = true
  }
}
