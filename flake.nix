{
  description = "startx as a systemd service. No DM required. ";
  outputs = { self, nixpkgs }: { nixosModules.default = import ./startx.nix; };
}
