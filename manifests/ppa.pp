class limp::ppa {
  require apt
  $p = ["software-properties-common", "python-software-properties" ]
  package { $p: ensure => present }

  apt::ppa { 'ppa:git-core/ppa': require => Package[$p] }

}