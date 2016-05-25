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


# homer::docker_web.pp
class homer::docker_web(
    $compose_bin,
    $compose_dir,
) {
    # Files required by Compose:
    # homer-ui-api/
#├── configuration.php
#├── Dockerfile
#├── nginx
#│   ├── nginx.conf
#│   └── sipcapture.conf
#├── preferences.php
#├── run.sh
#└── www.conf

    $base_dir = "${compose_dir}/homer-ui-api"

    file { $base_dir:
        ensure => directory,
    } ->
    file { "${base_dir}/Dockerfile":
        ensure  => present,
        content => file('homer/docker_web/Dockerfile'),
        notify  => Exec['docker-compose_build_web'],
    } ->
    file { "${base_dir}/configuration.php":
        ensure  => present,
        content => file('homer/docker_web/configuration.php'),
        notify  => Exec['docker-compose_build_web'],
    } ->
    file { "${base_dir}/preferences.php":
        ensure  => present,
        content => file('homer/docker_web/preferences.php'),
        notify  => Exec['docker-compose_build_web'],
    } ->
    file { "${base_dir}/www.conf":
        ensure  => present,
        content => file('homer/docker_web/www.conf'),
        notify  => Exec['docker-compose_build_web'],
    } ->
    file { "${base_dir}/run.sh":
        ensure  => present,
        content => file('homer/docker_web/run.sh'),
        notify  => Exec['docker-compose_build_web'],
    } ->
    file { "${base_dir}/nginx":
        ensure => directory,
    } ->
    file { "${base_dir}/nginx/nginx.conf":
        ensure  => present,
        content => file('homer/docker_web/nginx/nginx.conf'),
        notify  => Exec['docker-compose_build_web'],
    } ->
    file { "${base_dir}/nginx/sipcapture.conf":
        ensure  => present,
        content => file('homer/docker_web/nginx/sipcapture.conf'),
        notify  => Exec['docker-compose_build_web'],
    }
}
