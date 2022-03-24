# -*- mode: make; -*-

# POSIX
# install :
#	install --target-directory="$$HOME/.local/bin"\
#		--mode=0700\
#		local/bin/homedir_backup.sh\
#		local/bin/homedir_restore.sh

ifneq (${XDG_CONFIG_HOME},)
	config_home = ${XDG_CONFIG_HOME}/homedir
else
	config_home = ${HOME}/.config/homedir
endif

ifneq (${XDG_DATA_HOME},)
	backup_home = ${XDG_DATA_HOME}/homedir
else
	backup_home = ${HOME}/.local/share/homedir
endif

default :
	@echo "run 'make install'"

install :
	install -m 0700\
		local/bin/homedir.sh\
		${HOME}/.local/bin/
	install -m 0700\
		-d ${config_home}
	install -m 0700\
		-d ${backup_home}
