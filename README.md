nasm -f bin -o bootsector_main.bin bootsector_main.asm
nasm -f bin -o bootsector_helpers.bin bootsector_helpers.asm
cat bootsector_main.bin bootsector_helpers.bin > combined.bin
qemu-system-x86_64 -drive format=raw,file=combined.bin
