{ inputs, cell, user, ... }:

{
  vscode = {
    enable = 
      if builtins.hasAttr "vscode" user && user.vscode == false
      then false
      else true;
  };
}
