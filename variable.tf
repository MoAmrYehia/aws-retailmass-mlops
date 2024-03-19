# Make a change according to your VPC ID
variable "sm_vpc_id" {
  default = "vpc-c66091a0"
}

# Make a change according to your Subnet IDs
variable "sm_subnets" {
  default = ["subnet-c4718d9e"]
}

# Make a change according to your Security Groups
variable "sm_sec_group" {
  default = "sg-4bab0939"
}
