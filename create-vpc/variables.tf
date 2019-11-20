## S3 Bucket variable
variable s3bucket-name {
    default = "useast1.dev.stem.com"
}
variable region {
    default = "us-east-1"
}
variable sse_algorithm { default = "AES256" }

## VPC variables

variable cidr_block {
    default = "10.16.0.0/16"
}
variable pub_subnetlist {
    default =  ["10.16.1.0/24", "10.16.2.0/24","10.16.3.0/24"]
    type = "list"
}

variable private_subnetlist {
    default =  ["10.16.4.0/24", "10.16.5.0/24","10.16.6.0/24"]
    type = "list"
}

variable availability_zone {
    type = "list"
    default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}