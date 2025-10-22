#!/bin/bash

echo "🚀 Traefik Kubernetes Setup"
echo "==========================="
echo ""

# Function to check if kubectl is available
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        echo "❌ kubectl is not installed. Please install kubectl first."
        exit 1
    fi
    echo "✅ kubectl is available"
}

# Function to check if cluster is accessible
check_cluster() {
    if ! kubectl cluster-info &> /dev/null; then
        echo "❌ Kubernetes cluster is not accessible. Please check your kubeconfig."
        exit 1
    fi
    echo "✅ Kubernetes cluster is accessible"
}

# Function to install cert-manager
install_cert_manager() {
    echo "🔒 Installing cert-manager..."
    
    # Install cert-manager
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
    
    # Wait for cert-manager to be ready
    echo "⏳ Waiting for cert-manager to be ready..."
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=cert-manager -n cert-manager --timeout=300s
    
    echo "✅ cert-manager installed successfully"
}

# Function to deploy Traefik
deploy_traefik() {
    echo "🚀 Deploying Traefik to Kubernetes..."
    
    # Create namespace
    kubectl apply -f k8s/namespace.yaml
    
    # Deploy Traefik
    kubectl apply -f k8s/traefik-deployment.yaml
    
    # Wait for Traefik to be ready
    echo "⏳ Waiting for Traefik to be ready..."
    kubectl wait --for=condition=ready pod -l app=traefik-gateway -n traefik-gateway --timeout=300s
    
    echo "✅ Traefik deployed successfully"
}

# Function to deploy backend services
deploy_backends() {
    echo "🔧 Deploying backend services..."
    
    # Deploy backend services
    kubectl apply -f k8s/backend1-deployment.yaml
    kubectl apply -f k8s/backend2-deployment.yaml
    kubectl apply -f k8s/backend3-deployment.yaml
    
    # Wait for backend services to be ready
    echo "⏳ Waiting for backend services to be ready..."
    kubectl wait --for=condition=ready pod -l app=backend1-nodejs -n traefik-gateway --timeout=300s
    kubectl wait --for=condition=ready pod -l app=backend2-python -n traefik-gateway --timeout=300s
    kubectl wait --for=condition=ready pod -l app=backend3-java -n traefik-gateway --timeout=300s
    
    echo "✅ Backend services deployed successfully"
}

# Function to setup SSL and ingress
setup_ssl_ingress() {
    echo "🔒 Setting up SSL and ingress..."
    
    # Apply cert-manager setup
    kubectl apply -f k8s/cert-manager-setup.yaml
    
    # Apply ingress
    kubectl apply -f k8s/ingress.yaml
    
    # Apply HPA
    kubectl apply -f k8s/hpa.yaml
    
    echo "✅ SSL and ingress setup completed"
}

# Function to show status
show_status() {
    echo ""
    echo "📊 Deployment Status"
    echo "==================="
    
    echo "🔍 Namespaces:"
    kubectl get namespaces | grep traefik
    
    echo ""
    echo "🔍 Pods:"
    kubectl get pods -n traefik-gateway
    
    echo ""
    echo "🔍 Services:"
    kubectl get services -n traefik-gateway
    
    echo ""
    echo "🔍 Ingress:"
    kubectl get ingress -n traefik-gateway
    
    echo ""
    echo "🔍 HPA:"
    kubectl get hpa -n traefik-gateway
    
    echo ""
    echo "🌐 Access Information"
    echo "===================="
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
}

# Main setup function
setup_k8s() {
    echo "🔧 Setting up Traefik on Kubernetes..."
    
    # Check prerequisites
    check_kubectl
    check_cluster
    
    # Install cert-manager
    install_cert_manager
    
    # Deploy Traefik
    deploy_traefik
    
    # Deploy backend services
    deploy_backends
    
    # Setup SSL and ingress
    setup_ssl_ingress
    
    # Show status
    show_status
    
    echo ""
    echo "🎉 Traefik Kubernetes setup completed!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Ensure DNS points to your cluster's LoadBalancer IP"
    echo "2. Wait for Let's Encrypt certificates (may take 1-2 minutes)"
    echo "3. Test HTTPS endpoints using the URLs above"
    echo "4. Monitor logs: kubectl logs -f deployment/traefik-gateway -n traefik-gateway"
    echo ""
    echo "🛑 To delete: kubectl delete namespace traefik-gateway"
}

# Run setup
setup_k8s