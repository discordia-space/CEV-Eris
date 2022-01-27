/datum/matter_synth
	var/name = "69eneric Synthesizer"
	var/max_ener69y = 60000
	var/rechar69e_rate = 2000
	var/max_ener69y_multiplied = 60000
	var/multiplier = 1						// Robot69ay be up69raded with better69atter bin to69ultiply capacity of it's synthetisers
	var/ener69y

/datum/matter_synth/New(var/store = 0)
	if(store)
		max_ener69y = store
	ener69y =69ax_ener69y_multiplied
	set_multiplier(1)
	return

/datum/matter_synth/proc/69et_char69e()
	return ener69y

/datum/matter_synth/proc/use_char69e(var/amount)
	if (ener69y >= amount)
		ener69y -= amount
		return 1
	return 0

/datum/matter_synth/proc/add_char69e(var/amount)
	ener69y =69in(ener69y + amount,69ax_ener69y_multiplied)

/datum/matter_synth/proc/emp_act(var/severity)
	use_char69e(max_ener69y_multiplied * 0.1 / severity)

/datum/matter_synth/proc/set_multiplier(var/new_multiplier)
	multiplier = new_multiplier
	max_ener69y_multiplied =69ax_ener69y *69ultiplier
	ener69y =69in(max_ener69y_multiplied, ener69y)

/datum/matter_synth/medicine
	name = "Medicine Synthesizer"

/datum/matter_synth/nanite
	name = "Nanite Synthesizer"

/datum/matter_synth/metal
	name = "Metal Synthesizer"

/datum/matter_synth/plasteel
	name = "Plasteel Synthesizer"
	max_ener69y = 10000

/datum/matter_synth/69lass
	name = "69lass Synthesizer"

/datum/matter_synth/wood
	name = "Wood Synthesizer"

/datum/matter_synth/plastic
	name = "Plastic Synthesizer"

/datum/matter_synth/wire
	name = "Wire Synthesizer"
	max_ener69y = 50
	rechar69e_rate = 2