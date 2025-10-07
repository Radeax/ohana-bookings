#!/bin/bash

set -e

echo "🌺 Ohana of Polynesia Bookings - Setup"
echo "=========================================="
echo ""

# if ! command -v docker &> /dev/null; then
if ! command -v docker; then
    echo "❌ Docker not installed"
    echo "   Install from: https://www.docker.com/products/docker-desktop/"
    exit 1
fi

# if ! docker compose version &> /dev/null; then
if ! docker compose version; then
    echo "❌ Docker Compose not available"
    exit 1
fi

echo "✅ Docker installed"
echo "✅ Docker Compose installed"
echo ""

if [ ! -f .env ]; then
    echo "📝 Creating .env from template..."
    cp .env.example .env
    
    echo "🔐 Generating secrets..."
    JWT_SECRET=$(openssl rand -base64 32)
    JWT_REFRESH_SECRET=$(openssl rand -base64 32)
    SESSION_SECRET=$(openssl rand -base64 32)
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|JWT_SECRET=.*|JWT_SECRET=$JWT_SECRET|g" .env
        sed -i '' "s|JWT_REFRESH_SECRET=.*|JWT_REFRESH_SECRET=$JWT_REFRESH_SECRET|g" .env
        sed -i '' "s|SESSION_SECRET=.*|SESSION_SECRET=$SESSION_SECRET|g" .env
    else
        sed -i "s|JWT_SECRET=.*|JWT_SECRET=$JWT_SECRET|g" .env
        sed -i "s|JWT_REFRESH_SECRET=.*|JWT_REFRESH_SECRET=$JWT_REFRESH_SECRET|g" .env
        sed -i "s|SESSION_SECRET=.*|SESSION_SECRET=$SESSION_SECRET|g" .env
    fi
    
    echo "✅ .env created with secure secrets"
else
    echo "ℹ️  .env already exists"
fi

echo ""
echo "🚀 Setup complete!"
echo ""
echo "   Start development:"
echo "   $ docker compose -f compose.dev.yaml up"
echo ""
echo "   Start production:"
echo "   $ docker compose up"
echo ""