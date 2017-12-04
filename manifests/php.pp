define limp::php (
  $xdebug  = false,
  $version = "70"
) {


  $php = "php$version-php"

  $phpcommon = [
    "$php-common",
    "$php-cli",

  ]




  package { $phpcommon: ensure => present, }

  $phpextras = [
    "${php}-curl",
    "${php}-gd",
    "${php}-imap",
    "${php}-mbstring",
    "${php}-mcrypt",
    "${php}-mysql",
    "${php}-odbc",
    "${php}-soap",
    "${php}-xml",
    "${php}-xmlrpc",
    "${php}-xsl",
    "${php}-zip",
    "${php}-bz2",
    "${php}-ldap"

  ]


  package { $phpextras:
    ensure  => present,
    require => Package[$phpcommon],
  }

  if !defined(Package['php-pear']) {
    package { 'php-pear':
      require => Package[$phpcommon]
    }
  }

  if !defined(Package['composer']) {
    package { 'composer':
      ensure  => present,
      require => Package[$phpcommon]
    }
  }

  if $xdebug and !defined(Package['php-xdebug']) {
    package { 'php-xdebug':
      ensure  => present,
      require => Package[$phpcommon]
    }
  }


}


define fuse::php::fpm (
  $php_devmode         = false,
  $fpm_user            = "www-data",
  $fpm_group           = "www-data",
  $fpm_listen          = "127.0.0.1:9000",
  $fpm_allowed_clients = "127.0.0.1",
  $php_version         = "5.6",
  $newrelic            = false
) {

  $phpfpm = "php${php_version}-fpm"

  package { $phpfpm: ensure => present, require => [Class["fuse::ppa"], Class["apt::update"], Fuse::Php[$php_version]],
  } ->
  service {
    $phpfpm:
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      restart    => "/etc/init.d/$phpfpm restart"
  }

  $_poolconf = regsubst($name, '[\W\s]', "_")
  $poolconf = "pool-$_poolconf.conf"

  file { $poolconf:
    path    => "/etc/php/$php_version/fpm/pool.d/${poolconf}",
    owner   => "root",
    group   => "root",
    mode    => '0644',
    notify  => Service[$phpfpm],
    require => Package[$phpfpm],
    content => template("fuse/pool.conf.erb")
  }
  if ($newrelic) {
    fuse::newrelic::agent { $name: php_version => $php_version, require => File[$poolconf] }
  }
}

define fuse::php::ini (
  $php_version          = "5.6",
  $php_devmode          = false,
  $max_input_time       = 60,
  $max_execution_time   = 30,
  $upload_max_filesize  = '2M',
  $post_max_size        = '8M',
  $xdebug_remote_enable = $php_devmode,
  $xdebug_remote_mode   = undef,
  $xdebug_remote_host   = '10.0.2.2',
  $xdebug_remote_port   = undef

) {

  if $name =~ /fpm|cli|apache2/ {
    $phpini = "/etc/php/$php_version/$name/php.ini"
    if $php_devmode {
      notice("PHP.ini using Development settings")

      $_memory_limit = $memorysize_mb * 512 / 8000
      if ($_memory_limit < 512) {
        $memory_limit = 255 + 1
      }else {
        $memory_limit = $_memory_limit
      }
      $xdebug_extras_ensure = 'link'
    }else {
      notice("PHP.ini using Production settings")
      $memory_limit = 511 + 1
      $xdebug_extras_ensure = 'absent'
    }

    notice("PHP Memory Limit is $memory_limit of $memorysize_mb")

    case $name {
      'fpm': { $service = "php$php_version-fpm" }
      'apache2': { $service = "apache2" }
    }
    $php_xdebug_extras = "/etc/php/$php_version/mods-available/xdebug-dev.ini"
    file { $php_xdebug_extras:
      content => template("fuse/php_xdebug.ini.erb")
    } ->
    file { "/etc/php/$php_version/fpm/conf.d/99-xdebug-dev.ini":
      target => $php_xdebug_extras,
      ensure => $xdebug_extras_ensure
    } ->
    file { "$phpini":
      path    => $phpini,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      notify  => Service[$service],
      require => Package[$service],
      content => template("fuse/php.ini.erb")
    }
    -> exec { "restart_php_${php_version}":
      command => "/etc/init.d/php${php_version}-fpm force-reload"
    }


  }else {
    fail("PHP ini sapi not valid $name")
  }


}
