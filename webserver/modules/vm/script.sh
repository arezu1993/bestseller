#!/bin/bash
sudo yum update -y
sudo yum install -y httpd


sudo systemctl enable httpd
sudo service httpd start
#AWS documentation for accessing EC2 instance information
#https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h1>Private IP Address of EC2 Server: $PRIVATE_IP</h1>" | sudo tee /var/www/html/index.html


echo "
<VirtualHost *:80>
    DocumentRoot /var/www/html
</VirtualHost>
" | sudo tee /etc/httpd/conf.d/vhost.conf


sudo service httpd restart
