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
# class homer::params
class homer::params {
    $base_dir            = '/opt/homer'
    $listen_if           = '0.0.0.0'
    $listen_port         = '9060'
    $listen_proto        = 'udp'
    $manage_mysql        = false
    $mysql_user          = 'sipcapture'
    $mysql_host          = '127.0.0.1'
    $mysql_password      = undef
    $mysql_root_password = undef
    $source_dir          = '/root'
    $web_dir             = '/var/www/sipcapture'
    $web_user            = 'www-data'
    $ui_admin_password   = undef
    $kamailio_etc_dir    = '/etc/kamailio'
    $kamailio_mpath      = '/usr/lib/x86_64-linux-gnu/kamailio/modules'

    if ($::lsbdistcodename == 'xenial') {
        $db_configuration = 'homer_prod'
        $db_data          = 'homer_prod'
        $db_statistic     = 'homer_prod'
        $phpfpm_socket    = '/var/run/php/php7.0-fpm.sock'
        $php_session_path = '/var/lib/php/session'
        $phpfpm_slowlog   = '/var/log/php/7.0/fpm/www-slow.log'
        $phpfpm_errlog    = '/var/log/php/7.0/fpm/www-error.log'
    }
    else {
        $db_configuration = 'homer_configuration'
        $db_data          = 'homer_data'
        $db_statistic     = 'homer_statistic'
        $phpfpm_socker    = '/var/run/php5-fpm.sock'
        $php_session_path = '/var/lib/php5/session'
        $phpfpm_slowlog   = '/var/log/php5-fpm/www-slow.log'
        $phpfpm_errlog    = '/var/log/php5-fpm/www-error.log'
    }
}
