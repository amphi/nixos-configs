# nixos-configs

Here I'll try to come up with a nixos-config that works for me.

I sometimes add other repositories as submodules to browse them more easily.

## Useful links

- https://github.com/Misterio77/nix-starter-configs
- https://github.com/colemickens/nixos-flake-example
- https://github.com/jtraue/nixos-configs
- https://github.com/blitz/nix-configs
- https://github.com/tfc/nixos-configs
- https://github.com/tfc/nixos-auto-installer
- https://github.com/tfc/nixos-anywhere-example
- https://github.com/Gabriella439/nixos-in-production
- https://github.com/nix-community/lanzaboote
- https://github.com/numtide/nixos-anywhere
- https://mtlynch.io/notes/nix-first-impressions/
- https://borretti.me/article/nixos-for-the-impatient
- https://jvns.ca/blog/2023/02/28/some-notes-on-using-nix/
- https://ipetkov.dev/blog/tips-and-tricks-for-nix-flakes/
- https://github.com/tljuniper/dotfiles

## Installation

Optional: set german keyboard layout `sudo loadkeys de-latin1-nodeadkeys`.

The following instructions are for partitioning a disk with three partitions:
- a small one as a boot partition
- a swap partition, in this case with 8GB
- the remainder will be the root partition

The root and the swap partition will be encrypted.
Please note that it may happen that you have to exchange `/dev/sda` with
something else.

1. Create a GPT partition table
    ```
    # parted /dev/sda -- mklabel gpt
    ```
    
2. Add the boot partition
    ```
    # parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
    # parted /dev/sda -- set 1 boot on
    ```
    
3. Add a big partition that will be encrypted
    ```
    # parted /dev/sda -- mkpart primary 512 MiB 100%
    ```
    
4. Encrypt `/dev/sda2`
    ```
    # cryptsetup luksFormat /dev/sda2
    # cryptsetup luksOpen /dev/sda2 crypted
    # pvcreate /dev/mapper/crypted
    # vgcreate cryptedpool /dev/mapper/crypted
    # lvcreate -n swap cryptedpool -L 8GB
    # lvcreate -n root cryptedpool -l 100%FREE
    ```
    
5. Format partitions
    ```
    # mkfs.fat -F 32 -n boot /dev/sda1
    # mkfs.ext4 -L nixos /dev/cryptedpool/root
    # mkswap -L swap /dev/cryptedpool/swap
    ```
    
6. Mount the partitions
    ```
    # mount /dev/cryptedpool/root /mnt
    # mkdir /mnt/boot
    # mount /dev/sda1 /mnt/boot
    # swapon /dev/cryptedpool/swap
    ```
    
You'll have to include the following lines in your
`/mnt/etc/nixos/configuration.nix`:
```
boot.initrd.luks.devices = [
  { name = "crypted"; device = "/dev/sda2"; preLVM = true; allowDiscards = true; }
];
```
