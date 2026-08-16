{
  description = "Emette's Flake";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    #home-manager = {

    #  url = "github:nix-community/home-manager/release-25.05";
    #  inputs.nixpkgs.follows = "nixpkgs";

    #};

    # nixgl.url = "github:nix-community/nixGL";

    firefox.url = "github:nix-community/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    rose-pine-hyprcursor = {

      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";

    };

    nbfc-linux = {
      
      url = "github:nbfc-linux/nbfc-linux?dir=pkgbuilds/nix";
      inputs.nixpkgs.follows = "nixpkgs";

    };

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    
    nixosConfigurations = {

      wander = nixpkgs.lib.nixosSystem {

        specialArgs = { inherit inputs; };

        modules = [
	
	  ./modules/configuration.nix
	  ./modules/fhs.nix

	  # home-manager.nixosModules.default
	  # {

	  #  home-manager = {

	  #    useGlobalPkgs = true;
	  #    useUserPackages = true;
	  #    users.electrickazoo = import ./modules/home.nix;

	  #  };

	  # }

        ];

      };

    };

  };

}
