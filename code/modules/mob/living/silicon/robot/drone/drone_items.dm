//69atter decompiler.
/obj/item/matter_decompiler
	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon = 'icons/obj/device.dmi'
	icon_state = "decompiler"
	spawn_frequency = 0
	//Metal, glass, wood, plastic.
	var/datum/matter_synth/metal
	var/datum/matter_synth/glass
	var/datum/matter_synth/wood
	var/datum/matter_synth/plastic

//These caused failed GC runtime errors
/obj/item/matter_decompiler/Destroy()
	metal =69ull
	glass =69ull
	wood =69ull
	plastic =69ull
	return ..()

/obj/item/matter_decompiler/attack(mob/living/carbon/M as69ob,69ob/living/carbon/user as69ob)
	return

/obj/item/matter_decompiler/afterattack(atom/target as69ob|obj|turf|area,69ob/living/user as69ob|obj, proximity, params)

	if(!proximity) return //Not adjacent.

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return

	//Used to give the right69essage.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M,/mob/living/simple_animal/lizard) || ismouse(M))
			src.loc.visible_message(SPAN_DANGER("69src.loc69 sucks 69M69 into its decompiler. There's a horrible crunching69oise."),SPAN_DANGER("It's a bit of a struggle, but you69anage to suck 69M69 into your decompiler. It69akes a series of69isceral crunching69oises."))
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(M)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			return

		else if(isdrone(M) && !M.client)

			var/mob/living/silicon/robot/D = src.loc

			if(!istype(D))
				return

			to_chat(D, SPAN_DANGER("You begin decompiling 69M69."))

			if(!do_after(D,50,M))
				to_chat(D, SPAN_DANGER("You69eed to remain still while decompiling such a large object."))
				return

			if(!M || !D) return

			to_chat(D, SPAN_DANGER("You carefully and thoroughly decompile 69M69, storing as69uch of its resources as you can within yourself."))
			qdel(M)
			new/obj/effect/decal/cleanable/blood/oil(get_turf(src))

			if(metal)
				metal.add_charge(15000)
			if(glass)
				glass.add_charge(15000)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(1000)
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W,/obj/effect/spider/spiderling))
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
		else if(istype(W,/obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				if(metal)
					metal.add_charge(250)
				if(glass)
					glass.add_charge(250)
			else
				continue
		else if(istype(W,/obj/item/remains/robot))
			if(metal)
				metal.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/trash))
			if(metal)
				metal.add_charge(1000)
			if(plastic)
				plastic.add_charge(3000)
		else if(istype(W,/obj/effect/decal/cleanable/blood/gibs/robot))
			if(metal)
				metal.add_charge(2000)
			if(glass)
				glass.add_charge(2000)
		else if(istype(W,/obj/item/ammo_casing))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/material/shard/shrapnel))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/material/shard))
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/reagent_containers/food/snacks/grown))
			if(wood)
				wood.add_charge(4000)
		else if(istype(W,/obj/item/pipe))
			// This allows drones and engiborgs to clear pipe assemblies from floors.
		else
			continue

		qdel(W)
		grabbed_something = 1

	if(grabbed_something)
		to_chat(user, SPAN_NOTICE("You deploy your decompiler and clear out the contents of \the 69T69."))
	else
		to_chat(user, SPAN_DANGER("Nothing on \the 69T69 is useful to you."))
	return

//PRETTIER TOOL LIST.
/mob/living/silicon/robot/drone/installed_modules()

	if(weapon_lock)
		to_chat(src, SPAN_DANGER("Weapon lock active, unable to use69odules! Count:69weaponlock_time69"))
		return

	if(!module)
		module =69ew /obj/item/robot_module/drone(src)

	var/dat = "<HEAD><TITLE>Drone69odules</TITLE></HEAD><BODY>\n"
	dat += {"
	<B>Activated69odules</B>
	<BR>
	Module 1: 69module_state_1 ? "<A HREF=?src=\ref69src69;mod=\ref69module_state_169>69module_state_169<A>" : "No69odule"69<BR>
	Module 2: 69module_state_2 ? "<A HREF=?src=\ref69src69;mod=\ref69module_state_269>69module_state_269<A>" : "No69odule"69<BR>
	Module 3: 69module_state_3 ? "<A HREF=?src=\ref69src69;mod=\ref69module_state_369>69module_state_369<A>" : "No69odule"69<BR>
	<BR>
	<B>Installed69odules</B><BR><BR>"}


	var/tools = "<B>Tools and devices</B><BR>"
	var/resources = "<BR><B>Resources</B><BR>"

	for (var/O in69odule.modules)

		var/module_string = ""

		if (!O)
			module_string += text("<B>Resource depleted</B><BR>")
		else if(activated(O))
			module_string += text("69O69: <B>Activated</B><BR>")
		else
			module_string += text("69O69: <A HREF=?src=\ref69src69;act=\ref69O69>Activate</A><BR>")

		if((istype(O,/obj/item) || istype(O,/obj/item/device)) && !(istype(O,/obj/item/stack/cable_coil)))
			tools +=69odule_string
		else
			resources +=69odule_string

	dat += tools

	if (emagged)
		if (!module.emag)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(module.emag))
			dat += text("69module.emag69: <B>Activated</B><BR>")
		else
			dat += text("69module.emag69: <A HREF=?src=\ref69src69;act=\ref69module.emag69>Activate</A><BR>")

	dat += resources

	src << browse(dat, "window=robotmod")
