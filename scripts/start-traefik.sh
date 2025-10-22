#!/bin/bash

echo "🚀 Traefik Gateway"
echo "================================="
echo ""

# Function to show menu
show_menu() {
    echo "📋 Choose deployment option:"
    echo ""
    echo "1. 🏠 Local Development (HTTP only)"
    echo "2. 🌐 Production (HTTPS with Let's Encrypt)"
    echo "3. ☸️  Kubernetes Deployment"
    echo "4. 🧪 Test Services"
    echo "5. 📊 View Logs"
    echo "6. 🛑 Stop All Services"
    echo "7. ❌ Exit"
    echo ""
}

# Function to setup local development
setup_local() {
    echo "🏠 Setting up local development..."
    ./scripts/setup-traefik.sh
}

# Function to setup production
setup_production() {
    echo "🌐 Setting up production..."
    ./scripts/setup-traefik-prod.sh
}

# Function to setup Kubernetes
setup_kubernetes() {
    echo "☸️  Setting up Kubernetes deployment..."
    ./scripts/setup-k8s.sh
}

# Function to test services
test_services() {
    echo "🧪 Testing services..."
    echo ""
    echo "🔍 Testing local endpoints..."
    
    # Test health
    echo "Health check:"
    curl -s http://localhost/health | jq . 2>/dev/null || curl -s http://localhost/health
    echo ""
    
    # Test server info
    echo "Server info:"
    curl -s http://localhost/server-info | jq . 2>/dev/null || curl -s http://localhost/server-info
    echo ""
    
    # Test Traefik dashboard
    echo "Traefik dashboard:"
    curl -s http://localhost:8888/api/overview | jq . 2>/dev/null || echo "Dashboard accessible at http://localhost:8888"
    echo ""
    
    # Test backend services
    echo "🔍 Testing backend services..."
    for service in users products orders docs; do
        if curl -s "http://localhost/$service/" >/dev/null 2>&1; then
            echo "✅ $service endpoint accessible"
        else
            echo "⚠️  $service endpoint not accessible"
        fi
    done
    
    echo ""
    echo "✅ Service testing completed"
}

# Function to view logs
view_logs() {
    echo "📊 Viewing logs..."
    echo ""
    echo "Choose log source:"
    echo "1. All services (Docker)"
    echo "2. Traefik only (Docker)"
    echo "3. Backend services only (Docker)"
    echo "4. Kubernetes pods"
    echo "5. Kubernetes services"
    echo ""
    read -p "Enter choice (1-5): " log_choice
    
    case $log_choice in
        1)
            docker-compose -f docker-compose.local-clean.yml logs -f
            ;;
        2)
            docker-compose -f docker-compose.local-clean.yml logs -f traefik-gateway-local
            ;;
        3)
            docker-compose -f docker-compose.local-clean.yml logs -f backend1-nodejs-local backend2-python-local backend3-java-local
            ;;
        4)
            kubectl logs -f deployment/traefik-gateway -n traefik-gateway
            ;;
        5)
            kubectl logs -f deployment/backend1-nodejs -n traefik-gateway
            kubectl logs -f deployment/backend2-python -n traefik-gateway
            kubectl logs -f deployment/backend3-java -n traefik-gateway
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
}

# Function to stop services
stop_services() {
    echo "🛑 Stopping all services..."
    echo ""
    echo "Choose what to stop:"
    echo "1. Docker services only"
    echo "2. Kubernetes services only"
    echo "3. All services (Docker + Kubernetes)"
    echo ""
    read -p "Enter choice (1-3): " stop_choice
    
    case $stop_choice in
        1)
            docker-compose -f docker-compose.local-clean.yml down
            docker-compose -f docker-compose.prod-clean.yml down
            echo "✅ Docker services stopped"
            ;;
        2)
            kubectl delete namespace traefik-gateway
            echo "✅ Kubernetes services stopped"
            ;;
        3)
            docker-compose -f docker-compose.local-clean.yml down
            docker-compose -f docker-compose.prod-clean.yml down
            kubectl delete namespace traefik-gateway
            echo "✅ All services stopped"
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
}

# Main menu loop
while true; do
    show_menu
    read -p "Enter your choice (1-7): " choice
    
    case $choice in
        1)
            setup_local
            ;;
        2)
            setup_production
            ;;
        3)
            setup_kubernetes
            ;;
        4)
            test_services
            ;;
        5)
            view_logs
            ;;
        6)
            stop_services
            ;;
        7)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice. Please enter 1-7."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    clear
done
