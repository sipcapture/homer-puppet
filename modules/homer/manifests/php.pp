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
#
# homer::php.pp
class homer::php(
    $phpfpm_socket,
    $php_session_path,
    $web_user,
) {

    if ($::lsbdistcodename == 'xenial') {
        $phpfpm_socket    = '/var/run/php/php7.0-fpm.sock'
        $php_session_path = '/var/lib/php/session'
        $phpfpm_slowlog   = '/var/log/php/7.0/fpm/www-slow.log'
        $phpfpm_errlog    = '/var/log/php/7.0/fpm/www-error.log'

        package { [
            'php-common',
            'php-mysql',
            'php-fpm'
            ]:
            ensure => present,
        } ->
        # To store the "PHP sessions"
        # /var/lib/php is installed by 'php-common'
        file { $php_session_path:
            ensure => directory,
            owner  => 'root',
            group  => 'root',
            mode   => '0777',
        } ->
        file { '/etc/php/7.0/fpm/pool.d/www.conf':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('homer/php/php-fpm-www.conf.erb'),
            notify  => Service['php7.0-fpm'],
        }

        service { 'php7.0-fpm':
            ensure => running,
            enable => true,
        } ->
        file { $phpfpm_socket:
            ensure => present,
            owner  => $web_user,
            group  => $web_user,
        }
    }
    else {
        $phpfpm_slowlog   = '/var/log/php5-fpm/www-slow.log'
        $phpfpm_errlog    = '/var/log/php5-fpm/www-error.log'

        package { [
            'php5-common',
            'php5-mysql',
            'php5-fpm'
            ]:
            ensure => present,
        } ->
        # To store the "PHP sessions"
        # /var/lib/php is installed by 'php-common'
        file { $php_session_path:
            ensure => directory,
            owner  => 'root',
            group  => 'root',
            mode   => '0777',
        } ->
        file { '/etc/php5/fpm/pool.d/www.conf':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('homer/php/php-fpm-www.conf.erb'),
            notify  => Service['php5-fpm'],
        }

        service { 'php5-fpm':
            ensure => running,
            enable => true,
        } ->
        file { $phpfpm_socket:
            ensure => present,
            owner  => $web_user,
            group  => $web_user,
        }
    }
}
