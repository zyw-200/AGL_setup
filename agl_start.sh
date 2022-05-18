#!/bin/bash

job_corpus=$1
job_parallel_threads=$2
job_name=$3
job_output=$4
job_fuzzer_identifier=$5
job_dictionary=$6

cd agl
if [ -z "$job_dictionary" ]
then
	./afl-fuzz-full -m none -t 800000+  -i $job_corpus -o $job_output -M $job_fuzzer_identifier -QQ --  ./qemu-system-arm-docker -device virtio-net-device,netdev=net0 -netdev tap,id=net0,ifname=tapAGL,script=no,downscript=no -drive id=disk0,file=agl-demo-platform-crosssdk-qemuarm-20211221145527.rootfs.ext4,if=none,format=raw -device virtio-blk-device,drive=disk0 -show-cursor  -device qemu-xhci -device usb-tablet -device usb-kbd -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0  -nographic -M virt  -cpu cortex-a15 -m 2048  -device virtio-serial-device -chardev null,id=virtcon -device virtconsole,chardev=virtcon -kernel zImage--5.4.153+gitAUTOINC+9e3ab4e615_7a9ca83b48-r0.198-qemuarm-20211221145527.bin -append 'root=/dev/vda rw  console=ttyS1 console=ttyS0 mem=2048M ip=192.168.7.2::192.168.7.1:255.255.255.0 console=ttyAMA0 verbose vmalloc=256M '   -aflFile @@
else
	./afl-fuzz-full -m none -t 800000+  -i $job_corpus -o $job_output -x $job_dictionary -M $job_fuzzer_identifier -QQ --  ./qemu-system-arm-docker -device virtio-net-device,netdev=net0 -netdev tap,id=net0,ifname=tapAGL,script=no,downscript=no -drive id=disk0,file=agl-demo-platform-crosssdk-qemuarm-20211221145527.rootfs.ext4,if=none,format=raw -device virtio-blk-device,drive=disk0 -show-cursor  -device qemu-xhci -device usb-tablet -device usb-kbd -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0  -nographic -M virt  -cpu cortex-a15 -m 2048  -device virtio-serial-device -chardev null,id=virtcon -device virtconsole,chardev=virtcon -kernel zImage--5.4.153+gitAUTOINC+9e3ab4e615_7a9ca83b48-r0.198-qemuarm-20211221145527.bin -append 'root=/dev/vda rw  console=ttyS1 console=ttyS0 mem=2048M ip=192.168.7.2::192.168.7.1:255.255.255.0 console=ttyAMA0 verbose vmalloc=256M '   -aflFile @@
fi