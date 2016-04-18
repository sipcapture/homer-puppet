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
# homer::web
class homer::web(
    $base_dir,
    $mysql_user,
    $mysql_password,
    $phpfpm_socket,
    $source_dir,
    $web_dir,
    $web_user,
) {
    package { 'nginx':
        ensure => present,
    } ->
    file { '/etc/nginx/nginx.conf':
        ensure  => file,
        owner   => $web_user,
        group   => $web_user,
        mode    => '0644',
        content => template('homer/nginx/nginx.conf.erb'),
        notify  => Service['nginx'],
    } ->
    file { '/etc/nginx/conf.d/sipcapture.conf':
        ensure  => file,
        owner   => $web_user,
        group   => $web_user,
        mode    => '0644',
        content => template('homer/nginx/nginx_sipcapture.conf.erb'),
        notify  => Service['nginx'],
    }

    service { 'nginx':
        ensure => running,
        enable => true,
    }

    file { ['/var/www', $web_dir]:
        ensure => directory,
        owner   => $web_user,
        group   => $web_user,
    } ->

    # sudo cp -r ~/git/homer-ui/* /var/www/sipcapture/htdocs
    file { "${web_dir}/htdocs":
        source => "${source_dir}/homer-ui",
        owner   => $web_user,
        group   => $web_user,
        ignore  => ['.git'],
        recurse => true,
    } ->

    # sudo cp -r ~/git/homer-api/api /var/www/sipcapture/htdocs
    file { "${web_dir}/htdocs/api":
        source => "${source_dir}/homer-api/api",
        owner   => $web_user,
        group   => $web_user,
        ignore  => ['.git'],
        recurse => true,
    } ->


    # sudo cp ~/git/homer-api/api/preferences_example.php /var/www/sipcapture/htdocs/api/preferences.php
    file { "${web_dir}/htdocs/api/preferences.php":
        ensure  => present,
        content => template('homer/homer-api/preferences.php.erb'),
    } ->
    # sudo cp ~/git/homer-api/api/configuration_example.php /var/www/sipcapture/htdocs/api/configuration.php
    file { "${web_dir}/htdocs/api/configuration.php":
        ensure  => present,
        content => template('homer/homer-api/configuration.php.erb'),
    }
}
