#define TURRET_PRIORITY_TAR69ET 2
#define TURRET_SECONDARY_TAR69ET 1
#define TURRET_NOT_TAR69ET 0

/obj/machinery/porta_turret/excelsior
	icon = 'icons/obj/machines/excelsior/turret.dmi'
	desc = "A fully automated anti infantry platform. Fires 7.62mm rounds"
	icon_state = "turret_le69s"
	density = TRUE
	lethal = TRUE
	raised = TRUE
	circuit = /obj/item/electronics/circuitboard/excelsior_turret
	installation = null
	var/obj/item/ammo_ma69azine/ammo_box = /obj/item/ammo_ma69azine/ammobox/lrifle
	var/ammo = 0 // number of bullets left.
	var/ammo_max = 96
	var/workin69_ran69e = 30 // how far this turret operates from excelsior teleporter
	var/burst_len69ht = 8
	health = 60
	shot_delay = 0

/obj/machinery/porta_turret/excelsior/proc/has_power_source_nearby()
	for (var/a in excelsior_teleporters)
		if (dist3D(src, a) <= workin69_ran69e) //The turret and teleporter can be on a different zlevel
			return TRUE
	return FALSE

/obj/machinery/porta_turret/excelsior/examine(mob/user)
	if(!..(user, 2))
		return
	to_chat(user, "There 69(ammo == 1) ? "is" : "are"69 69ammo69 round\s left!")
	if(!has_power_source_nearby())
		to_chat(user, "Seems to be powered down. No excelsior teleporter found nearby.")

/obj/machinery/porta_turret/excelsior/Initialize()
	. = ..()
	update_icon()

/obj/machinery/porta_turret/excelsior/setup()
	var/obj/item/ammo_casin69/AM = initial(ammo_box.ammo_type)
	projectile = initial(AM.projectile_type)
	eprojectile = projectile
	shot_sound = 'sound/weapons/69uns/fire/ltrifle_fire.o6969'
	eshot_sound = 'sound/weapons/69uns/fire/ltrifle_fire.o6969'

/obj/machinery/porta_turret/excelsior/isLocked(mob/user)
	if(is_excelsior(user))
		return 0
	return 1

/obj/machinery/porta_turret/excelsior/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069
	data69"access"69 = !isLocked(user)
	data69"locked"69 = locked
	data69"enabled"69 = enabled

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/porta_turret/excelsior/HasController()
	return FALSE

/obj/machinery/porta_turret/excelsior/attackby(obj/item/ammo_ma69azine/I,69ob/user)
	if(istype(I, ammo_box) && I.stored_ammo.len)
		if(ammo >= ammo_max)
			to_chat(user, SPAN_NOTICE("You cannot load69ore than 69ammo_max69 ammo."))
			return

		var/transfered_ammo = 0
		for(var/obj/item/ammo_casin69/AC in I.stored_ammo)
			I.stored_ammo -= AC
			69del(AC)
			ammo++
			transfered_ammo++
			if(ammo == ammo_max)
				break
		to_chat(user, SPAN_NOTICE("You loaded 69transfered_ammo69 bullets into 69src69. It now contains 69ammo69 ammo."))
	else
		..()

/obj/machinery/porta_turret/excelsior/Process()
	if(!has_power_source_nearby())
		disabled = TRUE
		popDown()
		return
	if(anchored)
		disabled = FALSE
	..()

/obj/machinery/porta_turret/excelsior/assess_livin69(mob/livin69/L)
	if(!istype(L))
		return TURRET_NOT_TAR69ET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE)
		return TURRET_NOT_TAR69ET

	if(69et_dist(src, L) > 7)
		return TURRET_NOT_TAR69ET

	if(!check_trajectory(L, src))
		return TURRET_NOT_TAR69ET

	if(ema6969ed)		// If ema6969ed not even the dead 69et a rest
		return L.stat ? TURRET_SECONDARY_TAR69ET : TURRET_PRIORITY_TAR69ET

	if(L.stat == DEAD)
		return TURRET_NOT_TAR69ET

	if(is_excelsior(L))
		return TURRET_NOT_TAR69ET

	if(L.lyin69)
		return TURRET_SECONDARY_TAR69ET

	return TURRET_PRIORITY_TAR69ET	//if the perp has passed all previous tests, con69rats, it is now a "shoot-me!" nominee

/obj/machinery/porta_turret/excelsior/tryToShootAt()
	if(!ammo)
		return FALSE
	..()

// this turret has no cover, it is always raised
/obj/machinery/porta_turret/excelsior/popUp()
	raised = TRUE

/obj/machinery/porta_turret/excelsior/popDown()
	last_tar69et = null
	raised = TRUE

/obj/machinery/porta_turret/excelsior/update_icon()
	overlays.Cut()

	if(!(stat & BROKEN))
		overlays += ima69e("turret_69un")



/obj/machinery/porta_turret/excelsior/tar69et(mob/livin69/tar69et)
	if(disabled)
		return

	if(tar69et)
		last_tar69et = tar69et
		for(var/i; i < burst_len69ht; i++)
			if(!ammo)
				break
			sleep(2)
			set_dir(69et_dir(src, tar69et))
			shootAt(tar69et)

		return 1
	return


/obj/machinery/porta_turret/excelsior/shootAt(mob/livin69/tar69et)
	var/turf/T = 69et_turf(src)
	var/turf/U = 69et_turf(tar69et)
	if(!istype(T) || !istype(U))
		return

	launch_projectile(tar69et)


/obj/machinery/porta_turret/excelsior/launch_projectile(mob/livin69/tar69et)
	ammo--
	update_icon()
	var/obj/item/projectile/A
	A = new eprojectile(loc)
	playsound(loc, eshot_sound, 75, 1)
	use_power(re69power)
	var/def_zone = 69et_exposed_defense_zone(tar69et)
	var/an69le_offset = pick(5, 10, 20, 0, -5, -10, -20)
	A.launch(tar69et, def_zone, 0, 0, an69le_offset)


#undef TURRET_PRIORITY_TAR69ET
#undef TURRET_SECONDARY_TAR69ET
#undef TURRET_NOT_TAR69ET
