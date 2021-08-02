#!/bin/sh

echo "running the shell script"

version=$(python3 -c 'import sys; print(sys.version_info[:])')

echo "The current python version is - $version"

install_packages() {
    sudo apt update
    yes | sudo apt-get install awscli
    yes | sudo apt-get install python3-pip
    yes | sudo apt-get install python3-numpy
    yes | sudo pip install flask
}

install_packages

public_ip=$(curl ifconfig.me)

filename=${public_ip}_python_packages.txt

pip list > $filename

aws s3 cp $filename s3://serendipity-exercise-output-bucket #this really should be parameterised

wait $!

metadata_token=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

instanceid=$(curl -H "X-aws-ec2-metadata-token: $metadata_token" -v http://169.254.169.254/latest/meta-data/instance-id)

aws ec2 terminate-instances --instance-ids $instanceid --region "us-east-1"
