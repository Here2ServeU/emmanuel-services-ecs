# Use Node.js as base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files separately for better caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy all files (including public/)
COPY . .

# Ensure the public directory exists
RUN mkdir -p /app/public && chmod -R 755 /app/public

# Expose the correct port
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]