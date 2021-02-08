{
  description = "Golang Service";

  outputs = { self, nixpkgs }:
    let
      service = "service";
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {

      packages.${system}.${service} = pkgs.stdenv.mkDerivation {
      };

      defaultPackage.${system} = self.packages.${system}.${service};

      devShell.${system} = with pkgs; mkShell { nativeBuildInputs = [
        vgo2nix
      ]; };
    };
}
