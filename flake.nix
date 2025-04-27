{
  description = "Gleam flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"

        "aarch64-darwin"
        "x86_64-darwin"
      ];

      eachSystem = with nixpkgs.lib; f: foldAttrs mergeAttrs { }
        (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems);
    in
    eachSystem (system:
      let
        inherit (nixpkgs.lib) optional;
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      with pkgs;
      {

        packages.default = pkgs.callPackage ./default.nix { };
        formatter = nixpkgs-fmt;

        devShells.default = mkShell {
          name = "gleam-shell";
          buildInputs = with pkgs; [
            bun
            gleam
            watchexec
          ];
          LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
        };
      }
    );

}
