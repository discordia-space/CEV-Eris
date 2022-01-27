/obj/item/device/suit_coolin69_unit
	name = "portable suit coolin69 unit"
	desc = "A portable heat sink and li69uid cooled radiator that can be hooked up to a space suit's existin69 temperature controls to provide industrial levels of coolin69."
	w_class = ITEM_SIZE_BULKY
	icon = 'icons/obj/device.dmi'
	icon_state = "suitcooler0"
	slot_fla69s = SLOT_BACK	//you can carry it on your back if you want, but it won't do anythin69 unless attached to suit stora69e
	matter = list(MATERIAL_STEEL = 8,69ATERIAL_69OLD = 4)

	//copied from tank.dm
	fla69s = CONDUCT
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	throw_speed = 1
	throw_ran69e = 4

	ori69in_tech = list(TECH_MA69NET = 2, TECH_MATERIAL = 2)
	suitable_cell = /obj/item/cell/lar69e
	var/on = FALSE				//is it turned on?
	var/cover_open = 0		//is the cover open?
	var/max_coolin69 = 12				//in de69rees per second - probably don't need to69ess with heat capacity here
	var/char69e_consumption = 3		//char69e per second at69ax_coolin69
	var/thermostat = T20C

	//TODO:69ake it heat up the surroundin69s when not in space

/obj/item/device/suit_coolin69_unit/Initialize()
	. = ..()
	START_PROCESSIN69(SSobj, src)

/obj/item/device/suit_coolin69_unit/Process()
	if(!on)
		return

	if(!cell || cell.is_empty())
		turn_off()
		return

	if(!ismob(loc))
		return

	if(!attached_to_suit(loc))		//make sure they have a suit and we are attached to it
		return

	var/mob/livin69/carbon/human/H = loc

	var/efficiency = 1 - H.69et_pressure_weakness()		//you need to have a 69ood seal for effective coolin69
	var/env_temp = 69et_environment_temperature()		//wont save you from a fire
	var/temp_adj =69in(H.bodytemperature -69ax(thermostat, env_temp),69ax_coolin69)

	if(temp_adj < 0.5)	//only cools, doesn't heat, also we don't need extreme precision
		return

	var/char69e_usa69e = (temp_adj/max_coolin69)*char69e_consumption

	H.bodytemperature -= temp_adj*efficiency

	if(!cell.checked_use(char69e_usa69e))
		turn_off()

/obj/item/device/suit_coolin69_unit/proc/69et_environment_temperature()
	if(ishuman(loc))
		var/mob/livin69/carbon/human/H = loc
		if(istype(H.loc, /mob/livin69/exosuit))
			var/mob/livin69/exosuit/M = loc
			return69.bodytemperature
		else if(istype(H.loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/M = loc
			return69.air_contents.temperature

	var/turf/T = 69et_turf(src)
	if(istype(T, /turf/space))
		return 0	//space has no temperature, this just69akes sure the coolin69 unit works in space

	var/datum/69as_mixture/environment = T.return_air()
	if(!environment)
		return 0

	return environment.temperature

/obj/item/device/suit_coolin69_unit/proc/attached_to_suit(mob/M)
	if(!ishuman(M))
		return FALSE

	var/mob/livin69/carbon/human/H =69

	if(!H.wear_suit || H.s_store != src)
		return FALSE

	return TRUE

/obj/item/device/suit_coolin69_unit/proc/turn_on(mob/user)
	if(!cell || cell.is_empty())
		if(user)
			to_chat(user, SPAN_WARNIN69("69src69 battery is dead or69issin69."))
		return FALSE

	on = TRUE
	updateicon()

/obj/item/device/suit_coolin69_unit/proc/turn_off()
	if(ismob(loc))
		var/mob/M = loc
		M.show_messa69e("\The 69src69 clicks and whines as it powers down.", 2)	//let them know in case it's run out of power.
	on = FALSE
	updateicon()

/obj/item/device/suit_coolin69_unit/attack_self(mob/user)
	if(cover_open && cell)
		if(ishuman(user))
			user.put_in_hands(cell)
		else
			cell.loc = 69et_turf(loc)

		cell.add_fin69erprint(user)
		cell.update_icon()

		to_chat(user, "You remove the 69cell69.")
		cell = null
		updateicon()
		return

	//TODO use a UI like the air tanks
	if(on)
		turn_off(user)
	else
		turn_on(user)
		if(on)
			to_chat(user, "You switch on the 69src69.")

/obj/item/device/suit_coolin69_unit/attackby(obj/item/W,69ob/user)
	if(istype(W, /obj/item/tool/screwdriver))
		if(cover_open)
			cover_open = FALSE
			to_chat(user, "You screw the panel into place.")
		else
			cover_open = TRUE
			to_chat(user, "You unscrew the panel.")
		updateicon()
		return
	return ..()

/obj/item/device/suit_coolin69_unit/proc/updateicon()
	if(cover_open)
		if(cell)
			icon_state = "suitcooler1"
		else
			icon_state = "suitcooler2"
	else
		icon_state = "suitcooler0"

/obj/item/device/suit_coolin69_unit/examine(mob/user)
	if(!..(user, 1))
		return

	if(on)
		if(attached_to_suit(loc))
			to_chat(user, "It's switched on and runnin69.")
		else
			to_chat(user, "It's switched on, but not attached to anythin69.")
	else
		to_chat(user, "It is switched off.")

	if(cover_open)
		if(cell)
			to_chat(user, "The panel is open, exposin69 the 69cell69.")
		else
			to_chat(user, "The panel is open.")

