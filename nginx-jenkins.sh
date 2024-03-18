#!/bin/bash

# Replace with your desired domain and file path
domain="mrolujenkins.duckdns.org"
config_file="/etc/nginx/sites-available/$domain"

# Create Nginx configuration file
sudo tee "$config_file" > /dev/null <<'EOL'
upstream jenkins {
    server 3.92.238.53:8080;
}

server {
    listen      80;
    server_name mrolujenkins.duckdns.org;

    access_log  /var/log/nginx/jenkins.access.log;
    error_log   /var/log/nginx/jenkins.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://jenkins;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;

        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto https;
    }
}
EOL

# Enable the configuration file
sudo ln -s "$config_file" "/etc/nginx/sites-enabled/"

# Test for syntax errors and reload Nginx
if command -v nginx &> /dev/null; then
    sudo nginx -t && sudo systemctl reload nginx
else
    echo "Error: nginx not found. Please ensure nginx is installed."
    exit 1
fi

# Run certbot for SSL encryption
sudo certbot --nginx -d "$domain"

# Check status of certbot timer and renew SSL certificate
sudo systemctl status certbot.timer
sudo certbot renew --dry-run

echo "Nginx configuration and encryption reloaded successfully."
