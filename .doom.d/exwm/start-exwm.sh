#!/bin/sh

# NOTE: This is only for the live demo, not needed for your configuration!
# spice-vdagent

# Fire it up
exec dbus-run-session emacs -mm --debug-init -l ${HOME}/.doom.d/exwm/desktop.el
