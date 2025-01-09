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
        
        # Zsh plugins
        zsh-autosuggestions
        zsh-syntax-highlighting
        
        # Go development
        go
        gopls       # Go language server
        golangci-lint

        ## 
        typescript
        
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

        # Set zsh as default shell
        users.users.axelalmquist.shell = pkgs.zsh;
        nixpkgs.hostPlatform = "x86_64-darwin";
        
        # fingerprint
        # security.pam.enableSudoTouchIdAuth = true;

        # # System packages
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
          enableCompletion = true;
          syntaxHighlighting.enable = true;
          autosuggestion.enable = true;
          
          oh-my-zsh = {
            enable = true;
            plugins = [
              "git"
              "docker"
              "kubectl"
              "history"
              "sudo"
            ];
            theme = "fino";
          };

          initExtraFirst = ''
            # Ensure nix paths are first in PATH
            export PATH="/etc/profiles/per-user/axelalmquist/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
          '';
          
          initExtra = ''
            # Go configuration
            export GOPATH="$HOME/go"
            export PATH="$GOPATH/bin:$PATH"
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
