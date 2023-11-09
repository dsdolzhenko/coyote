/* Tells the bootloader where to start executing the kernel.
 * The symbol is defined in boot.S. */
ENTRY(boot)

SECTIONS
{
	/* Link the kernel 1M forward to avoid loading
	 * on top of the PC’s I/O region or other reserved areas. */
	. = 1M;

	/* ALIGN(CONSTANT(COMMONPAGESIZE)) - alligns section to the default page boundary defined by the target.
	 * https://sourceware.org/binutils/docs/ld/Symbolic-Constants.html */

	/* Executable code */
	.text : ALIGN(CONSTANT(COMMONPAGESIZE))
	{
		/* Places the multiboot header at the begining of the kernel image
		 * as it is required by the multiboot2 specification.
		 * The section is defined in boot.S. */
		KEEP(*(.multiboot))
		*(.text)
	}

	/* Read-only data. */
	.rodata : ALIGN(CONSTANT(COMMONPAGESIZE))
	{
		*(.rodata)
	}

	/* Read-write data (initialized) */
	.data : ALIGN(CONSTANT(COMMONPAGESIZE))
	{
		*(.data)
	}

	/* Read-write data (uninitialized) and stack.
	 *
	 * .bss needs to be the last thing mapped to :data, otherwise lots of
	 * unnecessary zeros will be written to the binary .*/
	.bss : ALIGN(CONSTANT(COMMONPAGESIZE))
	{
		/* *(COMMON) - includes common symbols without a particular input section.
		 * https://sourceware.org/binutils/docs/ld/Input-Section-Common.html */
		*(COMMON)
		*(.bss)
	}

	/* Discard unused .note.* and .eh_frame */
	/DISCARD/ :
	{
		*(.eh_frame)
		*(.note .note.*)
	}
}
