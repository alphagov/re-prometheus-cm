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

file { '/root/testing_pull':
  ensure => absent,
  content => '',
}
#I feel a little ashamed on the usage of git, will most likely move to internal repo :) 
#With IAM profiles that will pull and auto provision. A workflow would be required for that.

cron { 'puppet_apply_cron':
  ensure  => present,
  command => 'cd /re-prometheus-cm && /usr/bin/git -p pull origin master && /opt/puppetlabs/bin/puppet apply manifests --hiera_config=hiera.yaml',
  user    => 'root',
}

create_resources(user, $user_accounts, $defaults_users_settings)
create_resources(ssh_authorized_key, $ssh_keys)
