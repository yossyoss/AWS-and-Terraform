locals {
  my-nginx-instance-userdata = <<USERDATA
#!/bin/bash

sudo apt update -y
sudo apt install nginx -y
sed -i "s/nginx/Grandpa's Whiskey - $HOSTNAME.srv/g" /var/www/html/index.nginx-debian.html
sed -i '15,23d' /var/www/html/index.nginx-debian.html
service nginx restart
########## Upload Access Log To S3 Now & Every Hour ##########
echo "0 * * * * root aws s3 cp /var/log/nginx/access.log  s3://${var.purpose_tag}-${var.s3_logs_bucket_name}/$HOSTNAME-access.log" | tr [:upper:] [:lower:] | sudo tee -a /etc/crontab


USERDATA
}