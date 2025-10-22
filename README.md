# 🚀 Traefik Gateway với Load Balancer Nâng Cao

Advanced Traefik Gateway solution with built-in load balancing, health checks, circuit breaker, rate limiting, and auto-scaling. Supports local development, production deployment, and Kubernetes orchestration.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────┐
│        Traefik Gateway           │ ← SSL Termination, Auto-discovery
│        (Port 80/443)             │
└─────────────────┬───────────────┘
                  │
┌─────────────────▼───────────────┐
│        Nginx Load Balancer      │ ← Advanced Load Balancing, Security
│        (Port 80)                │
└─────────────────┬───────────────┘
                  │
        ┌─────────┼─────────┐
        │         │         │
┌───────▼───┐ ┌───▼───┐ ┌───▼───┐
│  Node.js  │ │Python │ │ Java  │
│  :3000    │ │:8000  │ │:8080  │
└───────────┘ └───────┘ └───────┘
```

## 🚀 Quick Start

### **Cách nhanh nhất - Chạy script tự động**
```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/traefik-nginx-gateway.git
cd traefik-nginx-gateway

# Chạy script chính (menu lựa chọn)
./scripts/start-traefik.sh
```

### **🌿 GitHub Workflow**
```bash
# Setup GitHub repository
./scripts/setup-github-repo.sh

# Create K8s feature branch
./scripts/create-k8s-branch.sh

# Create Pull Request
./scripts/create-pr.sh
```

### **Hoặc chạy trực tiếp cho từng môi trường**

#### 🏠 **Local Development**
```bash
# Setup local development
./scripts/setup-traefik.sh

# Access points:
# - Gateway: http://localhost
# - Traefik Dashboard: http://localhost:8080
# - Health Check: http://localhost/health
```

#### 🌐 **Production Deployment**
```bash
# Setup production with SSL
./scripts/setup-traefik-prod.sh

# Access points:
# - Gateway: https://apifincheck.husanenglish.online
# - Traefik Dashboard: https://traefik.apifincheck.husanenglish.online
# - Health Check: https://apifincheck.husanenglish.online/health
```

## 🎯 Key Features

### **🚀 Load Balancer Features**
- ✅ **Round-robin load balancing**: Even distribution across backends
- ✅ **Health checks**: Automatic failover with retry logic
- ✅ **Circuit breaker**: Protection against cascade failures
- ✅ **Rate limiting**: DDoS protection and API throttling
- ✅ **Sticky sessions**: Session affinity with secure cookies
- ✅ **Compression**: Gzip compression for better performance

### **🔧 Traefik Features**
- ✅ **Auto-discovery**: Automatic service detection
- ✅ **Dynamic configuration**: No restarts needed
- ✅ **Built-in Let's Encrypt**: Automatic SSL certificates
- ✅ **Dashboard UI**: Real-time monitoring
- ✅ **Kubernetes native**: Perfect for K8s deployments

### **🛡️ Security Features**
- ✅ **SSL/TLS termination**: Automatic HTTPS
- ✅ **Security headers**: HSTS, XSS protection, frame denial
- ✅ **Rate limiting**: API protection with burst handling
- ✅ **Circuit breaker**: Error threshold protection
- ✅ **Health monitoring**: Comprehensive health checks

## 📊 API Endpoints

| Endpoint | Service | Description |
|----------|---------|-------------|
| `/auth/` | User Service | Authentication endpoints |
| `/users/` | User Service | User management |
| `/products/` | Product Service | Product catalog |
| `/orders/` | Order Service | Order management |
| `/docs/` | Product Service | API documentation |
| `/health` | All Services | Health check |
| `/server-info` | Gateway | Server information |

## 🔧 Configuration

### **Load Balancer Configuration**
- **Health Check Interval**: 10s (local), 5s (production)
- **Circuit Breaker Threshold**: 30% (local), 20% (production)
- **Rate Limiting**: 100 req/min (local), 200 req/min (production)
- **Sticky Sessions**: Enabled with secure cookies
- **Compression**: Gzip compression enabled

### **Traefik Configuration**
- **Auto-discovery**: Docker labels and Kubernetes ingress
- **SSL**: Let's Encrypt integration
- **Dashboard**: Real-time monitoring
- **Routing**: Host-based routing with middleware

### **Kubernetes Configuration**
- **Replicas**: 3 (High Availability)
- **Auto-scaling**: HPA enabled (2-10 replicas)
- **Resource Limits**: CPU and memory constraints
- **Monitoring**: Prometheus metrics integration

## 🚀 Deployment Options

### **1. Local Development**
```bash
# Quick start
./scripts/start-traefik.sh

# Manual setup
docker-compose -f docker-compose.traefik-local.yml up -d
```

### **2. Production**
```bash
# Production setup
./scripts/setup-traefik-prod.sh

# Manual setup
docker-compose -f docker-compose.traefik.yml up -d
```

### **3. Kubernetes**
```bash
# Deploy to K8s
./scripts/start-traefik.sh
# Choose option 3: Kubernetes

# Test deployment
./scripts/start-traefik.sh
# Choose option 4: Test Services
```

## 📈 Monitoring & Logs

### **Traefik Dashboard**
- **URL**: http://localhost:8888 (local) / https://traefik.apifincheck.husanenglish.online:8888 (prod)
- **Features**: Real-time metrics, service discovery, routing rules, load balancer status

### **Load Balancer Monitoring**
- **Metrics Endpoint**: `/metrics` - Prometheus metrics
- **Health Check**: `/health` - Service health status
- **Circuit Breaker**: Real-time error rate monitoring
- **Rate Limiting**: Request rate statistics

### **Logs**
```bash
# View all logs
docker-compose -f docker-compose.local-clean.yml logs -f

# View specific service
docker-compose -f docker-compose.local-clean.yml logs -f traefik-gateway-local

# Kubernetes logs
kubectl logs -f deployment/traefik-gateway -n traefik-gateway
```

### **Health Monitoring**
```bash
# Health check
curl http://localhost/health

# Load balancer metrics
curl http://localhost:8888/metrics

# Test rate limiting
for i in {1..20}; do curl http://localhost/health; done
```

## 🔒 SSL Configuration

### **Automatic SSL (Production)**
- **Provider**: Let's Encrypt
- **Auto-renewal**: Every 60 days
- **Domains**: apifincheck.husanenglish.online
- **Dashboard**: traefik.apifincheck.husanenglish.online

### **Manual SSL (Development)**
```bash
# Generate dummy certificates
./scripts/generate-dummy-cert.sh

# Setup SSL
./scripts/init-ssl.sh
```

## 🧪 Testing

### **Test Load Balancer Features**
```bash
# Test load balancer features
./scripts/test-loadbalancer.sh

# Test health checks
curl http://localhost/health

# Test rate limiting
for i in {1..20}; do curl http://localhost/health; done

# Test sticky sessions
curl -c cookies.txt http://localhost/users/
curl -b cookies.txt http://localhost/users/

# Test compression
curl -H "Accept-Encoding: gzip" -I http://localhost/health
```

### **Test Individual Services**
```bash
# Test all services
./scripts/start-traefik.sh
# Choose option 4: Test Services

# Test specific service
curl http://localhost/users/
curl http://localhost/products/
curl http://localhost/orders/
```

### **Load Testing**
```bash
# Install Apache Bench
# Ubuntu/Debian: sudo apt-get install apache2-utils
# macOS: brew install httpd

# Run load test
ab -n 1000 -c 10 http://localhost/health

# Advanced load testing
wrk -t12 -c400 -d30s http://localhost/
```

## 🛠️ Troubleshooting

### **Common Issues**

#### **Load Balancer Issues**
```bash
# Check load balancer status
curl -v http://localhost/health

# Check circuit breaker status
curl http://localhost:8888/api/http/middlewares

# Check rate limiting
curl -v http://localhost/health | grep -i "429"

# Test sticky sessions
curl -c cookies.txt -v http://localhost/users/
```

#### **Services not starting**
```bash
# Check Docker status
docker info

# Check service logs
docker-compose -f docker-compose.local-clean.yml logs

# Restart services
docker-compose -f docker-compose.local-clean.yml restart
```

#### **SSL certificate issues**
```bash
# Check certificate status
docker-compose -f docker-compose.prod-clean.yml logs traefik

# Test SSL connection
openssl s_client -connect apifincheck.husanenglish.online:443
```

#### **Kubernetes issues**
```bash
# Check pod status
kubectl get pods -n traefik-gateway

# Check service status
kubectl get svc -n traefik-gateway

# Check HPA status
kubectl get hpa -n traefik-gateway

# View logs
kubectl logs -f deployment/traefik-gateway -n traefik-gateway
```

## 📚 Documentation

- **Quick Start**: Run `./scripts/start-traefik.sh` for interactive menu
- **Load Balancer Features**: Built-in health checks, circuit breaker, rate limiting
- **Kubernetes**: [K8s Deployment Guide](k8s/README-k8s.md)
- **Testing**: Use `./scripts/test-loadbalancer.sh` for comprehensive testing

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Traefik**: Modern reverse proxy and load balancer
- **Nginx**: High-performance web server
- **Docker**: Containerization platform
- **Let's Encrypt**: Free SSL certificates
