{
  inputs,
  cell,
  user,
  ...
}: {
  vscode = {
    enable = user.vscode or true;
  };
}
