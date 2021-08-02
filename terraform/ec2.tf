locals {
  tags = {
    Region = "us-east-1"
  }
}

resource "aws_instance" "serendipity_exercise_ec2" {
  ami                         = data.aws_ami.serendipity_exercise_ubuntu_filter.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.serendipity_exercise_vpc.id
  vpc_security_group_ids      = [aws_security_group.serendipity_exercise_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.serendipity_exercise_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_exercise_role_profile.name

  user_data = file(var.init_script_path)

  tags = merge(local.tags, { "Name" : "${terraform.workspace}-exercise-ec2-instance" })
}

data "aws_ami" "serendipity_exercise_ubuntu_filter" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


resource "aws_key_pair" "serendipity_exercise_key" {
  key_name   = "srdpt"
  public_key = file(var.ssh_public_key_file)
}

resource "aws_iam_role" "ec2-access-role" {
  name               = "ec2-access-role-${terraform.workspace}"
  tags               = merge(local.tags, { "Name" : "${terraform.workspace}-exercise-ec2-role" })
  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_s3_access_policy" {
  name = "ec2-s3-access-policy-${terraform.workspace}"
  role = aws_iam_role.ec2-access-role.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetBucketLocation",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetBucketAcl"],
            "Resource": ["${aws_s3_bucket.serendipity_exercise_output_bucket.arn}",
                         "${aws_s3_bucket.serendipity_exercise_output_bucket.arn}/",
                         "${aws_s3_bucket.serendipity_exercise_output_bucket.arn}/*"]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_ec2_access_policy" {
  name = "ec2-ec2-access-policy-${terraform.workspace}"
  role = aws_iam_role.ec2-access-role.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
       {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "${aws_instance.serendipity_exercise_ec2.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_exercise_role_profile" {
  name = "serendipity-ec2-role-profile"
  role = aws_iam_role.ec2-access-role.name
}

