# Build Stage
FROM node:22-alpine AS build

WORKDIR /app

# Copy package configuration files
COPY package*.json ./

# Install dependencies cleanly
RUN npm ci

# Copy project files
COPY . .

# Build application
RUN npm run build

# Production Stage
FROM nginx:alpine

# Copy Nginx configuration file for port 3001 and SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy compiled static assets from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 3001 for Dokploy
EXPOSE 3001

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
