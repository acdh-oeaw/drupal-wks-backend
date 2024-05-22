
/**
 * new sync directory
 */
$settings['config_sync_directory'] = '/var/www/drupal/config';

/**
 * database settings
 */
$databases['default']['default'] = array (
  'database' => 'DBNAME',
  'username' => 'DBUSER',
  'password' => 'DBPSWD',
  'prefix' => 'DBPREFIX',
  'host' => 'DBHOST',
  'port' => 'DBPORT',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
  'init_commands' => [
    'isolation_level' => 'SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED',
  ],
);

