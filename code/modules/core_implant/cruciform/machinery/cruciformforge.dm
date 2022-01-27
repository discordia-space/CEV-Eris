#define LOAD "load"
#define WORK "work"
#define DONE "done"

/obj/machinery/neotheology/cruciformforge
	name = "Cruciform Forge"
	desc = "This unique piece of technology can be fed biomatter, plasteel, and gold in order to print69ore cruciforms. Only a select few NeoTheologian architects know how to create these69achines. "
	icon = 'icons/obj/neotheology_machinery.dmi'
	icon_state = "cruciforge"

	density = TRUE
	anchored = TRUE
	layer = 2.8

	var/power_cost = 250

	var/working = FALSE
	var/start_working
	var/work_time = 30 SECONDS
	var/storage_capacity = 50
	var/list/stored_material = list()
	var/list/needed_material = list(MATERIAL_BIOMATTER = 10,69ATERIAL_PLASTEEL = 5,69ATERIAL_GOLD = 2)
	var/spawn_type = /obj/item/implant/core_implant/cruciform

	// A69is_contents hack for69aterials loading animation.
	var/tmp/obj/effect/flick_light_overlay/image_load

/obj/machinery/neotheology/cruciformforge/Initialize()
	. = ..()

	image_load = new(src)

	for(var/_material in needed_material)
		stored_material69_material69 = rand(1, 10)

/obj/machinery/neotheology/cruciformforge/examine(user)
	. = ..()

	var/list/matter_count_need = list()
	for(var/_material in needed_material)
		matter_count_need += "69needed_material69_material6969 69_material69"

	var/list/matter_count = list()
	for(var/_material in stored_material)
		matter_count += " 69stored_material69_material6969 69_material69"

	to_chat(user, SPAN_NOTICE("Materials required: 69english_list(matter_count_need)69.\nIt contains: 69english_list(matter_count)69."))

/obj/machinery/neotheology/cruciformforge/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/stack))
		eat(user, I)
		return
	. = ..()

/obj/machinery/neotheology/cruciformforge/proc/produce()
	for(var/_material in needed_material)
		stored_material69_material69 -= needed_material69_material69

	use_power(power_cost)
	working = TRUE
	start_working = world.time
	flick_anim(WORK)
	START_PROCESSING(SSmachines, src)

/obj/machinery/neotheology/cruciformforge/Process()
	if(!working)
		STOP_PROCESSING(SSmachines, src)
		return

	if(world.time >= (start_working + work_time))
		flick_anim(DONE)
		new spawn_type(get_turf(src))
		working = FALSE
		STOP_PROCESSING(SSmachines, src)

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

	if(!istype(eating, /obj/item/stack/material))
		to_chat(user, SPAN_WARNING("69src69 does not support this type of recycling."))
		return FALSE

	if(!length(eating.get_matter()))
		to_chat(user, SPAN_WARNING("\The 69eating69 does not contain significant amounts of useful69aterials and cannot be accepted."))
		return FALSE

	var/total_used = 0     // Amount of69aterial used.
	var/obj/item/stack/material/stack = eating
	var/material = stack.default_type

	if(!(material in needed_material))
		to_chat(user, SPAN_WARNING("69src69 does not support 69material69 recycle."))
		return FALSE

	if(stored_material69material69 >= storage_capacity)
		to_chat(user, SPAN_WARNING("The 69src69 are full of 69material69."))
		return FALSE

	if(stored_material69material69 + stack.amount > storage_capacity)
		total_used = storage_capacity - stored_material69material69

	else
		total_used = stack.amount


	stored_material69material69 += total_used

	if(!stack.use(total_used))
		qdel(stack)	// Protects against weirdness

	flick_anim(LOAD) // Play insertion animation.

	to_chat(user, SPAN_NOTICE("You add 69total_used69 of 69stack69\s to \the 69src69."))


/obj/machinery/neotheology/cruciformforge/proc/flick_anim(var/animation)

	if(animation == WORK)
		flick("69initial(icon_state)69_start", src)
		icon_state = "69initial(icon_state)69_work"
		update_icon()

	if(animation == LOAD)
		flick("69initial(icon_state)69_load", image_load)
		return

	if(animation == DONE)
		flick("69initial(icon_state)69_finish", src)
		icon_state = "69initial(icon_state)69"
		update_icon()

#undef WORK
#undef LOAD
#undef DONE
