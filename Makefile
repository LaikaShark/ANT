ATHC         ?= athc
CC           ?= gcc
COMPOSE      ?= fresh
SRC           = ant.ath
BIN           = ant

PREFIX        = $(HOME)/.local
GLOBAL_PREFIX = /usr/local
MAN_DIR       = $(HOME)/.local/share/man/man1
COMP_DIR      = $(HOME)/.local/share/bash-completion/completions
GLOBAL_MAN    = /usr/share/man/man1
GLOBAL_COMP   = /usr/share/bash-completion/completions

.PHONY: all clean install install-global uninstall uninstall-global

all: $(BIN)

$(BIN): $(wildcard *.ath)
	$(ATHC) $(SRC) -o $(BIN) --compose $(COMPOSE) --cc $(CC)

clean:
	rm -f $(BIN)

install: $(BIN)
	install -d $(PREFIX)/bin
	install -m 755 $(BIN) $(PREFIX)/bin/$(BIN)
	install -d $(MAN_DIR)
	install -m 644 ant.1 $(MAN_DIR)/ant.1
	install -d $(COMP_DIR)
	install -m 644 ant-completion.bash $(COMP_DIR)/ant

install-global: $(BIN)
	install -d $(GLOBAL_PREFIX)/bin
	install -m 755 $(BIN) $(GLOBAL_PREFIX)/bin/$(BIN)
	install -d $(GLOBAL_MAN)
	install -m 644 ant.1 $(GLOBAL_MAN)/ant.1
	install -d $(GLOBAL_COMP)
	install -m 644 ant-completion.bash $(GLOBAL_COMP)/ant

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
	rm -f $(MAN_DIR)/ant.1
	rm -f $(COMP_DIR)/ant

uninstall-global:
	rm -f $(GLOBAL_PREFIX)/bin/$(BIN)
	rm -f $(GLOBAL_MAN)/ant.1
	rm -f $(GLOBAL_COMP)/ant
