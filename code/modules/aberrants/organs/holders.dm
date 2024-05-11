/obj/item/organ/internal/scaffold
	name = "organ scaffold"
	icon = 'icons/obj/aberrant_organs.dmi'
	icon_state = "organ_scaffold"
	desc = "A collagen-based biostructure."
	description_info = "A functionless organ with three slots for organ mods or organoids. Best used with an input, process, and output organoid to create a modular organ."
	price_tag = 100
	organ_efficiency = list()
	specific_organ_size = 0.2
	origin_tech = list(TECH_BIO = 3)	// One level higher than regular organs
	rarity_value = 60
	spawn_tags = SPAWN_TAG_ABERRANT_ORGAN
	spawn_blacklisted = TRUE	// No point in having these spawn in junk

	var/list/organ_dna_data = list()		// For changing organ DNA

	var/use_generated_name = TRUE
	var/use_generated_icon = TRUE
	var/organ_type = null
	var/num_variants = 8		// Number of sprite variants in the dmi
	var/num_colors = 5			// Number of colored sprites in the dmi
	var/use_generated_color = TRUE
	var/generated_color = null

	// Internal
	var/aberrant_cooldown_time = STANDARD_ABERRANT_COOLDOWN
	var/on_cooldown = FALSE
	var/ruined = FALSE
	var/ruined_name = "organ scaffold"
	var/ruined_desc = "A collagen-based biostructure."
	var/ruined_description_info = "A functionless organ with three slots for organ mods or organoids. Best used with an input, process, and output organoid to create a modular organ."
	var/ruined_color = null

/obj/item/organ/internal/scaffold/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ABERRANT_COOLDOWN, PROC_REF(start_cooldown))

	if(use_generated_icon)
		if(organ_type)
			organ_type = "-[organ_type]"
		else if(num_variants)
			organ_type = "-[rand(1,num_variants)]"

	update_icon()

	if(reagents && LAZYLEN(organ_dna_data))
		reagents.maximum_volume += 5
		reagents.add_reagent("blood", 5, organ_dna_data)

/obj/item/organ/internal/scaffold/Destroy()
	UnregisterSignal(src, COMSIG_ABERRANT_COOLDOWN)
	if(LAZYLEN(item_upgrades))
		for(var/datum/mod in item_upgrades)
			SEND_SIGNAL_OLD(mod, COMSIG_REMOVE, src)
			qdel(mod)
	return ..()

/obj/item/organ/internal/scaffold/Process()
	..()

	if(owner && !on_cooldown && damage < min_broken_damage)
		SEND_SIGNAL(src, COMSIG_ABERRANT_INPUT, owner)

/obj/item/organ/internal/scaffold/examine(mob/user, extra_description = "")
	var/using_sci_goggles = FALSE
	var/details_unlocked = FALSE

	if(isghost(user))
		details_unlocked = TRUE
	else if(user.stats)
		// Goggles check
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H && istype(H.glasses, /obj/item/clothing/glasses/powered/science))
				var/obj/item/clothing/glasses/powered/G = H.glasses
				using_sci_goggles = G.active	// Meat vision

		// Stat check
		details_unlocked = (user.stats.getStat(STAT_BIO) >= STAT_LEVEL_EXPERT - 5 && user.stats.getStat(STAT_COG) >= STAT_LEVEL_BASIC - 5) ? TRUE : FALSE

	if(using_sci_goggles || details_unlocked)
		var/function_info
		var/input_info = SPAN_WARNING("Input organoid absent.")
		var/process_info = SPAN_WARNING("Process organoid absent.")
		var/output_info = SPAN_WARNING("Output organoid absent.")
		var/secondary_info

		for(var/mod in contents)
			var/obj/item/modification/organ/internal/holder = mod
			var/datum/component/modification/organ/organ_mod = holder.GetComponent(/datum/component/modification/organ)
			if(istype(mod, /obj/item/modification/organ/internal/input))
				input_info = organ_mod.get_function_info()
			else if(istype(mod, /obj/item/modification/organ/internal/process))
				process_info = organ_mod.get_function_info()
			else if(istype(mod, /obj/item/modification/organ/internal/output))
				output_info = organ_mod.get_function_info()
			else if(istype(mod, /obj/item/modification/organ/internal))
				secondary_info = organ_mod.get_function_info()

		function_info = input_info + "\n" +\
						process_info + "\n" +\
						output_info + "\n" +\
						secondary_info

		if(aberrant_cooldown_time > 0)
			extra_description += SPAN_NOTICE("\nAverage organ process duration: [aberrant_cooldown_time / (1 SECOND)] seconds")

		if(function_info)
			extra_description += SPAN_NOTICE(function_info)
	else
		extra_description += SPAN_WARNING("You lack the biological knowledge and/or mental ability required to understand its functions.")

	..(user, extra_description)

/obj/item/organ/internal/scaffold/refresh_organ_stats()
	name = initial(name)
	color = initial(color)
	max_upgrades = max_upgrades ? initial(max_upgrades) : 0		// If no max upgrades, it must be a ruined teratoma. So, leave it at 0.
	prefixes = list()
	min_bruised_damage = initial(min_bruised_damage)
	min_broken_damage = initial(min_broken_damage)
	max_damage = initial(max_damage) ? initial(max_damage) : min_broken_damage * 2
	owner_verbs = initial_owner_verbs.Copy()
	organ_efficiency = initial_organ_efficiency.Copy()
	scanner_hidden = initial(scanner_hidden)
	unique_tag = initial(unique_tag)
	specific_organ_size = initial(specific_organ_size)
	max_blood_storage = initial(max_blood_storage)
	blood_req = initial(blood_req)
	nutriment_req = initial(nutriment_req)
	oxygen_req = initial(oxygen_req)
	aberrant_cooldown_time = initial(aberrant_cooldown_time)
	SEND_SIGNAL(src, COMSIG_IWOUND_FLAGS_REMOVE)

/obj/item/organ/internal/scaffold/apply_modifiers()
	SEND_SIGNAL(src, COMSIG_IWOUND_EFFECTS)
	SEND_SIGNAL(src, COMSIG_IWOUND_LIMB_EFFECTS)
	SEND_SIGNAL(src, COMSIG_APPVAL)
	SEND_SIGNAL(src, COMSIG_APPVAL_MULT)
	SEND_SIGNAL(src, COMSIG_APPVAL_FLAT)
	SEND_SIGNAL(src, COMSIG_IWOUND_FLAGS_ADD)

	refresh_damage()
	
	update_color()
	update_name()
	update_icon()

/obj/item/organ/internal/scaffold/update_icon()
	if(use_generated_icon)
		icon_state = initial(icon_state) + organ_type + generated_color
	else
		icon_state = initial(icon_state)

/obj/item/organ/internal/scaffold/ui_action_click(mob/living/user, action_name)
	if(on_cooldown)
		to_chat(user, SPAN_NOTICE("\The [src] is not ready to be activated."))
		return
	
	SEND_SIGNAL(src, COMSIG_ABERRANT_INPUT_VERB, owner)

/obj/item/organ/internal/scaffold/proc/update_color()
	if(!num_colors)
		return
	if(!use_generated_color || !item_upgrades.len)
		color = ruined ? ruined_color : color
		generated_color = null
		return

	if(!generated_color)
		generated_color = "-[rand(1,num_colors)]"

/obj/item/organ/internal/scaffold/proc/update_name()
	if(use_generated_name)
		name = generate_name_from_eff()
	else
		name = ruined ? ruined_name : name

	for(var/prefix in prefixes)
		name = "[prefix] [name]"

/obj/item/organ/internal/scaffold/proc/try_ruin()
	if(!ruined)
		ruin()

/obj/item/organ/internal/scaffold/proc/ruin()
	ruined = TRUE
	name = ruined_name ? ruined_name : initial(name)
	desc = ruined_desc ? ruined_desc : initial(desc)
	description_info = ruined_description_info ? ruined_description_info : initial(description_info)
	color = ruined_color ? ruined_color : initial(color)
	price_tag = 100
	use_generated_name = TRUE

/obj/item/organ/internal/scaffold/proc/generate_name_from_eff()
	if(!organ_efficiency.len)
		return ruined && (name == initial(name)) ? ruined_name : name	// name == initial(name) check is to see if the name was overidden by mods

	var/beginning
	var/list/middle = list()
	var/end
	var/list/name_chunk
	var/new_name
	var/prefix

	for(var/organ in organ_efficiency)
		switch(organ)
			if(OP_EYES)
				name_chunk = list("e", "y", "es")
			if(OP_HEART)
				name_chunk = list("he", "ar", "t")
			if(OP_LUNGS)
				name_chunk = list("l", "un", "gs")
			if(OP_LIVER)
				name_chunk = list("l", "iv", "er")
			if(OP_KIDNEYS)
				name_chunk = list("k", "idn", "ey")
			if(OP_APPENDIX)
				name_chunk = list("app", "end", "ix")
			if(OP_STOMACH)
				name_chunk = list("st", "om", "ach")
			if(OP_BONE)
				name_chunk = list("b", "on", "e")
			if(OP_MUSCLE)
				name_chunk = list("m", "us", "cle")
			if(OP_NERVE)
				name_chunk = list("n", "er", "ve")
			if(OP_BLOOD_VESSEL)
				name_chunk = list("blood v", "ess", "el")
			else
				name_chunk = list()

		if(!beginning)
			beginning = name_chunk[1]
		middle += name_chunk[2]
		end = name_chunk[3]

	if(middle.len == 1)
		prefix = pick("little ", "small ", "pygmy ", "tiny ")

	if(middle.len > 2)
		middle.Cut(middle.len)
		middle.Cut(1,2)

	if(beginning)
		new_name = prefix + beginning
		if(middle.len)
			for(var/chunk in middle)
				new_name += chunk
		new_name += end
		return new_name

/obj/item/organ/internal/scaffold/proc/start_cooldown()
	SIGNAL_HANDLER
	on_cooldown = TRUE
	addtimer(CALLBACK(src, PROC_REF(end_cooldown)), aberrant_cooldown_time, TIMER_STOPPABLE)

/obj/item/organ/internal/scaffold/proc/end_cooldown()
	on_cooldown = FALSE
	if(action_button_name && owner)
		to_chat(owner, SPAN_NOTICE("Your [name] twitches. It is ready to be used again."))

/obj/item/organ/internal/scaffold/large
	name = "large organ scaffold"
	ruined_name = null
	desc = "A collagen-based biostructure. This one has room for an extra organoid."
	ruined_desc = null
	description_info = "A functionless organ with four slots for organ mods or organoids. Generally, you'll want to save the fourth upgrade slot for a membrane."
	ruined_description_info = null
	rarity_value = 80
	spawn_tags = SPAWN_TAG_ABERRANT_ORGAN
	max_upgrades = 4
	specific_organ_size = 0.2

/obj/item/organ/internal/scaffold/aberrant
	name = "aberrant organ"
	bad_type = /obj/item/organ/internal/scaffold/aberrant

	var/input_mod_path
	var/process_mod_path
	var/output_mod_path
	var/special_mod_path

	var/req_num_inputs = 1
	var/req_num_outputs = 1

	var/base_input_type = null
	var/list/specific_input_type_pool = list()
	var/input_mode = null
	var/input_threshold = 0
	var/list/process_info = list()
	var/should_process_have_organ_stats = FALSE
	var/list/output_pool = list()
	var/list/output_info = list()
	var/list/special_info = list()

/obj/item/organ/internal/scaffold/aberrant/Initialize()
	. = ..()
	if(!input_mod_path && !process_mod_path && !output_mod_path && !special_mod_path)
		return
	if(input_mod_path)
		if(!input_mode && (!base_input_type && !specific_input_type_pool.len))
			return
	if(output_mod_path)
		if(!output_pool.len || !output_info.len)
			return
	if(input_mod_path && output_mod_path)
		if((specific_input_type_pool.len < req_num_inputs && !base_input_type) || output_pool.len < req_num_outputs || output_info.len < req_num_outputs)
			return

	var/list/input_args = list()
	var/list/input_info = list()
	var/list/additional_input_info = list()
	var/list/output_args = list()
	var/list/output_types = list()
	var/list/additional_output_info = list()

	if(req_num_inputs)
		var/list/inputs_sans_blacklist = list()
		var/list/input_pool = list()

		if(specific_input_type_pool.len)
			additional_input_info = specific_input_type_pool.Copy()
			input_pool = specific_input_type_pool.Copy()
		else if(base_input_type)
			inputs_sans_blacklist = subtypesof(base_input_type) - REAGENT_BLACKLIST
			additional_input_info = inputs_sans_blacklist.Copy()
			input_pool = inputs_sans_blacklist.Copy()

		for(var/i in 1 to req_num_inputs)
			input_info += pick_n_take(input_pool)
		
		input_args += list(input_info)
		if(input_mode)
			input_args += input_mode
		if(input_threshold)
			input_args += input_threshold
		input_args += list(additional_input_info)

	if(req_num_outputs)
		additional_output_info = output_pool.Copy()
		for(var/i in 1 to req_num_outputs)
			output_types += list(pick_n_take(output_pool) = output_info[i])
		
		output_args += list(output_types)
		output_args += list(additional_output_info)

	var/obj/item/modification/organ/internal/input/I
	if(ispath(input_mod_path, /obj/item/modification/organ/internal/input))
		I = new input_mod_path(src, FALSE, null, 0, input_args)

	var/obj/item/modification/organ/internal/process/P
	if(ispath(process_mod_path, /obj/item/modification/organ/internal/process))
		P = new process_mod_path(src, should_process_have_organ_stats, null, 0, process_info)

	var/obj/item/modification/organ/internal/output/O
	if(ispath(output_mod_path, /obj/item/modification/organ/internal/output))
		O = new output_mod_path(src, FALSE, null, 0, output_args)

	var/obj/item/modification/organ/internal/S
	if(ispath(special_mod_path, /obj/item/modification/organ/internal))
		S = new special_mod_path(src, FALSE, null, 0, special_info)

	if(I)
		SEND_SIGNAL_OLD(I, COMSIG_IATTACK, src)

	if(P)
		SEND_SIGNAL_OLD(P, COMSIG_IATTACK, src)

	if(O)
		SEND_SIGNAL_OLD(O, COMSIG_IATTACK, src)

	if(S)
		SEND_SIGNAL_OLD(S, COMSIG_IATTACK, src)
