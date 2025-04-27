{ pkgs ? import <nixpkgs> { } } @attrs:
let
  # copy builder from here https://github.com/arnarg/nix-gleam/blob/main/builder/default.nix
  inherit (builtins) fromTOML readFile;
  src = ./.;
  gleamToml = fromTOML (readFile (src + "/gleam.toml"));
  manifestToml = fromTOML (readFile (src + "/manifest.toml"));
  buildTarget = attrs.target or gleamToml.target or "erlang";


  # Generates a packages.toml expected by gleam compiler.
  packagesToml = with pkgs.lib;
    concatStringsSep "\n" (
      [ "[packages]" ]
      ++ (map
        (p: "${p.name} = \"${p.version}\"")
        manifestToml.packages)
    );

in
pkgs.stdenv.mkDerivation {
  name = "reagir";
  src = src;
  nativeBuildInputs = [
    pkgs.gleam
    pkgs.bun
  ];

  buildPhase = ''
    runHook preBuild
    set -x 

    echo "Building project..."
    gleam build
    bun build --compile --minify --sourcemap build/dev/javascript/reagir/main.mjs --outfile reagir

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    set -x

    mkdir -p $out/
    cp reagir $out/
    chmod +x $out/reagir

    mkdir -p $out/bin
    ln -s $out/reagir $out/bin/reagir

    runHook postInstall
  '';
}
