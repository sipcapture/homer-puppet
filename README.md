[![Logo](http://sipcapture.org/data/images/sipcapture_header.png)](http://sipcapture.org)

# homer-puppet
#### HOMER Puppet Modules

This is a Puppet module to install and configure [Homer](https://github.com/sipcapture/homer)

Installing directly on the target host
--------------------------------------

Define a structure like this:

```
/root/homer-ui  (source code for homer-ui)
/root/homer-api (source code for homer-api)
```

In this case the variable `source_dir` is '/root'. This tells the Puppet module where to get the code for UI and API.

Then checkout `homer-puppet` (this repo), e.g. in '/root'.


Then:

```
cd /root/homer-puppet
```

Depending on your strategy _(hieradata, role/profile, etc)_ things may change, but you can just define the ```puppet/site.pp``` like:

```
node default {
    class { 'homer':
        manage_mysql        => true,
        mysql_password      => 'astrongone',
        mysql_root_password => 'averystrongone',
        ui_admin_password   => 'theadmin123',
    }
}
```

Using Docker
------------

If you set `use_docker` to `true`, then Puppet will manage two containers, one from `kamailio_image` and one from `ui_api_image`.
The images can be built in advance, then their names passed to the Homer module, e.g.:

```
node default {
    class { 'homer':
        base_dir            => '/homer',
        compose_bin         => '/usr/local/bin/docker-compose',
        compose_dir         => '/homer-docker',
        kamailio_image      => 'gvacca/kamailio_image',
        manage_mysql        => true,
        mysql_password      => 'astrongone',
        mysql_root_password => 'averystrongone',
        ui_admin_password   => 'theadmin123',
        ui_api_image        => 'gvacca/ui_api_image',
        use_docker          => true,
    }
}
```

This module manages the containers with Docker Compose. At each run Compose tries to pull the images to ensure they are at latest version.

Applying Puppet
---------------

This module can be used with Puppet in Master/Slave, but also directly on the target host, in stand-alone mode, with:

```
sudo puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff --noop
sudo puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff
```

(`noop` first to verify the changes).

Dependencies
------------

- 'puppetlabs-stdlib'
- 'puppetlabs-mysql'
- 'puppetlabs-apt'
- 'garethr-docker' (only with `use_docker` true)

(see [metadata.json](https://github.com/sipcapture/homer-puppet/blob/master/modules/homer/metadata.json))

Tested on
---------

Ubuntu 14.04

Debian 8.3

License
-------

GPLv2

Contact
-------

giacomo.vacca@gmail.com


Support
-------

Please log tickets and issues at our [Projects site](https://github.com/sipcapture/homer-puppet)
