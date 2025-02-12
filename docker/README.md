# Docker Configuration Guide

## Overview

This project uses Docker and Docker Compose for containerization of the following services:
- Backend API (Node.js)
- Frontend (React)
- PostgreSQL Database
- Redis Cache

## Prerequisites

- Docker Engine 20.10.0+
- Docker Compose 2.0.0+
- Node.js 18+ (for local development)

## Quick Start

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. Create environment files:
   ```bash
   cp .env.example .env
   ```

3. Start the development environment:
   ```bash
   docker compose up -d
   ```

4. Access the services:
   - Frontend: http://localhost:3001
   - API: http://localhost:3000
   - Database: localhost:5432
   - Redis: localhost:6379

## Development Environment

The development environment is configured for hot-reloading and debugging:

### Backend API
- Source code is mounted from ./backend
- Node.js runs in development mode
- Nodemon watches for file changes
- Debug port exposed on 9229

### Frontend
- Source code is mounted from ./frontend
- React dev server with hot reloading
- Development build with source maps
- Development tools enabled

## Production Environment

For production deployment:

1. Build the images:
   ```bash
   docker compose -f docker-compose.prod.yml build
   ```

2. Start the services:
   ```bash
   docker compose -f docker-compose.prod.yml up -d
   ```

### Production Features
- Multi-stage builds for smaller images
- Production-only dependencies
- Nginx serving static frontend files
- Security hardening enabled
- Health checks configured
- Non-root users for security

## Container Details

### API Container
- Base image: node:18-alpine
- Multi-stage build
- Production dependencies only
- Non-root user
- Health check endpoint
- Environment variables configured

### Frontend Container
- Development: node:18-alpine
- Production: nginx:alpine
- Multi-stage build
- Static file serving
- Nginx security headers
- Gzip compression
- Cache control headers

### Database Container
- PostgreSQL 14
- Persistent volume
- Health check configured
- Initialization scripts
- Backup capability

### Redis Container
- Redis 6
- Persistence enabled
- Health check
- Data volume

## Configuration

### Environment Variables
Required environment variables:
- `DB_NAME`: Database name
- `DB_USER`: Database user
- `DB_PASSWORD`: Database password
- `JWT_SECRET`: JWT signing key
- `NODE_ENV`: Environment (development/production)

### Ports
Default port mappings:
- Frontend: 3001
- API: 3000
- PostgreSQL: 5432
- Redis: 6379

## Health Checks

All services include health checks:
- API: HTTP GET /health
- Frontend: HTTP GET /
- PostgreSQL: pg_isready
- Redis: redis-cli ping

## Security

Security measures implemented:
- Non-root users
- Security headers
- Network isolation
- Volume permissions
- Environment separation
- Secrets management

## Troubleshooting

Common issues and solutions:

1. Container fails to start:
   ```bash
   # Check container logs
   docker compose logs [service-name]
   ```

2. Database connection issues:
   ```bash
   # Check database health
   docker compose exec db pg_isready
   ```

3. Permission issues:
   ```bash
   # Fix volume permissions
   docker compose down
   sudo chown -R 1000:1000 ./data
   ```

4. Cache issues:
   ```bash
   # Clear Redis cache
   docker compose exec redis redis-cli FLUSHALL
   ```

## Best Practices

1. Development:
   - Use volumes for hot reloading
   - Enable source maps
   - Use development builds
   - Configure debugging

2. Production:
   - Use multi-stage builds
   - Minimize image size
   - Enable security features
   - Configure health checks
   - Use non-root users

3. General:
   - Keep images updated
   - Use specific versions
   - Monitor resource usage
   - Regular security updates
   - Backup important data

## Maintenance

Regular maintenance tasks:

1. Update images:
   ```bash
   docker compose pull
   docker compose build --no-cache
   ```

2. Clean up:
   ```bash
   # Remove unused images
   docker image prune -a
   
   # Remove unused volumes
   docker volume prune
   ```

3. Backup database:
   ```bash
   docker compose exec db pg_dump -U $DB_USER $DB_NAME > backup.sql
   ```

## Contributing

When contributing to the Docker configuration:
1. Test changes locally
2. Update documentation
3. Follow security best practices
4. Maintain backwards compatibility
5. Update dependency versions 