{ lib, stdenv, autoPatchelfHook, fetchurl, gcc }:

stdenv.mkDerivation rec {
  pname = "opencode";
  version = "1.14.26";

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-x64.tar.gz";
    hash = "sha256-73rr5pkFQKjdE/KKLq5HburvprrZUPpfI7cz7yn8tdU=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ gcc.cc.lib ];

  installPhase = ''
    mkdir -p $out/bin
    cp opencode $out/bin/
    chmod +x $out/bin/opencode
  '';

  meta = {
    description = "The open source coding agent";
    homepage = "https://opencode.ai/";
    license = lib.licenses.mit;
    mainProgram = "opencode";
    platforms = [ "x86_64-linux" ];
  };
}
