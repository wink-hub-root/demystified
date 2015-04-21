SUBDIRS = 0.01 0.04 0.56 0.82 0.86

all: $(SUBDIRS) diff

$(SUBDIRS):
	$(MAKE) -C $@ -f ../Makefile extract
	cd extracted && ln -sfT ../$@/extracted $@
	cd tar && ln -sfT ../$@/app-rootfs.tar.gz $@.tar.gz
	cd ubi && ln -sfT ../$@/app-rootfs.ubi $@.ubi

extract: extracted app-rootfs.tar.gz after

before:
	sudo modprobe mtdblock
	sudo modprobe ubi
	sudo modprobe nandsim first_id_byte=0x01 second_id_byte=0xf1 third_id_byte=0x00 fourth_id_byte=0x1d

after:
	sudo umount /mnt/ubifs
	sudo rmmod ubifs ubi nandsim

extracted: before
	sudo dd if=app-rootfs.ubi of=/dev/mtdblock0 bs=2048
	sudo ubiattach /dev/ubi_ctrl -m 0 -O 2048
	sudo mount -t ubifs ubi0_0 /mnt/ubifs
	sudo rsync -a /mnt/ubifs/ extracted

app-rootfs.tar.gz: extracted
	sudo tar cvfpz app-rootfs.tar.gz -C extracted ./

diff:
	./fwdiff.sh

.PHONY: diff extract before after subdirs $(SUBDIRS)
