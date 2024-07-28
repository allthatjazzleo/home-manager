# https://github.com/ryantm/agenix
# Update secrets with agenix cli. When you save that file its content will be encrypted with all the public keys mentioned in the secrets.nix file.
#  ```
#  agenix -e cells/homemanager/secrets/ssh-config.age -i ~/.ssh/id_ed25519_homemanager
#  ```
let
  leopang = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJsF4iQmvHnLvSOnAuHMvpFaVww3TpAiNoIR6I1IxfcJ";
  workuser = "ssh-ed25519 xxx";
  users = [leopang];
in {
  "cells/homemanager/secrets/ssh-config.age".publicKeys = users;
  "cells/homemanager/secrets/nix.conf.age".publicKeys = users;
  "cells/homemanager/secrets/sops-age-key.age".publicKeys = users;
}
