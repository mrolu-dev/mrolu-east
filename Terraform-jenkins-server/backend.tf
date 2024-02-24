terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }

  }



  backend "s3" {

    bucket  = "laflortfstate"    //manually created 
    key     = "jenkins/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true

    # dynamodb_table = "Terraform_lock"   //manually created 

  }

}