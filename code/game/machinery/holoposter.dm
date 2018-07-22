/obj/machinery/holoposter
	name = "Holographic Poster"
	desc = "Wall-mounted holographic projector. Looks like those factions pay owner of this place for advertisement."
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
		"med" = "#17A32D",
	)

/obj/machinery/holoposter/update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
		set_light(0)
		return
	var/new_color = "#FFFFFF"
	if(stat & BROKEN)
		icon_state = "glitch"
		new_color = "#4D658D"
	else if(security_level >= SEC_LEVEL_RED)
		icon_state = "attention"
		new_color =  "#AA7039"
	else if(icon_state in postertypes)
		new_color = postertypes[icon_state]

	set_light(l_range = 2, l_power = 2, l_color = new_color)

/obj/machinery/holoposter/proc/set_rand_sprite()
    icon_state = pick(postertypes)
    update_icon()

/obj/machinery/holoposter/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(stat & (NOPOWER))
		return
	if (istype(W, /obj/item/weapon/tool/multitool))
		playsound(user.loc, 'sound/items/multitool_pulse.ogg', 60, 1)
		icon_state = input("Available Posters", "Holographic Poster") as null|anything in  postertypes + "random"
		if(icon_state == "random")
			stat &= ~BROKEN
			icon_forced = FALSE
			set_rand_sprite()
			return
		icon_forced = TRUE
		stat &= ~BROKEN
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

/obj/machinery/holoposter/Process()
	if(stat & (NOPOWER|BROKEN))
		return
	if((world.time > last_launch + 1 MINUTE) && (!icon_forced))
		set_rand_sprite()
		last_launch = world.time

/obj/machinery/firealarm/securityLevelChanged(var/newlevel)
	if(seclevel != newlevel)
		seclevel = newlevel
		update_icon()
