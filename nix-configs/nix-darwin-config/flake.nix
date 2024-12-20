{
  description = "Cross-platform system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nixos }: {
    # Common configuration for both platforms
    commonConfiguration = { pkgs, ... }: {
      environment.systemPackages = [
        pkgs.vim
        pkgs.git
        pkgs.curl
        pkgs.wget
      ];

      nix.settings.experimental-features = "nix-command flakes";
    };

    ####### Platform-specific package selections #####
    darwinPackages = { pkgs, ... }: [
      pkgs.iterm2
    ];

    nixosPackages = { pkgs, ... }: [
    ];

    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        self.commonConfiguration
        ({ pkgs, ... }: {
          services.nix-daemon.enable = true;
          programs.zsh.enable = true;
          
          # Darwin-specific packages
          environment.systemPackages = self.darwinPackages { inherit pkgs; };
          
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 4;
          nixpkgs.hostPlatform = "aarch64-darwin";
        })
      ];
    };

    nixosConfigurations."nixos" = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.commonConfiguration
        ({ pkgs, ... }: {

          # Basic system configuration
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          # NixOS-specific packages
          environment.systemPackages = self.nixosPackages { inherit pkgs; };
          
          # services.openssh.enable = true;
          # time.timeZone = "UTC";
          programs.zsh.enable = true;

          users.users.axl = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            initialPassword = "changeme";
          };

          system.stateVersion = "24.10";
        })
      ];
    };
  };
}
