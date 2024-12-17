FILES = ./build/kernel.asm.o ./build/kernel.o
FLAGS = -g -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc
GCC_TARGET = i686-elf
OUTPUT_DIR = ./bin
BUILD_DIR = ./build
SRC_DIR = ./src

all: $(OUTPUT_DIR)/os.bin

$(BUILD_DIR)/kernel.asm.o: $(SRC_DIR)/kernel.asm
	nasm -f elf -g $(SRC_DIR)/kernel.asm -o $@

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel.c
	$(GCC_TARGET)-gcc $(FLAGS) -std=gnu99 -c $< -o $@

$(BUILD_DIR)/completeKernel.o: $(BUILD_DIR)/kernel.asm.o $(BUILD_DIR)/kernel.o
	$(GCC_TARGET)-ld -g -relocatable $^ -o $@

$(OUTPUT_DIR)/boot.bin: $(SRC_DIR)/boot.asm
	nasm -f bin $< -o $@

$(OUTPUT_DIR)/kernel.bin: $(BUILD_DIR)/completeKernel.o $(SRC_DIR)/linkerScript.ld
	$(GCC_TARGET)-gcc $(FLAGS) -T $(SRC_DIR)/linkerScript.ld -o $@ -ffreestanding -O0 -nostdlib $<

$(OUTPUT_DIR)/os.bin: $(OUTPUT_DIR)/boot.bin $(OUTPUT_DIR)/kernel.bin
	cp $(OUTPUT_DIR)/boot.bin $@
	dd if=$(OUTPUT_DIR)/kernel.bin >> $@
	dd if=/dev/zero bs=512 count=8 >> $@

clean:
	rm -f $(OUTPUT_DIR)/boot.bin
	rm -f $(OUTPUT_DIR)/kernel.bin
	rm -f $(OUTPUT_DIR)/os.bin
	rm -f $(BUILD_DIR)/*.o
