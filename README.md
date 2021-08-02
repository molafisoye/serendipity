## **Serendipity exercise**

The idea is to run this locally and it should deploy an EC2, VPN, security group, S3 bucket, policies and other little
bits and bobs into your S3 account.

### *Steps*
1 Ensure you have the credentials file in the right place and up to date -
  https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

2 Install terraform on your local machine or wherever this will be run.

3 Navigate to the /serendipity/terraform/ directory.

4 Run 'terraform workspace new serendipity' (you should really call the workspace whatever you want but I haven't figured
  out whether I can pass the bucket name as parameter to the init.sh script run as "user date" and so it expects the bucket
  to be called "serendipity-exercise-output-bucket").

5 Run 'terraform apply' and type 'yes' (I promise its safe).

  a) It will ask for the location of your public key (*.pub) you need to access the instance (useful for debugging)

  b) It will also ask for the location of the init script which will run when the instance starts.

7 Grab a coffee or tea.

6 Via the AWS console or cli the instance should have been created and terminated.

6 In s3 search for the bucket - "serendipity-exercise-output-bucket" and you should have a file -
  <instance ip>_python_packages.txt inside it.

### *Answers to other questions*

1 To a kubernetes cluster, I would -

  Build and push the latest Docker image to the right registry, usually aws ECR.
  if this for a production deployment it would usually be handled by a CI/CD pipeline tool such as Jenkins, GitHub Actions,
  Helm or Concourse.

  Use either the kubectl set image or the kubectl edit command - this should automatically handle the upgrade.

2 For sharing environment variables across containers in a secure manner, I would use Kubernetes Secrets especially if
  these are sensitive credentials (DB username or passwords, API keys, certain URLs etc.) using the following values in
  the YAML file.

  env:
  ...
     valueFrom:
            secretKeyRef:
  	...

3 Not sure about the right subnet mask to use but I would go with /8 as it allows the creation of a maximum number of
  nodes without running out of IP addresses to provision.

4 'find <dir> -type f -executable' or the 'whereis' command

5 To get the lightest images possible,

  First ensure only required packages and utilities are installed within the container.

  ADD only necessary dirs and files a .dockerignore may help.

  Use multistage builds.

  Use a smaller base image if possible.

  Not likely but use 'FROM scratch'.

6 To run an adhoc task I would, depending on the scenario use AWS lambda or possibly EC2 if I had a preconfigured AMI