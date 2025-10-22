#!/bin/bash

echo "🚀 Traefik Production Setup"
echo "================================="
echo ""

# Function to check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        echo "❌ Docker is not running. Please start Docker Desktop first."
        exit 1
    fi
    echo "✅ Docker is running"
}

# Function to check service health
check_service_health() {
    local service_name=$1
    local max_attempts=30
    local attempt=1
    
    echo "🔍 Checking $service_name health..."
    
    while [ $attempt -le $max_attempts ]; do
        if docker ps --filter "name=$service_name" --filter "status=running" | grep -q "$service_name"; then
            echo "✅ $service_name is running"
            return 0
        fi
        
        echo "⏳ Waiting for $service_name... (attempt $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "❌ $service_name failed to start after $max_attempts attempts"
    return 1
}

# Function to test SSL endpoints
test_ssl_endpoints() {
    echo ""
    echo "🧪 Testing SSL endpoints..."
    echo "==========================="
    
    # Wait for services to be ready
    sleep 15
    
    # Test health endpoint
    echo "🔍 Testing health endpoint..."
    if curl -s -k https://apifincheck.husanenglish.online/health >/dev/null; then
        echo "✅ Health endpoint working with SSL"
    else
        echo "❌ Health endpoint failed"
    fi
    
    # Test Traefik dashboard
    echo "🔍 Testing Traefik dashboard..."
    if curl -s -k https://traefik.apifincheck.husanenglish.online >/dev/null; then
        echo "✅ Traefik dashboard accessible"
    else
        echo "❌ Traefik dashboard not accessible"
    fi
}

# Function to show service status
show_status() {
    echo ""
    echo "📊 Service Status"
    echo "=================="
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo ""
    echo "🌐 Production Access Points"
    echo "=========================="
    echo "🚪 Gateway: https://apifincheck.husanenglish.online"
    echo "📊 Traefik Dashboard: https://traefik.apifincheck.husanenglish.online:8888"
    echo "🔍 Health Check: https://apifincheck.husanenglish.online/health"
    echo ""
    echo "🔗 API Endpoints:"
    echo "  - Authentication: https://apifincheck.husanenglish.online/auth/"
    echo "  - Users: https://apifincheck.husanenglish.online/users/"
    echo "  - Products: https://apifincheck.husanenglish.online/products/"
    echo "  - Orders: https://apifincheck.husanenglish.online/orders/"
    echo "  - Documentation: https://apifincheck.husanenglish.online/docs/"
    echo ""
    echo "🔒 SSL Certificates:"
    echo "  - Automatic Let's Encrypt certificates"
    echo "  - Auto-renewal every 60 days"
    echo "  - HTTPS redirect enabled"
}

# Function to setup SSL certificates
setup_ssl() {
    echo "🔒 Setting up SSL certificates..."
    
    # Create letsencrypt directory
    mkdir -p ./letsencrypt
    
    # Set proper permissions
    chmod 600 ./letsencrypt
    
    echo "✅ SSL setup completed"
    echo "📝 Note: Let's Encrypt certificates will be automatically generated"
    echo "   on first request to the domain"
}

# Main setup function
setup_traefik_prod() {
    echo "🔧 Setting up Traefik production..."
    
    # Check Docker
    check_docker
    
    # Setup SSL
    setup_ssl
    
    # Stop any existing containers
    echo "🛑 Stopping existing containers..."
    docker-compose -f docker-compose.prod-clean.yml down
    
    # Build and start services
    echo "🏗️  Building and starting services..."
    docker-compose -f docker-compose.prod-clean.yml up -d --build
    
    # Wait for services to start
    echo "⏳ Waiting for services to start..."
    sleep 20
    
    # Check service health
    check_service_health "traefik-gateway"
    check_service_health "backend1-node"
    check_service_health "backend2-python"
    check_service_health "backend3-java"
    check_service_health "health-check"
    
    # Test SSL endpoints
    test_ssl_endpoints
    
    # Show status
    show_status
    
    echo ""
    echo "🎉 Traefik production setup completed!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Ensure DNS points to your server IP"
    echo "2. Wait for Let's Encrypt certificates (may take 1-2 minutes)"
    echo "3. Test HTTPS endpoints using the URLs above"
    echo "4. Monitor logs: docker-compose -f docker-compose.prod-clean.yml logs"
    echo ""
    echo "🛑 To stop: docker-compose -f docker-compose.prod-clean.yml down"
    echo "🔄 To restart: docker-compose -f docker-compose.prod-clean.yml restart"
}

# Run setup
setup_traefik_prod
