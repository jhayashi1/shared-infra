provider "aws" {
	region = "us-east-1"

    default_tags {
        tags = {
            Name = "shared-infra"
            git_url = "https://github.com/jhayashi1/shared-infra"
        }
    }
}

data "aws_caller_identity" "current" {}