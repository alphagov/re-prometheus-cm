$user_accounts = lookup('accounts::user')
$ssh_keys = lookup('accounts::sshkeys')

$defaults_users_settings = {
  managehome => true,
}

cron { 'motherbase':
  command => 'cd /motherbase && /usr/bin/git -p pull origin master',
  user    => 'root',
  ensure  => present,
}

create_resources(user, $user_accounts, $defaults_users_settings)
create_resources(ssh_authorized_key, $ssh_keys)
