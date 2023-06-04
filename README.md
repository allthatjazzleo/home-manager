# First run
```sh
nix run .#homeConfigurations.$USER.activationPackage
```
# After first run
```sh
home-manager switch --flake .
```

# update
```sh
update
```