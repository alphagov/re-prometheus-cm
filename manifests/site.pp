$user_accounts = lookup('accounts::user')
$ssh_keys = lookup('accounts::sshkeys')

$defaults_users_settings = {
  managehome => true,
}

file { '/etc/sudoers.d/80-gdsadmins-group':
  ensure  => present,
  mode    => '0440',
  content => '%gdsadmins ALL=(ALL) NOPASSWD:ALL'
}

group { 'gdsadmins_sudo':
  ensure => present,
  name   => 'gdsadmins',
}

cron { 'gitpull_puppet_repo':
  ensure  => present,
  command => 'cd /re-prometheus-cm && /usr/bin/git -p pull origin master',
  user    => 'root',
}

cron { 'puppet_apply_2m':
  ensure  => present,
  command => 'cd /re-prometheus-cm && /opt/puppetlabs/bin/puppet apply manifests --hiera_config=hiera.yaml',
  minute      => '2'
  user    => 'root',
}

create_resources(user, $user_accounts, $defaults_users_settings)
create_resources(ssh_authorized_key, $ssh_keys)
