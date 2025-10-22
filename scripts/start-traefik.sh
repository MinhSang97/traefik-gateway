#!/bin/bash

echo "🚀 Traefik Gateway"
echo "================================="
echo ""

# Function to show menu
show_menu() {
    echo "📋 Choose deployment option:"
    echo ""
    echo "1. 🏠 Local Development (HTTP + Load Balancer)"
    echo "2. 🌐 Production (HTTPS + Load Balancer + Let's Encrypt)"
    echo "3. ☸️  Kubernetes (Load Balancer + Auto-scaling + Monitoring)"
    echo "4. 🧪 Test Services"
    echo "5. 📊 View Logs"
    echo "6. 🛑 Stop All Services"
    echo "7. ❌ Exit"
    echo ""
    echo "💡 Note: All options include advanced load balancer features by default"
    echo "   - Round-robin load balancing"
    echo "   - Health checks & circuit breaker"
    echo "   - Rate limiting & security headers"
    echo "   - Sticky sessions & compression"
    echo ""
}

# Function to setup local development
setup_local() {
    echo "🏠 Setting up local development with load balancer..."
    echo ""
    echo "🚀 Starting Traefik Gateway with Advanced Load Balancer..."
    docker-compose -f docker-compose.local-clean.yml up -d
    
    echo ""
    echo "⏳ Waiting for services to be ready..."
    sleep 10
    
    echo ""
    echo "✅ Local development with load balancer is ready!"
    echo ""
    echo "🌐 Access URLs:"
    echo "  - Gateway Dashboard: http://localhost:8888"
    echo "  - API Gateway: http://localhost"
    echo "  - Health Check: http://localhost/health"
    echo ""
    echo "🔧 Load Balancer Features:"
    echo "  ✅ Round-robin load balancing"
    echo "  ✅ Health checks (10s interval)"
    echo "  ✅ Circuit breaker (30% error threshold)"
    echo "  ✅ Rate limiting (100 req/min)"
    echo "  ✅ Sticky sessions"
    echo "  ✅ Compression"
    echo "  ✅ Security headers"
    echo ""
    echo "📊 Backend Services:"
    echo "  - Backend1 (Node.js): http://localhost/users/ | http://localhost/auth/"
    echo "  - Backend2 (Python): http://localhost/products/ | http://localhost/docs/"
    echo "  - Backend3 (Java): http://localhost/orders/"
}

# Function to setup production
setup_production() {
    echo "🌐 Setting up production with load balancer..."
    echo ""
    echo "🚀 Starting Traefik Gateway with Advanced Load Balancer (Production)..."
    docker-compose -f docker-compose.prod-clean.yml up -d
    
    echo ""
    echo "⏳ Waiting for services to be ready..."
    sleep 15
    
    echo ""
    echo "✅ Production with load balancer is ready!"
    echo ""
    echo "🌐 Access URLs:"
    echo "  - Gateway Dashboard: https://traefik.apifincheck.husanenglish.online:8888"
    echo "  - API Gateway: https://apifincheck.husanenglish.online"
    echo "  - Health Check: https://apifincheck.husanenglish.online/health"
    echo ""
    echo "🔧 Load Balancer Features:"
    echo "  ✅ Round-robin load balancing"
    echo "  ✅ Health checks (5s interval)"
    echo "  ✅ Circuit breaker (20% error threshold)"
    echo "  ✅ Rate limiting (200 req/min)"
    echo "  ✅ SSL/TLS with Let's Encrypt"
    echo "  ✅ Sticky sessions with secure cookies"
    echo "  ✅ Compression"
    echo "  ✅ Security headers"
    echo "  ✅ Auto-scaling ready"
    echo ""
    echo "📊 Backend Services:"
    echo "  - Backend1 (Node.js): https://apifincheck.husanenglish.online/users/ | https://apifincheck.husanenglish.online/auth/"
    echo "  - Backend2 (Python): https://apifincheck.husanenglish.online/products/ | https://apifincheck.husanenglish.online/docs/"
    echo "  - Backend3 (Java): https://apifincheck.husanenglish.online/orders/"
}

# Function to setup Kubernetes
setup_kubernetes() {
    echo "☸️  Setting up Kubernetes with load balancer..."
    echo ""
    echo "🚀 Deploying Traefik Gateway with Advanced Load Balancer on Kubernetes..."
    
    # Check if kubectl is available
    if ! command -v kubectl &> /dev/null; then
        echo "❌ kubectl is not installed or not in PATH"
        echo "Please install kubectl and configure it to connect to your Kubernetes cluster"
        return 1
    fi
    
    # Check if we're connected to a Kubernetes cluster
    if ! kubectl cluster-info &> /dev/null; then
        echo "❌ Not connected to a Kubernetes cluster"
        echo "Please configure kubectl to connect to your Kubernetes cluster"
        return 1
    fi
    
    echo "✅ Connected to Kubernetes cluster: $(kubectl config current-context)"
    echo ""
    
    # Create namespace if it doesn't exist
    echo "📦 Creating namespace traefik-gateway..."
    kubectl create namespace traefik-gateway --dry-run=client -o yaml | kubectl apply -f -
    
    # Deploy Traefik Gateway
    echo "🚀 Deploying Traefik Gateway..."
    kubectl apply -f k8s/traefik-deployment.yaml
    
    # Deploy Advanced Load Balancer configuration
    echo "⚖️  Deploying Advanced Load Balancer configuration..."
    kubectl apply -f k8s/advanced-loadbalancer.yaml
    
    # Deploy Ingress configuration
    echo "🌐 Deploying Ingress configuration..."
    kubectl apply -f k8s/ingress.yaml
    
    # Deploy Monitoring configuration
    echo "📊 Deploying Monitoring configuration..."
    kubectl apply -f k8s/monitoring-config.yaml
    
    # Deploy Backend services
    echo "🔧 Deploying Backend services..."
    kubectl apply -f k8s/backend1-deployment.yaml
    kubectl apply -f k8s/backend2-deployment.yaml
    kubectl apply -f k8s/backend3-deployment.yaml
    
    # Deploy HPA for auto-scaling
    echo "📈 Deploying HPA for auto-scaling..."
    kubectl apply -f k8s/hpa.yaml
    
    # Wait for deployments to be ready
    echo "⏳ Waiting for deployments to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/traefik-gateway -n traefik-gateway
    kubectl wait --for=condition=available --timeout=300s deployment/backend1 -n traefik-gateway
    kubectl wait --for=condition=available --timeout=300s deployment/backend2 -n traefik-gateway
    kubectl wait --for=condition=available --timeout=300s deployment/backend3 -n traefik-gateway
    
    # Get LoadBalancer external IP
    echo "🌐 Getting LoadBalancer external IP..."
    EXTERNAL_IP=""
    while [ -z $EXTERNAL_IP ]; do
        echo "⏳ Waiting for LoadBalancer external IP..."
        EXTERNAL_IP=$(kubectl get svc traefik-gateway -n traefik-gateway --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
        [ -z "$EXTERNAL_IP" ] && sleep 10
    done
    
    echo "✅ LoadBalancer external IP: $EXTERNAL_IP"
    
    echo ""
    echo "✅ Kubernetes deployment with load balancer completed!"
    echo ""
    echo "🌐 Access Information:"
    echo "  - Gateway Dashboard: https://$EXTERNAL_IP:8888"
    echo "  - API Endpoint: https://$EXTERNAL_IP"
    echo "  - Health Check: https://$EXTERNAL_IP/health"
    echo "  - Metrics: https://$EXTERNAL_IP/metrics"
    echo ""
    echo "🔧 Load Balancer Features:"
    echo "  ✅ Round-robin load balancing"
    echo "  ✅ Health checks (10s interval)"
    echo "  ✅ Circuit breaker (30% error threshold)"
    echo "  ✅ Rate limiting (200 req/min)"
    echo "  ✅ SSL/TLS with Let's Encrypt"
    echo "  ✅ Sticky sessions"
    echo "  ✅ Compression"
    echo "  ✅ Security headers"
    echo "  ✅ Auto-scaling (HPA)"
    echo "  ✅ Monitoring and metrics"
    echo "  ✅ Persistent storage"
    echo ""
    echo "📊 Backend Services:"
    echo "  - Backend1 (Node.js): https://$EXTERNAL_IP/users/ | https://$EXTERNAL_IP/auth/"
    echo "  - Backend2 (Python): https://$EXTERNAL_IP/products/ | https://$EXTERNAL_IP/docs/"
    echo "  - Backend3 (Java): https://$EXTERNAL_IP/orders/"
}


# Function to test services
test_services() {
    echo "🧪 Testing services..."
    echo ""
    echo "Choose testing environment:"
    echo "1. Local Development"
    echo "2. Production"
    echo "3. Kubernetes"
    echo ""
    read -p "Enter choice (1-3): " test_choice
    
    case $test_choice in
        1)
            echo "🔍 Testing local endpoints..."
            test_local_services
            ;;
        2)
            echo "🔍 Testing production endpoints..."
            test_production_services
            ;;
        3)
            echo "🔍 Testing Kubernetes endpoints..."
            test_kubernetes_services
            ;;
        *)
            echo "Invalid choice"
            return 1
            ;;
    esac
}

# Function to test local services
test_local_services() {
    echo ""
    echo "🔍 Testing local endpoints..."
    
    # Test health
    echo "Health check:"
    curl -s http://localhost/health | jq . 2>/dev/null || curl -s http://localhost/health
    echo ""
    
    # Test Traefik dashboard
    echo "Traefik dashboard:"
    curl -s http://localhost:8888/api/overview | jq . 2>/dev/null || echo "Dashboard accessible at http://localhost:8888"
    echo ""
    
    # Test load balancer features
    echo "🔧 Testing load balancer features..."
    echo "Rate limiting test (sending 10 requests quickly):"
    for i in {1..10}; do
        curl -s -w "%{http_code} " http://localhost/health >/dev/null
    done
    echo ""
    
    # Test backend services
    echo "🔍 Testing backend services..."
    for service in users products orders docs auth; do
        if curl -s "http://localhost/$service/" >/dev/null 2>&1; then
            echo "✅ $service endpoint accessible"
        else
            echo "⚠️  $service endpoint not accessible"
        fi
    done
    
    # Test sticky sessions
    echo "🍪 Testing sticky sessions..."
    curl -s -c cookies.txt http://localhost/users/ >/dev/null
    if [ -f cookies.txt ]; then
        echo "✅ Sticky session cookies set"
        rm -f cookies.txt
    else
        echo "⚠️  No sticky session cookies found"
    fi
    
    echo ""
    echo "✅ Local service testing completed"
}

# Function to test production services
test_production_services() {
    echo ""
    echo "🔍 Testing production endpoints..."
    
    # Test health
    echo "Health check:"
    curl -s -k https://apifincheck.husanenglish.online/health | jq . 2>/dev/null || curl -s -k https://apifincheck.husanenglish.online/health
    echo ""
    
    # Test SSL
    echo "🔒 Testing SSL certificate..."
    echo | openssl s_client -connect apifincheck.husanenglish.online:443 -servername apifincheck.husanenglish.online 2>/dev/null | openssl x509 -noout -dates
    echo ""
    
    # Test Traefik dashboard
    echo "Traefik dashboard:"
    curl -s -k https://traefik.apifincheck.husanenglish.online:8888/api/overview | jq . 2>/dev/null || echo "Dashboard accessible at https://traefik.apifincheck.husanenglish.online:8888"
    echo ""
    
    # Test backend services
    echo "🔍 Testing backend services..."
    for service in users products orders docs auth; do
        if curl -s -k "https://apifincheck.husanenglish.online/$service/" >/dev/null 2>&1; then
            echo "✅ $service endpoint accessible"
        else
            echo "⚠️  $service endpoint not accessible"
        fi
    done
    
    echo ""
    echo "✅ Production service testing completed"
}

# Function to test Kubernetes services
test_kubernetes_services() {
    echo ""
    echo "🔍 Testing Kubernetes endpoints..."
    
    # Get external IP
    EXTERNAL_IP=$(kubectl get svc traefik-gateway -n traefik-gateway --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}" 2>/dev/null)
    
    if [ -z "$EXTERNAL_IP" ]; then
        echo "❌ Could not get external IP for Traefik service"
        echo "Please check if the service is running:"
        kubectl get svc -n traefik-gateway
        return 1
    fi
    
    echo "External IP: $EXTERNAL_IP"
    echo ""
    
    # Test health
    echo "Health check:"
    curl -s -k https://$EXTERNAL_IP/health | jq . 2>/dev/null || curl -s -k https://$EXTERNAL_IP/health
    echo ""
    
    # Test metrics
    echo "Metrics endpoint:"
    curl -s -k https://$EXTERNAL_IP/metrics | head -10
    echo ""
    
    # Test backend services
    echo "🔍 Testing backend services..."
    for service in users products orders docs auth; do
        if curl -s -k "https://$EXTERNAL_IP/$service/" >/dev/null 2>&1; then
            echo "✅ $service endpoint accessible"
        else
            echo "⚠️  $service endpoint not accessible"
        fi
    done
    
    # Test HPA
    echo "📊 Checking HPA status..."
    kubectl get hpa -n traefik-gateway
    
    echo ""
    echo "✅ Kubernetes service testing completed"
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
