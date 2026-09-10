FROM node:20-alpine

WORKDIR /app

# Install dependencies from the monorepo root so workspace links and the lockfile stay consistent.
COPY package.json package-lock.json ./
COPY frontend/package.json frontend/package.json
COPY backend/package.json backend/package.json

RUN npm ci

COPY . .

RUN npm run db:generate --workspace backend

EXPOSE 5000

CMD ["npm", "run", "start", "--workspace", "backend"]