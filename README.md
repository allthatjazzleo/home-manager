# Clone this project to ~/.config/
```sh
git clone https://github.com/allthatjazzleo/home-manager.git ~/.config/
```

# First run
```sh
nix run .#homeConfigurations.$USER.activationPackage
```
# After first run
```sh
home-manager switch --impure
```

# update
```sh
update
```