{config, ...}: {
  boot.kernel.sysctl = {"kernel.sysrq" = 1;};
}
