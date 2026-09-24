# Symlink dotfiles into $HOME.
#   make link    create missing links (default); never touches real files
#   make unlink  remove links that point into this repo
#   make status  show the state of every link
#
# Mapping is explicit: <path in repo>:<path under $HOME>

DOTFILES := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

LINKS := \
	configs/alacritty:.config/alacritty \
	configs/bash/bashrc:.bashrc \
	configs/bash/bash_profile:.bash_profile \
	configs/cmus/rc:.config/cmus/rc \
	configs/hypr:.config/hypr \
	configs/mako:.config/mako \
	configs/nvim:.config/nvim \
	configs/profile/profile:.profile \
	configs/starship:.config/starship \
	scripts/askpass.sh:.local/bin/askpass.sh \
	scripts/capture.sh:.local/bin/capture.sh

# Shared loop: sets $src (absolute) and $dst (absolute) for each pair.
FOREACH = for pair in $(LINKS); do \
	src="$(DOTFILES)/$${pair%%:*}"; dst="$(HOME)/$${pair\#*:}";

.DEFAULT_GOAL := link
.PHONY: link unlink status

# A symlink is replaced only when it is dangling (e.g. after moving the repo)
# or already correct; anything else is reported and left alone.
link:
	@rc=0; $(FOREACH) \
		if [ -L "$$dst" ]; then \
			[ "$$(readlink "$$dst")" = "$$src" ] && continue; \
			if [ -e "$$dst" ]; then \
				echo "skip  $$dst -> $$(readlink "$$dst") (foreign link)"; rc=1; continue; \
			fi; \
			ln -sfn "$$src" "$$dst" && echo "fix   $$dst"; \
		elif [ -e "$$dst" ]; then \
			echo "skip  $$dst (real file)"; rc=1; \
		else \
			mkdir -p "$${dst%/*}" && ln -s "$$src" "$$dst" && echo "link  $$dst"; \
		fi; \
	done; exit $$rc

unlink:
	@$(FOREACH) \
		if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
			rm "$$dst" && echo "rm    $$dst"; \
		fi; \
	done

status:
	@$(FOREACH) \
		if [ -L "$$dst" ]; then \
			t="$$(readlink "$$dst")"; \
			if [ "$$t" = "$$src" ]; then echo "ok    $$dst"; \
			elif [ -e "$$dst" ]; then echo "other $$dst -> $$t"; \
			else echo "dead  $$dst -> $$t"; fi; \
		elif [ -e "$$dst" ]; then echo "file  $$dst"; \
		else echo "none  $$dst"; fi; \
	done
