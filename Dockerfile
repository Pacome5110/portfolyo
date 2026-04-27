# Stage 1: Build (if we were using a framework, we'd compile here. 
# For static HTML, we use it to demonstrate multi-stage capability as requested in G2)
FROM node:20-alpine AS builder
WORKDIR /app
# Copy static files
COPY index.html style.css script.js 404.html ./

# Stage 2: Serve
FROM nginx:alpine
# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/

# Copy static assets from builder
COPY --from=builder /app /usr/share/nginx/html

# Copy OG image if it exists in a specific assets folder, but we will place it in root.
# Assuming og-image.png will be placed in the context root before build.
COPY og-image.png /usr/share/nginx/html/og-image.png

EXPOSE 80

# Use array syntax for CMD to allow graceful shutdown
CMD ["nginx", "-g", "daemon off;"]
