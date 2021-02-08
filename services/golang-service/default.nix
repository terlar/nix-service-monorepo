{ stdenv, buildGoModule, go, govers, mkShell, nix-gitignore, vgo2nix }:

let name = "golang-service";
in {
  service = buildGoModule {
    pname = name;
    version = "0.0.1";
    src = nix-gitignore.gitignoreSource [ "README.*" "*.nix" ] ./.;
    goDeps = ./deps.nix;
  };

  devShell = mkShell {
    nativeBuildInputs = [ go govers vgo2nix ];
    shellHook = ''
      echo 'Entering ${name}'
      cd $PWD/${stdenv.lib.removePrefix (toString ../../.) (toString ./.)}
    '';
  };
}
