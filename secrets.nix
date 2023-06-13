let
  leopang =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAm7QAIWdg/qsbNSerGH+JRw4y3TjWwRhqXp0dC9PHpi";
  workuser = "ssh-ed25519 xxx";
  users = [ leopang ];
in { "secrets/ssh-config.age".publicKeys = users; }
