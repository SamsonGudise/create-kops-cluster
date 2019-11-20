variable s3bucket-name {
    default = "useast1.dev.stem.com"
}
variable region {
    default = "us-east-1"
}
variable sse_algorithm { default = "AES256" }

resource "aws_kms_key" "terraform-s3-kmskey" {
  count = "${var.sse_algorithm == "AES256" ? 0 : 1}"
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "terraform-s3-bucket" {
  bucket = "${var.s3bucket-name}"
  acl    = "private"
  region = "${var.region}"
  versioning {
      enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "${var.sse_algorithm}"
      }
    }
  }

  tags = {
      Name = "useast1.dev.stem.com"
      Owner = "Samson Gudise"
  }
}