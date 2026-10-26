terraform {
  backend "s3" {
    bucket         = "REPLACE-ME-tfstate"
    key            = "cloud-native-platform/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "REPLACE-ME-tflock"
    encrypt        = true
  }
}
