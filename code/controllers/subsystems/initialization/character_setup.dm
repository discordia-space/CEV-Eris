SUBSYSTEM_DEF(character_setup)
	name = "Character Setup"
	init_order = INIT_ORDER_CHAR_SETUP
	flags = SS_NO_FIRE

	var/list/prefs_awaiting_setup = list()
	var/list/preferences_datums = list()

	var/datum/category_collection/setup_option_collection/setup_options

/datum/controller/subsystem/character_setup/Initialize()
	setup_options = new

	while(prefs_awaiting_setup.len)
		var/datum/preferences/prefs = prefs_awaiting_setup[prefs_awaiting_setup.len]
		prefs_awaiting_setup.len--
		prefs.setup()

	for(var/d in preferences_datums)
		var/datum/preferences/prefs = d
		if(istype(prefs) && !prefs.path)
			error("Prefs failed to setup (SS): [prefs.client_ckey]")
			prefs.setup()

	// Start playing music for clients
	for(var/client/C in clients)
		GLOB.lobbyScreen.play_music(C)

	. = ..()