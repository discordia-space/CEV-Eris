/obj/item/machinery_crate
	name = "IKEA"
	desc = "Integrated Kit of Engineering Assembly."
	icon = 'icons/obj/machinery_crates.dmi'
	icon_state = "standart"

	commonLore = "A IKEA Kit , the invention of these revolutioned multiple aspects of warfare and construction. "

	anchored = FALSE
	volumeClass = ITEM_SIZE_HUGE
	slowdown_hold = 0.5
	throw_range = 2
	matter = list(MATERIAL_PLASTIC = 10, MATERIAL_PLASTEEL = 5, MATERIAL_STEEL = 10)

	var/machine_name
	var/constructing_machine
	var/constructing_duration = 50
	var/anim
	var/animation_duration = 5
	var/activated
	var/can_place_on_table = FALSE

/obj/item/machinery_crate/examine(mob/user)
	..(user, afterDesc = "The piece of paper on the side reads: [machine_name]")

/obj/item/machinery_crate/attackby(obj/item/I, mob/user)
	if(!(QUALITY_BOLT_TURNING in I.tool_qualities))
		return ..()
	if(is_table_on_turf())
		return
	if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		anchored = !anchored

/obj/item/machinery_crate/attack_hand(mob/living/user)
	if(!anchored)
		return ..()
	to_chat(user, "Initializing construction…")
	if(do_after(user, constructing_duration, src))
		activate_constructing()

/obj/item/machinery_crate/proc/activate_constructing()
	if(!anchored || activated)
		return
	if(anim)
		invisibility = INVISIBILITY_MAXIMUM
		var/atom/movable/overlay/animation = new(loc)
		animation.icon = 'icons/obj/machinery_crates.dmi'
		animation.master = src
		animation.density = TRUE
		flick(anim, animation)
		activated = TRUE
		addtimer(CALLBACK(src, PROC_REF(finish_construction), animation), animation_duration)
		return
	new constructing_machine(get_turf(src))
	qdel(src)

/obj/item/machinery_crate/proc/finish_construction(atom/movable/overlay/animation)
	new constructing_machine(get_turf(src))
	if(!QDELETED(animation))
		qdel(animation)
	if(!QDELETED(src))
		qdel(src)

/obj/item/machinery_crate/proc/is_table_on_turf()
	if(can_place_on_table)
		return FALSE
	for(var/obj/structure/table/I in get_turf(src))
		to_chat(usr, "You can't fasten \the [name] here because of \the [I.name] in the way.")
		return TRUE
	return FALSE

/obj/item/machinery_crate/excelsior
	icon_state = "excelsior"
	bad_type = /obj/item/machinery_crate/excelsior

/obj/item/machinery_crate/excelsior/shield
	name = "shield generator IKEA"
	icon_state = "shield_gen"
	anim = "ESH_animation"
	machine_name = "Excelsior shield generator"
	animation_duration = 39
	constructing_machine = /obj/machinery/shieldwallgen/excelsior

/obj/item/machinery_crate/autolathe
	name = "autolathe IKEA"
	machine_name = "autolathe"
	constructing_machine = /obj/machinery/autolathe

/obj/item/machinery_crate/crafting_station
	name = "crafting station IKEA"
	machine_name = "crafting station"
	constructing_machine = /obj/machinery/autolathe/crafting_station

/obj/item/machinery_crate/excelsior/autolathe
	name = "Excelsior autolathe IKEA"
	machine_name = "Excelsior autolate"
	constructing_machine = /obj/machinery/autolathe/excelsior

/obj/item/machinery_crate/excelsior/boombox
	name = "Excelsior boombox IKEA"
	icon_state = "exboombox"
	constructing_duration = 80
	machine_name = "Excelsior boombox"
	constructing_machine = /obj/machinery/excelsior_boombox

/obj/item/machinery_crate/excelsior/diesel_generator
	name = "diesel generator IKEA"
	machine_name = "diesel generator"
	constructing_machine = /obj/machinery/power/port_gen/pacman/diesel

/obj/item/machinery_crate/excelsior/turret
	name = "turret IKEA"
	constructing_duration = 130
	machine_name = "Excelsior turret"
	constructing_machine = /obj/machinery/porta_turret/excelsior

/obj/item/machinery_crate/pacman
	name = "P.A.C.M.A.N. IKEA"
	machine_name = "P.A.C.M.A.N."
	constructing_machine = /obj/machinery/power/port_gen/pacman

/obj/item/machinery_crate/recharger
	name = "recharger IKEA"
	machine_name = "recharger"
	constructing_machine = /obj/machinery/recharger

/obj/item/machinery_crate/beer_dispenser
	name = "a-dispenser IKEA"
	machine_name = "alcohol dispenser"
	can_place_on_table = TRUE
	constructing_machine = /obj/machinery/chemical_dispenser/beer

/obj/item/machinery_crate/soda_dispenser
	name = "s-dispenser IKEA"
	machine_name = "soda dispenser"
	can_place_on_table = TRUE
	constructing_machine = /obj/machinery/chemical_dispenser/soda





