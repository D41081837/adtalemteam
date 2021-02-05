#!/usr/bin/env php
<?php
// phpcs:ignoreFile
$alias_locations = [
  "/var/www/robertshell/scripts/setup/bashrc",
];

foreach ($alias_locations as $alias_location) {
  if (file_exists($alias_location)) {
    $bashrc_file = "/home/vagrant/.bashrc";
    $bashrc_contents = file_get_contents($bashrc_file);
    $alias_contents = file_get_contents($alias_location);
    // Add aliases to end of .bashrc.
    $new_bashrc_contents = $bashrc_contents . $alias_contents;
    file_put_contents($bashrc_file, $new_bashrc_contents);
    break;
  }
}
if (!isset($bashrc_file)) {
  echo "Cannot find bashrc file to install.";
  exit(1);
}