{
  description = "Nix flake for hyperpas.tel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        baseBuildInputs = with pkgs; [ zola ];

        website = pkgs.stdenv.mkDerivation {
          name = "website";
          version = "1.0.0";

          src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;

          buildInputs = baseBuildInputs ++ [ ];

          buildPhase = "zola build -o $out";
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = baseBuildInputs ++ [ ];
          shellHook = ''
            export PROJECT_PREFIX=hyperpastel
            echo "Entered dev shell for project hyperpastel"
          '';
        };

        packages = {
          website = website;
          default = website;
        };
      }
    );
}
