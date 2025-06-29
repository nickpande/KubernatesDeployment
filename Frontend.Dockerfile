# Stage 1: Build React app
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the entire app source code and build it
COPY . .
RUN npm run build

# Stage 2: Serve using Nginx
FROM nginx:stable-alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom Nginx config (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port and start Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
