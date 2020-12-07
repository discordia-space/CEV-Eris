#define LOAD "load"
#define WORK "work"
#define DONE "done"

/obj/machinery/neotheology/cruciformforge
	name = "Cruciform Forge"
	desc = "This unique piece of technology can be fed biomatter, plasteel, and gold in order to print more cruciforms. Only a select few NeoTheologian architects know how to create these machines. "
	icon = 'icons/obj/neotheology_machinery.dmi'
	icon_state = "cruciforge"

	density = TRUE
	anchored = TRUE
	layer = 2.8

	var/power_cost = 250

	var/working = FALSE
	var/start_working = null
	var/work_time = 30 SECONDS
	var/paused = FALSE
	var/storage_capacity = 50
	var/list/stored_material = list()
	var/list/needed_material = list(MATERIAL_BIOMATTER = 10, MATERIAL_PLASTEEL = 5, MATERIAL_GOLD = 2)
	var/spawn_type = /obj/item/weapon/implant/core_implant/cruciform

	// A vis_contents hack for materials loading animation.
	var/tmp/obj/effect/flicker_overlay/image_load

/obj/machinery/neotheology/cruciformforge/Initialize()
	. = ..()

	image_load = new(src)

	for(var/_material in needed_material)
		stored_material[_material] = rand(1, 10)

/obj/machinery/neotheology/cruciformforge/examine(user)
	..()

	var/matter_count = "Need materials:"
	for(var/_material in needed_material)
		matter_count += " [needed_material[_material]] [_material]"
	matter_count += "."

	matter_count += "\nIt contains:"
	for(var/_material in stored_material)
		matter_count += " [stored_material[_material]] [_material]"
	matter_count += "."

	to_chat(user, SPAN_NOTICE(matter_count))

/obj/machinery/neotheology/cruciformforge/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack))
		eat(user, I)
		return

/obj/machinery/neotheology/cruciformforge/proc/produce()
	for(var/_material in needed_material)
		stored_material[_material] -= needed_material[_material]

	use_power(power_cost)
	working = TRUE
	start_working = world.time
	flick_anim(WORK)
	START_PROCESSING(SSobj, src)

/obj/machinery/neotheology/cruciformforge/Process()
	if(!working)
		STOP_PROCESSING(SSobj, src)
		return

	if(world.time >= (start_working + work_time))
		flick_anim(DONE)
		new spawn_type(get_turf(src))
		working = FALSE
		STOP_PROCESSING(SSobj, src)

/obj/machinery/neotheology/cruciformforge/proc/eat(mob/living/user, obj/item/eating)

	if(!eating && istype(user))
		eating = user.get_active_hand()

	if(!istype(eating))
		return FALSE

	if(stat)
		return FALSE

	if(!Adjacent(user) && !Adjacent(eating))
		return FALSE

	if(is_robot_module(eating))
		return FALSE

	if(!istype(eating, /obj/item/stack))
		to_chat(user, SPAN_WARNING("[src] does not support material recycling."))
		return FALSE

	if(!length(eating.get_matter()))
		to_chat(user, SPAN_WARNING("\The [eating] does not contain significant amounts of useful materials and cannot be accepted."))
		return FALSE

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.
	var/list/total_material_gained = list()

	for(var/obj/O in eating.GetAllContents(includeSelf = TRUE))
		var/list/_matter = O.get_matter()
		if(_matter)
			for(var/material in _matter)
				if(!(material in needed_material))
					to_chat(user, SPAN_WARNING("[src] does not support [material] recycle."))
					continue

				if(!(material in stored_material))
					stored_material[material] = 0

				if(!(material in total_material_gained))
					total_material_gained[material] = 0

				if(stored_material[material] + total_material_gained[material] >= storage_capacity)
					continue

				var/total_material = _matter[material]

				//If it's a stack, we eat multiple sheets.
				if(istype(O, /obj/item/stack))
					var/obj/item/stack/material/stack = O
					total_material *= stack.get_amount()

				if(stored_material[material] + total_material > storage_capacity)
					total_material = storage_capacity - stored_material[material]
					filltype = 1
				else
					filltype = 2

				total_material_gained[material] += total_material
				total_used += total_material
				mass_per_sheet += O.matter[material]

	if(!filltype)
		to_chat(user, SPAN_NOTICE("\The [src] is full or this thing isn't suitable for this autolathe type."))
		return

	// Determine what was the main material
	var/main_material
	var/main_material_amt = 0

	for(var/material in total_material_gained)
		stored_material[material] += total_material_gained[material]
		if(total_material_gained[material] > main_material_amt)
			main_material_amt = total_material_gained[material]
			main_material = material

	if(istype(eating, /obj/item/stack))
		flick_anim(LOAD) // Play insertion animation.
		var/obj/item/stack/stack = eating
		var/used_sheets = min(stack.get_amount(), round(total_used/mass_per_sheet))

		to_chat(user, SPAN_NOTICE("You add [used_sheets] [main_material] [stack.singular_name]\s to \the [src]."))

		if(!stack.use(used_sheets))
			qdel(stack)	// Protects against weirdness
	else
		flick_anim(LOAD) // Play insertion animation.
		to_chat(user, SPAN_NOTICE("You recycle \the [eating] in \the [src]."))
		qdel(eating)

/obj/machinery/neotheology/cruciformforge/proc/flick_anim(var/animation)

	if(animation == WORK)
		icon_state = "[initial(icon_state)]_start"
		update_icon()
		spawn(8)
		icon_state = "[initial(icon_state)]_work"
		update_icon()

	if(animation == LOAD)
		flick("[initial(icon_state)]_load", image_load)
		return

	if(animation == DONE)
		icon_state = "[initial(icon_state)]_finish"
		update_icon()
		spawn(8)
		icon_state = "[initial(icon_state)]"
		update_icon()

#undef WORK
#undef LOAD
#undef DONE
