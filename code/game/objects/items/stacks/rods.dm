/obj/item/stack/rods
	name = "metal rod"
	desc = "Some rods. Can be used for buildin69, or somethin69."
	icon = 'icons/obj/stack/items.dmi'
	sin69ular_name = "metal rod"
	icon_state = "rods"
	novariants = FALSE
	fla69s = CONDUCT
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	throw_speed = 5
	throw_ran69e = 20
	matter = list(MATERIAL_STEEL = 1)
	max_amount = 60
	attack_verb = list("hit", "blud69eoned", "whacked")
	price_ta69 = 1

/obj/item/stack/rods/random
	rand_min = 2
	rand_max = 30
	spawn_ta69s = SPAWN_TA69_ORE_TA69_JUNK
	rarity_value = 10

/obj/item/stack/rods/cybor69
	name = "metal rod synthesizer"
	desc = "A device that69akes69etal rods."
	69ender = NEUTER
	matter = null
	uses_char69e = 1
	char69e_costs = list(500)
	stacktype = /obj/item/stack/rods
	spawn_ta69s = null

/obj/item/stack/rods/attackby(obj/item/I,69ob/livin69/user)
	..()
	if(69UALITY_WELDIN69 in I.tool_69ualities)
		if(69et_amount() < 2)
			to_chat(user, SPAN_WARNIN69("You need at least two rods to do this."))
			return

		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDIN69, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
			var/obj/item/stack/material/steel/new_item = new (usr.loc)
			new_item.add_to_stacks(usr)
			for (var/mob/M in69iewers(src))
				M.show_messa69e(SPAN_NOTICE("69src69 is shaped into69etal by 69user.name69 with the 69I.name69."), 3, SPAN_NOTICE("You hear weldin69."), 2)
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.69et_inactive_hand() == R)
			R.use(2)
			if(!R && replace)
				user.put_in_hands(new_item)
		return
	..()


/obj/item/stack/rods/attack_self(mob/livin69/user)
	user.open_craft_menu("Tiles")//see69enu.dm
