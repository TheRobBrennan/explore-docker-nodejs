# ---------------------------------------------------------- #
# Development stage
# ---------------------------------------------------------- #
FROM node:10.16.3 AS development
# Uses large Node.js base image which includes a full compiler tool chain
# that lets us build node modules that use native code (as opposed to pure JavaScript). We won’t
# need that compiler tool chain at runtime, so from both a security and performance point of view,
# it would be better not to ship it to production.

# Root user - create the directory for our app and change ownership to an unprivileged user
#   NOTE: We are chaining our commands with && here to have a single layer in our image.
#   Chaining our commands allows us to have layers that do not need to store intermediate files.
RUN mkdir /srv/app && chown node:node /srv/app

# Run subsequent build steps as an unprivleged user instead of root
USER node

# Set the working directory for subsequent build steps
WORKDIR /srv/app

# Copy our npm packaging files and ensure they are owned by our unprivileged user.
COPY --chown=node:node package.json package-lock.json ./

# TODO - Remove this line once you have dependencies to install
RUN mkdir -p node_modules

# Run npm install since the full Node.js base image is available to us in this stage.
RUN npm install --quiet

# ---------------------------------------------------------- #
# Production stage
# ---------------------------------------------------------- #
# Uses the official slim image from Node.js which only includes
# dependencies to run an application.
# ---------------------------------------------------------- #
# Notice how this method takes our original development
# image (904 MB) and turns it into a much smaller production
# image (148 MB):
#
# REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
# app                 latest              83101b30850f        8 seconds ago       148MB
# <none>              <none>              687ea379e648        17 seconds ago      904MB
# ---------------------------------------------------------- #
FROM node:10.16.3-slim AS production

# Run subsequent build steps as an unprivleged user instead of root
USER node

# Set the working directory for subsequent build steps
WORKDIR /srv/app

# We installed node_modules in our development stage; simply copy that folder to our production image
#   NOTE: The files are owned by root deliberately. Our unprivileged user can only read
COPY --from=development --chown=root:root /srv/app/node_modules ./node_modules

# Copy application code and files into the production image
COPY . .

# Launch the application
CMD ["node", "index.js"]
