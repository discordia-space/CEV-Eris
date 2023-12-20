/obj/item/stack/rods
	name = "metal rod"
	desc = "Some rods. Can be used for building, or something."
	icon = 'icons/obj/stack/items.dmi'
	singular_name = "metal rod"
	icon_state = "rods"
	novariants = FALSE
	flags = CONDUCT
	volumeClass = ITEM_SIZE_NORMAL
	melleDamages = list(
		ARMOR_BLUNT = list(
			DELEM(BRUTE, 7)
		)
	)
	throwforce = WEAPON_FORCE_WEAK
	throw_speed = 5
	throw_range = 20
	matter = list(MATERIAL_STEEL = 1)
	max_amount = 60
	attack_verb = list("hit", "bludgeoned", "whacked")
	price_tag = 1

/obj/item/stack/rods/random
	rand_min = 2
	rand_max = 30
	spawn_tags = SPAWN_TAG_ORE_TAG_JUNK
	rarity_value = 10

/obj/item/stack/rods/cyborg
	name = "metal rod synthesizer"
	desc = "A device that makes metal rods."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)
	stacktype = /obj/item/stack/rods
	spawn_tags = null

/obj/item/stack/rods/attackby(obj/item/I, mob/living/user)
	..()
	if(QUALITY_WELDING in I.tool_qualities)
		if(get_amount() < 2)
			to_chat(user, SPAN_WARNING("You need at least two rods to do this."))
			return

		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
			var/obj/item/stack/material/steel/new_item = new (usr.loc)
			new_item.add_to_stacks(usr)
			for (var/mob/M in viewers(src))
				M.show_message(SPAN_NOTICE("[src] is shaped into metal by [user.name] with the [I.name]."), 3, SPAN_NOTICE("You hear welding."), 2)
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.get_inactive_hand() == R)
			R.use(2)
			if(!R && replace)
				user.put_in_hands(new_item)
		return
	..()


/obj/item/stack/rods/attack_self(mob/living/user)
	user.open_craft_menu("Tiles")//see menu.dm

//when thrown on impact, rods make an audio sound
/obj/item/stack/rods/throw_impact(atom/hit_atom, speed)
	..()
	if(isfloor(hit_atom))
		playsound(loc, 'sound/effects/metalpipe.ogg', 100, 1)
