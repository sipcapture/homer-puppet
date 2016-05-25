# homer::docker::compose.pp
class homer::docker::compose (
    $compose_bin,
    $compose_version,
) {
    # copied from build-machine docker install.pp with some changes
    exec { 'docker-compose':
        command => "curl -L https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-${::kernel}-${::hardwaremodel} > ${compose_bin}-${compose_version}",
        creates => "${compose_bin}-${compose_version}",
        path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/sbin'
    } ~>
    file { "${compose_bin}-${compose_version}":
        ensure => file,
        mode   => 'a+x',
        owner  => root,
        group  => root
    } ~>
    file { $compose_bin:
        ensure => link,
        target => "${compose_bin}-${compose_version}",
        owner  => root,
        group  => root
    }
}
