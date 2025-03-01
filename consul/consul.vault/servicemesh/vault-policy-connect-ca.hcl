path "/sys/mounts/root" {
  capabilities = [ "read" ]
}
path "/sys/mounts/consul_root" {
  capabilities = [ "read" ]
}

path "/sys/mounts/connect_dc1_inter" {
  capabilities = [ "read" ]
}

path "/sys/mounts/connect_dc1_inter/tune" {
  capabilities = [ "update" ]
}

path "/consul_root/" {
  capabilities = [ "read" ]
}


path "/root/" {
  capabilities = [ "read" ]
}

path "/consul_root/root/sign-intermediate" {
  capabilities = [ "update" ]
}

path "/connect_dc1_inter/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "auth/token/renew-self" {
  capabilities = [ "update" ]
}

path "auth/token/lookup-self" {
  capabilities = [ "read" ]
}

