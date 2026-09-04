{
  description = "Basic nixos config";

  outputs = inputs: import ./outputs.nix inputs;

  nixConfig = {
    warn-dirty = false;
    # Extra caches can slow builds if DNS/network is unstable.
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    master.url = "github:Nixos/nixpkgs/master";
    unstable.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    stable.url = "github:Nixos/nixpkgs/nixos-24.11";

    nixpkgs.follows = "unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # kept unpinned to nixpkgs on purpose — its kernel/firmware
    # packages need patches only guaranteed to build against its own pinned nixpkgs
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cclock.url = "github:tenyoru/cclock/v0.1.1";

    googleworkspace-cli = {
      url = "github:googleworkspace/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "path:./dotfiles";
      flake = true;
    };

    # No nixpkgs.follows on purpose — binary cache hits require
    # tracking noctalia's own pinned nixpkgs, per their cachix branch docs
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
  };
}
