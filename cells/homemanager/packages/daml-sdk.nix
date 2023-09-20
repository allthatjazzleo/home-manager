{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) stdenv fetchurl lib makeWrapper;
in
  stdenv.mkDerivation rec {
    pname = "daml-sdk";
    version = "2.7.1";

    src = fetchurl {
      url = "https://github.com/digital-asset/daml/releases/download/v${version}/daml-sdk-${version}-macos.tar.gz";
      sha256 = "sha256-cqZnJYbgk+cDbGow6j8CA+z0zaGGri9ydqqW2bItrC8=";
    };

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out
      tar -xzvf $src -C $out
      chmod +x $out/sdk-${version}/install.sh
      export HOME=$out
      $out/sdk-${version}/install.sh
      makeWrapper $out/.daml/bin/daml $out/bin/daml
    '';

    meta = with lib; {
      description = "DAML SDK";
      homepage = "https://www.digitalasset.com/";
      license = licenses.asl20;
      platforms = platforms.darwin;
    };
  }
