{
  fetchFromGitHub,
  mkYarnPackage,
  fetchYarnDeps,
  curl,
  # , qemu-utils
  # , python3-vmdkstream
  git,
  libxml2,
  fuse,
  # , nbdkit
  turbo,
}: let
  src = fetchFromGitHub {
    owner = "vatesfr";
    repo = "xen-orchestra";
    rev = "e2d83324ac513ba579d4f3376a2b20f4d6522548";
    hash = "sha256-L1ImFKEAtBsbBNZLDehdIb4o+iUt7YONW8btOpHBiy0=";
  };
in
  mkYarnPackage {
    name = "XO";
    version = src.rev;
    src = src;
    buildinputs = [
      fuse
      turbo
      libxml2
      curl
      git
    ];
    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      sha256 = "sha256-lT8rmZd21kF9aDMF4uoNPz7nOjoMrtfnpdUyePJsbWo=";
    };
  }
