# ── Build stage ─────────────────────────────────────────────────────────────
FROM node:20-alpine AS builder
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
ARG VITE_API_URL
ARG VITE_API_KEY
ARG VITE_NETWORK=testnet
RUN pnpm build

# ── Serve stage ──────────────────────────────────────────────────────────────
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
