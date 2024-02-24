terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }

  }



  backend "s3" {

    bucket  = "laflortfstate"    //manually created 
    key     = "ecr/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true

 
  }

}