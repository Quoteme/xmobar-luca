{ pkgs ? import <nixpkgs> {} }: with pkgs;
let
  xmonadctl = callPackage (fetchFromGitHub {
    owner = "quoteme";
    repo = "xmonadctl";
    rev = "v1.0";
    sha256 = "1bjf3wnxsghfb64jji53m88vpin916yqlg3j0r83kz9k79vqzqxd";
  }) {};
in
haskellPackages.mkDerivation {
  pname = "xmobar-luca";
  version = "0.1.0.0";
  src = ./.;
  # buildInputs = [ xmonadctl ];
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = with haskellPackages; [ base xmobar ];
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
