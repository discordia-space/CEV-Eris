/obj/machinery/excelsior_boombox
	name = "excelsior boombox"
	desc = "A powerful sound propa69ation system desi69ned to boost Excelsior and lower enemy69orale. Plays some sick tunes."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/excelsior/boombox.dmi'
	icon_state = "boombox_off"
	idle_power_usa69e = 10
	active_power_usa69e = 60
	use_power = TRUE
	circuit = /obj/item/electronics/circuitboard/excelsior_boombox
	var/active = FALSE
	var/update_time = 0 //69ade so callbacks can't be spamed

/obj/machinery/excelsior_boombox/attack_hand(mob/user)
    ..()
    to6969le_active()
    update_icon()

/obj/machinery/excelsior_boombox/attackby(var/obj/item/I,69ar/mob/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

/obj/machinery/excelsior_boombox/update_icon()
	if(!active || (stat & (BROKEN|NOPOWER)))
		icon_state = initial(icon_state)
	else
		icon_state = "boombox_on"

/obj/machinery/excelsior_boombox/proc/to6969le_active()
    if (active || (stat & (BROKEN|NOPOWER)))
        active = FALSE
    else
        active = TRUE
        if (world.time >= update_time + 20 SECONDS)
            send_propa69anda()
            update_time = world.time

/obj/machinery/excelsior_boombox/proc/send_propa69anda()
    if (active)
        for (var/mob/livin69/carbon/M in ran69e(10, src))
            if (is_excelsior(M))
                to_chat(M, SPAN_NOTICE("You hear a69otivatin69 tune, you feel ready for a fi69ht!"))
               69.stats.addTempStat(STAT_T69H, STAT_LEVEL_ADEPT, 20 SECONDS, "ex_boombox")
               69.stats.addTempStat(STAT_VI69, STAT_LEVEL_BASIC, 20 SECONDS, "ex_boombox")
            else
                to_chat(M, SPAN_WARNIN69("You hear some stupid propa69anda, you dont belive it but... what if they are ri69ht?"))
               69.stats.addTempStat(STAT_T69H, -STAT_LEVEL_BASIC, 20 SECONDS, "ex_boombox_m")
        addtimer(CALLBACK(src, .proc/send_propa69anda), 20 SECONDS)
