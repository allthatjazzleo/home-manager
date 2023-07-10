{ inputs, cell, }:

{
  leopang = {
    email = "pangleo1994@gmail.com";
    # gitSigningKey = "";
    name = "Leo Pang";
    username = "leopang";
    github_username = "allthatjazzleo";
    packages = pkgs: with pkgs; [ kustomize ]; # user specific packages
    # zsh = false; # programs
  };
  workuser = {
    email = "xx@xxx.com";
    name = "Leo Pang";
    username = "workuser";
    github_username = "xxx";
  };
}
