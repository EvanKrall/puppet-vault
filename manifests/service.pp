# == Class vault::service
#
# This class is meant to be called from vault
# It ensures the service is running
#
class vault::service {
  $init_selector = $vault::init_style ? {
    'launchd' => 'io.vaultproject.daemon',
    default   => 'vault',
  }

  if $vault::manage_service == true {
    service { 'vault':
      ensure => $vault::service_ensure,
      name   => $init_selector,
      enable => $vault::service_enable,
    }
  }
}
