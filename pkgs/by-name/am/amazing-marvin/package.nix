{ appimageTools, fetchurl, lib }:

let
  pname = "amazing-marvin";
  version = "1.65.0";

  src = fetchurl {
    url = "https://amazingmarvin.s3.amazonaws.com/Marvin-${version}.AppImage";
    sha256 = "sha256-ZkMo9SJL5x0ncGmcscoHgF+A6K9MWshAHdUdAGQkz9k=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

in appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/marvin.desktop $out/share/applications/marvin.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/marvin.png \
      $out/share/icons/hicolor/512x512/apps/marvin.png
    substituteInPlace $out/share/applications/marvin.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Desktop client for Amazing Marvin";
    mainProgram = "marvin";
    homepage = "https://amazingmarvin.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ otisdog8 ];
  };
}
