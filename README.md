runqemu nographic serial


demo
https://www.youtube.com/watch?app=desktop&v=6rPJ2hqtMzo

official website

https://docs.automotivelinux.org/en/master/#

(1)Download AGL software
mkdir bin
mkdir AGL
curl https://storage.googleapis.com/git-repo-downloads/repo > /home/yaowen/bin/repo
chmod a+x /home/yaowen/bin/repo
mkdir koi
cd koi
 /home/yaowen/bin/repo init -b koi -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo
 /home/yaowen/bin/repo init -b guppy  -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo
/home/yaowen/bin/repo sync

(2)Initializing your build environment for arm CPU architecture
# cd $AGL_TOP/koi chmod 777 -R .
# do not use bitbake as root
# source meta-agl/scripts/aglsetup.sh -m qemuarm -b qemuarm agl-demo agl-devel
supported machines are listed above
-b specify the directory

(3)building the AGL image
Do not use Bitbake as root
# bitbake agl-demo-platform or bitbake agl-image-minimal
# source $AGL_TOP/qemuarm/agl-init-build-env
# runqemu nographic serial


bitbake error
1）
pyinotify.WatchManagerError: add_watch: cannot watch /home/yaowen/AGL/qemuarm/conf WD=-1, Errno=No space left on device (ENOSPC)
ERROR: No space left on device or exceeds fs.inotify.max_user_watches?
ERROR: To check max_user_watches: sysctl -n fs.inotify.max_user_watches.
ERROR: To modify max_user_watches: sysctl -n -w fs.inotify.max_user_watches=<value>.
ERROR: Root privilege is required to modify max_user_watches.

rm -r /var/lib/docker/containers/*
rm -r /var/lib/docker/image/*
rm -r /var/lib/docker/overlay2
没有用，

最后增大max_user_watches即可，原来是8192
sysctl -n -w fs.inotify.max_user_watches=819200

2）
kernel and rootfs

https://download.automotivelinux.org/AGL/release/koi/11.0.5/qemuarm/deploy/images/qemuarm/zImage--5.4.153+gitAUTOINC+9e3ab4e615_7a9ca83b48-r0.198-qemuarm-20211221145527.bin
https://download.automotivelinux.org/AGL/release/koi/11.0.5/qemuarm/deploy/images/qemuarm/agl-demo-platform-crosssdk-qemuarm-20211221145527.rootfs.ext4.xz

###################

AGL/external/poky/scripts/runqemu
start_qemu()

runqemu nographic serial
root


/home/yaowen/AGL/qemuarm/tmp/work/x86_64-linux/qemu-helper-native/1.0-r1/recipe-sysroot-native/usr/bin/qemu-system-arm -device virtio-net-device,netdev=net0,mac=52:54:00:12:34:02 -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -drive id=disk0,file=/home/yaowen/AGL/qemuarm/tmp/deploy/images/qemuarm/agl-demo-platform-qemuarm-20210818063738.rootfs.ext4,if=none,format=raw -device virtio-blk-device,drive=disk0 -show-cursor  -device qemu-xhci -device usb-tablet -device usb-kbd -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0  -nographic -M virt -smp 4 -cpu cortex-a15 -m 2048  -device virtio-serial-device -chardev null,id=virtcon -device virtconsole,chardev=virtcon -kernel /home/yaowen/AGL/qemuarm/tmp/deploy/images/qemuarm/zImage--5.4.107+gitAUTOINC+19738ca97b_ea4097dbff-r0-qemuarm-20210602063823.bin -append 'root=/dev/vda rw  console=ttyS0 console=ttyS0 mem=2048M ip=192.168.7.2::192.168.7.1:255.255.255.0 console=ttyAMA0 verbose vmalloc=256M '

no ,vgamem_mb=64,edid=on


scp firmadyne/FILE_LOAD/procinfo_arm.ko root@192.168.7.2:/home/0

uname -a
Linux qemuarm 5.4.107-yocto-standard 

########### build a docker image

docker run -it --env USER=root --privileged -it  --device=/dev/net/tun -v /home/yaowen/firmadyne:/home/yaowen/firmadyne ubuntu /bin/bash

docker run -it --rm zyw200/agl /bin/bash

apt-get install locales
#locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales  choose en_US.UTF-8

apt-get install curl git python3 chrpath cpio cpp diffstat wget build-essential gawk python3-distutils

########## compile procinfo.ko

apt-get install -y libyaml-dev
cd /home/yaowen/AGL/qemuarm/tmp/deploy/sdk
Run ./poky-agl-glibc-x86_64-agl-demo-platform-crosssdk-armv7vet2hf-neon-vfpv4-qemuarm-toolchain-11.0.2.sh
install sdk in /opt/agl-sdk/11.0.2-armv7vethf-neon-vfpv4
. /opt/agl-sdk/11.0.2-armv7vethf-neon-vfpv4/environment-setup-armv7vet2hf-neon-vfpv4-agl-linux-gnueabi
CFLAGS -I/opt/agl-sdk/11.0.2-armv7vethf-neon-vfpv4/sysroots/armv7vet2hf-neon-vfpv4-agl-linux-gnueabi/usr/include/
./qemuarm/tmp/sysroots-components/qemuarm/most/lib/modules/5.4.107-yocto-standard
./qemuarm/tmp/sysroots-components/qemuarm/lttng-modules/lib/modules/5.4.107-yocto-standard
./qemuarm/tmp/sysroots-components/qemuarm/sllin/lib/modules/5.4.107-yocto-standard

qemu-arm的存放地址
/home/yaowen/AGL/qemuarm/tmp/work/x86_64-linux/qemu-helper-native/1.0-r1/recipe-sysroot-native/usr/bin/

只有gdb -q --args 才有输出， 去掉-smp 4就可以。


##########20220506  
1) 启动网卡

tunctl -t tapAGL -u root
ip link set tapAGL up
ip addr add 192.168.7.1/24 dev tapAGL
ip route add 192.168.7.2 via 192.168.7.2 dev tapAGL

ip route flush dev tapAGL
ip link set tapAGL down
tunctl -d tapAGL


2) 编译procinfo.ko。（之前的没找到的）
qemu-system-arm -device virtio-net-device,netdev=net0 -netdev tap,id=net0,ifname=tapAGL,script=no,downscript=no -drive id=disk0,file=agl-demo-platform-crosssdk-qemuarm-20211221145527.rootfs.ext4,if=none,format=raw -device virtio-blk-device,drive=disk0 -show-cursor  -device qemu-xhci -device usb-tablet -device usb-kbd -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0  -nographic -M virt  -cpu cortex-a15 -m 2048  -device virtio-serial-device -chardev null,id=virtcon -device virtconsole,chardev=virtcon -kernel zImage--5.4.153+gitAUTOINC+9e3ab4e615_7a9ca83b48-r0.198-qemuarm-20211221145527.bin -append 'root=/dev/vda rw  console=ttyS1 console=ttyS0 mem=2048M ip=192.168.7.2::192.168.7.1:255.255.255.0 console=ttyAMA0 verbose vmalloc=256M '

scp -r root@192.168.7.2:/lib/modules/5.4.153-yocto-standard /lib/modules/

编译失败
原因：fatal error: asm/bitsperlong.h: No such file or directory， asm目录不存在，asm link到asm-generic同样有问题。

cd /lib/modules/5.4.153-yocto-standard/build/include/uapi
ln -s asm-generic/ asm
cd /lib/modules/5.4.153-yocto-standard/build/include
ln -s asm-generic/ asm
cp missing_files/unistd-eabi.h /lib/modules/5.4.153-yocto-standard/build/arch/arm/include/uapi/asm/
cp missing_files/unistd-common.h /lib/modules/5.4.153-yocto-standard/build/arch/arm/include/uapi/asm/
cp missing_files/unistd-nr.h /lib/modules/5.4.153-yocto-standard/build/arch/arm/include/uapi/asm/

error: scripts/basic/fixdep: not found

cd /lib/modules/5.4.153-yocto-standard/build
make ARCH=arm CROSS_COMPILE=/opt/cross/arm-linux-musleabi/bin/arm-linux-musleabi- zImage -j8

make ARCH=arm CROSS_COMPILE=/opt/cross/arm-linux-musleabi/bin/arm-linux-musleabi-

3) qemu-system-arm 
need to modify the callbacktests_loadmainmodule_callback in cpu-exec.c
 config_pc = code_start +  0x38e0; replace it with the address of main or start function

4) FirmAFL_config
based on insmod result,
proc_exec_connector use free_bprm value
proc_exit_connector use do_task_dead from System.map

./afl-fuzz-full -m none -t 800000+  -i ./inputs -o ./outputs_full  -QQ --  ./qemu-system-arm-docker -device virtio-net-device,netdev=net0 -netdev tap,id=net0,ifname=tapAGL,script=no,downscript=no -drive id=disk0,file=agl-demo-platform-crosssdk-qemuarm-20211221145527.rootfs.ext4,if=none,format=raw -device virtio-blk-device,drive=disk0 -show-cursor  -device qemu-xhci -device usb-tablet -device usb-kbd -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0  -nographic -M virt  -cpu cortex-a15 -m 2048  -device virtio-serial-device -chardev null,id=virtcon -device virtconsole,chardev=virtcon -kernel zImage--5.4.153+gitAUTOINC+9e3ab4e615_7a9ca83b48-r0.198-qemuarm-20211221145527.bin -append 'root=/dev/vda rw  console=ttyS1 console=ttyS0 mem=2048M ip=192.168.7.2::192.168.7.1:255.255.255.0 console=ttyAMA0 verbose vmalloc=256M '   -aflFile @@

#############################################3
docker run -it --env USER=root --privileged -it  --device=/dev/net/tun -v /home/yaowen/AGL_setup:/home/yaowen/AGL_setup ubuntu:18.04 /bin/bash
docker run -it --env USER=root --privileged -it  --device=/dev/net/tun -v /home/yaowen/AGL_setup:/home/yaowen/AGL_setup zyw200/agl:0.1 /bin/bash

docker run -it --env USER=root --privileged -it  --device=/dev/net/tun -v /home/yaowen/AGL_setup:/agl zyw200/agl:0.1 /bin/bash


apt-get update

docker run -it --env USER=root --privileged -it  --device=/dev/net/tun -v /home/yaowen/FirmAFL_2020/:/home/yaowen/FirmAFL_2020 ubuntu:18.04 /bin/bash
docker run -it --env USER=root --privileged -it  --device=/dev/net/tun  ubuntu:18.04 /bin/bash

apt-get install build-essential python pkg-config zlib1g-dev  libglib2.0-dev autoconf libtool flex bison binutils-dev libboost-all-dev





#########################################33
vim -b file
:set noeol
:wq

kernel
Makefile重新修改，subdir改成M，编译成功
do_task_dead代替proc_exit_connector
Source目录下的System.map有符号地址。用do_task_dead代替proc_exit_connector

QEMU修改内容


/home/yaowen/AGL/external/poky/scripts/runqemu

 django.contrib.auth.authenticate
None  ######  ['tester']

Unable to find image 'afl_docker_dnu:0.23' locally
