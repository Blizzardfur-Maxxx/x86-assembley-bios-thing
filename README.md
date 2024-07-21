nasm -f bin -o bootsector_main.bin bootsector_main.asm

nasm -f bin -o bootsector_helpers.bin bootsector_helpers.asm

nasm -f bin -o bootsector_commands.bin bootsector_commands.asm

nasm -f bin -o bootsector_commands_printmem.bin bootsector_commands_printmem.asm

nasm -f bin -o bootsector_commands_cls.bin bootsector_commands_cls.asm

cat bootsector_main.bin bootsector_helpers.bin bootsector_commands.bin bootsector_commands_printmem.bin bootsector_commands_cls.bin > combined.bin
