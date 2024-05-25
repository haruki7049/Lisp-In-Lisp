{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    cl-nix-lite.url = "github:hraban/cl-nix-lite";
  };

  outputs = { self, nixpkgs, cl-nix-lite, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        overlays = [
          cl-nix-lite.overlays.default
        ];
        lib = pkgs.lib;
        name = "Lisp-In-Lisp";
        lispSystem = "lil";
        src = pkgs.lib.cleanSource ./.;
        lispDependencies = with pkgs.lispPackagesLite; [
          alexandria
          arrow-macros
        ];
        meta = with lib; {
          license = licenses.mit;
        };
        sbcl = with pkgs.lispPackagesLite; lispDerivation {
          inherit name src lispSystem lispDependencies meta;
          dontStrip = true;
        };
        clisp = with pkgs.lispPackagesLiteFor pkgs.clisp; lispDerivation {
          inherit name src lispSystem lispDependencies meta;
        };
        ecl = with pkgs.lispPackagesLiteFor pkgs.ecl; lispDerivation {
          inherit name src lispSystem lispDependencies meta;
        };
      in
        {
          packages = {
            inherit sbcl clisp ecl;
            default = sbcl;
          };
        });
  }
