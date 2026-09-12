{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    extraOptions = ''
      --ipv6 
      --fixed-cidr-v6="fd00:db8:1::/64"
    '';
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.dialout.members = [ "marufs" ];
  users.users.marufs = {
    isNormalUser = true;
    description = "Maruf Shafique";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "docker"
      "docker-compose"
      "i2c"
      "dialout"
    ];
    packages = with pkgs; [
      docker
      docker-compose
    ];
  };
}
