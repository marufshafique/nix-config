# System-level niri setup. Home-level bits (config.kdl, helper
# packages) live in ./default.nix, imported via modules/default.nix.
{ ... }:
{
  # Niri Wayland compositor.
  programs.niri = {
    enable = true;
  };

  # Niri specific environment variables.
  # Safe to remove on other DEs.
  environment.variables.MOZ_ENABLE_WAYLAND = "1";
  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  # Login screen launches the niri session.
  services.displayManager.dux-greeter.compositor.name = "niri";
}
