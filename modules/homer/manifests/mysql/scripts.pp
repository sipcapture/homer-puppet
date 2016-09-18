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

    file { $base_dir:
        ensure => directory,
    } ->
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

    # These files are taken from homer-api/scripts
    # From $GIT/homer-api/scripts/rotation.ini
    file { "${base_dir}/rotation.ini":
        ensure  => file,
        content => template('homer/mysql/rotation.ini.erb'),
    } ->
    # From $GIT/homer-api/scripts/homer_mysql_rotate.pl
    file { "${base_dir}/homer_mysql_rotate.pl":
        ensure  => file,
        content => file('homer/mysql/homer_mysql_rotate.pl'),
    } ->
#N.B. please run rotate.sh manual before send traffic to homer.
# The script will create capture tables also for current day.
    # rotate.sh is taken from $GIT/homer-api/scripts/homer_rotate
    file { "${base_dir}/homer_rotate.sh":
        ensure  => file,
        content => template('homer/mysql/homer_rotate.sh.erb'),
    } ->
    file { '/etc/cron.d/sipcapture':
        ensure  => file,
        mode    => '0644',
        content => template('homer/mysql/cron_sipcapture.erb'),
    }
}
