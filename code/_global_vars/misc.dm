GLOBAL_LIST_EMPTY(all_observable_events)

//see proc/get_average_color()
GLOBAL_LIST_EMPTY(average_icon_color)

//see getFlatTypeIcon()
GLOBAL_LIST_EMPTY(initialTypeIcon)

GLOBAL_DATUM(lobbyScreen, /datum/lobbyscreen)

// WORLD TOPIC CACHING //
GLOBAL_VAR(topic_status_lastcache)
GLOBAL_LIST(topic_status_cache)

// Extools vars
GLOBAL_VAR_INIT(internal_tick_usage, 0.2 * world.tick_lag) //This var is updated every tick by a DLL if present, used to reduce lag 
GLOBAL_PROTECT(internal_tick_usage) // NO TOUCHY

GLOBAL_VAR_INIT(fallback_alerted, FALSE)
GLOBAL_PROTECT(fallback_alerted) // NO TOUCHY

GLOBAL_VAR_INIT(next_promise_id, 0)
GLOBAL_PROTECT(next_promise_id) // NO TOUCHY