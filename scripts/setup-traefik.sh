#!/bin/bash

echo "🚀 Traefik Setup"
echo "===================="
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

# Function to test API endpoints
test_endpoints() {
    echo ""
    echo "🧪 Testing API endpoints..."
    echo "=========================="
    
    # Wait for services to be ready
    sleep 10
    
    # Test health endpoint
    echo "🔍 Testing health endpoint..."
    if curl -s http://localhost/health >/dev/null; then
        echo "✅ Health endpoint working"
    else
        echo "❌ Health endpoint failed"
    fi
    
    # Test backend services
    echo "🔍 Testing backend services..."
    for service in auth users products orders docs; do
        if curl -s "http://localhost/$service/" >/dev/null 2>&1; then
            echo "✅ $service endpoint accessible"
        else
            echo "⚠️  $service endpoint not accessible (may be normal for some services)"
        fi
    done
}

# Function to show service status
show_status() {
    echo ""
    echo "📊 Service Status"
    echo "=================="
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo ""
    echo "🌐 Access Points"
    echo "================"
    echo "🚪 Gateway: http://localhost"
    echo "📊 Traefik Dashboard: http://localhost:8888"
    echo "🔍 Health Check: http://localhost/health"
    echo ""
    echo "🔗 API Endpoints:"
    echo "  - Authentication: http://localhost/auth/"
    echo "  - Users: http://localhost/users/"
    echo "  - Products: http://localhost/products/"
    echo "  - Orders: http://localhost/orders/"
    echo "  - Documentation: http://localhost/docs/"
}

# Main setup function
setup_traefik() {
    echo "🔧 Setting up Traefik..."
    
    # Check Docker
    check_docker
    
    # Stop any existing containers
    echo "🛑 Stopping existing containers..."
    docker-compose -f docker-compose.local-clean.yml down
    
    # Build and start services
    echo "🏗️  Building and starting services..."
    docker-compose -f docker-compose.local-clean.yml up -d --build
    
    # Wait for services to start
    echo "⏳ Waiting for services to start..."
    sleep 15
    
    # Check service health
    check_service_health "traefik-gateway-local"
    check_service_health "backend1-nodejs-local"
    check_service_health "backend2-python-local"
    check_service_health "backend3-java-local"
    check_service_health "health-check-local"
    
    # Test endpoints
    test_endpoints
    
    # Show status
    show_status
    
    echo ""
    echo "🎉 Traefik setup completed!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Open http://localhost to test the gateway"
    echo "2. Open http://localhost:8888 to view Traefik dashboard"
    echo "3. Test API endpoints using the URLs above"
    echo "4. Check logs: docker-compose -f docker-compose.local-clean.yml logs"
    echo ""
    echo "🛑 To stop: docker-compose -f docker-compose.local-clean.yml down"
}

# Run setup
setup_traefik
