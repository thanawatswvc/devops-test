FROM node:alpine
WORKDIR "/home"
COPY package.json .
RUN npm install
#ARG BUILDTIME_NODE_ENV
#ENV NODE_ENV=$BUILDTIME_NODE_ENV
#RUN if [ "$BUILDTIME_NODE_ENV" == "dev" || "$BUILDTIME_NODE_ENV" == "uat"  || "$BUILDTIME_NODE_ENV" == "production" ]] ; then \
#         git clone xxx  \
#         NODE_ENV="$BUILDTIME_NODE_ENV"; \
#    fi
COPY . .
CMD ["npm","start"]
