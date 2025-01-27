#!/usr/bin/with-contenv bashio
# ==============================================================================
# Start the example service
# s6-overlay docs: https://github.com/just-containers/s6-overlay
# ==============================================================================

export ROUTESPATH=/data/routes

if [[ ! -S /run/docker.sock ]]; then
    bashio::exit.nok "Docker socket not found, please disable protection mode on the information screen of this plugin"
fi

local routes

# mock call to supervisor to get the addon config when testing locally
# function bashio::addon.config() {
#     cat /data/options.json
# }

routes=$(jq -r '.routes | join(",")' /data/options.json)
bashio::log.info "--- Looking for routes"
bashio::log.info "Routes: $routes"

export SYSLOG_HOSTNAME=$(bashio::config 'hostname' 'homeassistant')
export INACTIVITY_TIMEOUT=5m

if bashio::config.exists 'env'; then
    while IFS=, read -r key value ; do
        if [[ ! -z "$key" ]]; then
            bashio::log.info "$key=$value"
            local "$key"="$value"
            export $key
        fi
    done <<< $(jq -cr '.env[] | .name + "," + .value' /data/options.json)
fi

exec /logspout "$routes"
