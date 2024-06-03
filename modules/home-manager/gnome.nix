{ nixpkgs, pkgs, ... }:
let
  mkPrimitive = t: v: {
    _type = "gvariant";
    type = t;
    value = v;
    __toString = self: "@${self.type} ${toString self.value}";
  };

  mkUint32 = mkPrimitive "u";
in
{
  # use `dconf dump / | dconf2nix`
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/screensave" = {
      lock-enabled = false;
    };

    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "sound-output-device-chooser@kgshank.net"
        "tailscale-status@maxgallup.github.com"
      ];
    };
  };

  home.packages = with pkgs; [
    gnome.gnome-shell-extensions
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.tailscale-status

    okular
    google-chrome
    teams-for-linux

    dconf2nix
  ];

  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = [ "okularApplication_pdf.desktop" ];
      };
      defaultApplications = {
        "text/html" = [ "google-chrome.desktop" ];
        "x-scheme-handler/http" = [ "google-chrome.desktop" ];
        "x-scheme-handler/https" = [ "google-chrome.desktop" ];
        "x-scheme-handler/about" = [ "google-chrome.desktop" ];
        "x-scheme-handler/unknown" = [ "google-chrome.desktop" ];
        "x-scheme-handler/mkteams" = [ "teams-for-linux.desktop" ];
        "application/pdf" = [ "okularApplication_pdf.desktop" ];
      };
    };
  };
}
