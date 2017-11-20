define limp::site (
  Enum['absent', 'present'] $ensure = 'present',

  String $fastcgi                   = "127.0.0.1:9000",
  String $document_root             = "/var/www/html/$name",
  String $server_name               = "$name",
  Boolean $default                  = true,
  Integer $listen_port              = 80
) {

  if ($default) {
    $_listen_port = "$listen_port default_server"
  }else {
    $_listen_port = $listen_port
  }

  exec { "mkidr_$document_root":
    command => "/bin/mkdir -p $document_root",
    path    => "/bin",


  }

  include limp::nginx
  limp::nginx::vhost { $name:
    document_root => $document_root,
    fastcgi       => $fastcgi,
    server_name   => $server_name,
    ensure        => $ensure,
    listen        => $_listen_port,
    notify        => Service['nginx']
  }


}