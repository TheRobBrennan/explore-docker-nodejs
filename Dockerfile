FROM node:10.16.3

# Root user - create the directory for our app and change ownership to an unprivileged user
#   NOTE: We are chaining our commands with && here to have a single layer in our image.
# Chaining our commands allows us to have layers that do not need to store intermediate files.
RUN mkdir /srv/app && chown node:node /srv/app

# Run subsequent build steps as an unprivleged user instead of root
USER node

# Set the working directory for subsequent build steps
WORKDIR /srv/app

# Copy over our npm packaging files and ensure our unprivileged user owns them
COPY --chown=node:node package.json package-lock.json ./

# Install our modules
RUN npm install --quiet

# TODO: Remove once we have some dependencies defined
RUN mkdir -p node_modules
