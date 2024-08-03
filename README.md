* Do the following during new system installation:

```bash
sudo su
nix-shell -p git nixUnstable

mkdir -p /mnt/etc/nixos && cd /mnt/etc/nixos

git clone https://github.com/devpruthvi/nix-config.git .

# Replace hardware-configuration file if necessary
# Git commit new hardware-configuration file, nixos rebuild complains with untracked files

nixos-install --flake '.#nvpNix'
```
