{ ... }:
{
  # DMS from flake github:duxlabs-dev/dux-shell (not nixpkgs).
  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = false;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
  };

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
