
# limp

Welcome to your new module. A short overview of the generated parts can be found in the PDK documentation at https://puppet.com/pdk/latest/pdk_generating_modules.html .

The README template below provides a starting point with details about what information to include in your README.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with limp](#setup)
    * [What limp affects](#what-limp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with limp](#beginning-with-limp)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module allows to install on Debian OS Family:
- nginx
- php
- mysql

## Setup

### Setup Requirements **OPTIONAL**

    * puppet >= 6.0.0 < 7.0.0
    * puppetlabs-stdlib >= 4.25.1
    * puppetlabs-apt >= 6.3.0
    * puppet-nginx >= 0.16.0
    * puppet-php >= 6.0.3
    * puppetlabs-mysql >= 9.1.0

### Beginning with limp

install via git

```bash
git clone https://github.com/caherrera/puppet-limp.git /path/to/your/puppet/modules
```

## Usage

### Basic
for install a complete linux/nginx/mysql/php using current versions

```puppet
include limp
```

### setting up a virtual host with php
```puppet
include limp
::limp:resource:server{'hostname':
  www_root => '/var/www/html/myapp/public'
}

```

## Limitations

Use only on debian os family 

## Development



## Release Notes

### Version 0.1.0
* Original commit based on a old customization module for a former employer Salmat (2015)
* Updating dependencies to available versions on 2018

### Version 4.8.1
* Change Versioning to Ubuntu Format: Mayor=Year,Minor=Month,revision=changes
* Updating dependencies to available versions on 2019
