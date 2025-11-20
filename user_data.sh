#!/bin/bash
apt-get update -y
apt-get install nginx -y
systemctl enable nginx
systemctl start nginx
echo "<html>
  <head><title>Welcome to NGINX on Ubuntu EC2</title></head>
  <body>
    <h1>Deployed via EC2 User Data</h1>
    <p>Instance Hostname: $(hostname)</p>
  </body>
</html>" > /var/www/html/index.nginx-debian.html