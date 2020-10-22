#!/usr/bin/zsh

#
# azsphere-docker-aliases-unset
#
# Remove aliases for the mcr.microsoft.com/azurespheresdk image executables
#

# unalias azsphere-docker-interactive 2>/dev/null

unset -f azsphere-docker-build
unset -f azsphere-docker-interactive