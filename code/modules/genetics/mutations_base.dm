/proc/get_domino_value()
	return pick(1, 2, 3, 4, 5, 6, 7, 8)


/proc/get_random_hex()
	var/hex = ""
	while(length(hex) < 6)
		hex += pick(hexdigits)
	return hex


/datum/computer_file/binary/animalgene
	filetype = "ADNA"
	size = 5
	var/gene_type
	var/gene_value


/datum/mutation
	var/name = "Unknown mutation"
	var/desc = "Unknown function"
	var/hex = "FFFFFF"
	var/tier_num = 0 // 0, 1, 2, 3, 4
	var/tier_string = "Nero" // "Nero", "Vespasian", "Tacitus", "Hadrian", "Aurelien"
	var/NSA_load = 1 // How much NSA holder get if mutation is active
	var/is_active = FALSE
	var/domino_r = 1
	var/domino_l = 1


/datum/mutation/New()
	hex = get_random_hex()
	domino_r = get_domino_value()
	domino_l = get_domino_value()


/datum/mutation/proc/imprint(mob/living/carbon/user)
	if(!istype(user))
		return

	if(src in user.active_mutations)
		return

// Check for maximum active mutations of certain type

	if(src in user.dormant_mutations)
		user.dormant_mutations -= src

	user.active_mutations |= src
	user.metabolism_effects.adjust_nsa(NSA_load, "Mutation_[hex]_[name]")


/datum/mutation/proc/cleanse(mob/living/carbon/user)
	if(!istype(user))
		return

	user.active_mutations -= src
	user.dormant_mutations |= src
	user.metabolism_effects.remove_nsa("Mutation_[hex]_[name]")

/mob/proc/GetMutation(M)
	if(M in active_mutations)
		return TRUE
	return FALSE
