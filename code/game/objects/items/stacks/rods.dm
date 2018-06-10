/obj/item/stack/rods
	name = "metal rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "metal rod"
	icon_state = "rods"
	flags = CONDUCT
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFULL
	throwforce = WEAPON_FORCE_PAINFULL
	throw_speed = 5
	throw_range = 20
	matter = list(MATERIAL_STEEL = 1)
	max_amount = 60
	attack_verb = list("hit", "bludgeoned", "whacked")

/obj/item/stack/rods/cyborg
	name = "metal rod synthesizer"
	desc = "A device that makes metal rods."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)
	stacktype = /obj/item/stack/rods

/obj/item/stack/rods/attackby(obj/item/I, mob/user)
	..()
	if(QUALITY_WELDING in I.tool_qualities)
		if(get_amount() < 2)
			user << SPAN_WARNING("You need at least two rods to do this.")
			return

		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_VERY_EASY, required_stat = STAT_PRD))
			var/obj/item/stack/material/steel/new_item = new(usr.loc)
			new_item.add_to_stacks(usr)
			for (var/mob/M in viewers(src))
				M.show_message(SPAN_NOTICE("[src] is shaped into metal by [user.name] with the [I.name]."), 3, SPAN_NOTICE("You hear welding."), 2)
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.get_inactive_hand()==R)
			R.use(2)
			if (!R && replace)
				user.put_in_hands(new_item)
		return
	..()


/obj/item/stack/rods/attack_self(mob/user as mob)
	src.add_fingerprint(user)

	if(!istype(user.loc,/turf)) return 0

	if (locate(/obj/structure/grille, usr.loc))
		for(var/obj/structure/grille/G in usr.loc)
			if (G.destroyed)
				G.health = 10
				G.density = 1
				G.destroyed = 0
				G.icon_state = "grille"
				use(1)
			else
				return 1

	else if(!in_use)
		if(get_amount() < 2)
			user << SPAN_WARNING("You need at least two rods to do this.")
			return
		usr << SPAN_NOTICE("Assembling grille...")
		in_use = 1
		if (!do_after(usr, 10))
			in_use = 0
			return
		var/obj/structure/grille/F = new /obj/structure/grille/ ( usr.loc )
		usr << SPAN_NOTICE("You assemble a grille")
		in_use = 0
		F.add_fingerprint(usr)
		use(2)
	return
