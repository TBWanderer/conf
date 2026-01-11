# modules/hardware/disko.nix - Disk partitioning with LUKS and Btrfs
# This is a TEMPLATE - copy and customize per host if needed
{ lib, ... }:

{
  # Disko configuration is defined directly, not behind an option
  # To use: enable in host config and set the device
  
  # This module is imported but does nothing by default
  # Each host should define its own disko config if needed
}
