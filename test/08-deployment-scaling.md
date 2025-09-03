# Chapter 8: Deployment & Scaling

## Overview

Deployment and scaling are critical phases in the application lifecycle. This chapter covers production deployment strategies, containerization with Docker, and both vertical and horizontal scaling approaches. We'll explore how to take Sync from development to production and prepare it for enterprise-scale usage.

## Containerization with Docker

### Development Dockerfile

```dockerfile
# Dockerfile.dev
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "src/server.js"]
```

### Docker Compose for Production

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.prod
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - JWT_SECRET=${JWT_SECRET}
      - GOOGLE_CLOUD_PROJECT_ID=${GOOGLE_CLOUD_PROJECT_ID}
    depends_on:
      - db
      - redis
    restart: unless-stopped
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres_prod_data:/var/lib/postgresql/data
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 4G

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_prod_data:/data
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - app
    restart: unless-stopped

volumes:
  postgres_prod_data:
  redis_prod_data:
```
## Scaling Strategies

### Vertical Scaling

**Server Resource Optimization**

```javascript
// server.js - Optimized for vertical scaling
const cluster = require('cluster');
const os = require('os');

if (cluster.isMaster) {
    const numCPUs = os.cpus().length;
    
    console.log(`Master ${process.pid} is running`);
    console.log(`Forking for ${numCPUs} CPUs`);
    
    // Fork workers
    for (let i = 0; i < numCPUs; i++) {
        cluster.fork();
    }
    
    cluster.on('exit', (worker, code, signal) => {
        console.log(`Worker ${worker.process.pid} died`);
        // Replace the dead worker
        cluster.fork();
    });
} else {
    // Worker process
    require('./src/app');
    console.log(`Worker ${process.pid} started`);
}
```

### Horizontal Scaling

**Load Balancer Configuration**

```javascript
// loadBalancer.js
const http = require('http');
const httpProxy = require('http-proxy');

const proxy = httpProxy.createProxyServer({});

const servers = [
    'http://app1:3000',
    'http://app2:3000',
    'http://app3:3000'
];

let currentServer = 0;

const server = http.createServer((req, res) => {
    // Round-robin load balancing
    const target = servers[currentServer];
    currentServer = (currentServer + 1) % servers.length;
    
    proxy.web(req, res, { target });
});

server.listen(8080);
```





*This chapter demonstrates how to take the Task Manager App from development to production and scale it to handle workloads. The combination of containerization and load balancing a robust foundation for growth.*
