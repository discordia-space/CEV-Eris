// Glass shards
/obj/item/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on69aterial, if this desc is69isible it's a bug (shards default to being69ade of glass)
	icon_state = "large"
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_TINY
	force_divisor = 0.2 // 6 with hardness 30 (glass)
	thrown_force_divisor = 0.4 // 4 with weight 15 (glass)
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material =69ATERIAL_GLASS
	unbreakable = 1 //It's already broken.
	drops_debris = 0
	spawn_tags = SPAWN_TAG_MATERIAL_BUILDING_JUNK
	rarity_value = 6
	var/amount = 0

/obj/item/material/shard/New(newloc,69aterial_key, _amount)
	if(_amount)
		amount =69ax(round(_amount, 0.01), 0.01) //We won't ever need to physically represent less than 1% of a69aterial unit
	.=..()
	//Material will be set during the parent callstack
	if(!material)
		69del(src)
		return


	//Shards69ust be69ade of some69atter
	if (!amount)
		amount = round(RAND_DECIMAL(0.1, 1), 0.1)

	//Overwrite whatever was populated before. A shard contains <1 unit of a single69aterial
	matter = list(material.name = amount)
	update_icon()

/obj/item/material/shard/set_material(var/new_material,69ar/update)
	..(new_material)
	if(!istype(material))
		return

	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

	update_icon()

	if(material.shard_type)
		name = "69material.display_name69 69material.shard_type69"
		desc = "A small piece of 69material.display_name69. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch(material.shard_type)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		69del(src)

/obj/item/material/shard/update_icon()
	if(material)
		color =69aterial.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat69isible at 0.51 opacity
		alpha = 255 * (1 - (1 -69aterial.opacity)*(1 -69aterial.opacity))
	else
		color = "#ffffff"
		alpha = 255


	if (amount > 0.7)
		icon_state = "69material.shard_icon6969"large"69"
	else if (amount < 0.4)
		icon_state = "69material.shard_icon6969"medium"69"
	else
		icon_state = "69material.shard_icon6969"small"69"
	//variable rotation based on randomness
	var/rot = rand(0, 360)
	var/matrix/M =69atrix()
	M.Turn(rot)

	//Variable icon size based on69aterial 69uantity
	//Shards will scale from 0.6 to 1.25 scale, in the range of 0..1 amount
	if (amount < 1)
		M.Scale(((1.25 - 0.8)*amount)+0.8)

	transform =69

/obj/item/material/shard/attackby(obj/item/I,69ob/user)
	if(69UALITY_WELDING in I.tool_69ualities)
		merge_shards(I, user)
		return
	return ..()

//Allows you to weld together similar shards in a tile to create useful sheets
/obj/item/material/shard/proc/merge_shards(obj/item/I,69ob/user)
	if (!istype(loc, /turf))
		to_chat(user, SPAN_WARNING("You need to lay the shards down on a surface to do this!"))
		return

	var/list/shards = list()
	var/total = amount

	//Loop through all the other shards in the tile and cache them
	for (var/obj/item/material/shard/S in loc)
		if (S.material.name ==69aterial.name && S != src)
			shards.Add(S)
			total += S.amount

	//If there's less than one unit of69aterial in total, we can't do anything
	if (total < 1)
		to_chat(user, SPAN_WARNING("There's not enough 69material.name69 in 69shards.len < 2 ? "this piece" : "these 69shards.len69 pieces"69 to69ake anything useful. Gather69ore."))
		return


	//Alright, we've got enough to69ake at least one sheet!
	var/obj/item/stack/output = null //This stack will contain the sheets
	to_chat(user, SPAN_NOTICE("You start welding the 69name69s into useful69aterial sheets..."))

	//Do a tool operation for each shard
	for (var/obj/item/material/shard/S in shards)
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_WELDING, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
			//We69eld each shard with ourselves
			amount += S.amount
			69del(S)

			//And when our amount gets high enough, we split it off into a sheet
			if (amount > 1)
				//We create a new sheet stack if one doesn't exist yet
				//We also check the location and create a new stack if the old one is gone. Like if someone picked it up
				if (!output || output.loc != loc)
					output =69aterial.place_sheet(loc)
					output.amount = 0
				output.amount++
				amount -= 1
			update_icon()
		else
			//If we fail any of the operations, we abort it all
			break


/obj/item/material/shard/Crossed(AM as69ob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle69etal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H =69

			if(H.species.siemens_coefficient<0.5) //Thick skin.
				return

			if(H.shoes)
				return

			to_chat(M, SPAN_DANGER("You step on \the 69src69!"))

			var/list/check = list(BP_L_LEG, BP_R_LEG)
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(BP_IS_ROBOTIC(affecting))
						return
					if(affecting.take_damage(5, 0))
						H.UpdateDamageIcon()
					H.updatehealth()
					if(!(H.species.flags & NO_PAIN))
						H.Weaken(3)
					return
				check -= picked
			return

// Preset types - left here for the code that uses them
/obj/item/material/shard/shrapnel
	name = "shrapnel" //Needed for crafting
	rarity_value = 2.5

/obj/item/material/shard/shrapnel/New(loc)

	..(loc,69ATERIAL_STEEL)

/obj/item/material/shard/shrapnel/scrap
	name = "scrap69etal"
	amount = 1
	rarity_value = 5

/obj/item/material/shard/plasma/New(loc)
	..(loc,69ATERIAL_PLASMAGLASS)
