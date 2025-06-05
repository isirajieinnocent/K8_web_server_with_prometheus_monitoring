# ===== Stage 1: Builder =====
FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --production && \
    npm cache clean --force
COPY server.js .
COPY public ./public

# ===== Stage 2: Runtime =====
FROM node:18-alpine
WORKDIR /app

# Install libcap and set capabilities (must be done as root)
RUN apk add --no-cache libcap && \
    setcap 'cap_net_bind_service=+ep' $(readlink -f $(which node)) && \
    apk del libcap  # Remove after use to reduce image size

# Copy production files
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js .
COPY --from=builder /app/public ./public

# Runtime config
ENV NODE_ENV=production \
    PORT=80

# Security hardening
RUN addgroup -S appuser && \
    adduser -S appuser -G appuser && \
    chown -R appuser:appuser /app
USER appuser

EXPOSE 80
CMD ["node", "server.js"]