{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) stdenv;
  pkgs = inputs.nixpkgs;
  obtainValueForOS = linuxVal: macosVal:
    if stdenv.isLinux
    then linuxVal
    else
      (
        if stdenv.isDarwin
        then macosVal
        else throw "OS not supported: Linux & MacOS only"
      );

  osVersion = obtainValueForOS "linux" "macos";

  damlSdkVersion = "2.7.1";
  damlSdkSha256 = obtainValueForOS "72b6151168b8229e040cf4ed033c9838c1f0d986e63f18186091280dc82f4ea9" "72a6672586e093e7036c6a30ea3f0203ecf4cda186ae2f7276aa96d9b22dac2f";

  installCmd =
    obtainValueForOS
    # linux
    ''
      LIB_DIR=daml/lib
      exec "$LIB_DIR/ld-linux-x86-64.so.2" --library-path "$LIB_DIR" "$LIB_DIR/daml" install .
    ''
    # macos
    ''
      daml/daml install .
    '';
in
  stdenv.mkDerivation {
    name = "daml-sdk-${damlSdkVersion}-${osVersion}";

    src = pkgs.fetchurl {
      url = "https://github.com/digital-asset/daml/releases/download/v${damlSdkVersion}/daml-sdk-${damlSdkVersion}-${osVersion}.tar.gz";
      sha256 = damlSdkSha256;
    };

    buildInputs = [
      pkgs.coreutils
    ];

    buildPhase = "patchShebangs .";

    installPhase =
      ''
        mkdir -p $out
        export DAML_HOME=$out
      ''
      + installCmd;

    preFixup = ''
      mkdir -p $out/nix-support
      echo export DAML_HOME=$out > $out/nix-support/setup-hook
    '';
  }
