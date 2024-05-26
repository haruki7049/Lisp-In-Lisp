{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    cl-nix-lite.url = "github:hraban/cl-nix-lite";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, nixpkgs, cl-nix-lite, flake-utils, treefmt-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        overlays = [
          cl-nix-lite.overlays.default
        ];
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
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
          formatter = treefmtEval.config.build.wrapper;
          checks = {
            formatting = treefmtEval.config.build.check self;
          };

          packages = {
            inherit sbcl clisp ecl;
            default = sbcl;
          };
        });
  }
