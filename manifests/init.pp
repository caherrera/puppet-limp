# Class: limp
# ===========================
#
# Full description of class limp here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'limp':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class limp (
  String $php_version        = "5.6",
  String $mysql_rootpassword = 'mV=[b,?GUwM7K/%@'
) {


  class { 'limp::ppa':
    notify => Class['apt::update']

  }

  package { 'git':
    ensure  => latest,
    require => [Class['limp::ppa'], Class['Apt::Update']],
  }

  class { '::nginx': }

  class { '::php::globals':
    php_version => $php_version,
    config_root => "/etc/php/$php_version",
  } ->
  class { '::php':
    manage_repos => true,
    extensions   => {

      'curl'     => {},
      'gd'       => {},
      'imap'     => {},
      'mbstring' => {},
      'mcrypt'   => {},
      'mysql'    => {},
      'odbc'     => {},
      'soap'     => {},

      'xmlrpc'   => {},
      'xsl'      => {},
      'zip'      => {},
      'bz2'      => {},
      'ldap'     => {}


    }
  }

  class { '::mysql::server':
    root_password => $mysql_rootpassword,
  }


}
