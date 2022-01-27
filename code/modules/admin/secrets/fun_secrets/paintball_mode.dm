/datum/admin_secret_item/fun_secret/paintbal_mode
	name = "Paintball69ode"

/datum/admin_secret_item/fun_secret/paintbal_mode/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/species in all_species)
		var/datum/species/S = all_species69species69
		S.blood_color = "rainbow"
	for(var/obj/effect/decal/cleanable/blood/B in world)
		B.basecolor = "rainbow"
		B.update_icon()
