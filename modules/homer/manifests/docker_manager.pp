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
# homer::docker_manager.pp
class homer::docker_manager (
    $compose_bin,
    $compose_dir,
    $kamailio_image,
    $ui_api_image,
    $mysql_host,
    $mysql_user,
    $mysql_password
) {
    # Ensure Docker is installed
    # sudo puppet module install garethr-docker
    class { 'docker':
    }

    # Ensure Docker Compose is installed
    # TODO: Improve this
    $compose_version = '1.6.2'

    class { 'homer::docker::compose':
        compose_bin     => $compose_bin,
        compose_version => $compose_version,
    }

    # Set up docker-compose.yml and homer.env
    file { $compose_dir:
        ensure  => directory,
    } ->
    file { "${compose_dir}/homer.env":
        ensure  => present,
        content => template('homer/docker-compose/homer.env.erb'),
    } ->
    file { "${compose_dir}/docker-compose.yml":
        ensure  => present,
        content => template('homer/docker-compose/docker-compose.yml.erb'),
    }

    exec { 'docker-compose_pull_kamailio':
        command     => "${compose_bin} pull ${kamailio_image}",
        cwd         => $compose_dir,
        require     => Class['homer::docker::compose'],
        notify      => Exec['docker-compose_up'],
    }

    exec { 'docker-compose_pull_web':
        command     => "${compose_bin} pull ${ui_api_image}",
        cwd         => $compose_dir,
        require     => Class['homer::docker::compose'],
        notify      => Exec['docker-compose_up'],
    }

    # Run 'docker-compose up -d' on demand
    exec { 'docker-compose_up':
        command     => "${compose_bin} up -d",
        cwd         => $compose_dir,
        refreshonly => true,
    }
}
