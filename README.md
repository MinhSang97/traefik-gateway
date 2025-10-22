# 🚀 Traefik + Nginx Hybrid Gateway

Advanced hybrid gateway solution combining Traefik's auto-discovery with Nginx's powerful load balancing capabilities. Supports local development, production deployment, and Kubernetes orchestration.

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

### **🔧 Traefik Features**
- ✅ **Auto-discovery**: Automatic service detection
- ✅ **Dynamic configuration**: No restarts needed
- ✅ **Built-in Let's Encrypt**: Automatic SSL certificates
- ✅ **Dashboard UI**: Real-time monitoring
- ✅ **Kubernetes native**: Perfect for K8s deployments

### **⚡ Nginx Features**
- ✅ **Advanced load balancing**: Least connections, health checks
- ✅ **Security features**: Rate limiting, DDoS protection
- ✅ **Performance optimization**: Gzip, keepalive, caching
- ✅ **Flexible routing**: Complex routing rules
- ✅ **Monitoring**: Detailed access logs

### **🛡️ Security Features**
- ✅ **SSL/TLS termination**: Automatic HTTPS
- ✅ **Rate limiting**: API protection
- ✅ **DDoS protection**: Connection limiting
- ✅ **Security headers**: HSTS, XSS protection
- ✅ **IP blocking**: Direct IP access blocked

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

### **Traefik Configuration**
- **Auto-discovery**: Docker labels
- **SSL**: Let's Encrypt integration
- **Dashboard**: Real-time monitoring
- **Routing**: Host-based routing

### **Nginx Configuration**
- **Load balancing**: Least connections algorithm
- **Health checks**: Automatic failover
- **Rate limiting**: Per-IP and per-endpoint
- **Security**: Comprehensive security headers

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
./scripts/setup-k8s.sh

# Test deployment
./scripts/test-k8s.sh
```

## 📈 Monitoring & Logs

### **Traefik Dashboard**
- **URL**: http://localhost:8888 (local) / https://traefik.apifincheck.husanenglish.online:8888 (prod)
- **Features**: Real-time metrics, service discovery, routing rules

### **Nginx Logs**
```bash
# View all logs
docker-compose -f docker-compose.traefik-local.yml logs -f

# View specific service
docker-compose -f docker-compose.traefik-local.yml logs -f nginx-lb
```

### **Health Monitoring**
```bash
# Health check
curl http://localhost/health

# Server info
curl http://localhost/server-info
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

### **Test Individual Services**
```bash
# Test all services
./scripts/test-services.sh

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
```

## 🛠️ Troubleshooting

### **Common Issues**

#### **Services not starting**
```bash
# Check Docker status
docker info

# Check service logs
docker-compose -f docker-compose.traefik-local.yml logs

# Restart services
docker-compose -f docker-compose.traefik-local.yml restart
```

#### **SSL certificate issues**
```bash
# Check certificate status
docker-compose -f docker-compose.traefik.yml logs traefik

# Renew certificates
./scripts/renew-ssl.sh
```

#### **Traefik dashboard not accessible**
```bash
# Check Traefik logs
docker-compose -f docker-compose.traefik-local.yml logs traefik

# Verify port 8080 is open
netstat -tlnp | grep 8080
```

## 📚 Documentation

- **Local Development**: [Local Setup Guide](docs/local-setup.md)
- **Production Deployment**: [Production Guide](docs/production.md)
- **Kubernetes**: [K8s Deployment Guide](k8s/README-k8s.md)
- **API Documentation**: [API Reference](docs/api-reference.md)

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
