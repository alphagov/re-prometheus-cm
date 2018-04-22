$user_accounts = lookup('accounts::user')
$ssh_keys = lookup('accounts::sshkeys')

$defaults_users_settings = {
  managehome => true,
}

file { '/root/site-conf.test':
    ensure => 'file',
}

file { '/root/site-conf2.test':
    ensure => 'file',
}

cron { 'puppet_run_gitpull':
  command => 'cd /re-prometheus-cm && /usr/bin/git -p pull origin master && /opt/puppetlabs/bin/puppet apply /re-prometheus-cm/manifests/ --hiera_config=/re-prometheus-cm/hiera.yaml >> /var/log/puppet_run',
  user    => 'root',
  ensure  => present,
}

create_resources(user, $user_accounts, $defaults_users_settings)
create_resources(ssh_authorized_key, $ssh_keys)
