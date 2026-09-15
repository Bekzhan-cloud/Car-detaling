FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
COPY backend/package.json ./backend/package.json
COPY backend/prisma ./backend/prisma

RUN npm ci

COPY backend ./backend

RUN npm run db:generate --workspace backend

ENV NODE_ENV=production
ENV PORT=5000

EXPOSE 5000

WORKDIR /app/backend

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 CMD node -e "fetch('http://127.0.0.1:' + (process.env.PORT || 5000) + '/health').then(r => { if (!r.ok) process.exit(1) }).catch(() => process.exit(1))"

CMD ["node", "server.js"]