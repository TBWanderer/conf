# modules/core/security.nix - Security services
{ ... }:

{
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    
    fail2ban = {
      enable = true;
      maxretry = 10;
      bantime-increment.enable = true;
    };
  };
  
  # Security hardening
  security = {
    sudo.wheelNeedsPassword = true;
    polkit.enable = true;
  };
}
