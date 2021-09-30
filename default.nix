{ mkDerivation, base, lib, process, xmobar }:
mkDerivation {
  pname = "xmobar-luca";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base process xmobar ];
  executableHaskellDepends = [ base xmobar ];
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
