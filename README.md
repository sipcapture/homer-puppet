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

Summary of installation procedure
---------------------------------

```
apt update
apt install -y git wget

# Puppet for debian jessie
#wget https://apt.puppetlabs.com/puppetlabs-release-jessie.deb
#dpkg -i puppetlabs-release-jessie.deb

# Puppet for ubuntu xenial
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
dpkg -i puppetlabs-release-pc1-xenial.deb

apt update
apt install -y puppet

# Required Puppet modules (mysql is optional)
puppet module install puppetlabs/stdlib && puppet module install puppetlabs/mysql && puppet module install puppetlabs/apt

# The "source dir" by default is '/root'
# It can be changed by setting 'source_dir => DIR,' in site.pp
# This is where the module expects the source code for homer-ui and homer-api
cd /root
git clone https://github.com/sipcapture/homer-ui
git clone https://github.com/sipcapture/homer-api
git clone https://github.com/sipcapture/homer-puppet
cd homer-puppet
```

# If needed, use the appropriate branch, e.g.:
#git checkout gv/xenial

```
puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff
```

Ensure kamailio is running and watched by monit:

```
monit start kamailio
```


Dependencies
------------

- 'puppetlabs-stdlib'
- 'puppetlabs-mysql'
- 'puppetlabs-apt'

(see [metadata.json](https://github.com/sipcapture/homer-puppet/blob/master/modules/homer/metadata.json))

Tested on
---------

Ubuntu 16.04
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
