terraform {
  backend "s3" {
    bucket = "tfremotestate-n913gnfk3s"
    key    = "wellarchitected.tfstate"
    region = "eu-west-1"
  }
}