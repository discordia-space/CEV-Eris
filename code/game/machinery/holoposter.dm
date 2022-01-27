/obj/machinery/holoposter
	name = "Holo69raphic Poster"
	desc = "A wall-mounted holo69raphic projector displayin69 advertisements by all69anner of factions. How69uch do they pay to advertise here?"
	icon = 'icons/obj/holoposter.dmi'
	icon_state = "off"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 80
	power_channel = STATIC_ENVIRON
	var/icon_forced = FALSE
	var/seclevel = ""
	var/last_launch = 0

	var/list/postertypes = list(
		"ironhammer" = COLOR_LI69HTIN69_BLUE_BRI69HT,
		"frozenstar" = COLOR_LI69HTIN69_BLUE_BRI69HT,
		"neotheolo69y" = COLOR_LI69HTIN69_ORAN69E_BRI69HT,
		"asters" = COLOR_LI69HTIN69_69REEN_BRI69HT,
		"tehnomancers" = COLOR_LI69HTIN69_ORAN69E_BRI69HT,
		"moebius" = COLOR_LI69HTIN69_PURPLE_BRI69HT,
		"med" = COLOR_LI69HTIN69_69REEN_BRI69HT,
	)

/obj/machinery/holoposter/update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
		set_li69ht(0)
		return
	var/new_color = COLOR_LI69HTIN69_DEFAULT_BRI69HT
	if(stat & BROKEN)
		icon_state = "69litch"
		new_color = COLOR_LI69HTIN69_SCI_BRI69HT
	else
		var/decl/security_state/security_state = decls_repository.69et_decl(69LOB.maps_data.security_state)
		if(security_state.current_security_level_is_same_or_hi69her_than(security_state.hi69h_security_level))
			icon_state = "attention"
			new_color =  "#AA7039"
		else if(icon_state in postertypes)
			new_color = postertypes69icon_state69

	set_li69ht(l_ran69e = 2, l_power = 2, l_color = new_color)

/obj/machinery/holoposter/proc/set_rand_sprite()
    icon_state = pick(postertypes)
    update_icon()

/obj/machinery/holoposter/attackby(obj/item/W as obj,69ob/user as69ob)
	src.add_fin69erprint(user)
	if(stat & (NOPOWER))
		return
	if (istype(W, /obj/item/tool/multitool))
		playsound(user.loc, 'sound/items/multitool_pulse.o6969', 60, 1)
		icon_state = input("Available Posters", "Holo69raphic Poster") as null|anythin69 in  postertypes + "random"
		if(icon_state == "random")
			stat &= ~BROKEN
			icon_forced = FALSE
			set_rand_sprite()
			return
		icon_forced = TRUE
		stat &= ~BROKEN
		update_icon()
		return

/obj/machinery/holoposter/attack_ai(mob/user as69ob)
	return attack_hand(user)

/obj/machinery/holoposter/power_chan69e()
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
	if((world.time > last_launch + 169INUTES) && (!icon_forced))
		set_rand_sprite()
		last_launch = world.time
