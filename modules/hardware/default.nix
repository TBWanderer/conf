# modules/hardware/default.nix - Hardware modules index
{ ... }:

{
  imports = [
    ./nvidia.nix
    ./power.nix
    ./disko.nix
  ];
}
