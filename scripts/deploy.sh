#!/bin/bash
# ===========================================
# Deployment Script for Astro App
# Run this from your local machine
# ===========================================

set -e

SERVER="root@64.225.97.205"
APP_DIR="/var/www/astro-app"

echo "🚀 Deploying Astro App to production..."

# SSH to server and deploy
ssh $SERVER << 'ENDSSH'
set -e

cd /var/www/astro-app

echo "📥 Pulling latest changes..."
git pull origin main

echo "🔨 Building and restarting containers..."
docker compose up -d --build backend

echo "🧹 Cleaning up old images..."
docker image prune -f

echo "✅ Deployment complete!"

# Show running containers
docker compose ps
ENDSSH

echo ""
echo "✅ Deployment finished successfully!"
echo "🌐 API available at: http://64.225.97.205/api/v1"
echo "📚 Docs available at: http://64.225.97.205/docs"

