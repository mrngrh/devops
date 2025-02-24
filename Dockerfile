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

# Salin file .htaccess ke direktori kerja untuk konfigurasi Apache.
COPY .htaccess /var/www/html/.htaccess

# Set hak kepemilikan ke user www-data dan izin akses ke file/direktori.
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Buka port 80 agar aplikasi bisa diakses dari luar container.
EXPOSE 80

# Jalankan Apache di foreground saat container aktif.
CMD ["apache2-foreground"]
