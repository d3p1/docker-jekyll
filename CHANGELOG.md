## [1.0.4](https://github.com/d3p1/docker-jekyll/compare/v1.0.3...v1.0.4) (2023-09-18)


### Bug Fixes

* replace Jekyll _conf.env.yml.template file by _config.env.yml.template file [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([9247476](https://github.com/d3p1/docker-jekyll/commit/924747693e2b3bcf53c0c672a686412c7d59f362))

## [1.0.3](https://github.com/d3p1/docker-jekyll/compare/v1.0.2...v1.0.3) (2023-09-17)


### Bug Fixes

* add bundle install to Jekyll build script [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([883b13d](https://github.com/d3p1/docker-jekyll/commit/883b13ddd5600db1a25b6975bca3101568f17f55))

## [1.0.2](https://github.com/d3p1/docker-jekyll/compare/v1.0.1...v1.0.2) (2023-09-14)


### Bug Fixes

* add default command to Dockerfile [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([1872cbe](https://github.com/d3p1/docker-jekyll/commit/1872cbe5e8263005013a5733d3001ba4803b5fe2))
* adjust entrypoint validation [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([c4b899b](https://github.com/d3p1/docker-jekyll/commit/c4b899b04de36d67c26a57099e8e3f7d7c9240be))
* run Nginx as daemon when a Jekyll command is executed [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([6109f23](https://github.com/d3p1/docker-jekyll/commit/6109f236e28f3127721f03270136391ebc104b62))

## [1.0.1](https://github.com/d3p1/docker-jekyll/compare/v1.0.0...v1.0.1) (2023-09-14)


### Bug Fixes

* add Jekyll bootstrap script to Dockerfile [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([63ca300](https://github.com/d3p1/docker-jekyll/commit/63ca3009538413d417080457476dcd4d00332871))
* adjust jekyll-serve bin name [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([f23d5eb](https://github.com/d3p1/docker-jekyll/commit/f23d5eb372c00a4c318764e3eb6f88fc154bb293))
* adjust jekyll-serve permissions [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([995a972](https://github.com/d3p1/docker-jekyll/commit/995a972556f40abe7950d66011e40f558a023ded))
* adjust jekyll-serve validation [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([97ea9c9](https://github.com/d3p1/docker-jekyll/commit/97ea9c9e124e3269b4e52f64a9342d1f21c715f9))
* adjust nginx execution [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([14d5fad](https://github.com/d3p1/docker-jekyll/commit/14d5fad9764e398d9664c5dd171bdb126ccc19d8))
* improve docker entrypoint logic [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([c5ff880](https://github.com/d3p1/docker-jekyll/commit/c5ff88011a6c152925b1b80ab188d996f6653c40))
* improve Dockerfile adding new related scripts [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([f8cbec1](https://github.com/d3p1/docker-jekyll/commit/f8cbec1c54fe76bfaaa075b97035587ca96c1ec4))
* improve Nginx entrypoint script that builds Jekyll [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([4688565](https://github.com/d3p1/docker-jekyll/commit/46885657ab2f67c8fa0c0a54a2c9423d8d4304b6))

# 1.0.0 (2023-09-13)


### Bug Fixes

* adjust COPY instructions to work correctly with directories [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([d319ec5](https://github.com/d3p1/docker-jekyll/commit/d319ec5169b5249ed5c57875b49b0786f822fd4b))
* adjust Jekyll environment configuration file permissions [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([455872a](https://github.com/d3p1/docker-jekyll/commit/455872ae1f577682c9c505c5bffb539ff7ad55a4))
* adjust WORK_DIR environment variable in entrypoint script [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([c23447e](https://github.com/d3p1/docker-jekyll/commit/c23447e1f4203aeddba73c5ac3cab229fa299fbe))
* improve entrypoint script permissions [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([26733db](https://github.com/d3p1/docker-jekyll/commit/26733dbe6fd8fdcf2e1e42cda57b80ab5bf2123b))


### Features

* add default Jekyll environment configuration file [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([0a306e2](https://github.com/d3p1/docker-jekyll/commit/0a306e2e547f650c27c731d80102dddd73c09167))
* add instructions to execute entrypoint script in Dockerfile [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([79ced92](https://github.com/d3p1/docker-jekyll/commit/79ced92509c8acf5f8f21727280c0d17d53daac9))
* add Jekyll vhost configuration [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([bab78cc](https://github.com/d3p1/docker-jekyll/commit/bab78cc047c7d5481cea6426016b8f2cd89acb1a))
* init [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([993b0bf](https://github.com/d3p1/docker-jekyll/commit/993b0bf09a9acd949b5cc864ab99ce204156457d))
* init Dockerfile [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([e75515c](https://github.com/d3p1/docker-jekyll/commit/e75515cbfb435be5bff9a38b4633a6bfcc352d56))
* init Jekyll bootstrap entrypoint script [[#1](https://github.com/d3p1/docker-jekyll/issues/1)] ([8cf683b](https://github.com/d3p1/docker-jekyll/commit/8cf683b5b84a9520198bc07959ee78c8ef30eac1))
