FROM alpine:3.10

# Install packages
RUN apk --no-cache add php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
    php7-mbstring php7-gd php7-tokenizer nginx supervisor curl

COPY etc/config/nginx.conf /etc/nginx/nginx.conf

# Configure nginx
COPY etc/config/nginx.conf /etc/nginx/nginx.conf
# Remove default server definition
RUN rm /etc/nginx/conf.d/default.conf

RUN chown -R nobody.nobody /etc/nginx

# Configure PHP-FPM
COPY etc/config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY etc/config/php.ini /etc/php7/conf.d/custom.ini

# Configure supervisord
COPY etc/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add start up script
COPY etc/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/tmp/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Setup document root
RUN mkdir -p /var/www/html

# Copy the site
COPY --chown=nobody ./ /var/www/html

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html

EXPOSE 8080

ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
