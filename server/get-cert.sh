#!/bin/bash
#  ~/.acme.sh/acme.sh --upgrade -f --auto-upgrade

 ~/.acme.sh/acme.sh --issue -d www.jysafe.cn --webroot ~/docker/code/php/blog --log
 ~/.acme.sh/acme.sh --installcert -d www.jysafe.cn --key-file ~/docker/nginx/cert/www.jysafe.cn/private.key --fullchain-file ~/docker/nginx/cert/www.jysafe.cn/cert.crt
 ~/.acme.sh/acme.sh --installcert -d www.jysafe.cn --key-file ~/docker/code/php/ssl/www.jysafe.cn/private.key --fullchain-file ~/docker/code/php/ssl/www.jysafe.cn/cert.crt

echo "reload nginx"
docker exec -it server_nginx nginx -s reload

echo "apply change to apache"
docker exec -it server_php_apache apachectl graceful