#
# Copyright 2016 (C) Giacomo Vacca <giacomo.vacca@gmail.com>
#
#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version
#
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
## homer::kamailio
class homer::kamailio(
    $listen_proto,
    $listen_if,
    $listen_port,
    $kamailio_etc_dir,
    $kamailio_mpath,
    $mysql_user,
    $mysql_password,
) {
    $manage_systemd = false

    case $::lsbdistcodename {
        'trusty': {
            include 'homer::kamailio::apt'
            $manage_kamailio_package = true
         }
        'precise': {
            include 'homer::kamailio::apt'
            $manage_kamailio_package = true
         }
        'jessie': {
            include 'homer::kamailio::apt'
            $manage_kamailio_package = true
         }
        'wheezy': {
            include 'homer::kamailio::apt'
            $manage_kamailio_package = true
         }
        'squeeze': {
            include 'homer::kamailio::apt'
            $manage_kamailio_package = true
         }
        'xenial': {
            $manage_kamailio_package = false
        }
    }

    if ($manage_kamailio_package) {
        package { ['kamailio',
               'kamailio-geoip-modules',
               'kamailio-utils-modules',
               'kamailio-mysql-modules']:
            ensure => present,
        }
    }

    file { $kamailio_etc_dir:
        ensure => directory,
    } ->
    file { "${kamailio_etc_dir}/kamailio.cfg":
        ensure  => present,
        owner   => 'kamailio',
        group   => 'kamailio',
        content => file('homer/kamailio/kamailio.cfg'),
        notify  => Service['kamailio'],
    } ->
    file { "${kamailio_etc_dir}/kamailio-local.cfg":
        ensure  => present,
        owner   => 'kamailio',
        group   => 'kamailio',
        content => template('homer/kamailio/kamailio-local.cfg.erb'),
        notify  => Service['kamailio'],
    } ->
    file { "${kamailio_etc_dir}/kamctlrc":
        ensure  => present,
        owner   => 'kamailio',
        group   => 'kamailio',
        content => file('homer/kamailio/kamctlrc'),
        notify  => Service['kamailio'],
    } ->
    file { '/etc/default/kamailio':
        ensure  => present,
        content => file('homer/kamailio/default'),
        notify  => Service['kamailio'],
    }

    if ($manage_systemd) {
        file { '/etc/sysconfig':
            ensure  => directory,
        } ->
        file { '/etc/sysconfig/kamailio':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            content => template('homer/kamailio/etc_sysconfig_kamailio.erb'),
            notify  => Service['kamailio'],
        }
    
        file { '/usr/lib/systemd/system/kamailio.service':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            content => template('homer/kamailio/systemd_kamailio.erb'),
            notify  => [Exec['kamailio-systemd-reload'], Service['kamailio']],
        }
    
        exec { 'kamailio-systemd-reload':
            command     => 'systemctl daemon-reload',
            path        => '/bin',
            refreshonly => true,
        }
    }

    service { 'kamailio':
        ensure => running,
        enable => true,
    }
}
