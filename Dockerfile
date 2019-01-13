ARG NODE_VERSION=10
FROM node:${NODE_VERSION}
# Home directory for Node-RED application source code.
RUN mkdir -p /usr/src/node-red
# User data directory, contains flows, config and nodes.
RUN mkdir /data
WORKDIR /usr/src/node-red
# Add node-red user so we aren't running as root.
RUN useradd --home-dir /usr/src/node-red --no-create-home node-red \
    && chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red
USER node-red
# package.json contains Node-RED NPM module and node dependencies
#pull the normal node-red-docker repo
RUN git clone https://github.com/node-red/node-red-docker.git \
    && cp node-red-docker/package.json /usr/src/node-red/
RUN npm install
# User configuration directory volume
EXPOSE 1880
# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules
CMD ["npm", "start", "--", "--userDir", "/data"]