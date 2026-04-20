{ lib, buildNpmPackage, fetchFromGitLab }:

buildNpmPackage rec {
  pname = "readability-cli";
  # Using main branch HEAD because the v2.4.5 tag ships an outdated
  # package-lock.json (version 2.4.4) that references unresolvable
  # dompurify peer dep. Main HEAD has the correct lockfile.
  version = "2.4.5-unstable-2026-01-07";

  src = fetchFromGitLab {
    owner = "gardenappl";
    repo = "readability-cli";
    rev = "72c232e3cd33e91ab04b7dacfa649082b8037436";
    hash = "sha256-5a4mQbfJKAL8nOSnqnKQCjb6bJEEX59puwCw0KmddOo=";
  };

  npmDepsHash = "sha256-6S0HT98UYyMzlmC39wkVJZP0YavsFhfBh4ucYigUvMQ=";
  npmDepsFetcherVersion = 2;
  dontNpmBuild = true;

  meta = {
    description = "Command-line interface for Mozilla's Readability library";
    homepage = "https://gitlab.com/gardenappl/readability-cli";
    license = lib.licenses.gpl3Plus;
    mainProgram = "readable";
    platforms = lib.platforms.all;
  };
}

