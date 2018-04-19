$user_accounts = lookup('accounts::user')
$ssh_keys = lookup('accounts::sshkeys')

$defaults_users = {
  'managehome' => true,
}


create_resources(user, $user_accounts, $defaults_users)
create_resources(ssh_authorized_key, $ssh_keys)
