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
//This var is updated every tick by a DLL if present, used to reduce lag
//If no DLL is present, the default during MC init is 5% of tick_lag
//It's bumped to MAPTICK_DEFAULT_ITU during runtime (set once MC init is done)
GLOBAL_VAR_INIT(internal_tick_usage, 0.05 * world.tick_lag)
GLOBAL_PROTECT(internal_tick_usage) // NO TOUCHY

GLOBAL_VAR_INIT(fallback_alerted, FALSE)
GLOBAL_PROTECT(fallback_alerted) // NO TOUCHY

GLOBAL_VAR_INIT(next_promise_id, 0)
GLOBAL_PROTECT(next_promise_id) // NO TOUCHY


//////SCORE STUFF
//Goonstyle scoreboard
GLOBAL_VAR_INIT(score_crewscore, 0) // this is the overall var/score for the whole round
GLOBAL_VAR_INIT(score_stuffshipped, 0) // how many useful items have cargo shipped out?
GLOBAL_VAR_INIT(score_stuffharvested, 0) // how many harvests have hydroponics done?
GLOBAL_VAR_INIT(score_oremined, 0) // obvious
GLOBAL_VAR_INIT(score_researchdone, 0)
GLOBAL_VAR_INIT(score_eventsendured, 0) // how many random events did the station survive?
GLOBAL_VAR_INIT(score_powerloss, 0) // how many APCs have poor charge?
GLOBAL_VAR_INIT(score_escapees, 0) // how many people got out alive?
GLOBAL_VAR_INIT(score_deadcrew, 0) // dead bodies on the station, oh no
GLOBAL_VAR_INIT(score_mess, 0) // how much poo, puke, gibs, etc went uncleaned
GLOBAL_VAR_INIT(score_meals, 0)
GLOBAL_VAR_INIT(score_disease, 0) // how many rampant, uncured diseases are on board the station
GLOBAL_VAR_INIT(score_deadcommand, 0) // used during rev, how many command staff perished
GLOBAL_VAR_INIT(score_arrested, 0) // how many traitors/revs/whatever are alive in the brig
GLOBAL_VAR_INIT(score_traitorswon, 0) // how many traitors were successful?
GLOBAL_VAR_INIT(score_allarrested, 0) // did the crew catch all the enemies alive?
GLOBAL_VAR_INIT(score_opkilled, 0) // used during nuke mode, how many operatives died?
GLOBAL_VAR_INIT(score_disc, 0) // is the disc safe and secure?
GLOBAL_VAR_INIT(score_nuked, 0) // was the station blown into little bits?
GLOBAL_VAR_INIT(score_nuked_penalty, 0) //penalty for getting blown to bits

// these ones are mainly for the stat panel
GLOBAL_VAR_INIT(score_powerbonus, 0) // if all APCs on the station are running optimally, big bonus
GLOBAL_VAR_INIT(score_messbonus, 0) // if there are no messes on the station anywhere, huge bonus
GLOBAL_VAR_INIT(score_deadaipenalty, 0) // is the AI dead? if so, big penalty
GLOBAL_VAR_INIT(score_foodeaten, 0) // nom nom nom
GLOBAL_VAR_INIT(score_clownabuse, 0) // how many times a clown was punched, struck or otherwise maligned
GLOBAL_VAR(score_richestname) // this is all stuff to show who was the richest alive on the shuttle
GLOBAL_VAR(score_richestjob)  // kinda pointless if you dont have a money system i guess
GLOBAL_VAR_INIT(score_richestcash, 0)
GLOBAL_VAR(score_richestkey)
GLOBAL_VAR(score_dmgestname) // who had the most damage on the shuttle (but was still alive)
GLOBAL_VAR(score_dmgestjob)
GLOBAL_VAR_INIT(score_dmgestdamage, 0)
GLOBAL_VAR(score_dmgestkey)
