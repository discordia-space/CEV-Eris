#define TURRET_PRIORITY_TARGET 2
#define TURRET_SECONDARY_TARGET 1
#define TURRET_NOT_TARGET 0

/obj/machinery/porta_turret/mining
	name = "mining turret"
	icon = 'icons/obj/machines/mining_turret.dmi'
	desc = "A fully automated anti golem platform."
	icon_state = "turret_legs"

	// Projectile variables
	projectile = /obj/item/projectile/beam
	eprojectile = /obj/item/projectile/beam
	shot_sound = 'sound/weapons/Laser.ogg'
	eshot_sound = 'sound/weapons/Laser.ogg'
	egun = TRUE

	// Misc variables
	density = TRUE
	lethal = TRUE
	raised = TRUE
	circuit = /obj/item/electronics/circuitboard/miningturret
	installation = null
	health = 60
	shot_delay = 0
	use_power = NO_POWER_USE
	anchored = FALSE
	locked = FALSE
	enabled = FALSE

/obj/machinery/porta_turret/mining/allowed(mob/M)  // No access lock on turret
	return TRUE

/obj/machinery/porta_turret/mining/examine(mob/user)
	if(!..(user, 2))
		return

/obj/machinery/porta_turret/mining/Initialize()
	. = ..()
	update_icon()

/obj/machinery/porta_turret/mining/setup()
	return

/obj/machinery/porta_turret/mining/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	var/data[0]
	data["access"] = TRUE
	data["locked"] = locked
	data["enabled"] = enabled

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/porta_turret/mining/HasController()
	return FALSE

/obj/machinery/porta_turret/mining/Process()
	if(anchored)
		disabled = FALSE
	..()

/obj/machinery/porta_turret/mining/assess_living(mob/living/L)
	if(!istype(L))
		return TURRET_NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE)
		return TURRET_NOT_TARGET

	if(get_dist(src, L) > 7)
		return TURRET_NOT_TARGET

	if(!check_trajectory(L, src))
		return TURRET_NOT_TARGET

	if(emagged)  // If emagged not even the dead get a rest
		return L.stat ? TURRET_SECONDARY_TARGET : TURRET_PRIORITY_TARGET

	if(L.stat == DEAD)
		return TURRET_NOT_TARGET

	if(!isgolem(L))  // Only target golems
		return TURRET_NOT_TARGET

	if(L.lying)
		return TURRET_SECONDARY_TARGET

	return TURRET_PRIORITY_TARGET  // If the mob has passed all previous tests, congrats, it is now a "shoot-me!" nominee

// This turret has no cover, it is always raised
/obj/machinery/porta_turret/mining/popUp()
	raised = TRUE

/obj/machinery/porta_turret/mining/popDown()
	last_target = null
	raised = TRUE

/obj/machinery/porta_turret/mining/update_icon()
	overlays.Cut()
	if(!(stat & BROKEN))
		overlays += image("turret_gun")

/obj/machinery/porta_turret/mining/target(mob/living/target)
	if(disabled)
		return
	if(target)
		last_target = target
		set_dir(get_dir(src, target))	//even if you can't shoot, follow the target
		spawn()
			shootAt(target)
		return 1
	return

/obj/machinery/porta_turret/mining/shootAt(mob/living/target)
	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if(!istype(T) || !istype(U))
		return
	launch_projectile(target)

/obj/machinery/porta_turret/mining/launch_projectile(mob/living/target)
	update_icon()
	var/obj/item/projectile/A
	A = new eprojectile(loc)
	playsound(loc, eshot_sound, 75, 1)

	//Turrets aim for the center of mass by default.
	//If the target is grabbing someone then the turret smartly aims for extremities
	var/def_zone = get_exposed_defense_zone(target)
	//Shooting Code:
	A.launch(target, def_zone)

#undef TURRET_PRIORITY_TARGET
#undef TURRET_SECONDARY_TARGET
#undef TURRET_NOT_TARGET
