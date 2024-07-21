nasm -f bin -o bootsector_main.bin bootsector_main.asm

nasm -f bin -o bootsector_helpers.bin bootsector_helpers.asm

nasm -f bin -o bootsector_commands.bin bootsector_commands.asm

cat bootsector_main.bin bootsector_helpers.bin bootsector_commands.bin > combined.bin

qemu-system-x86_64 -drive format=raw,file=combined.bin
