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
# homer::docker_kamailio.pp
class homer::docker_kamailio(
    $compose_bin,
    $compose_dir,
) {
    # Files required by Compose:
    # Dockerfile  kamailio.cfg  kamailio-local.cfg  run.sh
    $base_dir = "${compose_dir}/homer-kamailio"

    file { $base_dir:
        ensure => directory,
    } ->
    file { "${base_dir}/Dockerfile":
        ensure  => present,
        content => file('homer/docker_kamailio/Dockerfile'),
        notify  => Exec['docker-compose_build_kamailio'],
    } ->
    file { "${base_dir}/kamailio.cfg":
        ensure  => present,
        content => file('homer/docker_kamailio/kamailio.cfg'),
        notify  => Exec['docker-compose_build_kamailio'],
    } ->
    file { "${base_dir}/kamailio-local.cfg":
        ensure  => present,
        content => file('homer/docker_kamailio/kamailio-local.cfg'),
        notify  => Exec['docker-compose_build_kamailio'],
    } ->
    file { "${base_dir}/run.sh":
        ensure  => present,
        content => file('homer/docker_kamailio/run.sh'),
        notify  => Exec['docker-compose_build_kamailio'],
    }
}
