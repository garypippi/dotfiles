# deps: install Neovim external tools into stdpath("data")/deps.
# Versions and checksums are pinned here; bump them by hand after review.

DEST ?= $(or $(XDG_DATA_HOME),$(HOME)/.local/share)/nvim/deps
OPTS := $(DEST)/opts
BIN  := $(DEST)/bin

LUALS_VERSION    := 3.19.1
LUALS_SHA256     := e9235d2d72ef55bc41cf8c99cda2ed64777682024b4bb81f5dea425060c5cbb8
PHPACTOR_VERSION := 2026.07.22.0
PHPACTOR_SHA256  := 8c0155380b9d7559a12f35ddf8d09c1dc23e72f1797498038251fc35ad15574d
STYLUA_VERSION   := 2.5.2
# 0.7.7; upstream tags lack the "v" prefix, so Go only sees pseudo-versions
ARDUINO_VERSION  := v0.0.0-20250319095226-9945da32e7fa

LUALS    := $(OPTS)/lua-language-server-$(LUALS_VERSION)
PHPACTOR := $(OPTS)/phpactor-$(PHPACTOR_VERSION)
STYLUA   := $(OPTS)/stylua-$(STYLUA_VERSION)
ARDUINO  := $(OPTS)/arduino-language-server-$(ARDUINO_VERSION)
NPM      := $(DEST)/node_modules/.installed

.PHONY: deps
deps: $(NPM) $(LUALS) $(PHPACTOR) $(STYLUA) $(ARDUINO)
	mkdir -p $(BIN)
	ln -sfn $(LUALS)/bin/lua-language-server $(BIN)/
	ln -sfn $(PHPACTOR)/phpactor $(BIN)/
	ln -sfn $(STYLUA)/bin/stylua $(BIN)/
	ln -sfn $(ARDUINO)/bin/arduino-language-server $(BIN)/

# npm: lockfile pinned, no install scripts
# (awk-language-server loads tree-sitter-awk.wasm, so no native build is needed)
#
# To update, edit only the lockfile (never plain `npm install` in deps/):
#   npm outdated --prefix $(DEST)
#   cd deps && npm update --package-lock-only --ignore-scripts --before=<7 days ago>
#   (major bump: npm install --package-lock-only --ignore-scripts <pkg>@latest)
#   git diff deps/; grep -B3 '"hasInstallScript"' deps/package-lock.json
#   make deps
$(NPM): deps/package.json deps/package-lock.json
	mkdir -p $(DEST)
	cp $^ $(DEST)/
	npm ci --prefix $(DEST) --ignore-scripts
	touch $@

$(LUALS):
	test -n '$(strip $(LUALS_SHA256))'
	rm -rf $@.tmp && mkdir -p $@.tmp
	curl -fsSL -o $@.tar.gz https://github.com/LuaLS/lua-language-server/releases/download/$(LUALS_VERSION)/lua-language-server-$(LUALS_VERSION)-linux-x64.tar.gz
	echo '$(strip $(LUALS_SHA256))  $@.tar.gz' | sha256sum -c -
	tar -xzf $@.tar.gz -C $@.tmp
	rm $@.tar.gz
	mv $@.tmp $@

$(PHPACTOR):
	test -n '$(strip $(PHPACTOR_SHA256))'
	rm -rf $@.tmp && mkdir -p $@.tmp
	curl -fsSL -o $@.tmp/phpactor https://github.com/phpactor/phpactor/releases/download/$(PHPACTOR_VERSION)/phpactor.phar
	echo '$(strip $(PHPACTOR_SHA256))  $@.tmp/phpactor' | sha256sum -c -
	chmod 755 $@.tmp/phpactor
	mv $@.tmp $@

$(STYLUA):
	rm -rf $@.tmp
	cargo install --locked --version $(STYLUA_VERSION) --root $@.tmp stylua
	mv $@.tmp $@

# verified against sum.golang.org
$(ARDUINO):
	rm -rf $@.tmp
	GOBIN=$@.tmp/bin go install github.com/arduino/arduino-language-server@$(ARDUINO_VERSION)
	mv $@.tmp $@

# nvim: build Neovim itself and install it under ~/.local/opt/nvim.
NVIM_REF    := ac1a06021de60ae2b94ac23aa51729c867f57ce0
NVIM_SRC    := $(HOME)/.ghq/github.com/neovim/neovim
NVIM_PREFIX := $(HOME)/.local/opt/nvim
NVIM_FLAGS  := CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$(NVIM_PREFIX)

.PHONY: nvim
nvim:
	test -d $(NVIM_SRC) || git clone --filter=blob:none https://github.com/neovim/neovim $(NVIM_SRC)
	git -C $(NVIM_SRC) fetch origin
	git -C $(NVIM_SRC) checkout --detach $(NVIM_REF)
	$(MAKE) -C $(NVIM_SRC) $(NVIM_FLAGS)
	rm -rf $(NVIM_PREFIX)
	$(MAKE) -C $(NVIM_SRC) $(NVIM_FLAGS) install
	mkdir -p $(HOME)/.local/bin
	ln -sfn $(NVIM_PREFIX)/bin/nvim $(HOME)/.local/bin/nvim
