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
        # Configure PATH to include all necessary Nix paths
        environment.systemPath = [
            "/run/current-system/sw/bin"
            "/nix/var/nix/profiles/default/bin"
            "/etc/profiles/per-user/$USER/bin"
            "/run/wrappers/bin"
            "/run/current-system/sw/bin"
            "/nix/var/nix/profiles/default/bin"
            "/opt/homebrew/bin"  # Keep Homebrew as fallback
        ];
        
        # Ensure nix-darwin tools are available
        environment.pathsToLink = [ "/Applications" "/Applications/Utilities" "/Developer" "/Library" "/usr/bin" "/usr/sbin" ];
        
        # System packages
        environment.systemPackages = commonPackages pkgs;
      };
      lib = nixpkgs.lib;
      # Home-manager common configuration
      homeConfig = { pkgs, lib,... }: {
        home = {
          username = "axelalmquist";  
          homeDirectory = if pkgs.stdenv.isDarwin
            then lib.mkForce (toString /Users/axelalmquist) 
            else lib.mkForce (toString /home/axl);
          
          packages = commonPackages pkgs;
          
          stateVersion = "23.11";
        };
        
        programs.zsh = {
          enable = true;
          initExtra = ''
            # Ensure Nix paths take precedence
            export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/etc/profiles/per-user/$USER/bin:$PATH"
            
            # Add darwin-rebuild to PATH
            if [ -e '/nix/var/nix/profiles/default/bin/darwin-rebuild' ]; then
              export PATH="/nix/var/nix/profiles/default/bin:$PATH"
            fi
            
            # Prevent accidental Homebrew usage
            brew() {
              echo "Homebrew is disabled. Using Nix instead."
              return 1
            }
            
            # Ensure we use Nix's neovim
            alias vim="$(which nvim)"
            alias vi="$(which nvim)"
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
              backupFileExtension = "backup";
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
