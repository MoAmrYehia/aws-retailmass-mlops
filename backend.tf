terraform {
  backend "s3" {
    #Bucket should be created in advance, Replace this with your bucket name!
    bucket         = "retailmass-predeployment"
    key            = "sagemaker/deployment/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
  }
}