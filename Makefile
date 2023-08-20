ASM=nasm

BUILD_DIR=build

.PHONY: all floppy_image kernel bootloader clean always

#
# Floppy image
#
floppy_image:$(BUILD_DIR)/image.img

$(BUILD_DIR)/image.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/image.img bs=512 count=28
	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/image.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/image.img conv=notrunc
	mcopy -i $(BUILD_DIR)/image.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
	cp $(BUILD_DIR)/boot.bin $(BUILD_DIR)/image.img
	truncate -s 1440k $(BUILD_DIR)/image.img

#
# Bootloader
#
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) bootloader/boot.s -f bin -o $(BUILD_DIR)/bootloader.bin

#
# Kernel
#
kernel:$(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) kernel/kernel.s -f bin -o $(BUILD_DIR)/kernel.bin

always:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*