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
    ARG USER_UID=1000
    ARG USER_GID=$USER_UID
    RUN addgroup -g ${USER_GID} jekyll
    RUN adduser -u ${USER_UID} -G jekyll -s /bin/sh -D jekyll
    USER ${USER_UID}:${USER_GID}

    ##
    # @note Create environment variables needed to work with gems without `root`
    #       priviligies
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
    ##
    WORKDIR /var/www

    ##
    # @note Create Jekyll site
    ##
    RUN jekyll new .
    RUN bundle install
    RUN bundle exec jekyll build

    ##
    # @note Setup server
    # @note To update the server configuration, it is necessary 
    #       `root` priviligies. Also, the Nginx image runs `nginx` process 
    #       by default when a container is started. The `nginx` process 
    #       must be run as `root`, too
    # @note Set Nginx VHost template file. 
    #       When a container is started, this template file is converted to a
    #       VHost configuration file in `/etc/nginx/conf.d` replacing its 
    #       `HOST` and `DOCUMENT_ROOT` placeholders by the 
    #       related environment variables. An example on how to run a container
    #       with this image, could be: 
    #       `docker run -p 80:80 --env HOST="d3p1.test" jekyll:nginx-alpine3.18`
    # @link https://hub.docker.com/_/nginx
    # @link https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine-slim/20-envsubst-on-templates.sh
    # @link https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine-slim/Dockerfile#L122
    ##
    USER root:root
    ENV HOST="localhost"
    ENV DOCUMENT_ROOT="/var/www/_site"
    COPY nginx/etc/jekyll.conf.template /etc/nginx/templates/jekyll.conf.template

