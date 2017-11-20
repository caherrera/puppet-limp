class limp::nginx {
  include ::nginx

}
define limp::nginx::vhost (
  Enum['absent', 'present'] $ensure = 'present',
  $server_name                      = undef,
  $server_alias                     = undef,
  $document_root                    = '/var/www/html/',
  $access_log                       = "/var/log/nginx/access-$name.log",
  $error_log                        = "/var/log/nginx/error-$name.log",
  $fastcgi                          = undef,

  $absolute_redirect                = undef,
  $aio                              = undef,
  $aio_write                        = undef,
  $chunked_transfer_encoding        = undef,
  $client_body_buffer_size          = undef,
  $client_body_in_file_only         = undef,
  $client_body_in_single_buffer     = undef,
  $client_body_temp_path            = undef,
  $client_body_timeout              = undef,
  $client_header_buffer_size        = undef,
  $client_header_timeout            = undef,
  $client_max_body_size             = undef,
  $connection_pool_size             = undef,
  $default_type                     = undef,
  $directio                         = undef,
  $directio_alignment               = undef,
  $disable_symlinks                 = undef,
  $etag                             = undef,
  $fastcgi_read_timeout             = undef,
  $if_modified_since                = undef,
  $ignore_invalid_headers           = undef,
  $keepalive_disable                = undef,
  $keepalive_requests               = undef,
  $keepalive_timeout                = undef,
  $large_client_header_buffers      = undef,
  $limit_rate                       = undef,
  $limit_rate_after                 = undef,
  $lingering_close                  = undef,
  $lingering_time                   = undef,
  $lingering_timeout                = undef,
  String $listen                    = "80 ",
  String $listen_ipv6               = "[::]:80",
  $log_not_found                    = undef,
  $log_subrequest                   = undef,
  $merge_slashes                    = undef,
  $msie_padding                     = undef,
  $msie_refresh                     = undef,
  $open_file_cache                  = undef,
  $open_file_cache_errors           = undef,
  $open_file_cache_min_uses         = undef,
  $open_file_cache_valid            = undef,
  $output_buffers                   = undef,
  $port_in_redirect                 = undef,
  $postpone_output                  = undef,
  $read_ahead                       = undef,
  $recursive_error_pages            = undef,
  $request_pool_size                = undef,
  $reset_timedout_connection        = undef,
  $resolver_timeout                 = undef,
  $root                             = undef,
  $satisfy                          = undef,
  $send_lowat                       = undef,
  $send_timeout                     = undef,
  $sendfile                         = undef,
  $sendfile_max_chunk               = undef,
  $server_tokens                    = undef,
  $tcp_nodelay                      = undef,
  $tcp_nopush                       = undef,
  $types_hash_bucket_size           = undef,
  $types_hash_max_size              = undef,
  $underscores_in_headers           = undef

) {

  if ($server_name == "") {
    $nginx_server_name = $name
  }else {
    $nginx_server_name = $server_name
  }
  $vhostconf = "vhost-$name.conf"
  $nginx_server_alias = $server_alias



  file { "/etc/nginx/sites-available/$vhostconf":
    ensure  => present,
    content => template('limp/vhost-nginx-conf.erb'),
  }


  file { "/etc/nginx/sites-enabled/$vhostconf":
    ensure  => link,
    target  => "/etc/nginx/sites-available/$vhostconf",
    require => [Package['nginx'], File["/etc/nginx/sites-available/$vhostconf"]],


  }


}