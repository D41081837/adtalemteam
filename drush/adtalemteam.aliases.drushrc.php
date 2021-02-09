<?php

/**
 * Drupal VM drush aliases.
 *
 * Ansible managed
 */

$aliases['dev'] = array(
  'uri' => 'adtalemteam.dev',
  'root' => '/var/www/dev.adtalem.team/html',
  'remote-host' => '68.183.57.65',
  'remote-user' => 'root',
  'ssh-options' => '-o PasswordAuthentication=no -i "~/.ssh/secure_private_key"',
  'path-aliases' => array(
    '%drush-script' => '/var/www/dev.adtalem.team/vendor/drush/drush/drush',
  ),
);

$aliases['local'] = array(
  'uri' => 'adtalemteam.local',
  'root' => '/var/www/adtalemteam/html',
  'remote-host' => 'adtalemteam.local',
  'remote-user' => 'vagrant',
  'ssh-options' => '-o PasswordAuthentication=no -i "~/.ssh/secure_private_key"',
  'path-aliases' => array(
    '%drush-script' => '/var/www/adtalemteam/vendor/bin/drush',
  ),
);

$aliases['live'] = array(
  'uri' => 'adtalemteam.live',
  'root' => '/var/www/adtalem.team/html',
  'remote-host' => '68.183.57.65',
  'remote-user' => 'root',
  'ssh-options' => '-o PasswordAuthentication=no -i "~/.ssh/secure_private_key"',
  'path-aliases' => array(
    '%drush-script' => '/var/www/adtalem.team/vendor/drush/drush/drush',
  ),
);

$aliases['test'] = array(
  'uri' => 'adtalemteam.test',
  'root' => '/var/www/stg.adtalem.team/html',
  'remote-host' => '68.183.57.65',
  'remote-user' => 'root',
  'ssh-options' => '-o PasswordAuthentication=no -i "~/.ssh/secure_private_key"',
  'path-aliases' => array(
    '%drush-script' => '/var/www/stg.adtalem.team/vendor/drush/drush/drush',
  ),
);

