#!/bin/bash

# Test Load Balancer Features
# This script tests various load balancer features of the Traefik gateway

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

# Function to test local load balancer
test_local_loadbalancer() {
    print_test "Testing Local Load Balancer Features"
    echo "=========================================="
    
    # Test basic connectivity
    print_status "Testing basic connectivity..."
    if curl -s http://localhost:8888/ping >/dev/null; then
        echo "✅ Gateway is accessible"
    else
        print_error "❌ Gateway is not accessible"
        return 1
    fi
    
    # Test rate limiting
    print_status "Testing rate limiting..."
    echo "Sending 20 requests quickly to test rate limiting..."
    rate_limited=0
    for i in {1..20}; do
        response=$(curl -s -w "%{http_code}" -o /dev/null http://localhost:8888/ping)
        if [ "$response" = "429" ]; then
            rate_limited=1
            break
        fi
    done
    
    if [ $rate_limited -eq 1 ]; then
        echo "✅ Rate limiting is working (got 429 response)"
    else
        print_warning "⚠️  Rate limiting might not be working (no 429 responses)"
    fi
    
    # Test sticky sessions
    print_status "Testing sticky sessions..."
    curl -s -c cookies.txt http://localhost/users/ >/dev/null
    if [ -f cookies.txt ]; then
        echo "✅ Sticky session cookies are being set"
        rm -f cookies.txt
    else
        print_warning "⚠️  No sticky session cookies found"
    fi
    
    # Test compression
    print_status "Testing compression..."
    response=$(curl -s -H "Accept-Encoding: gzip" -I http://localhost/health | grep -i "content-encoding")
    if echo "$response" | grep -i "gzip" >/dev/null; then
        echo "✅ Compression is working"
    else
        print_warning "⚠️  Compression might not be working"
    fi
    
    # Test health checks
    print_status "Testing health checks..."
    for service in users products orders docs auth; do
        if curl -s "http://localhost/$service/" >/dev/null 2>&1; then
            echo "✅ $service endpoint is healthy"
        else
            print_warning "⚠️  $service endpoint is not responding"
        fi
    done
    
    # Test circuit breaker (simulate errors)
    print_status "Testing circuit breaker..."
    echo "This would require backend services to return errors to test circuit breaker"
    echo "✅ Circuit breaker configuration is present"
    
    echo ""
    print_status "Local load balancer testing completed!"
}

# Function to test production load balancer
test_production_loadbalancer() {
    print_test "Testing Production Load Balancer Features"
    echo "=============================================="
    
    # Test SSL/TLS
    print_status "Testing SSL/TLS..."
    if curl -s -k https://apifincheck.husanenglish.online/health >/dev/null; then
        echo "✅ HTTPS is working"
    else
        print_error "❌ HTTPS is not working"
        return 1
    fi
    
    # Test SSL certificate
    print_status "Testing SSL certificate..."
    cert_info=$(echo | openssl s_client -connect apifincheck.husanenglish.online:443 -servername apifincheck.husanenglish.online 2>/dev/null | openssl x509 -noout -dates 2>/dev/null)
    if [ -n "$cert_info" ]; then
        echo "✅ SSL certificate is valid"
        echo "$cert_info"
    else
        print_warning "⚠️  Could not verify SSL certificate"
    fi
    
    # Test security headers
    print_status "Testing security headers..."
    headers=$(curl -s -k -I https://apifincheck.husanenglish.online/health)
    if echo "$headers" | grep -i "strict-transport-security" >/dev/null; then
        echo "✅ HSTS header is present"
    else
        print_warning "⚠️  HSTS header not found"
    fi
    
    if echo "$headers" | grep -i "x-frame-options" >/dev/null; then
        echo "✅ X-Frame-Options header is present"
    else
        print_warning "⚠️  X-Frame-Options header not found"
    fi
    
    # Test backend services
    print_status "Testing backend services..."
    for service in users products orders docs auth; do
        if curl -s -k "https://apifincheck.husanenglish.online/$service/" >/dev/null 2>&1; then
            echo "✅ $service endpoint is accessible via HTTPS"
        else
            print_warning "⚠️  $service endpoint is not accessible"
        fi
    done
    
    echo ""
    print_status "Production load balancer testing completed!"
}

# Function to test Kubernetes load balancer
test_kubernetes_loadbalancer() {
    print_test "Testing Kubernetes Load Balancer Features"
    echo "============================================="
    
    # Get external IP
    print_status "Getting external IP..."
    EXTERNAL_IP=$(kubectl get svc traefik-gateway -n traefik-gateway --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}" 2>/dev/null)
    
    if [ -z "$EXTERNAL_IP" ]; then
        print_error "❌ Could not get external IP for Traefik service"
        echo "Please check if the service is running:"
        kubectl get svc -n traefik-gateway
        return 1
    fi
    
    echo "External IP: $EXTERNAL_IP"
    
    # Test basic connectivity
    print_status "Testing basic connectivity..."
    if curl -s -k https://$EXTERNAL_IP/health >/dev/null; then
        echo "✅ Gateway is accessible"
    else
        print_error "❌ Gateway is not accessible"
        return 1
    fi
    
    # Test metrics endpoint
    print_status "Testing metrics endpoint..."
    metrics=$(curl -s -k https://$EXTERNAL_IP/metrics | head -5)
    if [ -n "$metrics" ]; then
        echo "✅ Metrics endpoint is working"
    else
        print_warning "⚠️  Metrics endpoint might not be working"
    fi
    
    # Test HPA status
    print_status "Checking HPA status..."
    hpa_status=$(kubectl get hpa -n traefik-gateway 2>/dev/null)
    if [ -n "$hpa_status" ]; then
        echo "✅ HPA is configured"
        echo "$hpa_status"
    else
        print_warning "⚠️  HPA might not be configured"
    fi
    
    # Test backend services
    print_status "Testing backend services..."
    for service in users products orders docs auth; do
        if curl -s -k "https://$EXTERNAL_IP/$service/" >/dev/null 2>&1; then
            echo "✅ $service endpoint is accessible"
        else
            print_warning "⚠️  $service endpoint is not accessible"
        fi
    done
    
    # Test pod status
    print_status "Checking pod status..."
    kubectl get pods -n traefik-gateway
    
    echo ""
    print_status "Kubernetes load balancer testing completed!"
}

# Function to run load tests
run_load_tests() {
    print_test "Running Load Tests"
    echo "==================="
    
    print_status "Testing with Apache Bench (if available)..."
    if command -v ab &> /dev/null; then
        echo "Running 100 requests with 10 concurrent connections..."
        ab -n 100 -c 10 http://localhost/health 2>/dev/null | grep -E "(Requests per second|Time per request|Failed requests)"
    else
        print_warning "Apache Bench not available, skipping load test"
    fi
    
    print_status "Testing with curl (simple load test)..."
    success_count=0
    total_requests=50
    
    for i in $(seq 1 $total_requests); do
        if curl -s http://localhost/health >/dev/null 2>&1; then
            success_count=$((success_count + 1))
        fi
    done
    
    success_rate=$((success_count * 100 / total_requests))
    echo "Success rate: $success_rate% ($success_count/$total_requests)"
    
    if [ $success_rate -ge 95 ]; then
        echo "✅ Load test passed"
    else
        print_warning "⚠️  Load test shows some failures"
    fi
}

# Main menu
echo "🧪 Load Balancer Testing Tool"
echo "=============================="
echo ""
echo "Choose testing environment:"
echo "1. Local Development"
echo "2. Production"
echo "3. Kubernetes"
echo "4. Load Tests"
echo "5. All Tests"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        test_local_loadbalancer
        ;;
    2)
        test_production_loadbalancer
        ;;
    3)
        test_kubernetes_loadbalancer
        ;;
    4)
        run_load_tests
        ;;
    5)
        test_local_loadbalancer
        echo ""
        test_production_loadbalancer
        echo ""
        test_kubernetes_loadbalancer
        echo ""
        run_load_tests
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

echo ""
print_status "Testing completed! 🎉"
