# CellProfiler docker

    $ make
    $ make test

# Building on AWS

Launch an instance with the Amazon Linux AMI and   
[set up docker](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html):
 
    $ sudo yum update -y
    $ sudo yum install -y docker
    $ sudo service docker start
    $ sudo usermod -a -G docker ec2-user
 
Log out and log back in again to pick up the new docker group permissions.
Clone this repo and then ```make```
