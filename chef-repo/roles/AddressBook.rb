name "AddressBook"
description "AddressBook Application"
all_env = [
  "role[base]",
  "recipe[AddressBook]"
]

prod_env = [
  "role[base]",
  "recipe[AddressBook]",
  "recipe[AddressBook-logstash]"
]

run_list(all_env)

env_run_lists(
  "_default" => all_env,
  "dev" => all_env,
  "qa" => all_env,
  "prod" => prod_env
)
