# Build Stage
FROM node:22-alpine AS build

WORKDIR /app

# Install dependencies first (leveraging Docker layer caching)
COPY package.json package-lock.json ./
RUN npm ci

# Copy application source code
COPY . .

# Build production bundle
RUN npm run build

# Production Stage
FROM nginx:alpine AS production

# Copy custom nginx configuration for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy compiled assets from build stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
