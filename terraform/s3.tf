resource "aws_s3_bucket" "serendipity_exercise_output_bucket" {
  bucket = "${terraform.workspace}-exercise-output-bucket"
  acl    = "private"

  tags = merge(local.tags, { "Name" : "${terraform.workspace}-exercise-output-bucket" })
}

resource "aws_s3_bucket_policy" "output_bucket_policy" {
  bucket = aws_s3_bucket.serendipity_exercise_output_bucket.id
  policy = <<POLICY
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "Allow access to output bucket",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": [
                "s3:Get*",
                "s3:Put*"
            ],
            "Resource": "${aws_s3_bucket.serendipity_exercise_output_bucket.arn}"
        },
        {
            "Sid": "Allow list of output bucket",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "s3:List*",
            "Resource": "${aws_s3_bucket.serendipity_exercise_output_bucket.arn}"
        }
    ]
}
POLICY
}
