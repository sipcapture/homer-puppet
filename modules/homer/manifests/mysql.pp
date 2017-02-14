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
# homer::mysql
class homer::mysql(
    $innodb_buffer_pool_size,
    $innodb_log_file_size,
    $innodb_read_io_threads,
    $innodb_write_io_threads,
    $max_heap_table_size,
    $mysql_root_password
) {
    if ($::lsbdistcodename == 'jessie') {
        $mysql_version = '5.7.17-1debian8'
    }
    else {
        $mysql_version = 'present'
    }

    class { '::mysql::server':
        manage_config_file      => false,
        package_ensure          => $mysql_version,
        root_password           => $mysql_root_password,
        remove_default_accounts => true,
        override_options        => {
            mysqld => {
                bind-address => '0.0.0.0', # Allow remote connections
            }
        },
        restart                 => true,
    } ->
    file { '/etc/mysql/mysql.cnf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('homer/mysql/my.cnf.erb'),
    }
}
