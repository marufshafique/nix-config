{ ... }:
{
  networking.hostName = "nixos"; # Define your hostname.

  networking.enableIPv6 = true;
  networking.networkmanager.enable = true;

  networking.tempAddresses = "disabled";

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  networking.firewall = {
    enable = true;
    checkReversePath = false;
    trustedInterfaces = [ "docker0" ];
    # Extra safety net: Force NixOS to let iptables handle forward actions
    extraCommands = ''
      iptables -A FORWARD -i docker0 -o wlp16s0 -j ACCEPT
      iptables -A FORWARD -i wlan0 -o docker0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    '';
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [ "docker0" ];
    externalInterface = "wlp16s0";
  };
}
