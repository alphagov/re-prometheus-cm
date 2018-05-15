$user_accounts = lookup('accounts::user')
$ssh_keys = lookup('accounts::sshkeys')
$packeges_base = lookup('packages::base')


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

#create users with ssh keys
create_resources(user, $user_accounts, $defaults_users_settings)
create_resources(ssh_authorized_key, $ssh_keys)
#install packages 
create_resources(package, $packeges_base)

file { '/srv/gds':
  ensure => 'directory',
  group  => 'gdsadmins',
  mode   => '0640',
}

file { '/srv/gds/prometheus':
  ensure => 'directory',
  group  => 'gdsadmins',
  mode   => '0640',
}


exec { 'move_prometheus_file':
  command => 'cp -f /re-prometheus-cm/templates/prometheus.yml.erb /srv/gds/prometheus/prometheus.yml',
  path    => '/usr/local/bin/:/bin/',
}

cron { 'puppet_apply_cron':
  ensure  => present,
  command => 'cd /re-prometheus-cm && /usr/bin/git -p pull origin master && /opt/puppetlabs/bin/puppet apply manifests --hiera_config=hiera.yaml',
  user    => 'root',
}

cron { 'cron_sd_pull':
  ensure  => present,
  command => '/usr/local/bin/aws s3 sync --delete s3://gds-prometheus-targets-staging/active /etc/prometheus/targets',
  user    => 'root',
}



