# modules/core/locale.nix - Locale and timezone
{ lib, config, ... }:

{
  time.timeZone = lib.mkDefault "Europe/Moscow";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_GB.UTF-8";
    };
  };
}
