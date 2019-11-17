# Laravel Cloud Run Experiment

This is a small project just to try out making a simple Laravel application
to run on Google Cloud's Cloud Run service.

## Problems Found

* Cloud Run requires any service you want to run in your docker image to have
the port set as via a PORT environment variable set by Cloud Run. This is problematic
for a PHP-FPM/Nginx setup as nginx sets the port in the config.

* Can't use the `gcloud builds submit` command. For some reason this causes the
`vendor` folder to disappear in the final image. Fixed this by building the image
locally and then [pushing it to google container repository service](https://cloud.google.com/container-registry/docs/pushing-and-pulling).

## Improvements to make

* Try replacing nginx with another PHP server (ideally not apache). Thinking [roadrunner](https://roadrunner.dev/)

* Test with config/route caching and cleaning up all the non production files
in the container.

* Test using databases etc.

## References

* Dockerfile is based on the work of [this repo](https://github.com/TrafeX/docker-php-nginx)
which uses nginx and php-fpm.
