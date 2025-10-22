# 🚀 Traefik Kubernetes Deployment

Complete Kubernetes deployment for Traefik gateway with automatic SSL certificates and auto-scaling.

## 🏗️ Architecture

```
┌─────────────────────────────────┐
│        Traefik Gateway           │ ← LoadBalancer Service
│        (Port 80/443)             │
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

### **Deploy to Kubernetes**
```bash
# Deploy Traefik with all services
./scripts/setup-k8s.sh

# Test deployment
./scripts/test-k8s.sh
```

### **Manual Deployment**
```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy Traefik
kubectl apply -f k8s/traefik-deployment.yaml

# Deploy backend services
kubectl apply -f k8s/backend1-deployment.yaml
kubectl apply -f k8s/backend2-deployment.yaml
kubectl apply -f k8s/backend3-deployment.yaml

# Setup SSL and ingress
kubectl apply -f k8s/cert-manager-setup.yaml
kubectl apply -f k8s/ingress.yaml

# Deploy HPA
kubectl apply -f k8s/hpa.yaml
```

## 📊 Components

### **Traefik Gateway**
- **Image**: traefik:v3.0
- **Ports**: 80 (HTTP), 443 (HTTPS), 8080 (Dashboard)
- **Features**: Auto-discovery, SSL termination, load balancing
- **Scaling**: 2-10 replicas based on CPU/memory

### **Backend Services**
- **Backend1**: Node.js (User Service) - Port 3000
- **Backend2**: Python FastAPI (Product Service) - Port 8000
- **Backend3**: Java (Order Service) - Port 8080
- **Scaling**: 2-5 replicas each based on CPU/memory

### **SSL Certificates**
- **Provider**: Let's Encrypt
- **Auto-renewal**: Every 60 days
- **Domain**: apifincheck.husanenglish.online

## 🔧 Configuration

### **Traefik Configuration**
```yaml
# Auto-discovery
- --providers.kubernetesingress=true

# SSL termination
- --certificatesresolvers.letsencrypt.acme.email=admin@apifincheck.husanenglish.online
- --certificatesresolvers.letsencrypt.acme.storage=/data/acme.json

# HTTP to HTTPS redirect
- --entrypoints.web.http.redirections.entrypoint.to=websecure
- --entrypoints.web.http.redirections.entrypoint.scheme=https
```

### **Service Routing**
- **Authentication**: `/auth/` → Backend1 (Node.js)
- **Users**: `/users/` → Backend1 (Node.js)
- **Products**: `/products/` → Backend2 (Python)
- **Orders**: `/orders/` → Backend3 (Java)
- **Documentation**: `/docs/` → Backend2 (Python)

## 📈 Monitoring & Scaling

### **Health Checks**
- **Liveness**: `/ping` endpoint
- **Readiness**: `/ping` endpoint
- **Backend Health**: `/health` endpoint

### **Auto-scaling (HPA)**
- **Traefik**: 2-10 replicas (CPU: 70%, Memory: 80%)
- **Backend Services**: 2-5 replicas each (CPU: 70%, Memory: 80%)

### **Resource Limits**
- **Traefik**: 128Mi memory, 100m CPU
- **Backend1**: 256Mi memory, 200m CPU
- **Backend2**: 256Mi memory, 200m CPU
- **Backend3**: 512Mi memory, 400m CPU

## 🌐 Access Points

### **Production URLs**
- **Gateway**: https://apifincheck.husanenglish.online
- **Dashboard**: https://traefik.apifincheck.husanenglish.online:8888
- **Health Check**: https://apifincheck.husanenglish.online/health

### **API Endpoints**
- **Authentication**: https://apifincheck.husanenglish.online/auth/
- **Users**: https://apifincheck.husanenglish.online/users/
- **Products**: https://apifincheck.husanenglish.online/products/
- **Orders**: https://apifincheck.husanenglish.online/orders/
- **Documentation**: https://apifincheck.husanenglish.online/docs/

## 🔍 Troubleshooting

### **Check Pod Status**
```bash
kubectl get pods -n traefik-gateway
kubectl describe pod <pod-name> -n traefik-gateway
```

### **Check Service Status**
```bash
kubectl get services -n traefik-gateway
kubectl get ingress -n traefik-gateway
```

### **Check SSL Certificates**
```bash
kubectl get certificates -n traefik-gateway
kubectl describe certificate traefik-tls -n traefik-gateway
```

### **View Logs**
```bash
# Traefik logs
kubectl logs -f deployment/traefik-gateway -n traefik-gateway

# Backend logs
kubectl logs -f deployment/backend1-nodejs -n traefik-gateway
kubectl logs -f deployment/backend2-python -n traefik-gateway
kubectl logs -f deployment/backend3-java -n traefik-gateway
```

### **Check HPA Status**
```bash
kubectl get hpa -n traefik-gateway
kubectl describe hpa traefik-hpa -n traefik-gateway
```

## 🛠️ Management

### **Scale Services**
```bash
# Scale Traefik
kubectl scale deployment traefik-gateway --replicas=5 -n traefik-gateway

# Scale Backend Services
kubectl scale deployment backend1-nodejs --replicas=3 -n traefik-gateway
kubectl scale deployment backend2-python --replicas=3 -n traefik-gateway
kubectl scale deployment backend3-java --replicas=3 -n traefik-gateway
```

### **Update Services**
```bash
# Update Traefik
kubectl set image deployment/traefik-gateway traefik=traefik:v3.1 -n traefik-gateway

# Update Backend Services
kubectl set image deployment/backend1-nodejs backend1=node:19-alpine -n traefik-gateway
```

### **Delete Deployment**
```bash
# Delete entire namespace
kubectl delete namespace traefik-gateway

# Delete specific resources
kubectl delete -f k8s/
```

## 📚 Prerequisites

- **Kubernetes**: 1.20+
- **kubectl**: 1.20+
- **cert-manager**: 1.13+
- **LoadBalancer**: Supported by your cluster

## 🔒 Security

- **SSL/TLS**: Automatic Let's Encrypt certificates
- **HTTPS Redirect**: Automatic HTTP to HTTPS redirect
- **Resource Limits**: CPU and memory constraints
- **Health Checks**: Liveness and readiness probes
- **Auto-scaling**: Based on resource usage

## 🎯 Benefits

- ✅ **Auto-discovery**: Automatic service detection
- ✅ **SSL Termination**: Automatic HTTPS
- ✅ **Load Balancing**: Built-in load balancing
- ✅ **Auto-scaling**: HPA based on metrics
- ✅ **Health Monitoring**: Comprehensive health checks
- ✅ **Dashboard**: Real-time monitoring
- ✅ **Production Ready**: Enterprise-grade features
