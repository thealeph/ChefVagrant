name "base"
description "Base sofware for AddressBook servers"
run_list(
  "recipe[users::sysadmins]",
  "recipe[yum-epel]",
  "recipe[firewalld]",
  "recipe[AddressBook-nginx]",
  "recipe[selinux]",
  "recipe[AddressBook-nrpe]",
  "recipe[AddressBook-users]",
  "recipe[AddressBook-firewall]"
)

override_attributes(
  :authorization => {
    :sudo => {
      :users => ["fjlopez"],
      :passwordless =>  true
    }
  }
)
