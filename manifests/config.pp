# == Class vault::config
#
# This class is called from vault::init to install the config file.
#
# == Parameters
#
# [*config_hash*]
#   Hash for vault to be deployed as JSON
#
# [*purge*]
#   Bool. If set will make puppet remove stale config files.
#
class vault::config(
  $config_hash,
  $purge = true,
) {

  if $vault::init_style {

    case $vault::init_style {
      'upstart' : {
        file { '/etc/init/vault.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('vault/vault.upstart.erb'),
        }
        file { '/etc/init.d/vault':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/vault.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('vault/vault.systemd.erb'),
        }
      }
      'sysv' : {
        file { '/etc/init.d/vault':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('vault/vault.sysv.erb')
        }
      }
      'debian' : {
        file { '/etc/init.d/vault':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('vault/vault.debian.erb')
        }
      }
      'sles' : {
        file { '/etc/init.d/vault':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('vault/vault.sles.erb')
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.vaultproject.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('vault/vault.launchd.erb')
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${vault::init_style}")
      }
    }
  }

  file { $vault::config_dir:
    ensure  => 'directory',
    purge   => $purge,
    recurse => $purge,
  } ->
  file { 'vault config.json':
    path    => "${vault::config_dir}/config.json",
    content => vault_sorted_json($config_hash),
  }

}
