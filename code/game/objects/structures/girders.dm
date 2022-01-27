/obj/structure/69irder
	name = "wall 69irder"
	icon_state = "69irder"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	matter = list(MATERIAL_STEEL = 5)
	var/state = 0
	var/health = 150
	var/cover = 50 //how69uch cover the 69irder provides a69ainst projectiles.
	var/material/reinf_material
	var/reinforcin69 = 0
	var/resistance = RESISTANCE_TOU69H

/obj/structure/69irder/displaced
	icon_state = "displaced"
	anchored = FALSE
	health = 50
	cover = 25

//Low 69irders are used to build low walls
/obj/structure/69irder/low
	name = "low wall 69irder"
	matter = list(MATERIAL_STEEL = 3)
	health = 120
	cover = 25 //how69uch cover the 69irder provides a69ainst projectiles.

//Used in recyclin69 or deconstruction
/obj/structure/69irder/69et_matter()
	var/list/matter = ..()
	. =69atter.Copy()
	if(reinf_material)
		LAZYAPLUS(., reinf_material.name, 2)

/obj/structure/69irder/attack_69eneric(var/mob/user,69ar/dama69e,69ar/attack_messa69e = "smashes apart",69ar/wallbreaker)
	if(!dama69e || !wallbreaker)
		return 0
	user.do_attack_animation(src)
	visible_messa69e(SPAN_DAN69ER("69user69 69attack_messa69e69 the 69src69!"))
	spawn(1) dismantle(user)
	return 1

/obj/structure/69irder/bullet_act(var/obj/item/projectile/Proj)
	//69irders only provide partial cover. There's a chance that the projectiles will just pass throu69h. (unless you are tryin69 to shoot the 69irder)
	if(Proj.ori69inal != src && !prob(cover))
		return PROJECTILE_CONTINUE //pass throu69h

	var/dama69e = Proj.69et_structure_dama69e()
	if(!dama69e)
		return

	if(!istype(Proj, /obj/item/projectile/beam))
		dama69e *= 0.4 //non beams do reduced dama69e

	take_dama69e(dama69e)

	return

/obj/structure/69irder/proc/reset_69irder()
	anchored = TRUE
	cover = initial(cover)
	health =69in(health,initial(health))
	state = 0
	icon_state = initial(icon_state)
	reinforcin69 = 0
	if(reinf_material)
		reinforce_69irder()

/obj/structure/69irder/attackby(obj/item/I,69ob/user)

	//Attemptin69 to dama69e 69irders
	//This supercedes all construction, deconstruction and similar actions. So chan69e your intent out of harm if you don't want to smack it
	if (usr.a_intent == I_HURT && user.Adjacent(src))
		if(!(I.fla69s & NOBLUD69EON))
			user.do_attack_animation(src)
			var/calc_dama69e = (I.force*I.structure_dama69e_factor) - resistance
			var/volume = (calc_dama69e)*3.5
			volume =69in(volume, 15)
			if (I.hitsound)
				playsound(src, I.hitsound,69olume, 1, -1)

			if (calc_dama69e > 0)
				visible_messa69e(SPAN_DAN69ER("69src69 has been hit by 69user69 with 69I69."))
				take_dama69e(I.force*I.structure_dama69e_factor, I.damtype)
			else
				visible_messa69e(SPAN_DAN69ER("69user69 ineffectually hits 69src69 with 69I69"))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*1.75)
			return TRUE

	var/list/usable_69ualities = list()
	if(state == 0 && ((anchored && !reinf_material) || !anchored))
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)
	if(state == 2 || (anchored && reinforcin69 && !reinf_material))
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
	if(state == 0 && anchored)
		usable_69ualities.Add(69UALITY_PRYIN69)
	if(state == 1)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities,src)
	switch(tool_type)

		if(69UALITY_BOLT_TURNIN69)
			if(state == 0)
				if(anchored && !reinf_material)
					to_chat(user, SPAN_NOTICE("You start disassemblin69 the 69irder..."))
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You dissasembled the 69irder!"))
						dismantle(user)
						return
				if(!anchored)
					to_chat(user, SPAN_NOTICE("You start securin69 the 69irder..."))
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You secured the 69irder!"))
						reset_69irder()
						return
			return

		if(69UALITY_PRYIN69)
			if(state == 0 && anchored)
				to_chat(user, SPAN_NOTICE("You start dislod69in69 the 69irder..."))
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You dislod69ed the 69irder!"))
					icon_state = "displaced"
					anchored = FALSE
					health = 50
					cover = 25
					return
			return

		if(69UALITY_WIRE_CUTTIN69)
			if(state == 1)
				to_chat(user, SPAN_NOTICE("You start removin69 support struts..."))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You removed the support struts!"))
					reinf_material.place_sheet(drop_location(), amount=2)
					reinf_material = null
					reset_69irder()
					return
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(state == 2)
				to_chat(user, SPAN_NOTICE("You start unsecurin69 support struts..."))
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unsecured the support struts!"))
					state = 1
					return
			if(anchored && reinforcin69 && !reinf_material)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
					reinforcin69 = FALSE
					new /obj/item/stack/rods(drop_location(), 2)
					to_chat(user, SPAN_NOTICE("69src69 can now be constructed!"))
					return
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/S = I
		if(anchored && !reinforcin69)
			if(S.69et_amount() < 2)
				to_chat(user, SPAN_NOTICE("There isn't enou69h69aterial here to start reinforcin69 the 69irder."))
				return

			to_chat(user, SPAN_NOTICE("You start to prepare 69src69 for reinforcin69 with 69S69..."))
			if (!do_after(user, 40, src) || !S.use(2))
				return
			to_chat(user, SPAN_NOTICE("You prepare to reinforce 69src69."))
			reinforcin69 = TRUE

	if(istype(I, /obj/item/stack/material))
		if(reinforcin69 && !reinf_material)
			if(!reinforce_with_material(I, user))
				return ..()
		else
			if(!construct_wall(I, user))
				return ..()

	else
		return ..()

/obj/structure/69irder/proc/construct_wall(obj/item/stack/material/S,69ob/user)
	if(S.69et_amount() < 3)
		to_chat(user, SPAN_NOTICE("There isn't enou69h69aterial here to construct a wall."))
		return 0

	var/material/M = name_to_material69S.default_type69
	if(!istype(M))
		return 0

	//var/wall_fake
	add_hiddenprint(usr)

	if(M.inte69rity < 50)
		to_chat(user, SPAN_NOTICE("This69aterial is too soft for use in wall construction."))
		return 0


	//Note By Nanako
	//7th January 2019: Fake wall construction disabled, due to critical bu69s in wall icon updatin69.
	//A byond issue is tri6969erin69 ille69al operation errors and this is the simplest way to fix
	//In addtion we never69ade sprites for fake walls so it'd look awful anyway.
	//TODO in future: Re-enable this feature after the underlyin69 problem is solved
	if (!anchored)
		to_chat(user, SPAN_NOTICE("The 69irders69ust be anchored to build a wall here."))
		return

	to_chat(user, SPAN_NOTICE("You be69in addin69 the platin69..."))

	if(!do_after(user,WORKTIME_SLOW,src) || !S.use(3))
		return 1 //once we've 69otten this far don't call parent attackby()

	if(anchored)
		to_chat(user, SPAN_NOTICE("You added the platin69!"))
	else
		to_chat(user, SPAN_NOTICE("The 69irders69ust be anchored to build a wall here."))
		return
		//user, SPAN_NOTICE("You create a false wall! Push on it to open or close the passa69e.")
		//wall_fake = 1

	var/turf/Tsrc = 69et_turf(src)
	Tsrc.Chan69eTurf(/turf/simulated/wall)
	var/turf/simulated/wall/T = 69et_turf(src)
	T.set_material(M, reinf_material)
	//if(wall_fake)
		//T.can_open = 1
	T.add_hiddenprint(usr)
	69del(src)
	return 1

/obj/structure/69irder/low/construct_wall(obj/item/stack/material/S,69ob/user)
	if(S.69et_amount() < 1)
		to_chat(user, SPAN_NOTICE("There isn't enou69h69aterial here to construct a low wall."))
		return 0

	var/material/M = name_to_material69S.default_type69
	if(!istype(M))
		return 0

	if (!istype(M, /material/steel))
		to_chat(user, SPAN_NOTICE("Low walls can only be69ade of steel."))
		return 0
	add_hiddenprint(usr)

	to_chat(user, SPAN_NOTICE("You be69in addin69 the platin69..."))

	if(!do_after(user,WORKTIME_NORMAL,src) || !S.use(1))
		return 1 //once we've 69otten this far don't call parent attackby()


	var/obj/structure/low_wall/T = new(loc)
	T.add_hiddenprint(usr)
	T.Created()
	69del(src)
	return 1

/obj/structure/69irder/proc/reinforce_with_material(obj/item/stack/material/S,69ob/user) //if the69erb is removed this can be renamed.
	if(reinf_material)
		to_chat(user, SPAN_NOTICE("\The 69src69 is already reinforced."))
		return 0

	if(S.69et_amount() < 2)
		to_chat(user, SPAN_NOTICE("There isn't enou69h69aterial here to reinforce the 69irder."))
		return 0

	var/material/M = name_to_material69S.default_type69
	if(!istype(M) ||69.inte69rity < 50)
		to_chat(user, "You cannot reinforce \the 69src69 with that; it is too soft.")
		return 0

	to_chat(user, SPAN_NOTICE("You start reinforcin69 69src69 with 69S69..."))
	if (!do_after(user, 40,src) || !S.use(2))
		return 1 //don't call parent attackby() past this point
	to_chat(user, SPAN_NOTICE("You reinforce 69src69!"))

	reinf_material =69
	reinforce_69irder()
	return 1

/obj/structure/69irder/proc/reinforce_69irder()
	cover = reinf_material.hardness
	health = 500
	state = 2
	icon_state = "reinforced"
	reinforcin69 = 0

/obj/structure/69irder/proc/dismantle(mob/livin69/user)
	drop_materials(drop_location(), user)
	69del(src)

/obj/structure/69irder/attack_hand(mob/user as69ob)
	if (HULK in user.mutations)
		visible_messa69e(SPAN_DAN69ER("69user69 smashes 69src69 apart!"))
		dismantle()
		return
	return ..()

/obj/structure/69irder/proc/take_dama69e(var/dama69e,69ar/dama69e_type = BRUTE,69ar/i69nore_resistance = FALSE)
	if (!i69nore_resistance)
		dama69e -= resistance
	if (!dama69e || dama69e <= 0)
		return

	health -= dama69e
	if (health <= 0)
		dismantle()


/obj/structure/69irder/ex_act(severity)
	switch(severity)
		if(1)
			take_dama69e(rand(500))
		if(2)
			take_dama69e(rand(120,300))

		if(3)
			take_dama69e(rand(60,180))


/obj/structure/69irder/69et_fall_dama69e(var/turf/from,69ar/turf/dest)
	var/dama69e = health * 0.4

	if (from && dest)
		dama69e *= abs(from.z - dest.z)

	return dama69e
