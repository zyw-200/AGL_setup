## demo

	https://www.youtube.com/watch?app=desktop&v=6rPJ2hqtMzo

## official website for AGL

	https://docs.automotivelinux.org/en/master/#

## Setup for AGL

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

	after that, you can use the command to start the full-system emulation of AGL.
	# runqemu nographic serial 

	if you want to see the output, remove -smp 4 in AGL/external/poky/scripts/runqemu

	NOTE: qemu-system-arm is stored in /home/yaowen/AGL/qemuarm/tmp/work/x86_64-linux/qemu-helper-native/1.0-r1/recipe-sysroot-native/usr/bin/


## Compile procinfo.ko

	apt-get install -y libyaml-dev
	cd /home/yaowen/AGL/qemuarm/tmp/deploy/sdk
	Run ./poky-agl-glibc-x86_64-agl-demo-platform-crosssdk-armv7vet2hf-neon-vfpv4-qemuarm-toolchain-11.0.2.sh
	install sdk in /opt/agl-sdk/11.0.2-armv7vethf-neon-vfpv4
	. /opt/agl-sdk/11.0.2-armv7vethf-neon-vfpv4/environment-setup-armv7vet2hf-neon-vfpv4-agl-linux-gnueabi
	CFLAGS -I/opt/agl-sdk/11.0.2-armv7vethf-neon-vfpv4/sysroots/armv7vet2hf-neon-vfpv4-agl-linux-gnueabi/usr/include/
	./qemuarm/tmp/sysroots-components/qemuarm/most/lib/modules/5.4.107-yocto-standard
	./qemuarm/tmp/sysroots-components/qemuarm/lttng-modules/lib/modules/5.4.107-yocto-standard
	./qemuarm/tmp/sysroots-components/qemuarm/sllin/lib/modules/5.4.107-yocto-standard


	scp -r root@192.168.7.2:/lib/modules/5.4.153-yocto-standard /lib/modules/
	when compiling the procinfo.ko,
		fatal error: asm/bitsperlong.h: No such file or directory， 

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

	NOTES: subdir should be M in Makefile

	scp firmadyne/FILE_LOAD/procinfo_arm.ko root@192.168.7.2:/home/0

	based on insmod result,
	proc_exec_connector use free_bprm value
	proc_exit_connector use do_task_dead from System.map


## Modification of QEMU
	modify the callbacktests_loadmainmodule_callback in cpu-exec.c
 	config_pc = code_start +  0x38e0; replace it with the address of main or start function

 	for compilation of QEMU, follow the instructions in Full_2022/README.md


## download docker container for AGL

	docker pull zyw200/agl

	NOTE: the docker preparation is as follows.
	apt-get install locales
	locale-gen en_US en_US.UTF-8
	dpkg-reconfigure locales  choose en_US.UTF-8
	apt-get install curl git python3 chrpath cpio cpp diffstat wget build-essential gawk python3-distutils

## In fuzzing prototype, the docker container is invoked by this.
	docker run -it --env USER=root --privileged -it  --device=/dev/net/tun -v /home/yaowen/AGL_setup:/agl zyw200/agl:0.1 /bin/bash /agl/agl_start.sh

	you can also login the container by following command

	docker run -it --env USER=root --privileged -it  --device=/dev/net/tun -v /home/yaowen/AGL_setup:/home/yaowen/AGL_setup zyw200/agl:0.1 /bin/bash



## Trouble shooting

	1）bitbake error
	pyinotify.WatchManagerError: add_watch: cannot watch /home/yaowen/AGL/qemuarm/conf WD=-1, Errno=No space left on device (ENOSPC)
	ERROR: No space left on device or exceeds fs.inotify.max_user_watches?
	ERROR: To check max_user_watches: sysctl -n fs.inotify.max_user_watches.
	ERROR: To modify max_user_watches: sysctl -n -w fs.inotify.max_user_watches=<value>.
	ERROR: Root privilege is required to modify max_user_watches.

	sysctl -n -w fs.inotify.max_user_watches=819200

	2）Specific kernel and rootfs can be downloaded from following urls

	https://download.automotivelinux.org/AGL/release/koi/11.0.5/qemuarm/deploy/images/qemuarm/zImage--5.4.153+gitAUTOINC+9e3ab4e615_7a9ca83b48-r0.198-qemuarm-20211221145527.bin
	https://download.automotivelinux.org/AGL/release/koi/11.0.5/qemuarm/deploy/images/qemuarm/agl-demo-platform-crosssdk-qemuarm-20211221145527.rootfs.ext4.xz


## Others
	
	django.contrib.auth.authenticate
	None  ######  ['tester']



