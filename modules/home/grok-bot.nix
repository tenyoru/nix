{
  lib,
  pkgs,
  ...
}: let
  grok-bot = pkgs.stdenv.mkDerivation rec {
    pname = "grok-bot";
    version = "0.36.0";

    src = pkgs.requireFile {
      name = "grok-bot_${version}_amd64.deb";
      sha256 = "sha256-lItBd2Z9mgORXBruSX58VDhwU5PagIOmrwF3KIUS0H4=";
      url = "https://x.ai/bot";
      message = ''
        nix-store --add-fixed sha256 ~/Downloads/grok-bot_${version}_amd64.deb
      '';
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      dpkg
      makeWrapper
      wrapGAppsHook3
    ];

    buildInputs = with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libGL
      libdrm
      libgbm
      libkrb5
      libnotify
      libsecret
      libuuid
      libxkbcommon
      nspr
      nss
      pango
      stdenv.cc.cc
      udev
      vulkan-loader
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxtst
      libxcb
      libxshmfence
      libxscrnsaver
    ];

    runtimeDependencies = with pkgs; [
      libGL
      libpulseaudio
      libsecret
      udev
      vulkan-loader
    ];

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x $src .
      runHook postUnpack
    '';

    dontBuild = true;
    dontWrapGApps = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r opt $out/
      cp -r usr/share $out/share
      mkdir -p $out/bin
      runHook postInstall
    '';

    postFixup = ''
      makeWrapper "$out/opt/Grok Bot/grok-bot" $out/bin/grok-bot \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags --no-sandbox \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath (with pkgs; [
        libGL
        libpulseaudio
        libsecret
        udev
        vulkan-loader
      ])}" \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]}
      substituteInPlace $out/share/applications/grok-bot.desktop \
        --replace-fail 'Exec=grok-bot %U' "Exec=$out/bin/grok-bot %U"
    '';

    meta = {
      description = "Grok Bot desktop agent";
      homepage = "https://x.ai/bot";
      platforms = ["x86_64-linux"];
      mainProgram = "grok-bot";
    };
  };
in {
  home.packages = [grok-bot];
}
