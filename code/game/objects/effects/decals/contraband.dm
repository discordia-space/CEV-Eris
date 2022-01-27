
// CONTRABAND

/obj/item/contraband
	name = "contraband item"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/contraband.dmi'
	force = 0


/obj/item/contraband/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive69echanism, for easy pinning to any69ertical surface."
	icon_state = "rolled_poster"
	var/serial_number = 0
	var/ruined = 0
	var/datum/poster/design
	rarity_value = 10
	bad_type = /obj/item/contraband/poster
	spawn_tags = SPAWN_ITEM_CONTRABAND

/obj/item/contraband/poster/New(turf/loc,69ar/datum/poster/new_design = null)
	if(!new_design)
		design = pick(GLOB.poster_designs)
	else
		design = new_design
	..(loc)

/obj/item/contraband/poster/placed
	icon_state = "random"
	anchored = TRUE
	spawn_tags = null
	New(turf/loc)
		if(icon_state != "random")
			for(var/datum/poster/new_design in GLOB.poster_designs)
				if(new_design.icon_state == icon_state)
					return ..(loc, new_design)
		..()
		if(iswall(loc) && !pixel_x && !pixel_y)
			for(var/dir in cardinal)
				if(isfloor(get_step(src, dir)))
					switch(dir)
						if(NORTH) pixel_y = -32
						if(SOUTH) pixel_y = 32
						if(EAST)  pixel_x = 32
						if(WEST)  pixel_x = -32

/obj/item/contraband/poster/attack_hand(mob/user)
	if(!anchored)
		return ..()

	if(ruined)
		return

	switch(alert("Do I want to rip the poster from the wall?","You think...","Yes","No"))
		if("Yes")
			if(!Adjacent(user))
				return
			visible_message(SPAN_WARNING("69user69 rips 69src69 in a single, decisive69otion!") )
			playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
			ruined = 1
			icon = initial(icon)
			icon_state = "poster_ripped"
			name = "ripped poster"
			desc = "You can't69ake out anything from the poster's original print. It's ruined."
			add_fingerprint(user)
		if("No")
			return

/obj/item/contraband/poster/attackby(obj/item/W,69ob/user)
	if(istype(W, /obj/item/tool/wirecutters))
		playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		if(ruined)
			to_chat(user, SPAN_NOTICE("You remove the remnants of the poster."))
			69del(src)
		else
			roll_and_drop()
			to_chat(user, SPAN_NOTICE("You carefully remove the poster from the wall."))
		return

/obj/item/contraband/poster/proc/roll_and_drop()
	anchored = FALSE
	pixel_x = 0
	pixel_y = 0
	icon = initial(icon)
	icon_state = initial(icon_state)
	name = initial(name)


//Places the poster on a wall
/obj/item/contraband/poster/afterattack(var/turf/simulated/wall/W,69ar/mob/user,69ar/adjacent,69ar/clickparams)
	if (!adjacent)
		return

	//must place on a wall and user69ust not be inside a closet/whatever
	if (!istype(W) || !W.Adjacent(user))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return

	var/turf/new_loc = null

	var/placement_dir = get_dir(user, W)
	if (placement_dir in cardinal)
		new_loc = user.loc
	else
		placement_dir = reverse_dir69placement_dir69
		for(var/t_dir in cardinal)
			if(!(t_dir & placement_dir)) continue
			if(iswall(get_step(W, t_dir)))
				if(iswall(get_step(W, placement_dir-t_dir)))
					break
				else
					new_loc = get_step(W, placement_dir-t_dir)
					break
			else
				if(iswall(get_step(W, placement_dir-t_dir)))
					new_loc = get_step(W, t_dir)
					break
				else
					new_loc = user.loc
					break
	if(!new_loc)
		to_chat(user, SPAN_WARNING("You can't place poster there"))

	//Looks like it's uncluttered enough. Place the poster.
	to_chat(user, SPAN_NOTICE("You start placing the poster on the wall..."))
	if(do_after(usr, 17, src))
		user.drop_from_inventory(src, new_loc)
		placement_dir = get_dir(W, new_loc)
		if(placement_dir&NORTH)
			pixel_y = -32
		else if(placement_dir&SOUTH)
			pixel_y = 32
		if(placement_dir&WEST)
			pixel_x = 32
		else if(placement_dir&EAST)
			pixel_x = -32
		anchored = TRUE
		flick("poster_being_set", src)
		playsound(W, 'sound/items/poster_being_created.ogg', 100, 1)
		design.set_design(src)

/datum/poster
	// Name suffix. Poster - 69name69
	var/name=""
	// Description suffix
	var/desc=""
	var/icon_state=""
	var/icon = 'icons/obj/contraband.dmi'

/datum/poster/proc/set_design(var/obj/item/contraband/poster/P)
	P.name = "poster - 69name69"
	P.desc = desc
	P.icon_state = icon_state
	P.icon = icon
	return 1
