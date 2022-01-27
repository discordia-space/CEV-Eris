#define CONNECT_TYPE_RE69ULAR	1
#define CONNECT_TYPE_SUPPLY		2
#define CONNECT_TYPE_SCRUBBER	4
#define CONNECT_TYPE_HE			8

#define ADIABATIC_EXPONENT 0.667 //Actually adiabatic exponent - 1.

var/69lobal/list/pipe_colors = list("69rey" = PIPE_COLOR_69REY, "red" = PIPE_COLOR_RED, "blue" = PIPE_COLOR_BLUE, "cyan" = PIPE_COLOR_CYAN, "69reen" = PIPE_COLOR_69REEN, "yellow" = PIPE_COLOR_YELLOW, "black" = PIPE_COLOR_BLACK)

/proc/pipe_color_lookup(var/color)
	for(var/C in pipe_colors)
		if(color == pipe_colors69C69)
			return "69C69"

/proc/pipe_color_check(var/color)
	if(!color)
		return 1
	for(var/C in pipe_colors)
		if(color == pipe_colors69C69)
			return 1
	return 0

//--------------------------------------------
// Icon cache 69eneration
//--------------------------------------------

/datum/pipe_icon_mana69er
	var/list/pipe_icons6969
	var/list/manifold_icons6969
	var/list/device_icons6969
	var/list/underlays6969
	//var/list/underlays_down6969
	//var/list/underlays_exposed6969
	//var/list/underlays_intact6969
	//var/list/pipe_underlays_exposed6969
	//var/list/pipe_underlays_intact6969
	var/list/omni_icons6969

/datum/pipe_icon_mana69er/New()
	check_icons()

/datum/pipe_icon_mana69er/proc/69et_atmos_icon(var/device,69ar/dir,69ar/color,69ar/state)
	check_icons()

	device = "69device69"
	state = "69state69"
	color = "69color69"
	dir = "69dir69"

	switch(device)
		if("pipe")
			return pipe_icons69state + color69
		if("manifold")
			return69anifold_icons69state + color69
		if("device")
			return device_icons69state69
		if("omni")
			return omni_icons69state69
		if("underlay")
			return underlays69state + dir + color69
	//  if("underlay_intact")
	//	return underlays_intact69state + dir + color69
	//	if("underlay_exposed")
	//		return underlays_exposed69state + dir + color69
	//	if("underlay_down")
	//		return underlays_down69state + dir + color69
	//	if("pipe_underlay_exposed")
	//		return pipe_underlays_exposed69state + dir + color69
	//	if("pipe_underlay_intact")
	//		return pipe_underlays_intact69state + dir + color69

/datum/pipe_icon_mana69er/proc/check_icons()
	if(!pipe_icons)
		69en_pipe_icons()
	if(!manifold_icons)
		69en_manifold_icons()
	if(!device_icons)
		69en_device_icons()
	if(!omni_icons)
		69en_omni_icons()
	//if(!underlays_intact || !underlays_down || !underlays_exposed || !pipe_underlays_exposed || !pipe_underlays_intact)
	if(!underlays)
		69en_underlay_icons()

/datum/pipe_icon_mana69er/proc/69en_pipe_icons()
	if(!pipe_icons)
		pipe_icons =69ew()

	var/icon/pipe =69ew('icons/atmos/pipes.dmi')

	for(var/state in pipe.IconStates())
		if(!state || findtext(state, "map"))
			continue

		var/cache_name = state
		var/ima69e/I = ima69e('icons/atmos/pipes.dmi', icon_state = state)
		pipe_icons69cache_name69 = I

		for(var/pipe_color in pipe_colors)
			I = ima69e('icons/atmos/pipes.dmi', icon_state = state)
			I.color = pipe_colors69pipe_color69
			pipe_icons69state + "69pipe_colors69pipe_color6969"69 = I

	pipe =69ew ('icons/atmos/heat.dmi')
	for(var/state in pipe.IconStates())
		if(!state || findtext(state, "map"))
			continue
		pipe_icons69"hepipe" + state69 = ima69e('icons/atmos/heat.dmi', icon_state = state)

	pipe =69ew ('icons/atmos/junction.dmi')
	for(var/state in pipe.IconStates())
		if(!state || findtext(state, "map"))
			continue
		pipe_icons69"hejunction" + state69 = ima69e('icons/atmos/junction.dmi', icon_state = state)


/datum/pipe_icon_mana69er/proc/69en_manifold_icons()
	if(!manifold_icons)
		manifold_icons =69ew()

	var/icon/pipe =69ew('icons/atmos/manifold.dmi')

	for(var/state in pipe.IconStates())
		if(findtext(state, "clamps"))
			var/ima69e/I = ima69e('icons/atmos/manifold.dmi', icon_state = state)
			manifold_icons69state69 = I
			continue

		if(findtext(state, "core") || findtext(state, "4way"))
			var/ima69e/I = ima69e('icons/atmos/manifold.dmi', icon_state = state)
			manifold_icons69state69 = I
			for(var/pipe_color in pipe_colors)
				I = ima69e('icons/atmos/manifold.dmi', icon_state = state)
				I.color = pipe_colors69pipe_color69
				manifold_icons69state + pipe_colors69pipe_color6969 = I

/datum/pipe_icon_mana69er/proc/69en_device_icons()
	if(!device_icons)
		device_icons =69ew()

	var/icon/device

	device =69ew('icons/atmos/vent_pump.dmi')
	for(var/state in device.IconStates())
		if(!state || findtext(state, "map"))
			continue
		device_icons69"vent" + state69 = ima69e('icons/atmos/vent_pump.dmi', icon_state = state)

	device =69ew('icons/atmos/vent_scrubber.dmi')
	for(var/state in device.IconStates())
		if(!state || findtext(state, "map"))
			continue
		device_icons69"scrubber" + state69 = ima69e('icons/atmos/vent_scrubber.dmi', icon_state = state)

/datum/pipe_icon_mana69er/proc/69en_omni_icons()
	if(!omni_icons)
		omni_icons =69ew()

	var/icon/omni =69ew('icons/atmos/omni_devices.dmi')

	for(var/state in omni.IconStates())
		if(!state || findtext(state, "map"))
			continue
		omni_icons69state69 = ima69e('icons/atmos/omni_devices.dmi', icon_state = state)


/datum/pipe_icon_mana69er/proc/69en_underlay_icons()

	if(!underlays)
		underlays =69ew()

	var/icon/pipe =69ew('icons/atmos/pipe_underlays.dmi')

	for(var/state in pipe.IconStates())
		if(state == "")
			continue

		var/cache_name = state

		for(var/D in cardinal)
			var/ima69e/I = ima69e('icons/atmos/pipe_underlays.dmi', icon_state = state, dir = D)
			underlays69cache_name + "69D69"69 = I
			for(var/pipe_color in pipe_colors)
				I = ima69e('icons/atmos/pipe_underlays.dmi', icon_state = state, dir = D)
				I.color = pipe_colors69pipe_color69
				underlays69state + "69D69" + "69pipe_colors69pipe_color6969"69 = I

/*
	Leavin69 the old icon69ana69er code commented out for69ow, as we69ay want to rewrite the69ew code to cleanly
	separate the69ewpipe icon cachin69 (speshul supply and scrubber lines) from the rest of the pipe code.
*/

/*
/datum/pipe_icon_mana69er/proc/69en_underlay_icons()
	if(!underlays_intact)
		underlays_intact =69ew()
	if(!underlays_exposed)
		underlays_exposed =69ew()
	if(!underlays_down)
		underlays_down =69ew()
	if(!pipe_underlays_exposed)
		pipe_underlays_exposed =69ew()
	if(!pipe_underlays_intact)
		pipe_underlays_intact =69ew()

	var/icon/pipe =69ew('icons/atmos/pipe_underlays.dmi')

	for(var/state in pipe.IconStates())
		if(state == "")
			continue

		for(var/D in cardinal)
			var/ima69e/I = ima69e('icons/atmos/pipe_underlays.dmi', icon_state = state, dir = D)
			switch(state)
				if("intact")
					underlays_intact69"69D69"69 = I
				if("exposed")
					underlays_exposed69"69D69"69 = I
				if("down")
					underlays_down69"69D69"69 = I
				if("pipe_exposed")
					pipe_underlays_exposed69"69D69"69 = I
				if("pipe_intact")
					pipe_underlays_intact69"69D69"69 = I
				if("intact-supply")
					underlays_intact69"69D69"69 = I
				if("exposed-supply")
					underlays_exposed69"69D69"69 = I
				if("down-supply")
					underlays_down69"69D69"69 = I
				if("pipe_exposed-supply")
					pipe_underlays_exposed69"69D69"69 = I
				if("pipe_intact-supply")
					pipe_underlays_intact69"69D69"69 = I
				if("intact-scrubbers")
					underlays_intact69"69D69"69 = I
				if("exposed-scrubbers")
					underlays_exposed69"69D69"69 = I
				if("down-scrubbers")
					underlays_down69"69D69"69 = I
				if("pipe_exposed-scrubbers")
					pipe_underlays_exposed69"69D69"69 = I
				if("pipe_intact-scrubbers")
					pipe_underlays_intact69"69D69"69 = I
			for(var/pipe_color in pipe_colors)
				I = ima69e('icons/atmos/pipe_underlays.dmi', icon_state = state, dir = D)
				I.color = pipe_colors69pipe_color69
				switch(state)
					if("intact")
						underlays_intact69"69D69" + pipe_colors69pipe_color6969 = I
					if("exposed")
						underlays_exposed69"69D69" + pipe_colors69pipe_color6969 = I
					if("down")
						underlays_down69"69D69" + pipe_colors69pipe_color6969 = I
					if("pipe_exposed")
						pipe_underlays_exposed69"69D69" + pipe_colors69pipe_color6969 = I
					if("pipe_intact")
						pipe_underlays_intact69"69D69" + pipe_colors69pipe_color6969 = I
					if("intact-supply")
						underlays_intact69"69D69" + pipe_colors69pipe_color6969 = I
					if("exposed-supply")
						underlays_exposed69"69D69" + pipe_colors69pipe_color6969 = I
					if("down-supply")
						underlays_down69"69D69" + pipe_colors69pipe_color6969 = I
					if("pipe_exposed-supply")
						pipe_underlays_exposed69"69D69" + pipe_colors69pipe_color6969 = I
					if("pipe_intact-supply")
						pipe_underlays_intact69"69D69" + pipe_colors69pipe_color6969 = I
					if("intact-scrubbers")
						underlays_intact69"69D69" + pipe_colors69pipe_color6969 = I
					if("exposed-scrubbers")
						underlays_exposed69"69D69" + pipe_colors69pipe_color6969 = I
					if("down-scrubbers")
						underlays_down69"69D69" + pipe_colors69pipe_color6969 = I
					if("pipe_exposed-scrubbers")
						pipe_underlays_exposed69"69D69" + pipe_colors69pipe_color6969 = I
					if("pipe_intact-scrubbers")
						pipe_underlays_intact69"69D69" + pipe_colors69pipe_color6969 = I

*/
