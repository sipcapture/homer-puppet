#!/bin/bash
set -x

apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5
echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7" > /etc/apt/sources.list.d/mysql.list

wget https://apt.puppetlabs.com/puppetlabs-release-jessie.deb
dpkg -i puppetlabs-release-jessie.deb
apt-get update
apt-get install -y git puppet

puppet module install puppetlabs-mysql
puppet module install puppetlabs-apt

cd /root
git clone https://github.com/sipcapture/homer-ui
git clone https://github.com/sipcapture/homer-api
git clone https://github.com/sipcapture/homer-puppet

cd homer-puppet
git checkout gv/debian_update

puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff --noop
#puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff --noop
#monit restart kamailio
