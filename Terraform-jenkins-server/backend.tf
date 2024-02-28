terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }

  }



  backend "s3" {

    bucket  = "lafloreast"    //manually created 
    key     = "jenkins/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true

    # dynamodb_table = "Terraform_lock"   //manually created 

  }

}