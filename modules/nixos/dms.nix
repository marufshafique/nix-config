{ pkgs, ... }:
let
  # Gate that is evaluated fresh on every start attempt (unlike
  # ConditionEnvironment, which reads the user manager's cached
  # environment and goes stale across logout/login DE switches).
  onlyNiri = pkgs.writeShellScript "dms-only-on-niri" ''
    uid=$(${pkgs.coreutils}/bin/id -u)
    for s in $(${pkgs.systemd}/bin/loginctl list-sessions --no-legend | ${pkgs.gawk}/bin/awk -v u="$uid" '$2==u {print $1}'); do
      if [ "$(${pkgs.systemd}/bin/loginctl show-session "$s" -p Desktop --value)" = "niri" ]; then
        exit 0
      fi
    done
    exit 1
  '';
in
{
  # DMS from flake github:duxlabs-dev/dux-shell (not nixpkgs).
  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
  };

  # The shell is WantedBy graphical-session, which is active in every
  # desktop (COSMIC included). Only start it when a niri session is
  # actually active, so it doesn't draw its bar over other desktops.
  systemd.user.services.dms.serviceConfig.ExecCondition = "${onlyNiri}";

  # Login screen matching DMS aesthetic (nixpkgs, renamed upstream:
  # services.displayManager.dms-greeter -> services.displayManager.dux-greeter).
  # Compositor selection lives in ../niri/system.nix.
  services.displayManager.dux-greeter = {
    enable = true;
  };

  # File indexer powering DMS launcher file results.
  # Not provided by the dms flake, still comes from nixpkgs
  # (renamed upstream: programs.dsearch -> programs.dux-search).
  programs.dux-search = {
    enable = true;

    systemd = {
      enable = true;
    };
  };
}
