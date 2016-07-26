# puppet-vault
Puppet module for managing Hashicorp's [Vault](https://vaultproject.io/)

##Prerequisites
This module requires:

- [puppet-archive](https://github.com/nanliu/puppet-staging)
- a `zip` package to be installed (eg `package { "zip": ensure => installed }`)

##Installation

To simply install the vault binary:

```puppet
include vault
```

To run it in server mode:
```puppet
class { 'vault':
  service_enable => true,
  service_ensure => 'running',
  manage_service => true,
}
```

## What this module handles
This module handles installing the vault binary, writing a config file for server mode, and creating an init script.

It does not:

 - [initialize](https://vaultproject.io/intro/getting-started/deploy.html) the vault
 - [unseal](https://www.vaultproject.io/docs/concepts/seal.html) the vault on startup
 - Provide a way to get secrets from Vault within puppet. For that, look at [puppet-vaultize-file](https://github.com/EvanKrall/puppet-vaultize-file)

##Development
Open an [issue](https://github.com/EvanKrall/puppet-vault/issues) or
[fork](https://github.com/EvanKrall/puppet-vault/fork) and open a
[Pull Request](https://github.com/EvanKrall/puppet-vault/pulls)

##Acknowledgements

Much of the initial code was adapted from [solarkennedy/puppet-consul](https://github.com/solarkennedy/puppet-consul). Thank you to the contributors to that project.
