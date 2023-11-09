#!/bin/bash 

IDS="ids.list"

nginx -p /etc/nginx/ -c ./nginx.conf

while IFS= read -r vm
do 
  ./ttyd -m 2 -W -i /tmp/$vm.sock qemu-system-aarch64 -m 100 -M virt -cpu cortex-a53 -nographic -smp 1 -kernel Image -append "rootwait root=/dev/vda ro console=ttyAMA0 quiet norandmaps" -drive file=rootfs.ext2,readonly=on,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0  -device usb-ehci,id=ehci -drive if=none,file=sd.img,format=raw,readonly=on,id=sd -device usb-storage,bus=ehci.0,drive=sd &
done < $IDS

wait
