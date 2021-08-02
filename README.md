## **Serendipity exercise**

The idea is to run this locally and it should deploy an EC2, VPN, security group, S3 bucket, policies and other little
bits and bobs into your S3 account.

#Steps
1 Ensure you have the credentials file in the right place and up to date -
  https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
2 Install terraform on your local machine or wherever this will be run.
3 Navigate to the /serendipity/terraform/ directory.
4 Run 'terraform workspace new serendipity' (you should really call the workspace whatever you want but I haven't figured
  out whether I can pass the bucket name as parameter to the init.sh script run as "user date" and so it expects the bucket
  to be called "serendipity-exercise-output-bucket").
5 Run 'terraform apply' and type 'yes' (I promise its safe).
7 Grab a coffee or tea.
6 Via the AWS console or cli the instance should have been created and terminated.
6 In s3 search for the bucket - "serendipity-exercise-output-bucket" and you should have a file
  <instance ip>_python_packages.txt inside it
