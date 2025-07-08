terraform {
  backend "s3" {
    bucket         = "jv-devops-capstone-tfstate"
    key            = "terraform/state.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}