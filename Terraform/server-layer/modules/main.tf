terraform {
  backend "s3" {
    bucket         = "hananel-cloudschool"
    key            = "terraform-app/terraform.tfstate"
    region         = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "us-east-1"
}

module "RDS-global" {
  source = "../RDS-global"
}


module "main-server" {
  source = "../main-server"
  database_user = "${module.RDS-global.database_user}"
  database_password = "${module.RDS-global.database_password}"
  database_url = "${module.RDS-global.database_url}"
  rds-mysql-db_sg_id = "${module.RDS-global.rds-mysql-db_sg_id}"
  depends_on = [module.RDS-global]
}

module "app-server" {
  source = "../app-server"
  main-instance_vault_sg_id = "${module.main-server.main-instance_vault_sg_id}"
  main-instance_consul_sg_id = "${module.main-server.main-instance_consul_sg_id}"
  main-instance_ssh_sg_id = "${module.main-server.main-instance_ssh_sg_id}"
  rds-mysql-db_sg_id = "${module.RDS-global.rds-mysql-db_sg_id}"
  main-instance_local_ipv4 = "${module.main-server.main-instance_local_ipv4}"
  iam_cloudwatch_s3_profile_id = "${module.main-server.cloudwatch_s3_profile_id}"
  iam_cloudwatch_s3_profile_name = "${module.main-server.cloudwatch_s3_profile_name}"
  depends_on = [module.RDS-global, module.main-server]
}

module "jenkins-server" {
  source = "../jenkins-server"
  main-instance_ssh_sg_id = "${module.main-server.main-instance_ssh_sg_id}"
  main-instance_local_ipv4 = "${module.main-server.main-instance_local_ipv4}"
  iam_cloudwatch_s3_profile_id = "${module.main-server.cloudwatch_s3_profile_id}"
  iam_cloudwatch_s3_profile_name = "${module.main-server.cloudwatch_s3_profile_name}"
  depends_on = [module.main-server]
}



