#include "multiboot.h"

	.section .multiboot
	.align 8
multiboot_header:
	.long  MULTIBOOT_HEADER_MAGIC
	.long  MULTIBOOT_ARCHITECTURE_I386
	/* Header length */
	.long  multiboot_header_end - multiboot_header
	/* Checksum */
	.long  -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))
	/* Required end tag */
	.short MULTIBOOT_HEADER_TAG_END
	.short 0 /* Flags */
	.short 8 /* Size */
multiboot_header_end:


	.section .text
	.code32
	/* linker.ld specifies "boot" as the entry point to the kernel,
	 * the bootloader will jump to this function once the kernel has been loaded. */
	.global boot
	.type boot, @function
boot:
	/* Print 'OK' to the screen */
	movl $0x2f4b2f4f, 0xb8000

	/* Halt the CPU */
	cli
1:
	hlt
	jmp 1b
