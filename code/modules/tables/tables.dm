#define CUSTOM_TABLE_COVERING 			1
#define CUSTOM_TABLE_ICON_REPLACE 		2


//Custom appearance for tables, just add here a69ew design
//should be: list(name, desc, icon_state, icon replace or overlay, reinfocing re69uired)
var/list/custom_table_appearance = list(
					"Bar - special" 	= list("bar table", "Well designed bar table.", "bar_table", CUSTOM_TABLE_ICON_REPLACE, TRUE),
					"Gambling" 			= list("gambling table",69ull, "carpet", CUSTOM_TABLE_COVERING, FALSE),
					"OneStar"			= list("onestar", "Very durable table69ade by an extinct empire", "onestar", CUSTOM_TABLE_ICON_REPLACE, TRUE )
										)


/obj/structure/table
	name = "table frame"
	icon = 'icons/obj/tables.dmi'
	icon_state = "frame"
	desc = "A table, for putting things on. Or standing on, if you really want to."
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
	var/material/material =69ull
	var/material/reinforced =69ull

	// Gambling tables. I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/list/custom_appearance =69ull

	var/list/connections = list("nw0", "ne0", "sw0", "se0")

/obj/structure/table/get_matter()
	var/list/matter = ..()
	. =69atter.Copy()
	if(material)
		LAZYAPLUS(.,69aterial.name, 1)
	if(reinforced)
		LAZYAPLUS(., reinforced.name, 1)

/obj/structure/table/proc/update_material()
	var/old_maxhealth =69axhealth
	if(!material)
		maxhealth = 10
		if(can_plate)
			layer = PROJECTILE_HIT_THRESHHOLD_LAYER
		else
			layer = TABLE_LAYER
	else
		maxhealth =69aterial.integrity / 2
		layer = TABLE_LAYER

		if(reinforced)
			maxhealth += reinforced.integrity / 2

	health +=69axhealth - old_maxhealth

/obj/structure/table/proc/take_damage(amount)
	// If the table is69ade of a brittle69aterial, and is *not* reinforced with a69on-brittle69aterial, damage is69ultiplied by TABLE_BRITTLE_MATERIAL_MULTIPLIER
	if(material &&69aterial.is_brittle())
		if(reinforced)
			if(reinforced.is_brittle())
				amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
		else
			amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
	health -= amount
	if(health <= 0)
		visible_message(SPAN_WARNING("\The 69src69 breaks down!"))
		return break_to_parts() // if we break and form shards, return them to the caller to do !FUN! things with

/obj/structure/table/Initialize()
	. = ..()

	// reset color/alpha, since they're set for69ice69ap previews
	color = "#ffffff"
	alpha = 255
	update_connections(1)
	update_icon()
	update_desc()
	update_material()

/obj/structure/table/Destroy()
	material =69ull
	reinforced =69ull
	update_connections(1) // Update tables around us to ignore us (material=null forces69o connections)
	for(var/obj/structure/table/T in oview(src, 1))
		T.update_icon()
	. = ..()

/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(isliving(mover))
		var/mob/living/L =69over
		if(L.weakened)
			return 1
	return ..()	

/obj/structure/table/examine(mob/user)
	. = ..()
	if(health <69axhealth)
		switch(health /69axhealth)
			if(0 to 0.5)
				to_chat(user, SPAN_WARNING("It looks severely damaged!"))
			if(0.25 to 0.5)
				to_chat(user, SPAN_WARNING("It looks damaged!"))
			if(0.5 to 1)
				to_chat(user, SPAN_NOTICE("It has a few scrapes and dents."))

/obj/structure/table/attackby(obj/item/I,69ob/user)

	var/list/usable_69ualities = list()
	if(reinforced)
		usable_69ualities.Add(69UALITY_SCREW_DRIVING)
	if(custom_appearance)
		usable_69ualities.Add(69UALITY_PRYING)
	if(health <69axhealth)
		usable_69ualities.Add(69UALITY_WELDING)
	if(!reinforced && !custom_appearance)
		usable_69ualities.Add(69UALITY_BOLT_TURNING)

	var/tool_type = I.get_tool_type(user, usable_69ualities)
	switch(tool_type)

		if(69UALITY_SCREW_DRIVING)
			if(reinforced)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
					remove_reinforced(I, user)
					if(!reinforced)
						update_desc()
						update_icon()
						update_material()
			return

		if(69UALITY_PRYING)
			if(custom_appearance)
				if(custom_appearance696969 && !reinforced)
					to_chat(user, SPAN_WARNING("This type of design can't be applied to simple tables. Reinforce it first."))
					return
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
					user.visible_message(
						SPAN_NOTICE("\The 69use6969 removes the carpet from \the 69s69c69."),
						SPAN_NOTICE("You remove the carpet from \the 69sr6969.")
					)
					new /obj/item/stack/tile/carpet(loc)
					custom_appearance =69ull
					name = initial(name)
					desc = initial(desc)
					update_icon()
			return

		if(69UALITY_WELDING)
			if(health <69axhealth)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
					user.visible_message(SPAN_NOTICE("\The 69use6969 repairs some damage to \the 69s69c69."),SPAN_NOTICE("You repair some damage to \the 6969rc69."))
					health =69in(health+(maxhealth/5),69axhealth)//max(health+(maxhealth/5),69axhealth) // 20% repair per application
			return

		if(69UALITY_BOLT_TURNING)
			if(!reinforced && !custom_appearance)
				if(material)
					if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
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
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
						user.visible_message(SPAN_NOTICE("\The 69use6969 dismantles \the 69s69c69."),SPAN_NOTICE("You dismantle \the 6969rc69."))
						drop_materials(drop_location())
						69del(src)
			return

	if(!custom_appearance &&69aterial && istype(I, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = I
		var/choosen_style = input("Select an appearance.") in custom_table_appearance
		if(choosen_style)
			if(C.use(1))
				user.visible_message(
					SPAN_NOTICE("\The 69use6969 adds \the 669C69 to \the 6969rc69."),
					SPAN_NOTICE("You add \the 696969 to \the 69s69c69.")
				)
				custom_appearance = custom_table_appearance69choosen_styl6969
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

/obj/structure/table/proc/reinforce_table(obj/item/stack/material/S,69ob/user)
	if(reinforced)
		to_chat(user, SPAN_WARNING("\The 69sr6969 is already reinforced!"))
		return

	if(!can_reinforce)
		to_chat(user, SPAN_WARNING("\The 69sr6969 cannot be reinforced!"))
		return

	if(!material)
		to_chat(user, SPAN_WARNING("Plate \the 69sr6969 before reinforcing it!"))
		return

	if(flipped)
		to_chat(user, SPAN_WARNING("Put \the 69sr6969 back in place before reinforcing it!"))
		return

	reinforced = common_material_add(S, user, "reinforc")
	if(reinforced)
		update_desc()
		update_icon()
		update_material()

/obj/structure/table/proc/update_desc()
	if(custom_appearance)
		name = custom_appearance696969 ||69ame
		desc = custom_appearance696969 || desc
	else
		if(material)
			name = "69material.display_nam6969 table"
		else
			name = "table frame"

		if(reinforced)
			name = "reinforced 69nam6969"
			desc = "69initial(desc6969 This one seems to be reinforced with 69reinforced.display_na69e69."
		else
			desc = initial(desc)

// Returns the69aterial to set the table to.
/obj/structure/table/proc/common_material_add(obj/item/stack/material/S,69ob/user,69erb) //69erb is actually69erb without 'e' or 'ing', which is added. Works for 'plate'/'plating' and 'reinforce'/'reinforcing'.
	var/material/M = S.get_material()
	if(!istype(M))
		to_chat(user, SPAN_WARNING("You cannot 69ver6969e \the 69s69c69 with \the 699S69."))
		return69ull
	if (src.flipped && istype(M, /material/glass))
		to_chat(user, SPAN_WARNING("You cannot 69ver6969e \the 69s69c69 with \the 699S69 when 669src69 flipped!."))
		return69ull
	if(manipulating) return69
	manipulating = 1
	to_chat(user, SPAN_NOTICE("You begin 69ver6969ing \the 69s69c69 with 69M.display_n69me69."))
	if(!do_after(user, 20, src) || !S.use(1))
		manipulating = 0
		return69ull
	user.visible_message(SPAN_NOTICE("\The 69use6969 69ve69b69es \the 6969rc69 with 69M.display_69ame69."), SPAN_NOTICE("You finish 669verb69ing \the6969src69."))
	manipulating = 0
	return69

// Returns the69aterial to set the table to.
/obj/structure/table/proc/common_material_remove(mob/user,69aterial/M, delay, what, type_holding, sound)
	if(!M.stack_type)
		to_chat(user, SPAN_WARNING("You are unable to remove the 69wha6969 from this table!"))
		return69
	user.visible_message(SPAN_NOTICE("\The 69use6969 removes the 69M.display_na69e69 69w69at69 from \the 669src69."),
	                              SPAN_NOTICE("You remove the 69M.display_nam6969 69wh69t69 from \the 6969rc69."))
	new69.stack_type(src.loc)
	return69ull

/obj/structure/table/proc/remove_reinforced(obj/item/I,69ob/user)
	reinforced = common_material_remove(user, reinforced, 40, "reinforcements", "screws")

/obj/structure/table/proc/remove_material(obj/item/I,69ob/user)
	material = common_material_remove(user,69aterial, 20, "plating", "bolts")

// Returns a list of /obj/item/material/shard objects that were created as a result of this table's breakage.
// Used for !fun! things such as embedding shards in the faces of tableslammed people.

// The repeated
//     S = 696969.place_shard(loc)
//     if(S) shards += S
// is to avoid filling the list with69ulls, as place_shard won't place shards of certain69aterials (holo-wood, holo-steel)

/obj/structure/table/proc/break_to_parts(full_return = 0)
	var/list/shards = list()
	var/obj/item/material/shard/S =69ull
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
			S =69aterial.place_shard(loc)
			if(S) shards += S
	if(custom_appearance && (full_return || prob(50))) // Higher chance to get the carpet back intact, since there's69o69on-intact option
		new /obj/item/stack/tile/carpet(src.loc)
	if(full_return || prob(20))
		new /obj/item/stack/material/steel(src.loc)
	else
		var/material/M = get_material_by_name(MATERIAL_STEEL)
		S =69.place_shard(loc)
		if(S) shards += S
	69del(src)
	return shards

/obj/structure/table/update_icon()
	if(flipped != 1)
		icon_state = "blank"
		overlays.Cut()

		var/image/I

		// Base frame shape.69ostly done for glass/diamond tables, where this is69isible.
		for(var/i = 1 to 4)
			I = image(icon, dir = 1<<(i-1), icon_state = connections696969)
			overlays += I

		//If there69o any custom appearance or its an overlay, we use standard images
		if(!custom_appearance || (custom_appearance && !(custom_appearance696969 == CUSTOM_TABLE_ICON_REPLACE)))
			// Standard table image
			if(material)
				if (istype(material, /material/glass))
					for(var/i = 1 to 4)
						I = image(icon, "glass_69connections669696969", dir = 1<<(i-1))
						if(material.icon_colour)
							I.color =69aterial.icon_colour
						overlays += I
						var/material/glass/G =69aterial
						if (G.is_reinforced())
							I = image(icon, "rglass_69connections669696969", dir = 1<<(i-1))
							overlays += I

				else if (istype(material, /material/wood))
					for(var/i = 1 to 4)
						I = image(icon, "wood_69connections669696969", dir = 1<<(i-1))
						overlays += I

				else
					for(var/i = 1 to 4)
						I = image(icon, "69material.icon_bas6969_69connections6969i6969", dir = 1<<(i-1))
						if(material.icon_colour) I.color =69aterial.icon_colour
						I.alpha = 255 *69aterial.opacity
						overlays += I

			// Reinforcements
			if(reinforced)
				for(var/i = 1 to 4)
					I = image(icon, "69reinforced.icon_rein6969_69connections6969i6969", dir = 1<<(i-1))
					I.color =69aterial.icon_colour
					I.alpha = 255 * reinforced.opacity
					overlays += I
		//Custom appearance
		if(custom_appearance)
			for(var/i = 1 to 4)
				I = image(icon, "69custom_appearance669696969_69connection69699i6969", dir = 1<<(i-1))
				overlays += I
	else
		overlays.Cut()
		var/type = 0
		var/tabledirs = 0
		for(var/direction in list(turn(dir,90), turn(dir,-90)) )
			var/obj/structure/table/T = locate(/obj/structure/table ,get_step(src,direction))
			if (T && T.flipped == 1 && T.dir == src.dir &&69aterial && T.material && T.material.name ==69aterial.name)
				type++
				tabledirs |= direction

		type = "69typ6969"
		if (type=="1")
			if (tabledirs & turn(dir,90))
				type += "-"
			if (tabledirs & turn(dir,-90))
				type += "+"

		icon_state = "flip69typ6969"
		if(custom_appearance && custom_appearance696969 == CUSTOM_TABLE_ICON_REPLACE)
			var/image/I = image(icon, "69custom_appearance669696969_flip69t69pe69")
			overlays += I
		else if(material)
			if (istype(material, /material/wood))
				var/image/I = image(icon, "wood_flip69typ6969")
				overlays += I
			else
				var/image/I = image(icon, "69material.icon_bas6969_flip69ty69e69")
				I.color =69aterial.icon_colour
				I.alpha = 255 *69aterial.opacity
				overlays += I
			name = "69material.display_nam6969 table"
		else
			name = "table frame"

		if(reinforced)
			var/image/I = image(icon, "69reinforced.icon_rein6969_flip69ty69e69")
			I.color = reinforced.icon_colour
			I.alpha = 255 * reinforced.opacity
			overlays += I

		if(custom_appearance && custom_appearance696969 == CUSTOM_TABLE_COVERING)
			overlays += "69custom_appearance669696969_flip69t69pe69"

// set propagate if you're updating a table that should update tables around it too, for example if it's a69ew table or something important has changed (like69aterial).
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
			if(W.is_fulltile() || W.dir == reverse_dir696969)
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST,69ORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)

		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir & reverse_dir696969)
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
		if(material && T.material &&69aterial.name == T.material.name && flipped == T.flipped)
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
    turn(matrix, angle) turns69atrix by angle degrees clockwise
    turn(dir, angle) turns dir by angle degrees counter-clockwise
*/

//This function is69ore complex than it appears.
//Previously, each corner can have up to three69eighbors. One clockwise (45 degrees), one anticlockwise, and one diagonal from it
//This function takes that and assigns a bitfield to that corner based on which69eighbors it has. Giving a69alue between 0 to 7, inclusive
//This69umber is used to choose the sprite file to draw that corner of the wall/table from. There are eight overlay files for each
/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST,69ORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret696969
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret696969 = "669.69"

	return ret

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIAGONAL
#undef CORNER_CLOCKWISE

#undef CUSTOM_TABLE_COVERING
#undef CUSTOM_TABLE_ICON_REPLACE