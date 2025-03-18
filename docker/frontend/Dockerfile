# Use Node.js as base image for building Angular (Force architecture)
FROM --platform=linux/amd64 node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json separately for better caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Build Angular app for production
RUN npm run build --configuration=production

# Use Nginx as a lightweight server to serve the built Angular app (Force architecture)
FROM --platform=linux/amd64 nginx:alpine

# Copy the built app from the previous stage
COPY --from=build /app/dist/angular-frontend /usr/share/nginx/html

# Expose port 8080 for the frontend
EXPOSE 8080

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]