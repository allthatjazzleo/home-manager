{
  inputs,
  cell,
}: {
  leopang = {
    email = "pangleo1994@gmail.com";
    gitSigningKey = "07F0D06865380163";
    name = "Leo Pang";
    username = "leopang";
    github_username = "allthatjazzleo";
    packages = pkgs:
      with pkgs; [
        discord
        zoom-us
        utm
        postman
      ]; # user specific packages
    ageIdentityPaths = ["~/.ssh/id_ed25519_homemanager"];
    # zsh = false; # programs
  };
  workuser = {
    email = "xx@xxx.com";
    name = "Leo Pang";
    username = "workuser";
    github_username = "xxx";
  };
}
