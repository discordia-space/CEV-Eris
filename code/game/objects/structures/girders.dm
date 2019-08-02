/obj/structure/girder
	icon_state = "girder"
	anchored = 1
	density = 1
	layer = BELOW_OBJ_LAYER
	w_class = ITEM_SIZE_HUGE
	var/state = 0
	var/health = 150
	var/cover = 50 //how much cover the girder provides against projectiles.
	var/material/reinf_material
	var/reinforcing = 0
	var/resistance = RESISTANCE_TOUGH
	var/dismantle_materials_count = 5

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = 0
	health = 50
	cover = 25

//Low girders are used to build low walls
/obj/structure/girder/low
	health = 120
	cover = 25 //how much cover the girder provides against projectiles.
	dismantle_materials_count = 3

/obj/structure/girder/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart", var/wallbreaker)
	if(!damage || !wallbreaker)
		return 0
	user.do_attack_animation(src)
	visible_message(SPAN_DANGER("[user] [attack_message] the [src]!"))
	spawn(1) dismantle()
	return 1

/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	//Girders only provide partial cover. There's a chance that the projectiles will just pass through. (unless you are trying to shoot the girder)
	if(Proj.original != src && !prob(cover))
		return PROJECTILE_CONTINUE //pass through

	var/damage = Proj.get_structure_damage()
	if(!damage)
		return

	if(!istype(Proj, /obj/item/projectile/beam))
		damage *= 0.4 //non beams do reduced damage

	take_damage(damage)

	return

/obj/structure/girder/proc/reset_girder()
	anchored = 1
	cover = initial(cover)
	health = min(health,initial(health))
	state = 0
	icon_state = initial(icon_state)
	reinforcing = 0
	if(reinf_material)
		reinforce_girder()

/obj/structure/girder/attackby(obj/item/I, mob/user)

	//Attempting to damage girders
	//This supercedes all construction, deconstruction and similar actions. So change your intent out of harm if you don't want to smack it
	if (usr.a_intent == I_HURT && user.Adjacent(src))
		if(!(I.flags & NOBLUDGEON))
			user.do_attack_animation(src)
			var/calc_damage = (I.force*I.structure_damage_factor) - resistance
			var/volume = (calc_damage)*3.5
			volume = min(volume, 15)
			if (I.hitsound)
				playsound(src, I.hitsound, volume, 1, -1)

			if (calc_damage > 0)
				visible_message(SPAN_DANGER("[src] has been hit by [user] with [I]."))
				take_damage(I.force*I.structure_damage_factor, I.damtype)
			else
				visible_message(SPAN_DANGER("[user] ineffectually hits [src] with [I]"))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*1.75)
			return TRUE

	var/list/usable_qualities = list()
	if(state == 0 && ((anchored && !reinf_material) || !anchored))
		usable_qualities.Add(QUALITY_BOLT_TURNING)
	if(state == 2 || (anchored && !reinf_material))
		usable_qualities.Add(QUALITY_SCREW_DRIVING)
	if(state == 0 && anchored)
		usable_qualities.Add(QUALITY_PRYING)
	if(state == 1)
		usable_qualities.Add(QUALITY_WIRE_CUTTING)

	var/tool_type = I.get_tool_type(user, usable_qualities,src)
	switch(tool_type)

		if(QUALITY_BOLT_TURNING)
			if(state == 0)
				if(anchored && !reinf_material)
					to_chat(user, SPAN_NOTICE("You start disassembling the girder..."))
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You dissasembled the girder!"))
						dismantle()
						return
				if(!anchored)
					to_chat(user, SPAN_NOTICE("You start securing the girder..."))
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
						to_chat(user, SPAN_NOTICE("You secured the girder!"))
						reset_girder()
						return
			return

		if(QUALITY_PRYING)
			if(state == 0 && anchored)
				to_chat(user, SPAN_NOTICE("You start dislodging the girder..."))
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You dislodged the girder!"))
					icon_state = "displaced"
					anchored = 0
					health = 50
					cover = 25
					return
			return

		if(QUALITY_WIRE_CUTTING)
			if(state == 1)
				to_chat(user, SPAN_NOTICE("You start removing support struts..."))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You removed the support struts!"))
					reinf_material.place_dismantled_product(get_turf(src))
					reinf_material = null
					reset_girder()
					return
			return

		if(QUALITY_SCREW_DRIVING)
			if(state == 2)
				to_chat(user, SPAN_NOTICE("Now unsecuring support struts..."))
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unsecured the support struts!"))
					state = 1
					return
			if(anchored && !reinf_material)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					reinforcing = !reinforcing
					to_chat(user, SPAN_NOTICE("The [src] can now be [reinforcing? "reinforced" : "constructed"]!"))
					return
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/material))
		if(reinforcing && !reinf_material)
			if(!reinforce_with_material(I, user))
				return ..()
		else
			if(!construct_wall(I, user))
				return ..()

	else
		return ..()

/obj/structure/girder/proc/construct_wall(obj/item/stack/material/S, mob/user)
	if(S.get_amount() < 3)
		to_chat(user, SPAN_NOTICE("There isn't enough material here to construct a wall."))
		return 0

	var/material/M = name_to_material[S.default_type]
	if(!istype(M))
		return 0

	//var/wall_fake
	add_hiddenprint(usr)

	if(M.integrity < 50)
		to_chat(user, SPAN_NOTICE("This material is too soft for use in wall construction."))
		return 0


	//Note By Nanako
	//7th January 2019: Fake wall construction disabled, due to critical bugs in wall icon updating.
	//A byond issue is triggering illegal operation errors and this is the simplest way to fix
	//In addtion we never made sprites for fake walls so it'd look awful anyway.
	//TODO in future: Re-enable this feature after the underlying problem is solved
	if (!anchored)
		to_chat(user, SPAN_NOTICE("The girders must be anchored to build a wall here."))
		return

	to_chat(user, SPAN_NOTICE("You begin adding the plating..."))

	if(!do_after(user,WORKTIME_SLOW,src) || !S.use(3))
		return 1 //once we've gotten this far don't call parent attackby()

	if(anchored)
		to_chat(user, SPAN_NOTICE("You added the plating!"))
	else
		to_chat(user, SPAN_NOTICE("The girders must be anchored to build a wall here."))
		return
		//user, SPAN_NOTICE("You create a false wall! Push on it to open or close the passage.")
		//wall_fake = 1

	var/turf/Tsrc = get_turf(src)
	Tsrc.ChangeTurf(/turf/simulated/wall)
	var/turf/simulated/wall/T = get_turf(src)
	T.set_material(M, reinf_material)
	//if(wall_fake)
		//T.can_open = 1
	T.add_hiddenprint(usr)
	qdel(src)
	return 1

/obj/structure/girder/low/construct_wall(obj/item/stack/material/S, mob/user)
	if(S.get_amount() < 1)
		to_chat(user, SPAN_NOTICE("There isn't enough material here to construct a low wall."))
		return 0

	var/material/M = name_to_material[S.default_type]
	if(!istype(M))
		return 0

	if (!istype(M, /material/steel))
		to_chat(user, SPAN_NOTICE("Low walls can only be made of steel."))
		return 0
	add_hiddenprint(usr)

	to_chat(user, SPAN_NOTICE("You begin adding the plating..."))

	if(!do_after(user,WORKTIME_NORMAL,src) || !S.use(1))
		return 1 //once we've gotten this far don't call parent attackby()


	var/obj/structure/low_wall/T = new(loc)
	T.add_hiddenprint(usr)
	T.Created()
	qdel(src)
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user) //if the verb is removed this can be renamed.
	if(reinf_material)
		to_chat(user, SPAN_NOTICE("\The [src] is already reinforced."))
		return 0

	if(S.get_amount() < 2)
		to_chat(user, SPAN_NOTICE("There isn't enough material here to reinforce the girder."))
		return 0

	var/material/M = name_to_material[S.default_type]
	if(!istype(M) || M.integrity < 50)
		to_chat(user, "You cannot reinforce \the [src] with that; it is too soft.")
		return 0

	to_chat(user, SPAN_NOTICE("Now reinforcing..."))
	if (!do_after(user, 40,src) || !S.use(2))
		return 1 //don't call parent attackby() past this point
	to_chat(user, SPAN_NOTICE("You added reinforcement!"))

	reinf_material = M
	reinforce_girder()
	return 1

/obj/structure/girder/proc/reinforce_girder()
	cover = reinf_material.hardness
	health = 500
	state = 2
	icon_state = "reinforced"
	reinforcing = 0

/obj/structure/girder/proc/dismantle()
	new /obj/item/stack/material/steel(src.loc, dismantle_materials_count)
	qdel(src)

/obj/structure/girder/attack_hand(mob/user as mob)
	if (HULK in user.mutations)
		visible_message(SPAN_DANGER("[user] smashes [src] apart!"))
		dismantle()
		return
	return ..()

/obj/structure/girder/proc/take_damage(var/damage, var/damage_type = BRUTE, var/ignore_resistance = FALSE)
	if (!ignore_resistance)
		damage -= resistance
	if (!damage || damage <= 0)
		return

	health -= damage
	if (health <= 0)
		dismantle()


/obj/structure/girder/ex_act(severity)
	switch(severity)
		if(1.0)
			take_damage(rand(500))
		if(2.0)
			take_damage(rand(120,300))

		if(3.0)
			take_damage(rand(60,180))


/obj/structure/girder/get_fall_damage(var/turf/from, var/turf/dest)
	var/damage = health * 0.4

	if (from && dest)
		damage *= abs(from.z - dest.z)

	return damage