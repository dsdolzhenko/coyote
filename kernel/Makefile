bin := kernel.bin
obj := $(patsubst %,%.o,$(basename $(wildcard src/*.[cS])))
dep := $(obj:.o=.d)

ifeq ($(DEBUG),)
	override CFLAGS += -O3
else
	override CFLAGS += -g -Og
endif

override CFLAGS += \
	-Wall \
	-Wextra \
	-Wpedantic \
	-std=gnu17 \
	-ffreestanding \
	-MMD \
	-MP

override LDFLAGS += \
	-nostdlib \
	-T linker.ld

.PHONY: all
all: $(bin)

$(bin): $(obj)
	$(LD) $(obj) $(LDFLAGS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

-include $(dep)

.PHONY: clean
clean:
	rm -rf $(bin) $(obj) $(dep)
