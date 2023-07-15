let
  leopang =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJsF4iQmvHnLvSOnAuHMvpFaVww3TpAiNoIR6I1IxfcJ";
  workuser = "ssh-ed25519 xxx";
  users = [ leopang ];
in {
  "cells/homemanager/secrets/ssh-config.age".publicKeys = users;
  "cells/homemanager/secrets/nix.conf.age".publicKeys = users;
}
