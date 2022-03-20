# Docker Container for Sauce Labs Sample App - Web
This docker container will provide the [sample web app from SauceLabs](https://github.com/saucelabs/sample-app-web) on port `3000`, including a slightly modified version, that will alter the login page, in order to demonstrate [AutonomIQ's](https://autonomiq.io) self healing capabilities.

# Configuration options
## Environment Variables
The following environmental variables can be used for configuration:

 - `BRANCH`  
    `default` or empty for the original version, `diff` for the altered version.
 - `PORT`  
    The port to listen on. Defaults to `3000`.

# docker-compose example
For a helper script to quickly switch between the two versions and required assets, see [`docker-compose.d`](https://github.com/steilerDev/saucedemo-docker/tree/main/docker-compose.d/).

The helper scripts can be easily installed by running the following command in the subdirectory, where you want your script to be stored:
```
curl -L https://raw.githubusercontent.com/steilerDev/saucedemo-docker/main/install.sh | bash
```

Usage with `nginx-proxy` inside of predefined `steilerGroup` network for the default version:

```
version: '2'
services:
  sauce-demo:
    image: steilerdev/sauce:latest
    container_name: sauce-demo
    on-failure: 5
    environment:
        VIRTUAL_HOST: "saucedemo.doe.net"
        VIRTUAL_PORT: 3000
        LETSENCRYPT_HOST: "saucedemo.doe.net"
        LETSENCRYPT_EMAIL: "hostmaster@doe.net"
        BRANCH: "default"
networks:
  default:
    external:
      name: steilerGroup
```