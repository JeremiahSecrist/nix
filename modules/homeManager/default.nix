{
  noisetorch = import ./noisetorch;
  default = {
    imports = [
      ./noisetorch
      # ./guake
    ];
  };
}
