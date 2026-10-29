# Screenshot entries for dux launcher (dms spotlight) search.
# `dms screenshot` saves file + clipboard by default; --no-file = clipboard only.
# Searching "screenshot" / "clipboard" / "snip" in dux search will list these.
# Each entry closes the launcher first (so the region selector isn't covered),
# via a wrapper script (desktop Exec can't contain shell ; & ' quoting).
{ pkgs, ... }:
let
  dmsBin = "/run/current-system/sw/bin/dms";
  mkShot = name: args: pkgs.writeShellScriptBin name ''
    ${dmsBin} ipc spotlight close >/dev/null 2>&1 || true
    ${dmsBin} ipc launcher close >/dev/null 2>&1 || true
    exec ${dmsBin} screenshot ${args}
  '';
  shotRegionClipboard = mkShot "screenshot-region-clipboard" "region --no-file --no-confirm";
  shotFullClipboard = mkShot "screenshot-full-clipboard" "full --no-file";
  shotWindowClipboard = mkShot "screenshot-window-clipboard" "window --no-file";
  shotAllClipboard = mkShot "screenshot-all-clipboard" "all --no-file";
  shotRegionFile = mkShot "screenshot-region-file" "region";
in
{
  home.packages = [
    shotRegionClipboard
    shotFullClipboard
    shotWindowClipboard
    shotAllClipboard
    shotRegionFile
  ];

  xdg.desktopEntries = {
    screenshot-region-clipboard = {
      name = "Screenshot: Region to Clipboard";
      genericName = "Screenshot region";
      comment = "Select a region, copy to clipboard (no file)";
      exec = "${shotRegionClipboard}/bin/screenshot-region-clipboard";
      terminal = false;
      categories = [ "Utility" ];
      settings.Keywords = "screenshot;screen;capture;clipboard;copy;snip;region;";
    };

    screenshot-full-clipboard = {
      name = "Screenshot: Full Screen to Clipboard";
      genericName = "Screenshot full screen";
      comment = "Capture focused output, copy to clipboard (no file)";
      exec = "${shotFullClipboard}/bin/screenshot-full-clipboard";
      terminal = false;
      categories = [ "Utility" ];
      settings.Keywords = "screenshot;screen;capture;clipboard;copy;fullscreen;monitor;";
    };

    screenshot-window-clipboard = {
      name = "Screenshot: Window to Clipboard";
      genericName = "Screenshot window";
      comment = "Capture focused window, copy to clipboard (no file)";
      exec = "${shotWindowClipboard}/bin/screenshot-window-clipboard";
      terminal = false;
      categories = [ "Utility" ];
      settings.Keywords = "screenshot;screen;capture;clipboard;copy;window;";
    };

    screenshot-all-clipboard = {
      name = "Screenshot: All Outputs to Clipboard";
      genericName = "Screenshot all outputs";
      comment = "Capture all outputs combined, copy to clipboard (no file)";
      exec = "${shotAllClipboard}/bin/screenshot-all-clipboard";
      terminal = false;
      categories = [ "Utility" ];
      settings.Keywords = "screenshot;screen;capture;clipboard;copy;all;";
    };

    screenshot-region-file = {
      name = "Screenshot: Region to File";
      genericName = "Screenshot region to file";
      comment = "Select a region, save file + clipboard (dms default)";
      exec = "${shotRegionFile}/bin/screenshot-region-file";
      terminal = false;
      categories = [ "Utility" ];
      settings.Keywords = "screenshot;screen;capture;file;save;region;";
    };
  };
}
