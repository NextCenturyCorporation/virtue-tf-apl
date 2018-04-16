# Needs to be configured per profile
# This shoud not be modified

terraform {
  backend "s3" {
    bucket  = "tf-state-virtue"
    key     = "virtue-apl.tfstate"
    profile = "virtue"
    region  = "us-east-1"
  }
}
