<?php

/**
 * Drupal VM drush aliases.
 *
 * Ansible managed
 */

$aliases['dev'] = array(
  'uri' => 'adtalemteam.dev',
  'root' => '/var/www/dev.adtalem.team/html',
  'remote-host' => 'dev.adtalem.team',
  'remote-user' => 'root',
  'ssh-options' => '-o "SendEnv PHP_IDE_CONFIG PHP_OPTIONS XDEBUG_CONFIG" -o PasswordAuthentication=no -i "' . (getenv('VAGRANT_HOME') ?: drush_server_home() . '/.ssh') . '/secure_private_key"',
  'path-aliases' => array(
    '%drush-script' => '/var/www/dev.adtalem.team/vendor/drush/drush/drush',
  ),
);

$aliases['local'] = array(
  'uri' => 'adtalemteam.local',
  'root' => '/var/www/adtalemteam/html',
  'remote-host' => 'adtalemteam.local',
  'remote-user' => 'vagrant',
  'ssh-options' => '-o "SendEnv PHP_IDE_CONFIG PHP_OPTIONS XDEBUG_CONFIG" -o PasswordAuthentication=no -i "' . (getenv('VAGRANT_HOME') ?: drush_server_home() . '/.vagrant.d') . '/insecure_private_key"',
  'path-aliases' => array(
    '%drush-script' => '/var/www/adtalemteam/vendor/bin/drush',
  ),
);

$aliases['live'] = array(
  'uri' => 'adtalemteam.live',
  'root' => '/var/www/adtalem.team/html',
  'remote-host' => 'adtalem.team',
  'remote-user' => 'root',
  'ssh-options' => '-o "SendEnv PHP_IDE_CONFIG PHP_OPTIONS XDEBUG_CONFIG" -o PasswordAuthentication=no -i "' . (getenv('VAGRANT_HOME') ?: drush_server_home() . '/.ssh') . '/secure_private_key"',
  'path-aliases' => array(
    '%drush-script' => '/var/www/adtalem.team/vendor/drush/drush/drush',
  ),
);

$aliases['test'] = array(
  'uri' => 'adtalemteam.test',
  'root' => '/var/www/stg.adtalem.team/html',
  'remote-host' => 'stg.adtalem.team',
  'remote-user' => 'root',
  'ssh-options' => '-o "SendEnv PHP_IDE_CONFIG PHP_OPTIONS XDEBUG_CONFIG" -o PasswordAuthentication=no -i "' . (getenv('VAGRANT_HOME') ?: drush_server_home() . '/.ssh') . '/secure_private_key"',
  'path-aliases' => array(
    '%drush-script' => '/var/www/stg.adtalem.team/vendor/drush/drush/drush',
  ),
);

