# re-prometheus-cm
Reliability engineering tools puppet configuration management for prometheus.

# New users
Generate SSH key if you don't have one already with
```ssh-keygen -t rsa```

This creates a .ssh directory in your home directory with your public and private keys.

Edit ```hiera/user.yml``` to include your user and public key following the format in use already
```
username:
    gid: gdsadmins
    shell: /bin/bash
```

```
username_sshkey:
    name: 'username@digital.cabinet-office.gov.uk'
    user: 'username'
    type: 'ssh-rsa'
    ensure: present
    key: 'yourPUBLICkey=='
```

Also edit ```test/integration/variables/test_data.json``` to add your user details and key

```{"username":"username", "group":"gdsadmins", "shell":"/bin/bash", "ssh_authorized_keys":"ssh-rsa yourPUBLICkey== username@digital.cabinet-office.gov.uk"},```

Get someone to review your PR and once your SSH key has been added you can test it's working by running;

```ssh metrics.gds-reliability.engineering```
