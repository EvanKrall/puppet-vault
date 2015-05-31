# == Class vault::intall
#
# Installs vault based in the parameters from init
#
class vault::install {

  if $vault::data_dir {
    file { $vault::data_dir:
      ensure => 'directory',
      owner  => $vault::user,
      group  => $vault::group,
      mode   => '0755',
    }
  }

  if $vault::install_method == 'url' {

    if $::operatingsystem != 'darwin' {
      ensure_packages(['unzip'])
    }
    staging::file { 'vault.zip':
      source => $vault::download_url
    } ->
    staging::extract { 'vault.zip':
      target  => $vault::bin_dir,
      creates => "${vault::bin_dir}/vault",
    } ->
    file { "${vault::bin_dir}/vault":
      owner => 'root',
      group => 0, # 0 instead of root because OS X uses "wheel".
      mode  => '0555',
    }

    if ($vault::ui_dir and $vault::data_dir) {
      file { "${vault::data_dir}/${vault::version}_web_ui":
        ensure => 'directory',
        owner  => 'root',
        group  => 0, # 0 instead of root because OS X uses "wheel".
        mode   => '0755',
      } ->
      staging::deploy { 'vault_web_ui.zip':
        source  => $vault::ui_download_url,
        target  => "${vault::data_dir}/${vault::version}_web_ui",
        creates => "${vault::data_dir}/${vault::version}_web_ui/dist",
      }
      file { $vault::ui_dir:
        ensure => 'symlink',
        target => "${vault::data_dir}/${vault::version}_web_ui/dist",
      }
    }

  } elsif $vault::install_method == 'package' {

    package { $vault::package_name:
      ensure => $vault::package_ensure,
    }

    if $vault::ui_dir {
      package { $vault::ui_package_name:
        ensure => $vault::ui_package_ensure,
      }
    }

  } else {
    fail("The provided install method ${vault::install_method} is invalid")
  }

  if $vault::manage_user {
    user { $vault::user:
      ensure => 'present',
    }
  }
  if $vault::manage_group {
    group { $vault::group:
      ensure => 'present',
    }
  }
}
