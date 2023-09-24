{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) stdenv fetchurl lib makeWrapper;
in
  stdenv.mkDerivation rec {
    pname = "canton";
    version = "2.7.1";

    src = fetchurl {
      url = "https://github.com/digital-asset/daml/releases/download/v${version}/canton-open-source-${version}.tar.gz";
      sha256 = "sha256-iB5HO0wWHWXqFH4mFEIsylOVsIdLdHWqt3nVK57dNsY=";
    };

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out
      tar -xzvf $src -C $out
      makeWrapper $out/canton-open-source-${version}/bin/canton $out/bin/canton
    '';

    meta = with lib; {
      description = "Canton";
      homepage = "https://www.digitalasset.com/";
      license = licenses.asl20;
      platforms = platforms.darwin;
    };
  }
