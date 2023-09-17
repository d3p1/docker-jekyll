#!/bin/sh

##
# @description Build Jekyll site 
#              with a custom environment configuration file
# @author      C. M. de Picciotto <d3p1@d3p1.dev> (https://d3p1.dev/)
# @note        This script will be run as part of the list of scripts that Nginx
#              runs before boot its process (`nginx`). It will try to setup
#              Jekyll site before web server starts
# @see         <project_root_dir>/jekyll/etc/_conf.env.yml.template
# @link        https://github.com/nginxinc/docker-nginx/blob/1.25.2/entrypoint/docker-entrypoint.sh#L17
##

##
# 
# @note Add flag to exit script if there is an error related to a command
#       or if it is used an undefined variable
##
set -eu

##
# Build Jekyll site with a custom environment configuration file
#
# @return void
# @note   For the moment, to avoid overcomplications,
#         the generated configuration file 
#         will have a fixed name: `_config.env.yml`
##
main() {
    ##
    # @note Check if environment configuration file exists
    # @note It is not considered an error 
    #       if the environment configuration file does not exist
    # @note If environment configuration file does not exist, the build process
    #       will be skipped. In this case, it is considered that the site is
    #       already ready to be served
    ##
    if [ ! -s "$JEKYLL_ENV_CONF_PATH" ]; then
        echo "$JEKYLL_ENV_CONF_PATH does not exist. Skipping Jekyll build";
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

    ##
    # @note Return with success
    ##
    return 0;
}

##
# Generate Jekyll config file
#
# @param  string $1 Jekyll site environment configuration filename
# @return void
##
generate_jekyll_config() {
    ##
    # @note Replace `${VAR}` placeholders by environment variables to generate
    #       configuration file
    ##
    output_file="$WORK_DIR/$1"
    echo "Running envsubst on $JEKYLL_ENV_CONF_PATH to $output_file"
    envsubst < "$JEKYLL_ENV_CONF_PATH" > "$output_file"
    chown "$JEKYLL_USER:$JEKYLL_GROUP" "$output_file"
}

##
# Build Jekyll
#
# @return void
# @link   https://jekyllrb.com/docs/configuration/options/
##
build_jekyll() {
    (cd "$WORK_DIR" && bundle install && \
     bundle exec jekyll build --config _config.yml,_config.env.yml)
}

##
# @note Generate Jekyll config file
# @note Build Jekyll with new configuration
##
main "$@"