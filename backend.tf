terraform {
  backend "s3" {
    bucket = "devops-capstone-tfstate"
    key    = "terraform/state.tfstate"
    region = "us-east-1"
  }
}