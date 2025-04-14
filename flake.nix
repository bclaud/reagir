{
  description = "Gleam flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-gleam.url = "github:arnarg/nix-gleam";
  };

  outputs = { self, nixpkgs, flake-utils, nix-gleam, ... }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      eachSystem = with nixpkgs.lib; f: foldAttrs mergeAttrs { }
        (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems);
    in
    eachSystem (system:
      let
        inherit (nixpkgs.lib) optional;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nix-gleam.overlays.default
          ];
        };
      in
      with pkgs;
      {

        # it's result on very large package: 1.4G :o
        packages.default = pkgs.buildGleamApplication {
          erlang = pkgs.beam_minimal.interpreters.erlang_26;
          src = ./.;
        };

        formatter = nixpkgs-fmt;

        devShells.default = mkShell {
          name = "gleam-shell";
          buildInputs = with pkgs; [ gleam rebar3 erlang watchexec yq-go deno elixir wasmtime bun];
          LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
        };
      }
    );

}
