{
  description = "Multi-platform development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Darwin-specific inputs
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Home-manager for both platforms
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      # System settings
      systemSettings = {
        system.stateVersion = 4;
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        services.nix-daemon.enable = true;
      };

      # Common packages for both platforms
      commonPackages = pkgs: with pkgs; [
        # Development tools
        git
        gnumake
        cmake
        
        # Utils
        ripgrep
        fd
        jq
        curl
        wget
      ];

      # Darwin-specific configuration
      darwinConfig = { pkgs, ... }: {
        inherit (systemSettings) system nix;
        services.nix-daemon.enable = true;
        
        # System configuration
        programs.zsh.enable = true;
        nixpkgs.hostPlatform = "x86_64-darwin";


        # Configure PATH to only include Nix paths
        environment.systemPath = [
            "/run/current-system/sw/bin"
            "/nix/var/nix/profiles/default/bin"
        ];

        # Add shell configuration to explicitly set PATH
        programs.zsh.shellInit = ''
            # Clear existing PATH
            export PATH=""
            # Add only Nix paths
            export PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH
        '';
        
        # System packages
        environment.systemPackages = commonPackages pkgs ++ [
        ];
      };


      lib = nixpkgs.lib;  # Add this line

      # Home-manager common configuration
      homeConfig = { pkgs, lib,... }: {
        home = {
          username = "axelalmquist";  
          homeDirectory = if pkgs.stdenv.isDarwin
            then lib.mkForce (toString /Users/axelalmquist) 
            else lib.mkForce (toString /home/axl);
          
          packages = commonPackages pkgs;
          
          # Don't change this unless you know what you're doing
          stateVersion = "23.11";
        };

        # # Git configuration
        # programs.git = {
        #   enable = true;
        #   userName = "Your Name";  # Change this
        #   userEmail = "your.email@example.com";  # Change this
        # };

        # Shell configuration
        programs.zsh = {
          enable = true;
          initExtra = ''
            # Prevent accidental Homebrew usage
            brew() {
              echo "Homebrew is disabled. Using Nix instead."
              return 1
            }
            
            # Your other zsh configurations...
          '';
        };

        programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            extraLuaConfig = lib.fileContents ./nvim/init.lua;
            extraPackages = [
              pkgs.gcc
              pkgs.lua-language-server
            ];
          };

      };

    in
    {
      # Darwin configuration
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {  
        system = "x86_64-darwin";
        modules = [
          darwinConfig
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.axelalmquist = homeConfig;  
              backupFileExtension = "backup";  # Add this line
            };
          }
        ];
      };

      # Linux home-manager configuration
      homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {  
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ homeConfig ];
      };
    };
}
