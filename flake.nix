{
  description = "Home Manager configuration of maruf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim.url = "github:nixos/nixpkgs?rev=e9f00bd893984bc8ce46c895c3bf7cac95331127";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-darwin,
      zen-browser,
      ...
    }:
    let
      linux = "x86_64-linux";
      mac = "aarch64-darwin";
      macosConfigurations =
        { pkgs, ... }:
        {
          security.pam.services.sudo_local.touchIdAuth = true;
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Set this to the version used during initial system setup
          system.stateVersion = 6;

          environment.systemPackages = with pkgs; [
            cloudflared
          ];

          nixpkgs.hostPlatform = mac;
          nixpkgs.config = {
            allowUnfree = true;
          };

          users.users.marufs = {
            name = "marufs";
            home = "/Users/marufs";
          };

          nix.linux-builder.enable = true;

          # aarch64-linux matches your M1 natively; add x86_64-linux only if needed
          nix.settings.trusted-users = [ "@admin" ];
        };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = linux;

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager # Add this import
          {
            home-manager = {

              extraSpecialArgs = {
                neovimPkgs = import inputs.neovim {
                  system = linux;
                  config.allowUnfree = true;
                };
              };
              users.marufs = {
                nixpkgs.config.allowUnfree = true;

                imports = [
                  ./home.nix
                  zen-browser.homeModules.beta
                ];
              };
            };
          }
        ];
      };

      darwinConfigurations.macos = nix-darwin.lib.darwinSystem {
        system = mac;

        modules = [
          macosConfigurations
          home-manager.darwinModules.home-manager # add the module
          {
            home-manager = {
              backupFileExtension = ".backup";
              extraSpecialArgs = { inherit inputs; };
              useGlobalPkgs = true;
              useUserPackages = true;

              users.marufs = {
                imports = [
                  ./marufs.nix # your mac home file
                ];
              };
            };
          }
        ];
      };

      # home config for aarch64 nix-darwin
      homeConfigurations."marufs" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = mac;
          config.allowUnfree = true;
        };

        extraSpecialArgs = {
          neovimPkgs = import inputs.neovim {
            system = mac;
            config.allowUnfree = true;
          };
        };

        modules = [
          ./marufs.nix
        ];
      };
    };
}
