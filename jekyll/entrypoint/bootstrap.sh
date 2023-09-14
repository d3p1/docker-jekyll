#!/bin/sh

##
# @description Boot Jekyll site 
#              with an environment configuration file
# @author      C. M. de Picciotto <d3p1@d3p1.dev> (https://d3p1.dev/)
##

##
# 
# @note Add flag to exit script if there is an error related to a command
#       or if it is used an undefined variable
##
set -eu

##
# Boot Jekyll site with environment configuration file
#
# @param  $1  Script arguments
# @return int Exit code
# @note   For the moment, to avoid overcomplications,
#         the generated configuration file 
#         will have a fixed name: `_config.env.yml`
##
main() {
    ##
    # @note Check if environment configuration file exists
    # @note It is not considered an error 
    #       if the environment configuration file does not exist
    ##
    if [ ! -s "$JEKYLL_ENV_CONF_PATH" ]; then
        echo "$JEKYLL_ENV_CONF_PATH does not exist. Skipping Jekyll boot";
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
# @param  $1  Jekyll site environment configuration filename
# @return int Exit code
##
generate_jekyll_config() {
    ##
    # @note Replace `${VAR}` placeholders by environment variables to generate
    #       configuration file
    ##
    local output_file="$WORK_DIR/$1"
    echo "Running envsubst on $JEKYLL_ENV_CONF_PATH to $output_file"
    envsubst < "$JEKYLL_ENV_CONF_PATH" > "$output_file"
    chown "$JEKYLL_USER:$JEKYLL_GROUP" "$output_file"
}

##
# Build Jekyll
#
# @return int Exit code
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
main "$@"