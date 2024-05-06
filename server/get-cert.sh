#!/bin/bash
#  ~/.acme.sh/acme.sh --upgrade -f --auto-upgrade

domain="www.jysafe.cn"
 ~/.acme.sh/acme.sh --issue -d "$domain" --webroot ~/docker/code/php/blog --log
 ~/.acme.sh/acme.sh --installcert -d "$domain" --key-file ~/docker/nginx/cert/$domain/private.key --fullchain-file ~/docker/nginx/cert/$domain/cert.crt
 ~/.acme.sh/acme.sh --installcert -d "$domain" --key-file ~/docker/code/php/ssl/$domain/private.key --fullchain-file ~/docker/code/php/ssl/$domain/cert.crt

domain="api.jysafe.cn"
 ~/.acme.sh/acme.sh --issue -d "$domain" --webroot ~/docker/code/php/api --log
 ~/.acme.sh/acme.sh --installcert -d "$domain" --key-file ~/docker/nginx/cert/$domain/private.key --fullchain-file ~/docker/nginx/cert/$domain/cert.crt
 ~/.acme.sh/acme.sh --installcert -d "$domain" --key-file ~/docker/code/php/ssl/$domain/private.key --fullchain-file ~/docker/code/php/ssl/$domain/cert.crt

echo "reload nginx"
docker exec -it server_nginx nginx -s reload

echo "apply change to apache"
docker exec -it server_php_apache apachectl graceful