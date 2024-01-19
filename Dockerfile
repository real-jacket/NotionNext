ARG NOTION_PAGE_ID
# Install dependencies only when needed
FROM node:18-alpine3.18 AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json ./
RUN yarn install --frozen-lockfile

# Rebuild the source code only when needed
FROM node:18-alpine3.18 AS builder
ARG NOTION_PAGE_ID
ARG NEXT_PUBLIC_BEI_AN
ARG ALGOLIA_ADMIN_APP_KEY
ARG NEXT_PUBLIC_ALGOLIA_APP_ID
ARG NEXT_PUBLIC_ALGOLIA_INDEX
ARG NEXT_PUBLIC_ALGOLIA_SEARCH_ONLY_APP_KEY
ENV NOTION_PAGE_ID $NOTION_PAGE_ID
ENV NEXT_PUBLIC_BEI_AN $NEXT_PUBLIC_BEI_AN
ENV ALGOLIA_ADMIN_APP_KEY $ALGOLIA_ADMIN_APP_KEY
ENV NEXT_PUBLIC_ALGOLIA_APP_ID $NEXT_PUBLIC_ALGOLIA_APP_ID
ENV NEXT_PUBLIC_ALGOLIA_INDEX $NEXT_PUBLIC_ALGOLIA_INDEX
ENV NEXT_PUBLIC_ALGOLIA_SEARCH_ONLY_APP_KEY $NEXT_PUBLIC_ALGOLIA_SEARCH_ONLY_APP_KEY
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN yarn build

ENV NODE_ENV production

EXPOSE 3000

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry.
# ENV NEXT_TELEMETRY_DISABLED 1

CMD ["yarn", "start"]
