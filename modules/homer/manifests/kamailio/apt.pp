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
# homer::kamailio::apt
class homer::kamailio::apt(
) {
    include '::apt'

    package { ['debian-keyring', 'debian-archive-keyring']:
        ensure => present,
    }

    apt::source { "kamailio_${::lsbdistcodename}":
        location          => 'http://deb.kamailio.org/kamailio43',
        release           => $::lsbdistcodename,
        repos             => 'main',
        key               => {
            id     => 'E79ACECB87D8DCD23A20AD2FFB40D3E6508EA4C8',
            source => 'http://deb.kamailio.org/kamailiodebkey.gpg',
        },
        include           => {
            src => true,
        },
    }

    Apt::Source["kamailio_${::lsbdistcodename}"] -> Package<|tag == 'kamailio'|>
}
