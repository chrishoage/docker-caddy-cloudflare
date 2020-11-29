#! /bin/bash

ENV_VARS="$(printenv | xargs)"

if [[ "$ENV_VARS" == *"FILE__"* ]]; then
  for ENV_VAR in $ENV_VARS; do
    VAR_NAME="${ENV_VAR%=*}"
    if [[ "${VAR_NAME}" == "FILE__"* ]]; then
      VAR_VALUE="${!VAR_NAME}"
      if [[ -f "$VAR_VALUE" ]]; then
        FILESTRIP=${VAR_NAME//FILE__/}
        FILEVALUE=$(cat "$VAR_VALUE")
        printf -v $FILESTRIP "$FILEVALUE"
        export $FILESTRIP
        unset "$VAR_NAME"
        echo "${FILESTRIP} set from ${VAR_VALUE}"
      else
        echo "cannot find secret in ${ENV_VAR}"
      fi
    fi
  done
fi

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile "$@"
