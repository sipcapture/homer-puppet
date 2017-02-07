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
# class homer::mysql::scripts
class homer::mysql::scripts(
    $base_dir,
    $mysql_host,
    $mysql_user,
    $mysql_password,
    $mysql_root_password,
    $ui_admin_password,
) {
    File {
        owner => 'root',
        group => 'root',
        mode  => '0700',
    }

    file { "${base_dir}/sql":
        ensure  => directory,
        require => File[$base_dir],
    } ->
    # Taken from $GIT/homer-api/sql/
    file { "${base_dir}/sql/schema_data.sql":
        ensure  => file,
        content => file('homer/mysql/schema_data.sql'),
        notify  => Exec['run_mysql_setup'],
    } ->
    # Taken from $GIT/homer-api/sql/
    file { "${base_dir}/sql/schema_configuration.sql":
        ensure  => file,
        content => template('homer/mysql/schema_configuration.sql.erb'),
        notify  => Exec['run_mysql_setup'],
    } ->
    # Taken from $GIT/homer-api/sql/
    file { "${base_dir}/sql/schema_statistic.sql":
        ensure  => file,
        content => file('homer/mysql/schema_statistic.sql'),
        notify  => Exec['run_mysql_setup'],
    } ->
    file { "${base_dir}/sql/setup.sql":
        ensure  => file,
        content => template('homer/mysql/setup.sql.erb'),
        notify  => Exec['run_mysql_setup'],
    }

    exec { 'run_mysql_setup':
        command     => "/usr/bin/mysql -u root -p${mysql_root_password} < ${base_dir}/sql/setup.sql",
        refreshonly => true,
    }
}
