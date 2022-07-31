with (import <nixpkgs> {});
mkShell {
  shellHook = '' 
  '';
  buildInputs = [
    gnumake
  ];
}