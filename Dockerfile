FROM php:8.2-apache
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libicu-dev libzip-dev \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install gd intl zip pdo_mysql mysqli \
 && a2dismod mpm_event mpm_worker || true \
 && a2enmod mpm_prefork rewrite \
 && sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf \
 && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
 && sed -i 's/:80>/:8080>/' /etc/apache2/sites-available/000-default.conf
COPY . /var/www/html/bot/
RUN chown -R www-data:www-data /var/www/html/bot
EXPOSE 8080
CMD ["sh", "-c", "a2dismod mpm_event mpm_worker 2>/dev/null; a2enmod mpm_prefork 2>/dev/null; apache2-foreground"]
