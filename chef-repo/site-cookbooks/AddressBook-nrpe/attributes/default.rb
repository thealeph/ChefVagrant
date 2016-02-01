default['nrpe']['allowed_hosts']   = %w( monitoring_host )
default['nrpe']['version']  = '2.6'
default['nrpe']['dont_blame_nrpe'] = 1
  default['nrpe']['packages']          = {
    'nrpe' => {
      'version' => nil
    },
    'nagios-plugins-disk' => {
      'version' => nil
    },
    'nagios-plugins-load' => {
      'version' => nil
    },
    'nagios-plugins-procs' => {
      'version' => nil
    },
    'nagios-plugins-users' => {
      'version' => nil
    },
    'nagios-plugins-swap' => {
      'version' => nil
    }
  }
