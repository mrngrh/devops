# Gunakan image dasar PHP 7.4 dengan Apache.
FROM php:7.4-apache

# Set direktori kerja di dalam container ke /var/www/html
WORKDIR /var/www/html

# Salin semua file dari project lokal ke dalam container.
COPY . /var/www/html/

# Install ekstensi PHP: mysqli, pdo, dan pdo_mysql untuk koneksi MySQL.
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Aktifkan modul mod_rewrite di Apache untuk dukungan URL rewriting.
RUN a2enmod rewrite

# Ubah konfigurasi Apache agar mengizinkan .htaccess
RUN echo "<Directory /var/www/html/> \
    AllowOverride All \
    Require all granted \
</Directory>" > /etc/apache2/conf-available/allow-override.conf \
    && a2enconf allow-override

# Salin file .htaccess ke direktori kerja untuk konfigurasi Apache.
COPY .htaccess /var/www/html/.htaccess

# Set hak kepemilikan ke user www-data dan izin akses ke file/direktori.
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Buka port 80 agar aplikasi bisa diakses dari luar container.
EXPOSE 80

# Jalankan Apache di foreground saat container aktif.
CMD ["apache2-foreground"]