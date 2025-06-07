# Dockerfile for a Node.js Todo App

# ---------- Stage 1: Build ----------
FROM node:18-alpine AS build
WORKDIR /app

# Copy only necessary files for dependency resolution
COPY package.json yarn.lock ./
RUN yarn install --production

# Copy source code
COPY src ./src
COPY spec ./spec

# ---------- Stage 2: Runtime ----------
FROM node:18-alpine
WORKDIR /app

# Copy everything from build stage
COPY --from=build /app /app

# Command to run the app
CMD ["node", "src/index.js"]
EXPOSE 3000
