let
  leopang =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAm7QAIWdg/qsbNSerGH+JRw4y3TjWwRhqXp0dC9PHpi";
  workuser = "ssh-ed25519 xxx";
  users = [ leopang ];
in {
  "cells/homemanager/secrets/ssh-config.age".publicKeys = users;
  "cells/homemanager/secrets/nix.conf.age".publicKeys = users;
}
