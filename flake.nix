{
  description = "Service mono-repo flake";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/release-20.03"; };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      pkgsFor = system: import nixpkgs { inherit system; };
    in {
      devShell.x86_64-linux = let pkgs = pkgsFor "x86_64-linux";
      in with pkgs;
      mkShell {
        nativeBuildInputs = [
          fd
          nixfmt
          (writeShellScriptBin "p-format" "fd -e nix --exec nixfmt")
        ];
      };

      services = let inherit (pkgsFor "x86_64-linux") callPackage;
      in lib.mapAttrs (name: _: callPackage (./services + "/${name}") { })
      (builtins.readDir ./services);

      templates = {
        service = {
          path = ./shared/templates/service;
          description = "Service flake";
        };
      };

      defaultTemplate = self.templates.service;
    };
}
