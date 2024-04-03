# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

# Env
export CYPRESS_INSTALL_BINARY=0
export CYPRESS_RUN_BINARY=$HOME/.local/opt/Cypress/Cypress/Cypress
export STARSHIP_CACHE=$XDG_CACHE_HOME/starship
export GOPATH=$HOME/.go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# Starship 🚀
eval "$(starship init bash)"

