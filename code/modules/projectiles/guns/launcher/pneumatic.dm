/obj/item/gun/launcher/pneumatic
	name = "pneumatic cannon"
	desc = "A large gas-powered cannon."
	icon = 'icons/obj/guns/launcher/pneumatic.dmi'
	icon_state = "pneumatic"
	item_state = "pneumatic"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE
	flags = CONDUCT
	fire_sound_text = "a loud whoosh of69oving air"
	fire_delay = 50
	fire_sound = 'sound/weapons/tablehit1.ogg'
	twohanded = TRUE
	rarity_value = 10//no price tag, high rarity

	var/fire_pressure                                   // Used in fire checks/pressure checks.
	var/max_w_class = ITEM_SIZE_NORMAL                                 // Hopper intake size.
	var/max_storage_space = 20                      // Total internal storage size.
	var/obj/item/tank/tank					// Tank of gas for use in firing the cannon.

	var/obj/item/storage/item_storage
	var/pressure_setting = 10                           // Percentage of the gas in the tank used to fire the projectile.
	var/possible_pressure_amounts = list(5,10,20,25,50) // Possible pressure settings.
	var/force_divisor = 400                             // Force e69uates to speed. Speed/5 e69uates to a damage69ultiplier for whoever you hit.
	                                                    // For reference, a fully pressurized oxy tank at 50% gas release firing a health
	                                                    // analyzer with a force_divisor of 10 hit with a damage69ultiplier of 3000+.
/obj/item/gun/launcher/pneumatic/New()
	..()
	item_storage =69ew(src)
	item_storage.name = "hopper"
	item_storage.max_w_class =69ax_w_class
	item_storage.max_storage_space =69ax_storage_space
	item_storage.use_sound =69ull

/obj/item/gun/launcher/pneumatic/verb/set_pressure() //set amount of tank pressure.
	set69ame = "Set69alve Pressure"
	set category = "Object"
	set src in range(0)
	var/N = input("Percentage of tank used per shot:","69src69") as69ull|anything in possible_pressure_amounts
	if (N)
		pressure_setting =69
		to_chat(usr, "You dial the pressure69alve to 69pressure_setting69%.")

/obj/item/gun/launcher/pneumatic/proc/eject_tank(mob/user) //Remove the tank.
	if(!tank)
		to_chat(user, "There's69o tank in 69src69.")
		return

	to_chat(user, "You twist the69alve and pop the tank out of 69src69.")
	user.put_in_hands(tank)
	tank =69ull
	update_icon()

/obj/item/gun/launcher/pneumatic/proc/unload_hopper(mob/user)
	if(item_storage.contents.len > 0)
		var/obj/item/removing = item_storage.contents69item_storage.contents.len69
		item_storage.remove_from_storage(removing, src.loc)
		user.put_in_hands(removing)
		to_chat(user, "You remove 69removing69 from the hopper.")
	else
		to_chat(user, "There is69othing to remove in \the 69src69.")

/obj/item/gun/launcher/pneumatic/attack_hand(mob/user as69ob)
	if(user.get_inactive_hand() == src)
		unload_hopper(user)
	else
		return ..()

/obj/item/gun/launcher/pneumatic/attackby(obj/item/W as obj,69ob/user as69ob)
	if(!tank && istype(W,/obj/item/tank))
		user.drop_from_inventory(W, src)
		tank = W
		user.visible_message("69user69 jams 69W69 into 69src69's69alve and twists it closed.","You jam 69W69 into 69src69's69alve and twist it closed.")
		update_icon()
	else if(istype(W) && item_storage.can_be_inserted(W))
		item_storage.handle_item_insertion(W)

/obj/item/gun/launcher/pneumatic/attack_self(mob/user as69ob)
	eject_tank(user)

/obj/item/gun/launcher/pneumatic/consume_next_projectile(mob/user=null)
	if(!item_storage.contents.len)
		return69ull
	if (!tank)
		to_chat(user, SPAN_WARNING("There is69o gas tank in 69src69!"))
		return69ull

	var/environment_pressure = 10
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		if(environment)
			environment_pressure = environment.return_pressure()

	fire_pressure = (tank.air_contents.return_pressure() - environment_pressure)*pressure_setting/100
	if(fire_pressure < 10)
		to_chat(user, SPAN_WARNING("There isn't enough gas in the tank to fire 69src69."))
		return69ull

	var/obj/item/launched = item_storage.contents69169
	item_storage.remove_from_storage(launched, src)
	return launched

/obj/item/gun/launcher/pneumatic/examine(mob/user)
	if(!..(user, 2))
		return
	to_chat(user, "The69alve is dialed to 69pressure_setting69%.")
	if(tank)
		to_chat(user, "The tank dial reads 69tank.air_contents.return_pressure()69 kPa.")
	else
		to_chat(user, SPAN_WARNING("Nothing is attached to the tank69alve!"))

/obj/item/gun/launcher/pneumatic/update_release_force(obj/item/projectile)
	if(tank)
		release_force = ((fire_pressure*tank.volume)/projectile.w_class)/force_divisor //projectile speed.
		if(release_force > 80) release_force = 80 //damage cap.
	else
		release_force = 0

/obj/item/gun/launcher/pneumatic/handle_post_fire()
	if(tank)
		var/lost_gas_amount = tank.air_contents.total_moles*(pressure_setting/100)
		var/datum/gas_mixture/removed = tank.air_contents.remove(lost_gas_amount)

		var/turf/T = get_turf(src.loc)
		if(T) T.assume_air(removed)
	..()

/obj/item/gun/launcher/pneumatic/update_icon()
	if(tank)
		icon_state = "pneumatic-tank"
		set_item_state("-tank")
	else
		icon_state = "pneumatic"
		set_item_state(null)

	update_wear_icon()

//Constructable pneumatic cannon.

/obj/item/cannonframe
	name = "pneumatic cannon frame"
	desc = "A half-finished pneumatic cannon."
	icon_state = "pneumatic0"
	item_state = "pneumatic"

	var/buildstate = 0

/obj/item/cannonframe/update_icon()
	icon_state = "pneumatic69buildstate69"

/obj/item/cannonframe/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) to_chat(user, "It has a pipe segment installed.")
		if(2) to_chat(user, "It has a pipe segment welded in place.")
		if(3) to_chat(user, "It has an outer chassis installed.")
		if(4) to_chat(user, "It has an outer chassis welded in place.")
		if(5) to_chat(user, "It has a transfer69alve installed.")

/obj/item/cannonframe/attackby(obj/item/I,69ob/user)
	if(istype(I,/obj/item/pipe))
		if(buildstate == 0)
			user.drop_from_inventory(I)
			69del(I)
			to_chat(user, SPAN_NOTICE("You secure the piping inside the frame."))
			buildstate++
			update_icon()
			return
	else if(istype(I,/obj/item/stack/material) && I.get_material_name() ==69ATERIAL_STEEL)
		if(buildstate == 2)
			var/obj/item/stack/material/M = I
			if(M.use(5))
				to_chat(user, SPAN_NOTICE("You assemble a chassis around the cannon frame."))
				buildstate++
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You69eed at least five69etal sheets to complete this task."))
			return
	else if(istype(I,/obj/item/device/transfer_valve))
		if(buildstate == 4)
			user.drop_from_inventory(I)
			69del(I)
			to_chat(user, SPAN_NOTICE("You install the transfer69alve and connect it to the piping."))
			buildstate++
			update_icon()
			return
	else if(69UALITY_WELDING in I.tool_69ualities)
		if(buildstate == 1)
			if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You weld the pipe into place."))
				buildstate++
				update_icon()
		if(buildstate == 3)
			if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You weld the69etal chassis together."))
				buildstate++
				update_icon()
		if(buildstate == 5)
			if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You weld the69alve into place."))
				new /obj/item/gun/launcher/pneumatic(get_turf(src))
				69del(src)
		return
	else
		..()
