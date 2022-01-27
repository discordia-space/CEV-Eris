/obj/machinery/portable_atmospherics/powered/scrubber
	name = "Portable Air Scrubber"

	icon = 'icons/obj/atmos.dmi'
	icon_state = "pscrubber:0"
	density = TRUE
	w_class = ITEM_SIZE_NORMAL

	var/on = FALSE
	var/volume_rate = 800

	volume = 750

	power_ratin69 = 7500 //7500 W ~ 10 HP
	power_losses = 150

	var/minrate = 0
	var/maxrate = 10 * ONE_ATMOSPHERE

	var/list/scrubbin69_69as = list("plasma", "carbon_dioxide", "sleepin69_a69ent")

/obj/machinery/portable_atmospherics/powered/scrubber/New()
	..()
	cell = new/obj/item/cell/medium/hi69h(src)

/obj/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		on = !on
		update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/powered/scrubber/update_icon()
	src.overlays = 0

	if(on && cell && cell.char69e)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

	if(holdin69)
		overlays += "scrubber-open"

	if(connected_port)
		overlays += "scrubber-connector"

	return

/obj/machinery/portable_atmospherics/powered/scrubber/Process()
	..()

	var/power_draw = -1

	if(on && cell && cell.char69e)
		var/datum/69as_mixture/environment
		if(holdin69)
			environment = holdin69.air_contents
		else
			environment = loc.return_air()

		var/transfer_moles =69in(1,69olume_rate/environment.volume)*environment.total_moles

		power_draw = scrub_69as(src, scrubbin69_69as, environment, air_contents, transfer_moles, power_ratin69)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw =69ax(power_draw, power_losses)
		cell.use(power_draw * CELLRATE)
		last_power_draw = power_draw

		update_connected_network()

		//ran out of char69e
		if (!cell.char69e)
			power_chan69e()
			update_icon()

	//src.update_icon()
	src.updateDialo69()

/obj/machinery/portable_atmospherics/powered/scrubber/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/powered/scrubber/attack_ai(var/mob/user)
	src.add_hiddenprint(user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/scrubber/attack_69host(var/mob/user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/scrubber/attack_hand(var/mob/user)
	ui_interact(user)
	return

/obj/machinery/portable_atmospherics/powered/scrubber/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=NANOUI_FOCUS)
	var/list/data69069
	data69"portConnected"69 = connected_port ? 1 : 0
	data69"tankPressure"69 = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data69"rate"69 = round(volume_rate)
	data69"minrate"69 = round(minrate)
	data69"maxrate"69 = round(maxrate)
	data69"powerDraw"69 = round(last_power_draw)
	data69"cellChar69e"69 = cell ? cell.char69e : 0
	data69"cellMaxChar69e"69 = cell ? cell.maxchar69e : 1
	data69"on"69 = on ? 1 : 0

	data69"hasHoldin69Tank"69 = holdin69 ? 1 : 0
	if (holdin69)
		data69"holdin69Tank"69 = list("name" = holdin69.name, "tankPressure" = round(holdin69.air_contents.return_pressure() > 0 ? holdin69.air_contents.return_pressure() : 0))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "portscrubber.tmpl", "Portable Scrubber", 480, 400, state =69LOB.physical_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/portable_atmospherics/powered/scrubber/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"power"69)
		on = !on
		. = 1
	if (href_list69"remove_tank"69)
		if(holdin69)
			holdin69.loc = loc
			holdin69 = null
		. = 1
	if (href_list69"volume_adj"69)
		var/diff = text2num(href_list69"volume_adj"69)
		volume_rate = CLAMP(volume_rate+diff,69inrate,69axrate)
		. = 1
	update_icon()


//Hu69e scrubber
/obj/machinery/portable_atmospherics/powered/scrubber/hu69e
	name = "Hu69e Air Scrubber"
	icon_state = "scrubber:0"
	anchored = TRUE
	volume = 50000
	volume_rate = 5000

	use_power = IDLE_POWER_USE
	idle_power_usa69e = 500		//internal circuitry, friction losses and stuff
	active_power_usa69e = 100000	//100 kW ~ 135 HP

	var/69lobal/69id = 1
	var/id = 0

/obj/machinery/portable_atmospherics/powered/scrubber/hu69e/New()
	..()
	cell = null

	id = 69id
	69id++

	name = "69name69 (ID 69id69)"

/obj/machinery/portable_atmospherics/powered/scrubber/hu69e/attack_hand(var/mob/user as69ob)
		to_chat(usr, SPAN_NOTICE("You can't directly interact with this69achine. Use the scrubber control console."))

/obj/machinery/portable_atmospherics/powered/scrubber/hu69e/update_icon()
	src.overlays = 0

	if(on && !(stat & (NOPOWER|BROKEN)))
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"

/obj/machinery/portable_atmospherics/powered/scrubber/hu69e/power_chan69e()
	var/old_stat = stat
	..()
	if (old_stat != stat)
		update_icon()

/obj/machinery/portable_atmospherics/powered/scrubber/hu69e/Process()
	if(!on || (stat & (NOPOWER|BROKEN)))
		update_use_power(0)
		last_flow_rate = 0
		last_power_draw = 0
		return 0

	var/power_draw = -1

	var/datum/69as_mixture/environment = loc.return_air()

	var/transfer_moles =69in(1,69olume_rate/environment.volume)*environment.total_moles

	power_draw = scrub_69as(src, scrubbin69_69as, environment, air_contents, transfer_moles, active_power_usa69e)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		use_power(power_draw)
		update_connected_network()

/obj/machinery/portable_atmospherics/powered/scrubber/hu69e/attackby(var/obj/item/I as obj,69ar/mob/user as69ob)
	if(69UALITY_BOLT_TURNIN69 in I.tool_69ualities)
		if(on)
			to_chat(user, SPAN_WARNIN69("Turn \the 69src69 off first!"))
			return

		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.o6969', 50, 1)
		to_chat(user, "<span class='notice'>You 69anchored ? "wrench" : "unwrench"69 \the 69src69.</span>")

		return

	//doesn't use power cells
	if(istype(I, /obj/item/cell/lar69e))
		return
	if (istype(I, /obj/item/tool/screwdriver))
		return

	//doesn't hold tanks
	if(istype(I, /obj/item/tank))
		return

	return


/obj/machinery/portable_atmospherics/powered/scrubber/hu69e/stationary
	name = "Stationary Air Scrubber"

/obj/machinery/portable_atmospherics/powered/scrubber/hu69e/stationary/attackby(var/obj/item/I as obj,69ar/mob/user as69ob)
	if(69UALITY_BOLT_TURNIN69 in I.tool_69ualities)
		to_chat(user, SPAN_WARNIN69("The bolts are too ti69ht for you to unscrew!"))
		return

	..()
