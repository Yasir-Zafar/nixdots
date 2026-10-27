# omnisearch: small metasearch engine in C (ddg, startpage, yahoo, mojeek), not in nixpkgs.
# Upstream lives on git.bwaaa.monster; this builds from the codeberg mirrors. beaker is its
# web/template library, built alongside. Adds a gruvbox theme and makes it the default.
# Runs as a service in modules/nixos/services/omnisearch.nix.
# Update: bump rev/version, set hash = "" and build; nix prints the new hash.
{
  lib,
  stdenv,
  fetchFromCodeberg,
  curl,
  libxml2,
  openssl,
}: let
  beaker = stdenv.mkDerivation {
    pname = "beaker";
    version = "0-unstable-2026-09-29";

    src = fetchFromCodeberg {
      owner = "gabrielf";
      repo = "beaker";
      rev = "10be7f581fb828e74f064ea7ad4fb0534ee8540a";
      hash = "sha256-Al/BE7uVRSmUGF/t1m0pWxF9jNgzdCVUrc5ZHkcPiQg=";
    };

    installPhase = ''
      install -Dm644 build/libbeaker.so build/libbeaker.a -t $out/lib
      install -Dm644 beaker.h -t $out/include
    '';

    meta.license = lib.licenses.lgpl21Plus;
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "omnisearch";
    version = "0-unstable-2026-10-25";

    src = fetchFromCodeberg {
      owner = "gabrielf";
      repo = "omnisearch";
      rev = "e5a836e1359bbc06a1c197cd02b1732368928e62";
      hash = "sha256-n+5q3q2mMhg7marSHIYGfwsJLLvLBkx2S1kkDyHfVJk=";
    };

    buildInputs = [beaker curl libxml2 openssl];

    # the Makefile asks git for these and hardcodes /usr/include/libxml2
    makeFlags = ["VERSION=${finalAttrs.version}" "GIT_REMOTE=https://codeberg.org/gabrielf/omnisearch"];
    env.NIX_CFLAGS_COMPILE = "-I${lib.getDev libxml2}/include/libxml2";

    # gruvbox as the default theme (still switchable in /settings), branded MeurSearch
    postPatch = ''
      cp ${./gruvbox.css} static/themes/gruvbox.css
      substituteInPlace src/Utility/Utility.c \
        --replace-fail ': "system");' ': "gruvbox");'
      substituteInPlace templates/home.html \
        --replace-fail 'Omni<span>Search</span>' 'Meur<span>Search</span>'
      substituteInPlace templates/* locales/* --replace-quiet OmniSearch MeurSearch
    '';

    # templates/static/locales are read from the working directory, next to config.ini
    installPhase = ''
      install -Dm755 bin/omnisearch -t $out/bin
      mkdir -p $out/share/omnisearch
      cp -r templates static locales $out/share/omnisearch
    '';

    meta = {
      description = "Lightweight metasearch engine written in C";
      homepage = "https://codeberg.org/gabrielf/omnisearch";
      license = lib.licenses.gpl2Plus;
      mainProgram = "omnisearch";
      platforms = lib.platforms.linux;
    };
  })
