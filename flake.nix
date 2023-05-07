{
  description = "zmk dev flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            ccache
            cmake
            dfu-util
            dtc
            gcc-arm-embedded
            ninja

            (python3.withPackages (ps:
              with ps; [
                pyelftools
                pyyaml
                canopen
                packaging
                progress
                anytree
                intelhex
                west
              ]))
          ];

          ZEPHYR_TOOLCHAIN_VARIANT = "gnuarmemb";
          GNUARMEMB_TOOLCHAIN_PATH = pkgs.gcc-arm-embedded;
        };
      }
    );
}
