#!/bin/sh

##
# @description Script to serve Jekyll
# @author      C. M. de Picciotto <d3p1@d3p1.dev> (https://d3p1.dev/)
# @note        The idea of this script is to run it as the 
#              Docker entrypoint command. 
#              It builds Jekyll with a custom configuration
#              and also executes Nginx startup processes
# @link https://github.com/nginxinc/docker-nginx/blob/master/entrypoint/docker-entrypoint.sh
##

##
# @note Add flag to exit script if there is an error related to a command
##
set -e

##
# Main
#
# @param  $1  Script arguments
# @return int Exit code
##
main() {
    ##
    # @note Define bootstrap scripts
    ##
    local jekyll="/docker-entrypoint.d/jekyll/bootstrap.sh"
    local nginx="/docker-entrypoint.sh"

    ##
    # @note Check if scripts have needed permissions to execute them
    ##
    echo "Trying to boot Jekyll and Nginx..."
    if [ -x $jekyll ] && [ -x $nginx ]; then
        ##
        # @note Boot Jekyll
        ##
        "$jekyll"

        ##
        # @note Boot Nginx
        # @note It is used `exec` to avoid the creation of a subshell 
        #       and to be able to send signals to this process
        ##
        exec "$nginx" nginx -g 'daemon off;'
    else
        ##
        # @note Log error
        ##
        echo "It is not possible to execute $jekyll and $nginx :("
        return 1;
    fi 
}

##
# @note Execute main function
##
main "$@"