# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’)

{ config, inputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hyprland.nix
      #./xp_pen_pentablet.nix
    ];

  # Bootloader

  boot.loader.systemd-boot.enable = false;

  boot.loader.grub = {

    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;

  };

  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelModules = [ "i2c-dev" "uinput" ];

  # Networking

  networking.hostName = "wander"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;

  # Allow unfree packages

  nixpkgs.config.allowUnfree = true;

  # NVIDIA config

  # services.pulseaudio.enable = true;

  services.printing.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];
  services.xserver.libinput.enable = true;
  services.xserver.wacom.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = [ pkgs.mesa.drivers ];

  hardware.nvidia = {

    open = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {

     # version = "565.77";
      #sha256_64bit = "sha256-CnqnQsRrzzTXZpgkAtF7PbH9s7wbiTRNcM0SPByzFHw=";
      #openSha256 = "sha256-Fxo0t61KQDs71YA8u7arY+503wkAc1foaa51vi2Pl5I=";
      #settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
      #persistencedSha256 = "sha256-BMpo2pIabhHjZQqUQi/W5DYhgAPmfCdFvXdN6ND2Bfs=";

    #};

    nvidiaSettings = true;

    prime = {

      offload.enable = true;

      nvidiaBusId = "PCI:1:00:0";
      intelBusId = "PCI:0:02:0";

    };

    powerManagement = {
      
      enable = true;
      finegrained = true;

    };
 
    forceFullCompositionPipeline = true;

  };

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  hardware.uinput.enable = true;

  hardware.bluetooth = {

	enable = true;
	powerOnBoot = true;
	settings = {

		General = {
		
			Experimental = true;
			FastConnectable = true;
	
		};

		Policy = {

			AutoEnable = true;

		};

	};

  };

  # Time Zone

  time.timeZone = "America/Los_Angeles";

  # Internationalisation

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Virtualisation

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.rootless.setSocketVariable = true;

  # virtualisation.libvirtd = {

  #	enable = true;

  #	qemu = {

  #		swtpm.enable = true;
  #		ovmf.packages = [ pkgs.OVMFFull.fd ];
  
  #	};
  	
  # };

  virtualisation.spiceUSBRedirection.enable = true;

  # users.groups.libvirtd.members = [ "electrickazoo" ];
  users.groups.kvm.members = [ "electrickazoo" ];


  # Users

  nix.settings.allowed-users = [

	"root"
	"electrickazoo"

  ];

  nix.settings.trusted-users = [
  	"root"
	"electrickazoo"
  ];

  users.users.electrickazoo = {
    isNormalUser = true;
    description = "Emette Jones";
    extraGroups = [ "networkmanager" "wheel" "video" "i2c" "docker" ];
    packages = with pkgs; [ tree ];
  };

  # Programs

  programs = {

    foot.enable = true;
    firefox.enable = true;
    steam.enable = true;
    #light.enable = true;
    # nix-ld.enable = true;

    # waybar.enable = true;

  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Services  

  services.udisks2.enable = true;

  services.getty.autologinUser = "electrickazoo";

  services.displayManager.sddm = {

    enable = true;
    wayland.enable = true;

  };

  services.udev.extraRules = ''
    KERNEL=="i2c-[0-0]*", GROUP="i2c", MODE="0660"
  '';


  security.rtkit.enable = true;

  services.pipewire = {

    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;

    jack.enable = true;
    pulse.enable = true;

  };

  services.freshrss = {

    enable = true;
    baseUrl = "https://rss.cheredeprince.net";
    authType = "none";

  };

  services.avahi = {

    enable = true;
    nssmdns4 = true;
    openFirewall = true;

  };

  services.xserver = {

    xkb.layout = "us, de";
    xkb.options = "grp:caps_toggle";

  };

  services.jellyfin.enable = true;

  # Environment

  environment.variables = {

    WAYLAND_DISPLAY = ":0";
  };

  nixpkgs.config.permittedInsecurePackages = [
	"electron-39.8.10"
	"logseq-0.10.15"
	"fluffychat-linux-1.27.0"
	"olm-3.2.16"
	"docker-28.5.2"
	"python3.13-beets-2.5.1"
  ];

  environment.systemPackages = [

     inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default

  # Media

     pkgs.jellyfin
     pkgs.jellyfin-web
     pkgs.jellyfin-ffmpeg
     pkgs.vlc
     pkgs.ffmpeg-full
     pkgs.mpv
     pkgs.yt-dlp
     pkgs.unetbootin
     pkgs.beets

  # Packages

     pkgs.cron
     pkgs.cups
     pkgs.neofetch
     pkgs.firefox
     pkgs.git
     pkgs.git-lfs
     pkgs.wget
     pkgs.ripcord
     pkgs.revolt-desktop
     pkgs.weechat
     pkgs.steam
     pkgs.steam-run
     pkgs.signal-desktop
     pkgs.kdePackages.dolphin
    
     pkgs.fluffychat
     pkgs.matrix-synapse
     # pkgs.matrix-appservice-discord
     
     pkgs.cinny-desktop

     pkgs.hledger
     pkgs.hledger-ui
     pkgs.hledger-iadd
     pkgs.hledger-web

     pkgs.obsidian
     pkgs.notesnook
     pkgs.audacity
     pkgs.freetube
     pkgs.lmms
     pkgs.freshrss
     pkgs.webcord
     pkgs.discord
     pkgs.reaper
     pkgs.puredata
     pkgs.fmodex
     #pkgs.vcv-rack

     pkgs.lshw
     pkgs.waybar

     pkgs.alsa-scarlett-gui
     pkgs.alsa-utils
     pkgs.pwvucontrol

     pkgs.qbittorrent
     pkgs.wireguard-tools

     pkgs.curl
     pkgs.zip
     pkgs.unzip
     pkgs.gnutar

     pkgs.prismlauncher
     pkgs.dolphin-emu

  # Terminals

     pkgs.kitty
     pkgs.foot

  # Managers

     pkgs.home-manager
     pkgs.hyprland
     pkgs.nvd
     pkgs.brightnessctl
     pkgs.ddcutil
     pkgs.miniflux
     pkgs.electron

  # Notes

     pkgs.logseq
     pkgs.zathura

  # Code Editors

     pkgs.vscode
     pkgs.neovim

  # Art Applications

    pkgs.krita
    pkgs.xp-pen-g430-driver
    pkgs.opentabletdriver
    pkgs.tiled    

  # Game Engines / Frameworks

     pkgs.unityhub
     pkgs.godotPackages_4_5.godot-mono
     pkgs.dotnetCorePackages.dotnet_9.sdk
     pkgs.vscode-extensions.woberg.godot-dotnet-tools

     # pkgs.nodejs_26
     pkgs.python313Packages.meson
     pkgs.python313Packages.cmake
     pkgs.gnumake

     pkgs.libgccjit
     pkgs.gnat15

     pkgs.glfw
     pkgs.mesa
     pkgs.cmake
     pkgs.gcc

     pkgs.libGL
     pkgs.pkg-config
     pkgs.direnv
     pkgs.nix-direnv

     # Emulation

     pkgs.vbam

     # Virtualisation

     pkgs.gnome-boxes
     pkgs.dnsmasq
     pkgs.phodav

  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
