### Custom ZSH and powerlevel9k autoinstaller for debian

Install software and fonts needed ; Customise ~/.zshrc ; Setting zsh as default shell

**Installation :**

Run this commande, and it will launch the setup in `debian:jessie` container.
```
make run
Y
/srv/install_zsh.sh setup
source $HOME/.zshrc
```

**Installation :**

Just run `./install_zsh.sh` and enjoy !


**Required :**

```
sudo
```