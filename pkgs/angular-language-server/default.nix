{ buildNpmPackage, fetchurl }:

buildNpmPackage rec {
  pname = "angular-language-server";
  version = "18.2.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@angular/language-server/-/language-server-${version}.tgz";
    hash = "sha256-UvYOxs59jOO9Yf0tvX96P4R/36qPeEne+NQAFkg9Eis=";
  };

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-stB85lVfZPWr9ycO4HSXyaHNx0PhicjSFI8KuXHCd5k=";
  dontNpmBuild = true;
}
