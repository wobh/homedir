# -*- mode: sh; -*-
#!/user/bin/env bash

# strict mode
set -euo pipefail

usage="Usage: ${0} <command> [<option>]

Commands
    backup      sync config to backup
    restore     sync backup to config
    help        print this message

Options
    --for-real  actually sync

By default, homedir does a 'dry run' sync. No syncing happens without
the '--for-real' option being specified.
"

cmd=${1:-}
opt=${2:-}

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
backup_home="${XDG_DATA_HOME:-$HOME/.local/share}/homedir/config"

case $cmd in
    "backup")
        sync_src="${config_home}/"
        sync_dest="${backup_home}"
        ;;
    "restore")
        sync_src="${backup_home}/"
        sync_dest="${config_home}"
        ;;
    "help")
        echo "${usage}"
        exit 0
        ;;
    *)
        echo "${usage}"
        exit 1
        ;;
esac

declare -a sync_opts
sync_opts=(
    "--update"
    "--archive"
    "--recursive"
    "--itemize-changes"
)

excludes="${XDG_CONFIG_HOME:-$HOME/.config}/homedir/excluded_configs"
if [[ -r ${excludes} ]]
then
   sync_opts[${#sync_opts[@]}]="--exclude-from=${excludes}"
fi

if [[ ${opt} != "--for-real" ]]
then
    sync_opts[${#sync_opts[@]}]="--dry-run"
fi

# sync $XDG_CONFIG_HOME
rsync ${sync_opts[@]}\
      --\
      ${sync_src}\
      ${sync_dest}
