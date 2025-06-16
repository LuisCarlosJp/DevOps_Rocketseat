# --- Build Stage ---
# Use a Node.js 18 Alpine image for building
FROM node:18-alpine3.21 AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Enable Corepack (which manages yarn, npm, pnpm versions)
# and set the desired Yarn version early. This is crucial for Yarn 2+ (Berry).
RUN corepack enable
RUN yarn set version 3.4.1

# Copy only the dependency-related files first to leverage Docker layer caching.
# This includes the root package.json, yarn.lock, .yarnrc.yml, and the .yarn directory.
# For Yarn workspaces, copying .yarn is essential as it contains the Yarn cache and plugins.
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn/

# If your project is a monorepo with multiple workspaces, you might need to copy
# their package.json files here too, depending on how `yarn install` resolves them.
# A general `COPY . .` will cover it later, but for initial dependency resolution caching,
# sometimes copying specific workspace package.json files is beneficial.
# For example: COPY packages/ packages/

# Install all project dependencies, including those for workspaces.
# Use --immutable to ensure reproducible builds in CI/CD environments.
RUN yarn install --immutable

# Copy the rest of the application source code.
# This ensures all source files, including those within workspaces, are present for the build.
COPY . .

# Run the build script defined in your package.json.
# This will typically compile your source code into the 'dist' directory.
RUN yarn run build
RUN yarn workspaces focus --production && yarn cache clean

# --- Production Stage ---
# Use the same base image for the final production environment.
FROM node:18-alpine3.21

# Set the working directory
WORKDIR /usr/src/app

# Copy only the essential files for running the application in production from the build stage.
# 1. package.json: Needed for running npm/yarn scripts (like `start:prod`).
# 2. yarn.lock: Crucial for Yarn to correctly resolve dependencies at runtime.
# 3. .yarnrc.yml: Yarn configuration.
# 4. .yarn: Contains Yarn's cache and specific Yarn files needed for resolution.
# 5. dist: Your compiled application output.
# 6. node_modules: The fully resolved and populated dependency directory from the build stage.
#    This is key to resolving the "package doesn't seem to be present in your lockfile" error,
#    as it ensures all workspace symlinks and package resolutions are intact.
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/yarn.lock ./yarn.lock
COPY --from=build /usr/src/app/.yarnrc.yml ./.yarnrc.yml
COPY --from=build /usr/src/app/.yarn ./.yarn/
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

# Expose the port your application listens on
EXPOSE 3000

# Define the command to run when the container starts.
# This assumes 'start:prod' is a script in your root package.json that correctly
# starts your API service, leveraging the built 'dist' folder and copied 'node_modules'.
CMD [ "yarn", "run", "start:prod" ]