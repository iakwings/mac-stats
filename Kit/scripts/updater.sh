#!/bin/sh

set -euf; unset -v _ IFS; export LC_ALL=C

set_path() {
  case "$2" in
    (/*|./*|../*|.|..|'') eval "${1}=\"\${2}\"" ;;
    (*) eval "${1}=\"./\${2}\"" ;;
  esac
}

set_path DMG_PATH "${HOME}/Downloads/Stats.dmg"
set_path MOUNT_PATH '/tmp/Stats'
set_path APPLICATION_PATH '/Applications'

STEP=''

while [ 0 -lt "$#" ]; do
  case "$1" in
    (-s|--step) STEP="${2?--step}"; shift 2;;
    (-d|--dmg) set_path DMG_PATH "${2?--dmg}"; shift 2;;
    (-a|--app) set_path APPLICATION_PATH "${2?--app}"; shift 2;;
    (-m|--mount) set_path MOUNT_PATH "${2?--mount}"; shift 2;;
    (*)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
  esac
done

if [ 2 = "${STEP}" ]; then
  rm -rf -- "${APPLICATION_PATH}/Stats.app"
  cp -rf -- "${MOUNT_PATH}/Stats.app" "${APPLICATION_PATH}/Stats.app"
  "${APPLICATION_PATH}/Stats.app/Contents/MacOS/Stats" --dmg "${DMG_PATH}"
  echo "New version started"
elif [ 3 = "${STEP}" ]; then
    hdiutil detach "${MOUNT_PATH}"
    rm -rf -- "${MOUNT_PATH}"
    rm -rf -- "${DMG_PATH}"
    echo 'Done'
else
    rm -rf -- "${APPLICATION_PATH}/Stats.app"
    cp -rf -- "${MOUNT_PATH}/Stats.app" "${APPLICATION_PATH}/Stats.app"
    "${APPLICATION_PATH}/Stats.app/Contents/MacOS/Stats" --dmg-path "${DMG_PATH}" --mount-path "${MOUNT_PATH}"
    echo 'New version started'
fi

exit

cat <<'ORIGINAL'
#!/bin/bash

DMG_PATH="$HOME/Downloads/Stats.dmg"
MOUNT_PATH="/tmp/Stats"
APPLICATION_PATH="/Applications/"

STEP=""

while [[ "$#" > 0 ]]; do case $1 in
  -s|--step) STEP="$2"; shift;;
  -d|--dmg) DMG_PATH="$2"; shift;;
  -a|--app) APPLICATION_PATH="$2"; shift;;
  -m|--mount) MOUNT_PATH="$2"; shift;;
  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

if [[ "$STEP" == "2" ]]; then
    rm -rf $APPLICATION_PATH/Stats.app
    cp -rf $MOUNT_PATH/Stats.app $APPLICATION_PATH/Stats.app

    $APPLICATION_PATH/Stats.app/Contents/MacOS/Stats --dmg "$DMG_PATH"

    echo "New version started"
elif [[ "$STEP" == "3" ]]; then
    /usr/bin/hdiutil detach "$MOUNT_PATH"
    /bin/rm -rf "$MOUNT_PATH"
    /bin/rm -rf "$DMG_PATH"

    echo "Done"
else
    rm -rf $APPLICATION_PATH/Stats.app
    cp -rf $MOUNT_PATH/Stats.app $APPLICATION_PATH/Stats.app

    $APPLICATION_PATH/Stats.app/Contents/MacOS/Stats --dmg-path "$DMG_PATH" --mount-path "$MOUNT_PATH"

    echo "New version started"
fi
ORIGINAL
