# \ <section:var>
MODULE     = $(notdir $(CURDIR))
OS         = $(shell uname -s)
MACHINE    = $(shell uname -m)
NOW        = $(shell date +%d%m%y)
REL        = $(shell git rev-parse --short=4 HEAD)
HW        ?= pill030
include       hw/$(HW).mk
include      cpu/$(SoC).mk
# / <section:var>
# \ <section:dir>
CWD        = $(CURDIR)
DOC        = $(CWD)/doc
BIN        = $(CWD)/bin
SRC        = $(CWD)/src
TMP        = $(CWD)/tmp
CARGOBIN   = $(HOME)/.cargo/bin
FW         = $(CWD)/firmware
# / <section:dir>
# \ <section:tool>
WGET       = wget -c
RUSTUP     = $(CARGOBIN)/rustup
CARGO      = $(CARGOBIN)/cargo
RUSTC      = $(CARGOBIN)/rustc
HOSTCC     = $(CC)
CC         = $(TARGET)-gcc
HOSTCXX    = $(CXX)
CXX        = $(TARGET)-g++
LD         = $(TARGET)-ld
AS         = $(TARGET)-as
SIZE       = $(TARGET)-size
OBJDUMP    = $(TARGET)-objdump
GDB        = $(TARGET)-gdb
CC         = clang --target=$(TARGET)
SIZE       = llvm-size
# / <section:tool>
# \ <section:obj>
# \ <section:c>
C   += $(SRC)/rustpill.c
# / <section:c>
# \ <section:h>
H   += $(SRC)/rustpill.h
# / <section:h>
# \ <section:s>
S   += $(C) $(H)
# / <section:s>
OBJ += $(FW)/rustpill.elf
# / <section:obj>
# \ <section:cfg>
# \ <section:cflags>
CFLAGS    += -mcpu=$(CPU) $(THUMB)
CFLAGS    += -O0 -g3
CFLAGS    += -I$(SRC)
# / <section:cflags>
# / <section:cfg>
# \ <section:all>
.PHONY: all
all: $(S)	
	# \ <section:body>
	$(CARGO) run $(MODULE).ini
	# / <section:body>
# / <section:all>
# \ <section:rules>
$(FW)/rustpill.elf: $(C) $(H) Makefile
	$(CC) $(CFLAGS) -o $@ $(C)
	$(SIZE) $@
	$(OBJDUMP) -x $@ > $@.objdump
# / <section:rules>
# \ <section:install>
.PHONY: install
install: $(OS)_install
	# \ <section:body>
	$(MAKE)   $(RUSTUP)
	$(RUSTUP) update
	$(RUSTUP) component add rustfmt
	$(RUSTUP) component add llvm-tools-preview
	# / <section:body>
	# \ <section:post>
	$(CARGO)  build
	# / <section:post>
.PHONY: update
update: $(OS)_update
	# \ <section:update>
	$(RUSTUP) update
	# / <section:update>
.PHONY: $(OS)_install $(OS)_update
$(OS)_install $(OS)_update:
	sudo apt update
	sudo apt install -u `cat apt.txt`
$(RUSTUP) $(CARGO) $(RUSTC):
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# / <section:install>
# \ <section:merge>
MERGE  = Makefile README.md apt.txt .gitignore .vscode $(S)
.PHONY: main
main:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)
.PHONY: shadow
shadow:
	git pull -v
	git checkout $@
	git pull -v
.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	$(MAKE) shadow
# / <section:merge>
