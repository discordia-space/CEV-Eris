/obj/machinery/holoposter
	name = "Holographic Poster"
	icon = 'icons/obj/holoposter.dmi'
	icon_state = "off"
	anchored = 1
	use_power = 1
	idle_power_usage = 80
	power_channel = ENVIRON
	var/icon_forced = FALSE
	var/seclevel = ""
	var/last_launch = 0

	var/list/postertypes = list(
		"ironhammer" = "#4D658D",
		"frozenstar" = "#4D658D",
		"neotheology" = "#D49E6A",
		"asters" = "#5FAE57",
		"tehnomancers" = "#AA7039",
		"moebius" = "#5D2971",
	)

/obj/machinery/holoposter/proc/set_rand_sprite()
    icon_state = pick(postertypes)

/obj/machinery/holoposter/update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
		set_light(0)
		return
	if(stat & BROKEN)
		icon_state = "glitch"
		set_light(l_range = 2, l_power = 2, l_color = "#4D658D")
		return
	if(icon_state in postertypes)
		set_light(l_range = 2, l_power = 2, l_color = postertypes[icon_state])
	else
		set_light(l_range = 2, l_power = 2, l_color = "#FFFFFF")

/obj/machinery/holoposter/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(stat & (NOPOWER|BROKEN))
		return

	if (istype(W, /obj/item/device/multitool))
		playsound(user.loc, 'sound/items/multitool_pulse.ogg', 60, 1)
		icon_state = input("Available Posters", "Holographic Poster") as null|anything in  postertypes + "random"
		if(icon_state == "random")
			icon_forced = FALSE
			set_rand_sprite()
			update_icon()
			return
		icon_forced = TRUE
		update_icon()
		return

/obj/machinery/holoposter/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/holoposter/power_change()
	var/wasUnpowered = stat & NOPOWER
	..()
	if(wasUnpowered != (stat & NOPOWER))
		update_icon()

/obj/machinery/holoposter/emp_act()
	stat |= BROKEN
	update_icon()

/obj/machinery/holoposter/process()
	if(stat & (NOPOWER|BROKEN))
		return
	if(seclevel == ("red" || "delta"))
		if(!icon_state == "attention")
			icon_state = "attention"
			set_light(l_range = 2, l_power = 3, l_color = "#AA7039")
		return
	if((world.time > last_launch + 1 MINUTE) && (!icon_forced))
		set_rand_sprite()
		update_icon()
		last_launch = world.time
