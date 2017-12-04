define limp::repo (
  Pattern $version = '70'
) {

  yumrepo { "remi-php$version":
    descr      => 'Remi\'s PHP 7.0 RPM repository for Enterprise Linux $releasever - $basearch',
    mirrorlist => "https://rpms.remirepo.net/enterprise/7/php$version/mirror",
    enabled    => 1,
    gpgcheck   => 1,
    gpgkey     => 'https://rpms.remirepo.net/RPM-GPG-KEY-remi',
    priority   => 1,
  }
}