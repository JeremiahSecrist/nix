{
  disks ? ["/dev/disk/by-id/usb-_USB_DISK_3.2_0700199604A32D02-0:0" "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S59ANMFNB34577E"],
  partitionSizes ? ["34G" "120G" "700G"],
  ...
}: {
  disk = {
    disk0 = {
      type = "disk";
      device = builtins.elemAt disks 0;
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            # type = "partition";
            name = "ESP";
            start = "1MiB";
            end = "2g";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
              ];
            };
          }
          {
            name = "swap";
            # type = "partition";
            start = "2g";
            end = builtins.elemAt partitionSizes 0;
            part-type = "primary";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          }
          {
            # type = "partition";
            name = "luks";
            start = builtins.elemAt partitionSizes 0;
            end = "100%";
            content = {
              type = "luks";
              name = "crypted";
              extraOpenArgs = ["--allow-discards"];
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          }
        ];
      };
    };
    disk1 = {
      type = "disk";
      device = builtins.elemAt disks 1;
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            # type = "partition";
            name = "luks";
            start = "1g";
            end = "100%";
            content = {
              type = "luks";
              name = "nvme_crypted";
              extraOpenArgs = ["--allow-discards"];
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          }
        ];
      };
    };
  };
  lvm_vg = {
    pool = {
      type = "lvm_vg";
      lvs = {
        root = {
          # type = "lvm_lv";
          size = builtins.elemAt partitionSizes 1;
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [
              "defaults"
            ];
          };
        };
        home = {
          # type = "lvm_lv";
          size = builtins.elemAt partitionSizes 2;
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/home";
          };
        };
      };
    };
  };
}
