variable "ami_id" {
  type = string
  default = "ami-065292b4abbb3575f"
}

variable "instance-type" {
  type = string
  default = "t2.micro"
}

variable "region" {
  type = string
  default = "sa-east-1"
}