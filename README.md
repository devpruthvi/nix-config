
## On MacOS

- `cd && git clone https://github.com/devpruthvi/nix-config.git`
- Install 'Nix from Determinate Systems' with upstream Nix: `curl -fsSL https://install.determinate.systems/nix | sh -s -- install`
- `sudo ln -s ~/nix-config /etc/nix-darwin`
- `sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#nvpMacMini`
- `nix run home-manager -- switch --flake .#nvp@nvpMacMini`
