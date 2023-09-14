##
# @description Jekyll image. It will be set a minimum required environment 
#              to be able to serve a Jekyll site
# @author      C. M. de Picciotto <d3p1@d3p1.dev> (https://d3p1.dev/)
# @link        https://jekyllrb.com/
##

##
# @note The idea is to generate this `Dockerfile` (and the build process) 
#       automatically for each new dependency version that is released.
#       For the moment, the dependency versions will be fixed manually
##
FROM nginx:alpine3.18
    ##
    # @note Add Ruby and required dependency `build-base` 
    #       (necessary to build gems)
    # @note The official recommendation is to not pin a package 
    #       to a specific version number 
    # @link https://superuser.com/questions/1055060/how-to-install-a-specific-package-version-in-alpine
    # @link https://gitlab.alpinelinux.org/alpine/abuild/-/issues/9996#note_87135
    ## 
    RUN apk --no-cache add build-base ruby-full>3.2.2-r0 ruby-dev>3.2.2-r0 

    ##
    # @note Create a `jekyll` user to be able to work with the environment
    #       without `root` priviligies
    ##
    ARG JEKYLL_USER_UID=1000
    ARG JEKYLL_USER_GID=$JEKYLL_USER_UID
    ENV JEKYLL_USER="jekyll"
    ENV JEKYLL_GROUP="jekyll"
    RUN addgroup -g ${JEKYLL_USER_GID} ${JEKYLL_GROUP}
    RUN adduser -u ${JEKYLL_USER_UID} -G ${JEKYLL_GROUP} \
        -s /bin/sh -D ${JEKYLL_USER}
    USER ${JEKYLL_USER_UID}:${JEKYLL_USER_GID}

    ##
    # @note Create environment variables needed to work with gems without `root`
    #       priviligies
    # @note For some reason, it is not possible to use 
    #       the `HOME` environment variable to declare `GEM_HOME`
    # @link https://github.com/docker-library/ruby/blob/master/3.2/alpine3.18/Dockerfile#L157
    ##
    ENV GEM_HOME="/home/jekyll/.config/ruby/bundle"
    ENV BUNDLE_SILENCE_ROOT_WARNING=1
    ENV BUNDLE_APP_CONFIG="$GEM_HOME"
    ENV PATH="$GEM_HOME/bin:$PATH"
    RUN mkdir -p "$GEM_HOME"

    ##
    # @note Install Jekyll
    ##
    RUN gem install jekyll -v '~> 4.3'

    ##
    # @note Set working dir to implement Jekyll site
    # @note Create working dir environment variable to be able to
    #       define new locations based on this one
    ##
    ENV WORK_DIR="/var/www"
    WORKDIR ${WORK_DIR}

    ##
    # @note Init Jekyll site on production mode by default
    # @note For the image, it is builded this default Jekyll site but,
    #       when a container runs this image, the `jekyll-serve`
    #       command is executed by default, and re-builds the site with a
    #       custom configuration file
    ##
    ENV JEKYLL_ENV="production"
    RUN jekyll new .
    RUN bundle install
    RUN bundle exec jekyll build

    ##
    # @note Setup server
    # @note To update the server configuration, it is necessary 
    #       `root` priviligies. Also, the `nginx` process 
    #       must be run as `root`, too
    # @note Add Nginx VHost template file. 
    #       When a container is started, this template file is converted to a
    #       VHost configuration file in `/etc/nginx/conf.d` replacing its 
    #       `${HOST}` and `${DOCUMENT_ROOT}` placeholders by the 
    #       related environment variables. An example on how to run a container
    #       with this image, could be: 
    #       `docker run -p 80:80 --env HOST="local.test" jekyll:nginx-alpine3.18`
    # @link https://hub.docker.com/_/nginx
    # @link https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine-slim/20-envsubst-on-templates.sh
    # @link https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine-slim/Dockerfile#L122
    ##
    USER root:root
    ENV HOST="localhost"
    ENV DOCUMENT_ROOT="$WORK_DIR/_site"
    COPY nginx/etc/jekyll.conf.template /etc/nginx/templates/

    ##
    # @note Add Jekyll script that re-builds the site 
    #       with a custom configuration based on environment settings
    # @note Copy default Jekyll environment configuration file
    # @link https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine-slim/Dockerfile#L111
    # @link https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine-slim/docker-entrypoint.sh#L17
    ##
    ENV JEKYLL_ENV_CONF_DIR="$WORK_DIR/_conf"
    ENV JEKYLL_ENV_CONF_FILE="_conf.env.yml.template"
    ENV JEKYLL_ENV_CONF_PATH=${JEKYLL_ENV_CONF_DIR}/${JEKYLL_ENV_CONF_FILE}
    COPY --chown=${JEKYLL_USER_UID}:${JEKYLL_USER_GID} \
         jekyll/etc/_conf.env.yml.template ${JEKYLL_ENV_CONF_PATH}
    COPY entrypoint/jekyll-serve.sh /usr/local/bin/jekyll-serve

    ##
    # @note Execute `jekyll-serve` script as default entrypoint command
    ##
    CMD ["jekyll-serve"];


