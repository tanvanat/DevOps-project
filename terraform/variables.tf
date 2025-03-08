variable "region" {
    type = string
    description = "The AWS region to use"
    default = "us-east-1"
}
variable "public_key" {
  type        = string
  description = "Public key for SSH access"
}
variable "private_key" {
  type        = string
  description = "The private key for SSH access to the EC2 instance"
  sensitive   = true # Mark as sensitive to prevent display in plan/apply output
}


variable "key_name" {
  type        = string
  description = "Name of the SSH key pair"
}

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "TF_STATE_BUCKET_NAME" {
  type = string
}

