[![Logo](http://sipcapture.org/data/images/sipcapture_header.png)](http://sipcapture.org)

# homer-puppet
#### HOMER Puppet Modules

This is a Puppet module to install and configure [Homer](https://github.com/sipcapture/homer)

Define a structure like this:

```
/root/homer-ui  (source code for homer-ui)
/root/homer-api (source code for homer-api)
```

e.g. with:

```
cd /root
https://github.com/sipcapture/homer-ui
https://github.com/sipcapture/homer-api
```

In this case the variable `source_dir` is '/root'. This tells the Puppet module where to get the code for UI and API.

Then checkout `homer-puppet` (this repo), e.g. in '/root'.


Then:

```
cd /root/homer-puppet
```

Depending on your strategy _(hieradata, role/profile, etc)_ things may change, but you can just define ```site.pp``` like:

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

Satisfy puppet dependencies if not already:

```
sudo puppet module install puppetlabs/stdlib
sudo puppet module install puppetlabs/mysql
sudo puppet module install puppetlabs/apt
```

and apply (`noop` first to verify the changes):

```
sudo puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff --noop
sudo puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff
```

Dependencies
------------

- 'puppetlabs-stdlib'
- 'puppetlabs-mysql'
- 'puppetlabs-apt'

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
