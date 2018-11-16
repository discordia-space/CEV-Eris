// Glass shards

/obj/item/weapon/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	sharp = 1
	edge = 1
	w_class = ITEM_SIZE_SMALL
	force_divisor = 0.2 // 6 with hardness 30 (glass)
	thrown_force_divisor = 0.4 // 4 with weight 15 (glass)
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material = MATERIAL_GLASS
	unbreakable = 1 //It's already broken.
	drops_debris = 0
	var/amount = 0

/obj/item/weapon/material/shard/New(var/newloc, var/material_key, var/_amount)
	if (_amount)
		amount = max(round(_amount, 0.01), 0.01) //We won't ever need to physically represent less than 1% of a material unit
	.=..()

/obj/item/weapon/material/shard/set_material(var/new_material)
	..(new_material)
	if(!istype(material))
		return

	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

	//Shards must be made of some matter
	if (!amount)
		amount = rand_between(0.25, 1)

	//Overwrite whatever was populated before. A shard contains <1 unit of a single material
	matter = list(material.name = amount)

	update_icon()



	if(material.shard_type)
		name = "[material.display_name] [material.shard_type]"
		desc = "A small piece of [material.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch(material.shard_type)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		qdel(src)

/obj/item/weapon/material/shard/update_icon()
	if(material)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255


	//variable rotation based on randomness
	var/rot = rand(0, 360)
	var/matrix/M = matrix()
	M.Turn(rot)

	//Variable icon size based on material quantity
	//Shards will scale from 0.6 to 1.25 scale, in the range of 0..1 amount
	if (amount < 1)
		M.Scale(((1.25 - 0.6)*amount)+0.6)

	transform = M

/obj/item/weapon/material/shard/attackby(obj/item/I, mob/user)
	if(QUALITY_WELDING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_COG))
			material.place_sheet(loc)
			qdel(src)
			return
	return ..()

/obj/item/weapon/material/shard/Crossed(AM as mob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5) //Thick skin.
				return

			if(H.shoes)
				return

			M << SPAN_DANGER("You step on \the [src]!")

			var/list/check = list(BP_L_LEG, BP_R_LEG)
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(affecting.robotic >= ORGAN_ROBOT)
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
/obj/item/weapon/material/shard/shrapnel
	name = "shrapnel" //Needed for crafting

/obj/item/weapon/material/shard/shrapnel/New(loc)

	..(loc, MATERIAL_STEEL)

/obj/item/weapon/material/shard/plasma/New(loc)
	..(loc, MATERIAL_PLASMAGLASS)
