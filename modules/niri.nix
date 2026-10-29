# Niri compositor config, managed declaratively (vendored from ~/.config/niri/config.kdl).
# The `include "dms/..."` lines at the end resolve to dms-generated files at
# runtime (~/.config/niri/dms/) and are intentionally left untouched.
{ ... }:
{
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
}
