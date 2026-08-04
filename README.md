# nvp's Nix config

A single, reusable base config for all my machines (NixOS, nix-darwin, standalone
home-manager). Machine-specific work config lives in a **separate private flake**
that imports this one — so nothing work-specific is ever committed here.

## Layout

```
flake.nix                     inputs + host entrypoints (calls lib/builders.nix)
lib/builders.nix              mkNixos / mkDarwin / mkHome (exported as `.#lib`)
hosts/<host>/                 per-host system config (NixOS: configuration.nix, darwin: default.nix)
home/nvp/<host>/              per-host home-manager entrypoint (imports the common aggregate)
modules/
  shared/                     nix settings, packages, stylix shared by all
  nixos/    (.#nixosModules.default)      -> ./common
  darwin/   (.#darwinModules.default)     -> aggregate (common/homebrew/sketchybar)
  home-manager/ (.#homeManagerModules.default) -> ./common (imports all programs/*)
dotfiles/                     out-of-store-symlinked configs (nvim, sketchybar, ...)
```

Modules import each other by **relative path**, and the builders + module
aggregates are exported as flake outputs (`.#lib`, `.#homeManagerModules.default`,
etc.) so another flake can reuse them.

## Reusing this as a base (work / private overlay)

A private flake wraps this one and adds its own hosts, layering work-only modules
via the `extraModules` / `extraHomeModules` seams and `nvimLocalDir`:

```nix
{
  inputs.personal.url = "github:devpruthvi/nix-config";
  outputs = {personal, ...}: {
    darwinConfigurations.workMac = personal.lib.mkDarwin {
      hostname = "workMac";
      userConfig = { name = "nvp"; fullName = "Pruthvi Raj N V"; email = "me@work.example"; };
      extraModules = [ ./hosts/workMac ];        # system-level work config
      extraHomeModules = [ ./home/work.nix ];    # work packages, git email, ...
      nvimLocalDir = "/Users/nvp/nix-config-work/dotfiles-local/nvim";
    };
  };
}
```

- Builders close over **this** flake's pinned inputs/overlays, so versions stay
  in lockstep. Work syncs with `nix flake update personal`.
- Git identity in `modules/home-manager/programs/git` is `mkDefault`, so a work
  home module can override `user.email` (or add `includeIf`) without `mkForce`.
- Neovim: base config is symlinked from `dotfiles/.config/nvim`. If `nvimLocalDir`
  is set, it is symlinked to `~/.config/nvim-local`; `lua/local/*.lua` there is
  put on the runtimepath and imported by lazy.nvim. So work can add e.g. corp
  `jdtls` settings without editing shared Lua. Personal machines set nothing → no-op.

## Bootstrap

### macOS (nix-darwin)

- `cd && git clone https://github.com/devpruthvi/nix-config.git`
- Install Nix (Determinate): `curl -fsSL https://install.determinate.systems/nix | sh -s -- install`
- `sudo ln -s ~/nix-config /etc/nix-darwin`
- `sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#nvpMacMini`
- `nix run home-manager -- switch --flake .#nvp@nvpMacMini`

### NixOS

- `sudo nixos-rebuild switch --flake .#<host>`   (`nvpNix`, `nvpWSL`, `nvp-vm`)

### Standalone home-manager (e.g. Linux cloud desktop)

- `nix run home-manager -- switch --flake .#nvp@<host>`

### Work machines

Clone **both** this repo (`~/nix-config`, keeps base dotfiles live-editable) and
the private overlay (`~/nix-config-work`), then build from the overlay:

- `darwin-rebuild switch --flake ~/nix-config-work#workMac`
- `home-manager switch --flake ~/nix-config-work#nvp@workDesktop`
