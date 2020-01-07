#/bin/bash

# `SECRET.env` example:
# declare -x FLOOD_SECRET="long-random-password"

FILE=${1:-"SECRET.env"}

if [ ! -f ${FILE} ] ; then
  echo "File \"${FILE}\" not found."
  exit 1
fi

. ${FILE}
echo "Secrets from ${FILE} imported to current bash session."
