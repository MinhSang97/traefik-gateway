#!/bin/bash

echo "🧪 Testing Traefik Kubernetes Deployment"
echo "======================================="
echo ""

# Function to test services
test_services() {
    echo "🔍 Testing services..."
    
    # Get LoadBalancer IP
    LB_IP=$(kubectl get service traefik-gateway -n traefik-gateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    
    if [ -z "$LB_IP" ]; then
        echo "❌ LoadBalancer IP not found. Service may not be ready yet."
        return 1
    fi
    
    echo "✅ LoadBalancer IP: $LB_IP"
    
    # Test health endpoint
    echo "🔍 Testing health endpoint..."
    if curl -s -k "https://$LB_IP/health" >/dev/null; then
        echo "✅ Health endpoint working"
    else
        echo "❌ Health endpoint failed"
    fi
    
    # Test backend services
    echo "🔍 Testing backend services..."
    for service in auth users products orders docs; do
        if curl -s -k "https://$LB_IP/$service/" >/dev/null 2>&1; then
            echo "✅ $service endpoint accessible"
        else
            echo "⚠️  $service endpoint not accessible (may be normal for some services)"
        fi
    done
}

# Function to show pod logs
show_logs() {
    echo ""
    echo "📊 Pod Logs"
    echo "==========="
    
    echo "🔍 Traefik logs:"
    kubectl logs -l app=traefik-gateway -n traefik-gateway --tail=10
    
    echo ""
    echo "🔍 Backend1 logs:"
    kubectl logs -l app=backend1-nodejs -n traefik-gateway --tail=5
    
    echo ""
    echo "🔍 Backend2 logs:"
    kubectl logs -l app=backend2-python -n traefik-gateway --tail=5
    
    echo ""
    echo "🔍 Backend3 logs:"
    kubectl logs -l app=backend3-java -n traefik-gateway --tail=5
}

# Function to show detailed status
show_detailed_status() {
    echo ""
    echo "📊 Detailed Status"
    echo "=================="
    
    echo "🔍 Pods:"
    kubectl get pods -n traefik-gateway -o wide
    
    echo ""
    echo "🔍 Services:"
    kubectl get services -n traefik-gateway -o wide
    
    echo ""
    echo "🔍 Ingress:"
    kubectl get ingress -n traefik-gateway -o wide
    
    echo ""
    echo "🔍 HPA:"
    kubectl get hpa -n traefik-gateway -o wide
    
    echo ""
    echo "🔍 Events:"
    kubectl get events -n traefik-gateway --sort-by='.lastTimestamp'
}

# Function to test SSL certificates
test_ssl() {
    echo ""
    echo "🔒 Testing SSL Certificates"
    echo "==========================="
    
    # Check certificate status
    echo "🔍 Certificate status:"
    kubectl get certificates -n traefik-gateway
    
    echo ""
    echo "🔍 Certificate details:"
    kubectl describe certificate traefik-tls -n traefik-gateway
}

# Main test function
test_k8s() {
    echo "🧪 Testing Traefik Kubernetes deployment..."
    
    # Test services
    test_services
    
    # Show logs
    show_logs
    
    # Show detailed status
    show_detailed_status
    
    # Test SSL
    test_ssl
    
    echo ""
    echo "✅ Testing completed!"
    echo ""
    echo "📋 Troubleshooting:"
    echo "1. Check pod logs: kubectl logs -f deployment/traefik-gateway -n traefik-gateway"
    echo "2. Check service status: kubectl get services -n traefik-gateway"
    echo "3. Check ingress status: kubectl get ingress -n traefik-gateway"
    echo "4. Check certificate status: kubectl get certificates -n traefik-gateway"
}

# Run tests
test_k8s
