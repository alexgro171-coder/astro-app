FROM node:20-slim

# Install OpenSSL (required by Prisma) and procps (for nest watch mode)
RUN apt-get update && apt-get install -y openssl procps && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies (use ci for reproducible builds)
RUN npm ci

# Copy source code
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Expose port
EXPOSE 3000

# Run in development mode
CMD ["npm", "run", "start:dev"]
