################################################################################
# Policies
################################################################################
locals {
  lifecycle_policy = {
    rules = [{
      rulePriority = 10
      description  = "keep last 20 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 20
      }
    },
    {
      rulePriority = 1
      description  = "Expire untagged images older than 14 days"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = 1
      }
    }]
  }
}
################################################################################
# Resources
################################################################################
module "ecrs" {
  source = "terraform-module/ecr/aws"
  version = "1.0.6"
  ecrs = {
    adservice = {
      tags             = { Service = "adservice", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    },
    cartservice = {
      tags             = { Service = "cartservice", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    },
    checkoutservice = {
      tags             = { Service = "checkoutservice", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    },
    currencyservice = {
      tags             = { Service = "currencyservice", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }
    emailservice = {
      tags             = { Service = "emailservice", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }
    frontend = {
      tags             = { Service = "frontend", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }
    loadgenerator = {
      tags             = { Service = "loadgenerator", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }
    paymentservice = {
      tags             = { Service = "paymentservice", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }
    productcatalogservice = {
      tags             = { Service = "productcatalogservice", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }
    recommendationservice = {
      tags             = { Service = "recommendationservice", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }
    shippingservice = {
      tags             = { Service = "shippingservice", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }
    webapi = {
      tags             = { Service = "webapi", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    } 
    api = {
      tags             = { Service = "api", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }  
    client = {
      tags             = { Service = "client", Env = "dev" }
      lifecycle_policy = local.lifecycle_policy
    }         
  }
}
