FROM node:20-alpine AS deps
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

FROM deps AS builder
WORKDIR /app
COPY prisma ./prisma
COPY . .
RUN npm run build

FROM node:20-alpine AS prod-deps
WORKDIR /app
ENV NODE_ENV=production

COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=5000

RUN addgroup -S nodejs && adduser -S appuser -G nodejs

COPY --from=prod-deps --chown=appuser:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:nodejs /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder --chown=appuser:nodejs /app ./

USER appuser
EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 CMD node -e "fetch('http://127.0.0.1:' + (process.env.PORT || 5000) + '/health').then(r => { if (!r.ok) process.exit(1) }).catch(() => process.exit(1))"
CMD ["node", "server.js"]
