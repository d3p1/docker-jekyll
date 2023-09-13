#!/bin/sh

##
# @description Docker entrypoint to bootstrap Jekyll site 
#              with an environment configuration file
# @author      C. M. de Picciotto <d3p1@d3p1.dev> (https://d3p1.dev/)
# @link        https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine-slim/20-envsubst-on-templates.sh
##

##
# @note Exit script if there is an error
##
set -eu

##
# Logger
# @param  $1 Message
# @return void
# @note   Use Nginx log flag to check log generation 
#         to mantain the same behaviour as other scripts
# @note   Just to develop a cleaner code, `ME` is defined as local variable but
#         this approach has the downside that it is re-declared every time this
#         function is called
# @link   https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine-slim/20-envsubst-on-templates.sh#L8
##
log() {
    local ME=$(basename "$0");
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$ME: $@"
    fi
}

##
# Bootstrap Jekyll site with environment configuration
# @return void
# @note   For the moment, to avoid overcomplications,
#         the generated configuration file 
#         will have a fixed name: `_config.env.yml`
##
bootstrap_jekyll() {
    ##
    # @note Check if environment configuration file exists
    ##
    if [ ! -s "$JEKYLL_ENV_CONF_PATH" ]; then
        log "$JEKYLL_ENV_CONF_PATH does not exist. Skipping Jekyll bootstrap";
        return 0;
    fi

    ##
    # @note Generate Jekyll config file
    ##
    generate_jekyll_config _config.env.yml

    ##
    # @note Build Jekyll
    ##
    build_jekyll
}

##
# Generate Jekyll config file
# @param  $1 Jekyll site environment configuration filename
# @return void
##
generate_jekyll_config() {
    ##
    # @note Replace `${VAR}` placeholders by environment variables to generate
    #       configuration file
    ##
    local output_file="$WORK_DIR/$1"
    log "Running envsubst on $JEKYLL_ENV_CONF_PATH to $output_file"
    envsubst < "$JEKYLL_ENV_CONF_PATH" > "$output_file"
    chown "$JEKYLL_USER:$JEKYLL_GROUP" "$output_file"
}

##
# Build Jekyll
# @return void
# @link   https://jekyllrb.com/docs/configuration/options/
##
build_jekyll() {
    (cd "$WORK_DIR" && bundle exec jekyll build \
    --config _config.yml,_config.env.yml)
}

##
# @note Generate Jekyll config file
# @note Build Jekyll with new configuration
##
bootstrap_jekyll

##
# @note Exit with success
##
exit 0