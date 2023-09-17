#!/bin/sh

##
# @description Docker entrypoint
# @author      C. M. de Picciotto <d3p1@d3p1.dev> (https://d3p1.dev/)
# @note        This entrypoint works as a wrapper of the Nginx entrypoint. 
#              It adds a layer of validation to check if the container command
#              to run is related to Jekyll. If this is the case, it will run
#              `nginx` as a background process and will allow the Jekyll command 
#              to be the main process of the container 
#              (it will run in the foreground). In this way, it is possible to
#              run commands like `bundle exec jekyll build --watch` for 
#              development purposes (remember that the command to be run 
#              must maintain an active process 
#              if we want the container to stay up) 
# @link https://github.com/nginxinc/docker-nginx/blob/1.25.2/entrypoint/docker-entrypoint.sh
##

##
# @note Add flag to exit script if there is an error related to a command
##
set -e

##
# Main
#
# @param  string $1 Script to run
# @return void
##
main() {
    ##
    # @note Check if the command to run is related to Jekyll
    # @note Remember that the first container argument is 
    #       the name of the script to run
    ##
    if [ "$1" = "bundle" ] || [ "$1" = "jekyll" ]; then
        ##
        # @note Run Nginx entrypoint to bootstrap server 
        #       with needed configuration
        # @note Run Nginx as daemon
        ##
        /docker-entrypoint.sh nginx -g 'daemon on;'

        ##
        # @note Exec Jekyll command as main process
        # @note It is used `exec` to avoid the creation of a subshell
        #       and run the command as the main process 
        #       (in this way, it is possible to send signals to this process)
        ##
        exec "$@"
    else
        ##
        # @note If the command is not related to Jekyll, 
        #       just delegate responsibility for execution to the 
        #       default entrypoint (Nginx entrypoint) 
        # @note It is used `exec` to avoid the creation of a subshell
        #       and run the command as the main process 
        #       (in this way, it is possible to send signals to this process)
        ##
        exec /docker-entrypoint.sh "$@"
    fi 
}

##
# @note Execute main function
##
main "$@"