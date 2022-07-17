/obj/item/moecube
	name = "cube of whirling worms"
	desc = "Absolutely disgusting."
	icon = 'icons/obj/eris_genetics.dmi'
	icon_state = "wormcube"
	layer = TOP_ITEM_LAYER // So it don't "fall" under machine that spawned it
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_BIOMATTER = 3)
	var/gene_type
	var/gene_value


/obj/item/moecube/attack(mob/living/carbon/human/H, mob/user)
	if(!istype(H))
		return

	if(!H.check_has_mouth())
		to_chat(user, "Where do you intend to put \the [src]?")
		return

	var/obj/item/thing = H.check_mouth_coverage()

	if(thing)
		to_chat(user, SPAN_WARNING("\The [thing] is in the way!"))
		return

	// Default eating messages from reagent_containers.dm, will do for now
	if(H == user)
		to_chat(user, SPAN_NOTICE("You eat \the [src]. It feels absolutely disgusting."))

	else
		user.visible_message(SPAN_WARNING("[user] is trying to feed [H] \the [src]!"))

		if(!do_mob(user, H, 15))
			return

		user.visible_message(SPAN_WARNING("[user] has fed [H] \the [src]!"))

	if(gene_type)
		switch(gene_type)
			if("mutation")
				var/datum/mutation/U = gene_value
				U.imprint(H)

			if("b_type")
				H.b_type = gene_value
				H.fixblood()
				H.adjustOxyLoss(rand(10, 50))

			if("real_name")
				H.real_name = gene_value
				H.dna_trace = sha1(gene_value)
				H.fingers_trace = md5(gene_value)

			if("species")
				var/datum/species/S = gene_value
				H.set_species(S.name)
	else
		var/datum/mutation/U = gene_value ? gene_value : (H.active_mutations.len ? pick(H.active_mutations) : null)
		U?.cleanse(H)

	// Neither safe nor pleasant experience
	H.adjustToxLoss(rand(10, 50))
	H.sanity.changeLevel(-20)

	user.drop_from_inventory(src)
	qdel(src)
