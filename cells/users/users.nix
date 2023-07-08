{ inputs, cell, }:

{
  leopang = {
    email = "pangleo1994@gmail.com";
    # gitSigningKey = "";
    name = "Leo Pang";
    username = "leopang";
    github_username = "allthatjazzleo";
    packages = with inputs.nixpkgs; [ kustomize ]; # user specific packages
  };
  workuser = {
    email = "xx@xxx.com";
    name = "Leo Pang";
    username = "workuser";
    github_username = "xxx";
  };
}
