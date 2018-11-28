passwd
/etc/init.d/sshd start


fdisk /dev/sda

o

n
p


+16384M
a
1
w

# swap 作る場合は512Mのパーティションも この場合/dev/sda2とする


loadkeys jp106
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt/gentoo

#swap 有

mkswap /dev/sda2

swapon /dev/sda2

 

mkswap
mkdir /mnt/gentoo/boot
cd /mnt/gentoo

# x86-x64

wget http://ftp.iij.ad.jp/pub/linux/gentoo/releases/amd64/current-stage3/stage3-amd64-20130130.tar.bz2

# i686

wget http://ftp.iij.ad.jp/pub/linux/gentoo/releases/x86/current-stage3/stage3-i686-20121213.tar.bz2


tar xvjpf stage3-*.tar.bz2
cp -L /etc/resolv.conf /mnt/gentoo/etc/
mount -t proc none /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
chroot /mnt/gentoo /bin/bash
env-update
source /etc/profile
export PS1="(chroot) $PS1"
mkdir /usr/portage
emerge-webrsync
emerge --sync
nano -w /etc/locale.gen

nano -w /etc/fstab
    
    # <fs>                  <mountpoint>    <type>          <opts>          <dump/pass>

    /dev/sda1               /               ext3            noatime         0 1

eselect profile list
eselect profile set [*]
locale-gen
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
emerge gentoo-sources genkernel --quiet

genkernel --menuconfig --makeopts=-j3 all

nano -w /etc/portage/make.conf

GENTOO_MIRRORS="http://ftp.jaist.ac.jp/pub/Linux/Gentoo/ ftp://ftp.jaist.ac.jp/pub/Linux/Gentoo/"
SYNC="rsync://masterspark.j-ynv.net/gentoo-portage&quot;
USE="-gtk -gnome qt4 kde dvd alsa cdr"
MAKEOPTS=&quot;-j3&quot;

nano -w /etc/conf.d/hostname

 

 


nano -w /etc/conf.d/net
    
    dns_domain_lo="*"
    config_eth0="dhcp"

nano -w /etc/conf.d/keymaps
    
    jp106
    
nano -w /etc/conf.d/hwclock
    
    clock="local"
    clock_systohc="YES"
    clock_hctosys="YES"

echo 'sys-boot/grub:2' > /etc/portage/package.keywords
emerge sys-boot/grub:2 --quiet
emerge syslog-ng dhcpcd bash-completion --quiet
ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
rc-update add net.eth0 default
rc-update add syslog-ng default
rc-update add sshd default

grub2-install /dev/sda
grub2-mkconfig -o /boot/grub2/grub.cfg

passwd

exit
cd
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -l /mnt/gentoo{/boot,/proc,}
sync
reboot

 