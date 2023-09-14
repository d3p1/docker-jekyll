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
    #       reference this location in scripts and 
    #       define new locations based on this one
    # @see  <project_root_dir>/nginx/entrypoint/5-build-jekyll.sh
    ##
    ENV WORK_DIR="/var/www"
    WORKDIR ${WORK_DIR}

    ##
    # @note Init Jekyll site on production mode by default
    # @note For the image, it is builded this default Jekyll site but,
    #       when a container runs this image, the 
    #       default entrypoint command (`nginx`) re-builds 
    #       the site with a custom configuration file
    # @see  <project_root_dir>/nginx/entrypoint/5-build-jekyll.sh
    # @see  <project_root_dir>/jekyll/etc/_conf.env.yml.template
    # @link https://github.com/nginxinc/docker-nginx/blob/1.25.2/entrypoint/docker-entrypoint.sh#L17
    ##
    ENV JEKYLL_ENV="production"
    RUN jekyll new .
    RUN bundle install
    RUN bundle exec jekyll build

    ##
    # @note Setup server
    # @note To update the server configuration, it is necessary 
    #       `root` priviligies. Also, the `nginx` process 
    #       (default entrypoint command) must be run as `root`, too
    # @note Add Nginx VHost template file. 
    #       When a container is started, this template file is converted to a
    #       VHost configuration file in `/etc/nginx/conf.d` replacing its 
    #       `${HOST}` and `${DOCUMENT_ROOT}` placeholders by the 
    #       related environment variables
    # @see  <project_root_dir>/nginx/etc/jekyll.conf.template
    # @link https://hub.docker.com/_/nginx
    # @link https://github.com/nginxinc/docker-nginx/blob/1.25.2/entrypoint/20-envsubst-on-templates.sh
    ##
    USER root:root
    ENV HOST="localhost"
    ENV DOCUMENT_ROOT="$WORK_DIR/_site"
    COPY nginx/etc/jekyll.conf.template /etc/nginx/templates/

    ##
    # @note Copy default Jekyll environment configuration file
    # @note When a container is started, this template file is converted to
    #       a Jekyll configuration file localted in `$WORK_DIR/_conf.env.yml`,
    #       and it will be used to re-build the site:
    #       `bundle exec jekyll build --config _config.yml,_config.env.yml`.
    #       This template configuration file could use environment variables
    #       as placeholders (`${VAR}`) that then will be replaced by the 
    #       respective environment variable value by the Jekyll build script
    # @see  <project_root_dir>/nginx/entrypoint/5-build-jekyll.sh
    # @see  <project_root_dir>/jekyll/etc/_conf.env.yml.template
    ##
    ENV JEKYLL_ENV_CONF_DIR="$WORK_DIR/_conf"
    ENV JEKYLL_ENV_CONF_FILE="_conf.env.yml.template"
    ENV JEKYLL_ENV_CONF_PATH=${JEKYLL_ENV_CONF_DIR}/${JEKYLL_ENV_CONF_FILE}
    COPY --chown=${JEKYLL_USER_UID}:${JEKYLL_USER_GID} \
         jekyll/etc/_conf.env.yml.template ${JEKYLL_ENV_CONF_PATH}

    ##
    # @note Add custom entrypoint that wraps Nginx image entrypoint
    # @note Add Jekyll script that re-builds the site 
    #       with a custom configuration based on environment settings
    # @note It seems that, with the new entrypoint definition, is necessary to
    #       re-define the image default command (it is not possible to re-use
    #       the Nginx image command: `nginx -g 'daemon off;'`)
    # @see  <project_root_dir>/entrypoint/main.docker-entrypoint.sh
    # @see  <project_root_dir>/nginx/entrypoint/5-build-jekyll.sh
    # @see  <project_root_dir>/jekyll/etc/_conf.env.yml.template
    # @link https://github.com/nginxinc/docker-nginx/blob/1.25.2/entrypoint/docker-entrypoint.sh#L17
    ##
    COPY entrypoint/main.docker-entrypoint.sh /
    COPY nginx/entrypoint/5-build-jekyll.sh /docker-entrypoint.d/
    ENTRYPOINT ["/main.docker-entrypoint.sh"];
    CMD ["nginx", "-g", "daemon off;"]


