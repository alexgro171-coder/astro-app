#!/bin/bash
# ===========================================
# Server Setup Script for Astro App
# Digital Ocean Droplet: 64.225.97.205
# ===========================================

set -e

echo "🚀 Starting Astro App server setup..."

# Update system
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install essential tools
echo "🔧 Installing essential tools..."
apt install -y curl wget git vim htop ufw

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    
    # Add current user to docker group
    usermod -aG docker $USER
fi

# Install Docker Compose
echo "🐳 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Install Nginx
echo "🌐 Installing Nginx..."
apt install -y nginx

# Install Certbot for SSL
echo "🔒 Installing Certbot..."
apt install -y certbot python3-certbot-nginx

# Configure firewall
echo "🔥 Configuring firewall..."
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw allow 3000  # Backend API (temporary, will be proxied through Nginx)
ufw --force enable

# Create application directory
echo "📁 Creating application directory..."
mkdir -p /var/www/astro-app
chown -R $USER:$USER /var/www/astro-app

# Clone repository (you'll need to run this manually with proper auth)
echo "📥 Clone the repository manually:"
echo "   cd /var/www/astro-app"
echo "   git clone https://github.com/alexgro171-coder/astro-app.git ."

# Create Nginx configuration
echo "🌐 Creating Nginx configuration..."
cat > /etc/nginx/sites-available/astro-app << 'NGINX'
server {
    listen 80;
    server_name 64.225.97.205;  # Replace with your domain later

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 86400;
    }

    # Health check
    location /health {
        proxy_pass http://localhost:3000/api/v1/health;
    }
}
NGINX

# Enable the site
ln -sf /etc/nginx/sites-available/astro-app /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
nginx -t

# Restart Nginx
systemctl restart nginx
systemctl enable nginx

echo ""
echo "✅ Server setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Clone the repository:"
echo "   cd /var/www/astro-app && git clone https://github.com/alexgro171-coder/astro-app.git ."
echo ""
echo "2. Create the .env file:"
echo "   cp .env.example .env && nano .env"
echo ""
echo "3. Start the application:"
echo "   docker compose up -d --build"
echo ""
echo "4. (Optional) Add a domain and SSL:"
echo "   certbot --nginx -d yourdomain.com"
echo ""

