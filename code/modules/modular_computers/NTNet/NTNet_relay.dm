// Relays don't handle any actual communication. Global69TNet datum does that, relays only tell the datum if it should or shouldn't work.
/obj/machinery/ntnet_relay
	name = "NTNet Quantum Relay"
	desc = "A69ery complex router and transmitter capable of connecting electronic devices together. Looks fragile."
	icon = 'icons/obj/machines/telecomms.dmi'
	use_power = ACTIVE_POWER_USE
	active_power_usage = 20000 //20kW, apropriate for69achine that keeps69assive cross-Zlevel wireless69etwork operational.
	idle_power_usage = 100
	icon_state = "bus"
	anchored = TRUE
	density = TRUE
	var/datum/ntnet/NTNet =69ull // This is69ostly for backwards reference and to allow69aredit69odifications from ingame.
	var/enabled = 1				// Set to 0 if the relay was turned off
	var/dos_failure = 0			// Set to 1 if the relay failed due to (D)DoS attack
	var/list/dos_sources = list()	// Backwards reference for qdel() stuff

	// Denial of Service attack69ariables
	var/dos_overload = 0		// Amount of DoS "packets" in this relay's buffer
	var/dos_capacity = 500		// Amount of DoS "packets" in buffer required to crash the relay
	var/dos_dissipate = 1		// Amount of DoS "packets" dissipated over time.


// TODO: Implement69ore logic here. For69ow it's only a placeholder.
/obj/machinery/ntnet_relay/operable()
	if(!..(EMPED))
		return 0
	if(dos_failure)
		return 0
	if(!enabled)
		return 0
	return 1

/obj/machinery/ntnet_relay/update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"

/obj/machinery/ntnet_relay/Process()
	if(operable())
		use_power = ACTIVE_POWER_USE
	else
		use_power = IDLE_POWER_USE

	if(dos_overload)
		dos_overload =69ax(0, dos_overload - dos_dissipate)

	// If DoS traffic exceeded capacity, crash.
	if((dos_overload > dos_capacity) && !dos_failure)
		dos_failure = 1
		update_icon()
		ntnet_global.add_log("Quantum relay switched from69ormal operation69ode to overload recovery69ode.")
	// If the DoS buffer reaches 0 again, restart.
	if((dos_overload == 0) && dos_failure)
		dos_failure = 0
		update_icon()
		ntnet_global.add_log("Quantum relay switched from overload recovery69ode to69ormal operation69ode.")
	..()

/obj/machinery/ntnet_relay/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = list()
	data69"enabled"69 = enabled
	data69"dos_capacity"69 = dos_capacity
	data69"dos_overload"69 = dos_overload
	data69"dos_crashed"69 = dos_failure

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "ntnet_relay.tmpl", "NTNet Quantum Relay", 500, 300, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/ntnet_relay/attack_hand(var/mob/living/user)
	ui_interact(user)

/obj/machinery/ntnet_relay/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"restart"69)
		dos_overload = 0
		dos_failure = 0
		update_icon()
		ntnet_global.add_log("Quantum relay69anually restarted from overload recovery69ode to69ormal operation69ode.")
		return 1
	else if(href_list69"toggle"69)
		enabled = !enabled
		ntnet_global.add_log("Quantum relay69anually 69enabled ? "enabled" : "disabled"69.")
		update_icon()
		return 1
	else if(href_list69"purge"69)
		ntnet_global.banned_nids.Cut()
		ntnet_global.add_log("Manual override:69etwork blacklist cleared.")
		return 1

/obj/machinery/ntnet_relay/New()
	uid = gl_uid
	gl_uid++
	component_parts = list()
	component_parts +=69ew /obj/item/stack/cable_coil(src,15)
	component_parts +=69ew /obj/item/electronics/circuitboard/ntnet_relay(src)

	if(ntnet_global)
		ntnet_global.relays.Add(src)
		NTNet =69tnet_global
		ntnet_global.add_log("New quantum relay activated. Current amount of linked relays: 69NTNet.relays.len69")
	..()

/obj/machinery/ntnet_relay/Destroy()
	if(ntnet_global)
		ntnet_global.relays.Remove(src)
		ntnet_global.add_log("Quantum relay connection severed. Current amount of linked relays: 69NTNet.relays.len69")
		NTNet =69ull
	for(var/datum/computer_file/program/ntnet_dos/D in dos_sources)
		D.target =69ull
		D.error = "Connection to quantum relay severed"
	..()

/obj/machinery/ntnet_relay/attackby(var/obj/item/W as obj,69ar/mob/user as69ob)
	if(default_deconstruction(W, user))
		return
	if(default_part_replacement(W, user))
		return
	..()