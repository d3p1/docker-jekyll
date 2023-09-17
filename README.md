<div align=center>

# [DOCKER FT. JEKYLL]

[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)
[![Release](https://github.com/d3p1/docker-jekyll/actions/workflows/release.yml/badge.svg)](https://github.com/d3p1/docker-jekyll/actions/workflows/release.yml)

</div>

## Introduction

As a developer, I am an avid blogger :no_mouth: and I'd like to share a [Docker](https://www.docker.com/) image that can help both me and the community get started with the best static site generator for blogs:

[![Jekyll](./docs/jekyll.jpg)](https://jekyllrb.com/)

Most of the images found for working with [Jekyll](https://jekyllrb.com/) tend to have certain issues that this implementation aims to address (or tries to):

- They often have a considerable size compared to what is believed to be necessary
- They usually run with the `root` user, which can cause minor difficulties in managing permissions between the local development environment and the container's remote environment
- It is believed that in a production environment, there is a strong dependency on the web server that will serve the static content. Therefore, providing this service embedded in the image is thought to allow for a much cleaner implementation in this environment

In this way, with the goal of solving these problems and providing an easy-to-use solution, this image:

- Is based on the [Alpine image of Nginx](https://hub.docker.com/_/nginx) to attempt to ensure that it does not have more size than necessary and provide a web server with a recommended out-of-the-box configuration
- Comes with the `jekyll` user for working with it in development environments, which can be used in [Dev Containers](https://containers.dev/) or similar setups (this user has the necessary permissions to install [Ruby gems](https://rubygems.org/)).
- Similar to the [Nginx image](https://hub.docker.com/_/nginx), this image also makes it easy to create configuration files with environment variables. For example, it allows the creation of a configuration file that receives the URL of the site/environment where it will run.

In the following section, these aspects are elaborated upon, along with an explanation of how to use the image.

## Usage

This image comes with configuration templates for both [Nginx](https://www.nginx.com/) and [Jekyll](https://jekyllrb.com/).

_(Note: Configuration templates are simply files that capture values from the environment in which they are running to create the final files that the services will use)_

In this way, both the [Nginx configuration template](https://github.com/d3p1/docker-jekyll/blob/v1.0.2/nginx/etc/jekyll.conf.template) and the [Jekyll configuration template](https://github.com/d3p1/docker-jekyll/blob/v1.0.2/jekyll/etc/_conf.env.yml.template) rely on the `${HOST}` environment variable. This environment variable should point to the URL that the site will use, so both [Nginx](https://www.nginx.com/) and the [Jekyll](https://jekyllrb.com/) site are correctly configured.

### Production use

To use this image in a production environment (or any environment that is not for development purposes), you could use, for example:

```
docker run -d -p 80:80 --env HOST=example.com d3p1/jekyll:nginx-alpine3.18
```

Where `example.com` is the domain that the site will use in that environment.

### Development use

To use this image in a development environment, you could use, for example:

```
docker run -d -p 80:80 --env HOST=example.test d3p1/jekyll:nginx-alpine3.18 bundle exec jekyll build --watch
```

Where `example.test` is the domain that our site will use in that environment.

_(Note: The container is passed the command `bundle exec jekyll build --watch`, which allows it to build with every change made in the source code, providing a smooth development experience)_

## Brief technical overview

The container already comes with a default [Jekyll](https://jekyllrb.com/) site at `/var/www`, so it can be used and worked on. This location is defined in the `${DOCUMENT_ROOT}` environment variable, which is used for [certain web server configurations](https://github.com/d3p1/docker-jekyll/blob/v1.0.2/nginx/etc/jekyll.conf.template#L17), so it is usually not recommended to modify it unless you know what you are doing.

Regarding [Nginx](https://www.nginx.com/), a [standard/recommended/optimized configuration file](https://github.com/d3p1/docker-jekyll/blob/v1.0.2/nginx/etc/jekyll.conf.template) is provided to serve [Jekyll](https://jekyllrb.com/) content. This configuration file will use the value of `${HOST}` to correctly point its [`server_name`](http://nginx.org/en/docs/http/server_names.html) to the site's URL and handle requests coming from there.

Regarding [Jekyll](https://jekyllrb.com/), the `${HOST}` value will be used for the [`url`](https://jekyllrb.com/docs/variables/#site-variables) value, which is used to define the URLs of the site's links. When the container starts, the configuration file will be created at `${DOCUMENT_ROOT}/_config.env.yml`, so that a site build can be performed using it: `bundle exec jekyll build --config _config.yml,_config.env.yml`.

## Changelog

Detailed changes for each release are documented in [`CHANGELOG.md`](./CHANGELOG.md).

## License

This work is published under [MIT License](./LICENSE).

## Author

Always happy to receive a greeting on:

- [LinkedIn](https://www.linkedin.com/in/cristian-marcelo-de-picciotto/) 
- [Twitter](https://twitter.com/___d3p1)
- [Web](https://d3p1.dev/)
