{ config, inputs, pkgs, ...}:

let

in {

  environment.systemPackages = with pkgs; [

    dunst
    libnotify
    networkmanagerapplet
    rofi
    swww
    # waybar
    hyprpaper

  ];

  programs = {

    hyprland = {

      enable = true;
      xwayland.enable = true;

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;

    };

    # sway.enable = true;

  };

  environment.sessionVariables = {

    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";

  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [

    xdg-desktop-portal-wlr

  ];

}
