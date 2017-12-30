# Class to configure whitelists
#
# Parameters:
# $whitelist_clients_file:
#   path of the whitelist_clients file.
#   default: '/etc/postgrey/whitelist_clients'
# $whitelist_receipients_file:
#   path of the whitelist_recepients file.
#   default: '/etc/postgrey/whitelist_recipients'
#
class postgrey::config(
  $whitelist_clients_file     = '/etc/postgrey/whitelist_clients',
  $whitelist_receipients_file = '/etc/postgrey/whitelist_recipients',
) {
  file {
    '/etc/default/postgrey':
      content => template('postgrey/default.erb');
  }

  concat {
    $whitelist_clients_file:
  }

  concat::fragment { 'postgrey/whitelist_clients/header':
     target => $whitelist_clients_file,
     order  => 00,
     source => 'puppet:///modules/postgrey/whitelist_clients.header';
  }

  if ($postgrey::default_whitelist_clients == true) {
    concat::fragment { 'postgrey/whitelist_clients/default':
      target => $whitelist_clients_file,
      order  => 10,
      source => 'puppet:///modules/postgrey/whitelist_clients.default';
    }
  }

  if ($postgrey::whitelist_clients != []) {
    concat::fragment { 'postgrey/whitelist_clients':
      target  => $whitelist_clients_file,
      order   => 15,
      content => inline_template('<%= scope.lookupvar("postgrey::whitelist_clients").join("\n") %>')
    }
  }

  concat {
    $whitelist_receipients_file:
  }

  concat::fragment { 'postgrey/whitelist_recipients/header':
     target => $whitelist_receipients_file,
     order  => 00,
     source => 'puppet:///modules/postgrey/whitelist_recipients.header';
  }

  if ($postgrey::default_whitelist_recipients == true) {
    concat::fragment { 'postgrey/whitelist_recipients/default':
      target => $whitelist_receipients_file,
      order  => 10,
      source => 'puppet:///modules/postgrey/whitelist_recipients.default';
    }
  }

  if ($postgrey::whitelist_recipients != []) {
    concat::fragment { 'postgrey/whitelist_recipients':
      target  => $whitelist_receipients_file,
      order   => 15,
      content => inline_template('<%= scope.lookupvar("postgrey::whitelist_recipients").join("\n") %>')
    }
  }
}

