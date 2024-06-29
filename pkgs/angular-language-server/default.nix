{ buildNpmPackage, fetchurl }:

buildNpmPackage rec {
  name = "angular-language-server";
  version = "18.0.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@angular/language-server/-/language-server-${version}.tgz";
    hash = "sha256-sIp9e4J83lrKM1dFPQOMBstTfM1fBOrGQspNMcINUkA=";
  };

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-oLe8X6ykFoMOMMYODP6sEK2s1ihhM35sJf3jpOpfasY=";
  dontNpmBuild = true;
}
