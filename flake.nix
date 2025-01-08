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
        neovim
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
        
        # System packages
        environment.systemPackages = commonPackages pkgs ++ [
        ];
      };

      # Home-manager common configuration
      homeConfig = { pkgs, ... }: {
        home = {
          username = "axl";  # Change this
          homeDirectory = if pkgs.stdenv.isDarwin
            then lib.mkForce (toString /Users/axl) 
            else lib.mkForce (toString /home/axl) /home/axl;
          
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
            # Your custom zsh configuration here
          '';
        };

        programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            # extraLuaConfig = lib.fileContents neovim/init.lua;
            extraLuaConfig = builtins.readFile ./neovim/init.lua;
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
              users.axl = homeConfig;  
            };
          }
        ];
      };

      # Linux home-manager configuration
      homeConfigurations."inux" = home-manager.lib.homeManagerConfiguration {  
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ homeConfig ];
      };
    };
}
