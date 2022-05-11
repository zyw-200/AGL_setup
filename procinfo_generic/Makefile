obj-m	:= procinfo.o
#KDIR	:= /lib/modules/$(shell uname -r)/build
#KDIR	:= /lib/modules/3.2.1/build
#KDIR	:= /lib/modules/2.6.32.70/build
#KDIR	:= /lib/modules/2.6.39.4+/build
#KDIR	:= /lib/modules/4.1.17+/build
#KDIR	:= /opt/agl-sdk/11.0.2-armv7vethf-neon-vfpv4/sysroots/armv7vet2hf-neon-vfpv4-agl-linux-gnueabi/usr/src/kernel
#KDIR    := /opt/agl-sdk/11.0.2-armv7vethf-neon-vfpv4/sysroots/armv7vet2hf-neon-vfpv4-agl-linux-gnueabi/lib/modules/5.4.107-yocto-standard/build
#KDIR    := /opt/agl-sdk/11.0.2-armv7vethf-neon-vfpv4/sysroots/armv7vet2hf-neon-vfpv4-agl-linux-gnueabi/

#KDIR    := /lib/modules/5.4.107-yocto-standard/build
#KDIR    := /lib/modules/4.18.33-yocto-standard/build/
KDIR    := /lib/modules/5.4.153-yocto-standard/build/
#KDIR    := /home/yaowen/agl-sdk/sysroots/armv7vet2hf-neon-vfpv4-agl-linux-gnueabi/lib/modules/5.4.153-yocto-standard/build
PWD	:= $(shell pwd)



default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
	#$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
	
clean:
	#$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) clean
	rm -rf Module.markers modules.order Module.symvers

#make ARCH=mips CROSS_COMPILE=/opt/cross/mipsel-linux-musl/bin/mipsel-linux-musl-
#make ARCH=arm CROSS_COMPILE=/opt/cross/arm-linux-musleabihf/bin/arm-linux-musleabihf-
#make ARCH=arm CROSS_COMPILE=/opt/cross/arm-linux-musleabi/bin/arm-linux-musleabi-
#make ARCH=arm CROSS_COMPILE=/opt/cross/arm-linux-musleabi/bin/arm-linux-musleabi- zImage -j8
