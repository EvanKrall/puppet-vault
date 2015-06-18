# == Class: vault
#
# Installs, configures, and manages vault
#
# === Parameters
#
# [*version*]
#   Specify version of vault binary to download.
#
# [*backend*]
#   The backend configuration dictionary. If unset or undef, the vault service
#   will not be run (vault will only be installed.)
#
# [*listener*]
#   The listener configuration dictionary. Must be set if backend is set.
#
# [*config_hash*]
#   Use this to populate the JSON config file for vault.
#
# [*install_method*]
#   Defaults to `url` but can be `package` if you want to install via a system
#   package.
#
# [*package_name*]
#   Only valid when the install_method == package. Defaults to `vault`.
#
# [*package_ensure*]
#   Only valid when the install_method == package. Defaults to `latest`.
#
# [*extra_options*]
#   Extra arguments to be passed to the vault agent, as an array of strings.
#   Will be shellquoted before being written to init scripts.
#
# [*init_style*]
#   What style of init system your system uses. Valid options are 'upstart',
#   'systemd', 'sysv', 'debian', 'sles', 'launchd'. If unset, this will be
#   auto-detected.
#
# [*purge_config_dir*]
#   Purge config files no longer generated by Puppet.
#
class vault (
  $backend           = undef,
  $listener          = undef,
  $manage_user       = false,
  $user              = 'root',
  $manage_group      = false,
  $group             = 'root',
  $purge_config_dir  = true,
  $bin_dir           = '/usr/local/bin',
  $arch              = $vault::params::arch,
  $version           = $vault::params::version,
  $install_method    = $vault::params::install_method,
  $os                = $vault::params::os,
  $download_url      = "https://dl.bintray.com/mitchellh/vault/vault_${version}_${os}_${arch}.zip",
  $package_name      = $vault::params::package_name,
  $package_ensure    = $vault::params::package_ensure,
  $config_dir        = '/etc/vault',
  $extra_options     = [],
  $config_hash       = {},
  $config_defaults   = {},
  $service_enable    = undef,
  $service_ensure    = 'stopped',
  $manage_service    = false,
  $init_style        = $vault::params::init_style,
) inherits vault::params {

  # with no arguments, we simply install vault.
  anchor {'vault_first': } ->
  class { 'vault::install': } ->
  anchor {'vault_last': }

  # but if $backend is set, assume we want to run the service.
  if $backend {
    validate_bool($purge_config_dir)
    validate_bool($manage_user)
    validate_bool($manage_service)
    validate_hash($backend)
    validate_hash($listener)
    validate_hash($config_hash)
    validate_hash($config_defaults)

    $config_hash_real = merge(
      $config_defaults,
      { backend => $backend },
      { listener => $listener },
      $config_hash
    )
    validate_hash($config_hash_real)

    if $config_hash_real['data_dir'] {
      $data_dir = $config_hash_real['data_dir']
    }

    Class['vault::install'] ->
    class { 'vault::config':
      config_hash => $config_hash_real,
      purge       => $purge_config_dir,
    } ~>
    class { 'vault::service': } ->
    Anchor['vault_last']
  }
}
