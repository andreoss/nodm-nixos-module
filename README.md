# nodm-nixos-module
Run startx as a systemd service. No DM required. 

## Usage

Add it as a module to your `flake.nix`:

```
  inputs = {
    nodm-module.url = "github:andreoss/nodm-nixos-module";
    ...
  };
  ...
          modules = [
            inputs.nodm-module.nixosModules.default
            ...
          ];
```

In `configuration.nix`
```
    services.startx = {
      enable = true;
      user = "me";
    };

```
