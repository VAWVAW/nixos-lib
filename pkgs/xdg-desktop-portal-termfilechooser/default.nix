{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  inih,
  scdoc,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-termfilechooser";
  version = "2021-07-14";

  src = fetchFromGitHub {
    owner = "hunkyburrito";
    repo = pname;
    rev = "d3139a43a89fe4f8239722dff8ed9270000e92ef";
    sha256 = "sha256-F4B0s5mXJNNy4e9QDg1Sh91Fw42sUzvcLjqulIC2O9Q=";
  };

  patches = [
    ./remove-path-rewrite.patch
  ];

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];
  buildInputs = [
    inih
    systemd
  ];

  mesonFlags = [
    "-Dsd-bus-provider=libsystemd"
  ];

  meta = with lib; {
    homepage = "https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser";
    description = "xdg-desktop-portal backend for choosing files with your favorite file chooser";
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
