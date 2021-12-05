#define CUSTOM_TABLE_COVERING 			1
#define CUSTOM_TABLE_ICON_REPLACE 		2


//Custom appearance for tables, just add here a new design
//should be: list(name, desc, icon_state, icon replace or overlay, reinfocing required)
var/list/custom_table_appearance = list(
					"Bar - special" 	= list("bar table", "Well designed bar table.", "bar_table", CUSTOM_TABLE_ICON_REPLACE, TRUE),
					"Gambling" 			= list("gambling table", null, "carpet", CUSTOM_TABLE_COVERING, FALSE),
					"OneStar"			= list("onestar", "Very durable table made by an extinct empire", "onestar", CUSTOM_TABLE_ICON_REPLACE, TRUE )
										)


/obj/structure/table
	name = "table frame"
	icon = 'icons/obj/tables.dmi'
	icon_state = "frame"
	desc = "It's a table, for putting things on. Or standing on, if you really want to."
	density = TRUE
	anchored = TRUE
	climbable = 1
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	throwpass = 1
	matter = list(MATERIAL_STEEL = 2)
	var/flipped = 0
	var/maxhealth = 10
	var/health = 10

	// For racks.
	var/can_reinforce = 1
	var/can_plate = 1

	var/manipulating = 0
	var/material/material = null
	var/material/reinforced = null

	// Gambling tables. I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/list/custom_appearance = null

	var/list/connections = list("nw0", "ne0", "sw0", "se0")

/obj/structure/table/get_matter()
	var/list/matter = ..()
	. = matter.Copy()
	if(material)
		LAZYAPLUS(., material.name, 1)
	if(reinforced)
		LAZYAPLUS(., reinforced.name, 1)

/obj/structure/table/proc/update_material()
	var/old_maxhealth = maxhealth
	if(!material)
		maxhealth = 10
		if(can_plate)
			layer = PROJECTILE_HIT_THRESHHOLD_LAYER
		else
			layer = TABLE_LAYER
	else
		maxhealth = material.integrity / 2
		layer = TABLE_LAYER

		if(reinforced)
			maxhealth += reinforced.integrity / 2

	health += maxhealth - old_maxhealth

/obj/structure/table/proc/take_damage(amount)
	// If the table is made of a brittle material, and is *not* reinforced with a non-brittle material, damage is multiplied by TABLE_BRITTLE_MATERIAL_MULTIPLIER
	if(material && material.is_brittle())
		if(reinforced)
			if(reinforced.is_brittle())
				amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
		else
			amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
	health -= amount
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] breaks down!"))
		return break_to_parts() // if we break and form shards, return them to the caller to do !FUN! things with

/obj/structure/table/Initialize()
	. = ..()

	// reset color/alpha, since they're set for nice map previews
	color = "#ffffff"
	alpha = 255
	update_connections(1)
	update_icon()
	update_desc()
	update_material()

/obj/structure/table/Destroy()
	material = null
	reinforced = null
	update_connections(1) // Update tables around us to ignore us (material=null forces no connections)
	for(var/obj/structure/table/T in oview(src, 1))
		T.update_icon()
	. = ..()

/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(isliving(mover))
		var/mob/living/L = mover
		if(L.weakened)
			return 1
	return ..()	

/obj/structure/table/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0 to 0.5)
				to_chat(user, SPAN_WARNING("It looks severely damaged!"))
			if(0.25 to 0.5)
				to_chat(user, SPAN_WARNING("It looks damaged!"))
			if(0.5 to 1)
				to_chat(user, SPAN_NOTICE("It has a few scrapes and dents."))

/obj/structure/table/attackby(obj/item/I, mob/user)

	var/list/usable_qualities = list()
	if(reinforced)
		usable_qualities.Add(QUALITY_SCREW_DRIVING)
	if(custom_appearance)
		usable_qualities.Add(QUALITY_PRYING)
	if(health < maxhealth)
		usable_qualities.Add(QUALITY_WELDING)
	if(!reinforced && !custom_appearance)
		usable_qualities.Add(QUALITY_BOLT_TURNING)

	var/tool_type = I.get_tool_type(user, usable_qualities)
	switch(tool_type)

		if(QUALITY_SCREW_DRIVING)
			if(reinforced)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
					remove_reinforced(I, user)
					if(!reinforced)
						update_desc()
						update_icon()
						update_material()
			return

		if(QUALITY_PRYING)
			if(custom_appearance)
				if(custom_appearance[5] && !reinforced)
					to_chat(user, SPAN_WARNING("This type of design can't be applied to simple tables. Reinforce it first."))
					return
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
					user.visible_message(
						SPAN_NOTICE("\The [user] removes the carpet from \the [src]."),
						SPAN_NOTICE("You remove the carpet from \the [src].")
					)
					new /obj/item/stack/tile/carpet(loc)
					custom_appearance = null
					name = initial(name)
					desc = initial(desc)
					update_icon()
			return

		if(QUALITY_WELDING)
			if(health < maxhealth)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
					user.visible_message(SPAN_NOTICE("\The [user] repairs some damage to \the [src]."),SPAN_NOTICE("You repair some damage to \the [src]."))
					health = min(health+(maxhealth/5), maxhealth)//max(health+(maxhealth/5), maxhealth) // 20% repair per application
			return

		if(QUALITY_BOLT_TURNING)
			if(!reinforced && !custom_appearance)
				if(material)
					if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
						remove_material(I, user)
						if(!material)
							update_connections(1)
							update_icon()
							for(var/obj/structure/table/T in oview(src, 1))
								T.update_icon()
							update_desc()
							update_material()
							return
				if(!material)
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
						user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."),SPAN_NOTICE("You dismantle \the [src]."))
						drop_materials(drop_location())
						qdel(src)
			return

	if(!custom_appearance && material && istype(I, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = I
		var/choosen_style = input("Select an appearance.") in custom_table_appearance
		if(choosen_style)
			if(C.use(1))
				user.visible_message(
					SPAN_NOTICE("\The [user] adds \the [C] to \the [src]."),
					SPAN_NOTICE("You add \the [C] to \the [src].")
				)
				custom_appearance = custom_table_appearance[choosen_style]
				update_icon()
				return 1
			else
				to_chat(user, SPAN_WARNING("You don't have enough carpet!"))

	if(!material && can_plate && istype(I, /obj/item/stack/material))
		material = common_material_add(I, user, "plat")
		if(material)
			update_connections(1)
			update_icon()
			update_desc()
			update_material()
		return 1

	return ..()

/obj/structure/table/MouseDrop_T(obj/item/stack/material/what)
	if(can_reinforce && isliving(usr) && (!usr.stat) && istype(what) && usr.get_active_hand() == what && Adjacent(usr))
		reinforce_table(what, usr)
	else
		return ..()

/obj/structure/table/proc/reinforce_table(obj/item/stack/material/S, mob/user)
	if(reinforced)
		to_chat(user, SPAN_WARNING("\The [src] is already reinforced!"))
		return

	if(!can_reinforce)
		to_chat(user, SPAN_WARNING("\The [src] cannot be reinforced!"))
		return

	if(!material)
		to_chat(user, SPAN_WARNING("Plate \the [src] before reinforcing it!"))
		return

	if(flipped)
		to_chat(user, SPAN_WARNING("Put \the [src] back in place before reinforcing it!"))
		return

	reinforced = common_material_add(S, user, "reinforc")
	if(reinforced)
		update_desc()
		update_icon()
		update_material()

/obj/structure/table/proc/update_desc()
	if(custom_appearance)
		name = custom_appearance[1] || name
		desc = custom_appearance[2] || desc
	else
		if(material)
			name = "[material.display_name] table"
		else
			name = "table frame"

		if(reinforced)
			name = "reinforced [name]"
			desc = "[initial(desc)] This one seems to be reinforced with [reinforced.display_name]."
		else
			desc = initial(desc)

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_add(obj/item/stack/material/S, mob/user, verb) // Verb is actually verb without 'e' or 'ing', which is added. Works for 'plate'/'plating' and 'reinforce'/'reinforcing'.
	var/material/M = S.get_material()
	if(!istype(M))
		to_chat(user, SPAN_WARNING("You cannot [verb]e \the [src] with \the [S]."))
		return null
	if (src.flipped && istype(M, /material/glass))
		to_chat(user, SPAN_WARNING("You cannot [verb]e \the [src] with \the [S] when [src] flipped!."))
		return null
	if(manipulating) return M
	manipulating = 1
	to_chat(user, SPAN_NOTICE("You begin [verb]ing \the [src] with [M.display_name]."))
	if(!do_after(user, 20, src) || !S.use(1))
		manipulating = 0
		return null
	user.visible_message(SPAN_NOTICE("\The [user] [verb]es \the [src] with [M.display_name]."), SPAN_NOTICE("You finish [verb]ing \the [src]."))
	manipulating = 0
	return M

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_remove(mob/user, material/M, delay, what, type_holding, sound)
	if(!M.stack_type)
		to_chat(user, SPAN_WARNING("You are unable to remove the [what] from this table!"))
		return M
	user.visible_message(SPAN_NOTICE("\The [user] removes the [M.display_name] [what] from \the [src]."),
	                              SPAN_NOTICE("You remove the [M.display_name] [what] from \the [src]."))
	new M.stack_type(src.loc)
	return null

/obj/structure/table/proc/remove_reinforced(obj/item/I, mob/user)
	reinforced = common_material_remove(user, reinforced, 40, "reinforcements", "screws")

/obj/structure/table/proc/remove_material(obj/item/I, mob/user)
	material = common_material_remove(user, material, 20, "plating", "bolts")

// Returns a list of /obj/item/material/shard objects that were created as a result of this table's breakage.
// Used for !fun! things such as embedding shards in the faces of tableslammed people.

// The repeated
//     S = [x].place_shard(loc)
//     if(S) shards += S
// is to avoid filling the list with nulls, as place_shard won't place shards of certain materials (holo-wood, holo-steel)

/obj/structure/table/proc/break_to_parts(full_return = 0)
	var/list/shards = list()
	var/obj/item/material/shard/S = null
	if(reinforced)
		if(reinforced.stack_type && (full_return || prob(20)))
			reinforced.place_sheet(loc)
		else
			S = reinforced.place_shard(loc)
			if(S) shards += S
	if(material)
		if(material.stack_type && (full_return || prob(20)))
			material.place_sheet(loc)
		else
			S = material.place_shard(loc)
			if(S) shards += S
	if(custom_appearance && (full_return || prob(50))) // Higher chance to get the carpet back intact, since there's no non-intact option
		new /obj/item/stack/tile/carpet(src.loc)
	if(full_return || prob(20))
		new /obj/item/stack/material/steel(src.loc)
	else
		var/material/M = get_material_by_name(MATERIAL_STEEL)
		S = M.place_shard(loc)
		if(S) shards += S
	qdel(src)
	return shards

/obj/structure/table/on_update_icon()
	if(flipped != 1)
		icon_state = "blank"
		cut_overlays()

		var/image/I

		// Base frame shape. Mostly done for glass/diamond tables, where this is visible.
		for(var/i = 1 to 4)
			I = image(icon, dir = 1<<(i-1), icon_state = connections[i])
			add_overlays(I)

		//If there no any custom appearance or its an overlay, we use standard images
		if(!custom_appearance || (custom_appearance && !(custom_appearance[4] == CUSTOM_TABLE_ICON_REPLACE)))
			// Standard table image
			if(material)
				if (istype(material, /material/glass))
					for(var/i = 1 to 4)
						I = image(icon, "glass_[connections[i]]", dir = 1<<(i-1))
						if(material.icon_colour)
							I.color = material.icon_colour
						add_overlays(I)
						var/material/glass/G = material
						if (G.is_reinforced())
							I = image(icon, "rglass_[connections[i]]", dir = 1<<(i-1))
							add_overlays(I)

				else if (istype(material, /material/wood))
					for(var/i = 1 to 4)
						I = image(icon, "wood_[connections[i]]", dir = 1<<(i-1))
						add_overlays(I)

				else
					for(var/i = 1 to 4)
						I = image(icon, "[material.icon_base]_[connections[i]]", dir = 1<<(i-1))
						if(material.icon_colour) I.color = material.icon_colour
						I.alpha = 255 * material.opacity
						add_overlays(I)

			// Reinforcements
			if(reinforced)
				for(var/i = 1 to 4)
					I = image(icon, "[reinforced.icon_reinf]_[connections[i]]", dir = 1<<(i-1))
					I.color = material.icon_colour
					I.alpha = 255 * reinforced.opacity
					add_overlays(I)
		//Custom appearance
		if(custom_appearance)
			for(var/i = 1 to 4)
				I = image(icon, "[custom_appearance[3]]_[connections[i]]", dir = 1<<(i-1))
				add_overlays(I)
	else
		cut_overlays()
		var/type = 0
		var/tabledirs = 0
		for(var/direction in list(turn(dir,90), turn(dir,-90)) )
			var/obj/structure/table/T = locate(/obj/structure/table ,get_step(src,direction))
			if (T && T.flipped == 1 && T.dir == src.dir && material && T.material && T.material.name == material.name)
				type++
				tabledirs |= direction

		type = "[type]"
		if (type=="1")
			if (tabledirs & turn(dir,90))
				type += "-"
			if (tabledirs & turn(dir,-90))
				type += "+"

		icon_state = "flip[type]"
		if(custom_appearance && custom_appearance[4] == CUSTOM_TABLE_ICON_REPLACE)
			var/image/I = image(icon, "[custom_appearance[3]]_flip[type]")
			add_overlays(I)
		else if(material)
			if (istype(material, /material/wood))
				var/image/I = image(icon, "wood_flip[type]")
				add_overlays(I)
			else
				var/image/I = image(icon, "[material.icon_base]_flip[type]")
				I.color = material.icon_colour
				I.alpha = 255 * material.opacity
				add_overlays(I)
			name = "[material.display_name] table"
		else
			name = "table frame"

		if(reinforced)
			var/image/I = image(icon, "[reinforced.icon_reinf]_flip[type]")
			I.color = reinforced.icon_colour
			I.alpha = 255 * reinforced.opacity
			add_overlays(I)

		if(custom_appearance && custom_appearance[4] == CUSTOM_TABLE_COVERING)
			add_overlays("[custom_appearance[3]]_flip[type]")

// set propagate if you're updating a table that should update tables around it too, for example if it's a new table or something important has changed (like material).
/obj/structure/table/proc/update_connections(propagate=0)
	if(!material)
		connections = list("0", "0", "0", "0")

		if(propagate)
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_connections()
		return

	var/list/blocked_dirs = list()
	for(var/obj/structure/window/W in get_turf(src))
		if(W.is_fulltile())
			connections = list("0", "0", "0", "0")
			return
		blocked_dirs |= W.dir

	for(var/D in list(NORTH, SOUTH, EAST, WEST) - blocked_dirs)
		var/turf/T = get_step(src, D)
		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir == reverse_dir[D])
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)

		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir & reverse_dir[D])
				blocked_dirs |= D
				break

	// Blocked cardinals block the adjacent diagonals too. Prevents weirdness with tables.
	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	var/list/connection_dirs = list()

	for(var/obj/structure/table/T in orange(src, 1))
		var/T_dir = get_dir(src, T)
		if(T_dir in blocked_dirs) continue
		if(material && T.material && material.name == T.material.name && flipped == T.flipped)
			connection_dirs |= T_dir
		if(propagate)
			spawn(0)
				T.update_connections()
				T.update_icon()

	connections = dirs_to_corner_states(connection_dirs)

#define CORNER_NONE 0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL 2
#define CORNER_CLOCKWISE 4

/*
  turn() is weird:
    turn(icon, angle) turns icon by angle degrees clockwise
    turn(matrix, angle) turns matrix by angle degrees clockwise
    turn(dir, angle) turns dir by angle degrees counter-clockwise
*/

//This function is more complex than it appears.
//Previously, each corner can have up to three neighbors. One clockwise (45 degrees), one anticlockwise, and one diagonal from it
//This function takes that and assigns a bitfield to that corner based on which neighbors it has. Giving a value between 0 to 7, inclusive
//This number is used to choose the sprite file to draw that corner of the wall/table from. There are eight overlay files for each
/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIAGONAL
#undef CORNER_CLOCKWISE

#undef CUSTOM_TABLE_COVERING
#undef CUSTOM_TABLE_ICON_REPLACE