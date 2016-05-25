node default {
    class { 'homer':
        base_dir            => '/homer',
        compose_bin         => '/usr/local/bin/docker-compose',
        compose_dir         => '/homer-docker',
        kamailio_image      => 'gvacca/kamailio_image',
        manage_mysql        => true,
        mysql_password      => 'astrongone',
        mysql_root_password => 'averystrongone',
        ui_admin_password   => 'theadmin123',
        ui_api_image        => 'gvacca/ui_api_image',
        use_docker          => true,
    }
}
