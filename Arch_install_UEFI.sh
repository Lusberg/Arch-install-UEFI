#$ loadkeys et #not needed when US keyboard

$ wifi-menu #connect to wifi during install process ; use '$ dhcpcd' when using wired

$ ping google.com #ctrl-c to terminate when successful

#$ timedatectl set-ntp true

$ fdisk -l #list disks and take note of /dev/nvme0nX where you want to install

$ cfdisk /dev/nvme0nX #partitioning program
#choose youre partition where you want to install the OS: Delete -> New -> Write -> Quit
#this method assumes you have an existing ESP partition (partition with existing EFI bootloaders) on your drive

$ mkfs.ext4 /dev/nvme0nXpX #OS partition you just set up

$ mount /dev/nvme0nXpX /mnt #mount OS partition

$ mkdir /mnt/boot #create a boot directory in your new OS partition

$ mount /dev/nvme0nXpX /mnt/boot #mount existing ESP partition

$ pacstrap /mnt base base-devel ranger dialog wpa_supplicant iw grub efibootmgr intel-ucode git

$ genfstab -U /mnt >> /mnt/etc/fstab #creates fstab entry for partition

$ arch-chroot /mnt #change root to your new OS

$ ln -sf /usr/share/zoneinfo/Europe/Tallinn /etc/localtime

#$ hwclock --systohc

$ nano /etc/locale.gen #uncomment: 'en_US.UTF-8' ; ctrl-o or ctrl-s to save and ctrl-x to exit

$ locale-gen #generates previously uncommented locale

$ nano /etc/locale.conf #add: LANG=en_US.UTF-8 ; save, exit

$ nano /etc/vconsole.conf #add: KEYMAP=et ; or 'en' for US keyboard ; save, exit ; this is keymap for TTY and terminal emulator

$ echo myhostname > /etc/hostname #substitute 'myhostname' with your chosen hostname, I use 'archlinux' ; has to be lowercase

$ nano /etc/hosts # append line: 127.0.1.1 myhostname.localdomain myhostname ; save, exit

$ passwd #rootpass

$ grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub #install grub to EFI partition

$ grub-mkconfig -o /boot/grub/grub.cfg #make grub conf, now you can boot into new OS

$ exit #exits to installer root

$ umount -R /mnt #unmount /mnt and /boot partitions

$ reboot #when you reboot and get stuck to kernel loading screen, use: ctrl-alt-F2 ; this happen because some drivers, 
#notably graphics drivers, are not properly set up (dual-GPU)

*****************************************************************************************************************************************
#log in as root

$ useradd -m -G users -s /bin/bash username #substitute username with your chosen username, I use 'Clarke'

$ passwd username #add userpass

$ nano /etc/sudoers #add under Root ALL=(ALL) ALL: username ALL=(ALL) ALL ; essentially same line as Root, but with your username ; 
#this gives you premission to execute sudo command ; save, exit

$ exit 

#log in with your new user ; you have a clean OS set up, now you can choose to install your favorite login manager, DE, programs, etc

*****************************************************************************************************************************************

#install pacaur using a shell script: https://gist.github.com/Tadly/0e65d30f279a34c33e9b ; 
#or install manually: https://www.ostechnix.com/install-pacaur-arch-linux/

$ chmod +x filename.sh #makes script executable ; use sudo when needed
$ ./filename.sh #executes

*****************************************************************************************************************************************
#Dell XPS 9560 specific

$ pacaur -S bbswitch bumblebee
#add: 'acpi_rev_override=1' kernel parameter, run: $ grub-mkconfig -o /boot/grub/grub.cfg

$ sudo systemctl enable bumblebeed #this XPS 9560 specific section is a guide how to disable dedicated nvidia GPU

$ reboot

