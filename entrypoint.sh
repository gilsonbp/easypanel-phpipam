#!/bin/sh
set -e

cat > /var/www/html/config.php <<EOF
<?php

/* Database connection details */
\$db['host'] = "${IPAM_DATABASE_HOST}";
\$db['user'] = "${IPAM_DATABASE_USER}";
\$db['pass'] = "${IPAM_DATABASE_PASS}";
\$db['name'] = "${IPAM_DATABASE_NAME}";
\$db['port'] = "${IPAM_DATABASE_PORT:-3306}";

define('BASE', "/");

\$disable_installer = false;

?>
EOF

chown -R www-data:www-data /var/www/html/app/admin/import-export/
chown -R www-data:www-data /var/www/html/app/subnets/import-subnet/
chown -R www-data:www-data /var/www/html/uploads/

exec "$@"