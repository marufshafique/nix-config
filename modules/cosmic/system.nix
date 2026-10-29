# COSMIC desktop environment (alternative session alongside niri).
# Login screen stays on dux-greeter (see ../nixos/dms.nix), so the
# COSMIC greeter is disabled. HM-side bits: none (no ./default.nix).
{ ... }:
{
  services.displayManager.cosmic-greeter = {
    enable = false;
  };

  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = true;
  };
}
