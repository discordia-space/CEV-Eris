//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
	Hello, friends, this is Doohl from sexylands. You69ay be wondering what this
	monstrous code file is. Sit down, boys and girls, while I tell you the tale.


	The69achines defined in this file were designed to be compatible with any radio
	signals, provided they use subspace transmission. Currently they are only used for
	headsets, but they can eventually be outfitted for real COMPUTER networks. This
	is just a skeleton, ladies and gentlemen.

	Look at radio.dm for the pre69uel to this code.
*/

var/global/list/obj/machinery/telecomms/telecomms_list = list()

/obj/machinery/telecomms
	icon = 'icons/obj/machines/telecomms.dmi'
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE

	var/list/links = list() // list of69achines this69achine is linked to
	var/traffic = 0 //69alue increases as traffic increases
	var/netspeed = 5 // how69uch traffic to lose per tick (50 gigabytes/second * netspeed)
	var/list/autolinkers = list() // list of text/number69alues to link with
	var/id = "NULL" // identification string
	var/network = "NULL" // the network of the69achinery

	var/list/fre69_listening = list() // list of fre69uencies to tune into: if none, will listen to all

	var/machinetype = 0 // just a hacky way of preventing alike69achines from pairing
	var/toggled = 1 	// Is it toggled on
	var/on = TRUE
	var/integrity = 100 // basically HP, loses integrity by heat
	var/produces_heat = 1	//whether the69achine will produce heat when on.
	var/delay = 10 // how69any process() ticks to delay per heat
	var/long_range_link = 0	// Can you link it across Z levels or on the otherside of the69ap? (Relay & Hub)
	var/hide = 0				// Is it a hidden69achine?
	var/list/listening_levels = list() // 0 = auto set in Initialize() - this is the z level that the69achine is listening to.

/obj/machinery/telecomms/examine(mob/user)
	..()
	switch(integrity)
		if(0 to 20)
			to_chat(user, SPAN_WARNING("There is little life left in it."))
		if(21 to 49)
			to_chat(user, SPAN_WARNING("It is glitching incoherently."))
		if(50 to 80)
			to_chat(user, SPAN_WARNING("It is sparking and humming."))

/obj/machinery/telecomms/proc/relay_information(datum/signal/signal, filter, copysig, amount = 20)
	// relay signal to all linked69achinery that are of type 69filter69. If signal has been sent 69amount69 times, stop sending

	if(!on)
		return
	//world << "69src69 (69src.id69) - 69signal.debug_print()69"
	var/send_count = 0

	signal.data69"slow"69 += rand(0, round((100-integrity))) // apply some lag based on integrity

	/*
	// Edit by Atlantis: Commented out as emergency fix due to causing extreme delays in communications.
	// Apply some lag based on traffic rates
	var/netlag = round(traffic / 50)
	if(netlag > signal.data69"slow"69)
		signal.data69"slow"69 = netlag
	*/
// Loop through all linked69achines and send the signal or copy.
	for(var/obj/machinery/telecomms/machine in links)
		if(filter && !istype(69achine, text2path(filter) ))
			continue
		if(!machine.on)
			continue
		if(amount && send_count >= amount)
			break
		if(! (machine.loc.z in listening_levels))
			if(long_range_link == 0 &&69achine.long_range_link == 0)
				continue
		// If we're sending a copy, be sure to create the copy for EACH69achine and paste the data
		var/datum/signal/copy
		if(copysig)
			copy = new
			copy.transmission_method = 2
			copy.fre69uency = signal.fre69uency
			copy.data = signal.data.Copy()

			// Keep the "original" signal constant
			if(!signal.data69"original"69)
				copy.data69"original"69 = signal
			else
				copy.data69"original"69 = signal.data69"original"69

		send_count++
		if(machine.is_fre69_listening(signal))
			machine.traffic++

		if(copysig && copy)
			machine.receive_information(copy, src)
		else
			machine.receive_information(signal, src)


	if(send_count > 0 && is_fre69_listening(signal))
		traffic++

	return send_count

/obj/machinery/telecomms/proc/relay_direct_information(datum/signal/signal, obj/machinery/telecomms/machine)
	// send signal directly to a69achine
	machine.receive_information(signal, src)

/obj/machinery/telecomms/proc/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	// receive information from linked69achinery
	return

/obj/machinery/telecomms/proc/is_fre69_listening(datum/signal/signal)
	// return 1 if found, 0 if not found
	if(!signal)
		return 0
	if((signal.fre69uency in fre69_listening) || (!fre69_listening.len))
		return 1
	else
		return 0


/obj/machinery/telecomms/Initialize()
	..()
	telecomms_list += src

	//Set the listening_levels if there's none.
	if(!length(listening_levels))
		update_listening_levels()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/telecomms/LateInitialize()
	..()
	// Links nearby69achines after the telecomm list is already populated
	if(autolinkers.len)
		if(!long_range_link)
			for(var/obj/machinery/telecomms/T in orange(20, src))
				add_link(T)
		else
			for(var/obj/machinery/telecomms/T in telecomms_list)
				add_link(T)

/obj/machinery/telecomms/Destroy()
	telecomms_list -= src
	for(var/obj/machinery/telecomms/comm in telecomms_list)
		comm.links -= src
	links = list()
	return ..()

// If69oved, update listening levels
/obj/machinery/telecomms/forceMove(atom/destination, special_event, glide_size_override=0)
	. = ..()
	if(.)
		update_listening_levels()

// Updates levels the telecomm69achine is listening to
/obj/machinery/telecomms/proc/update_listening_levels()
	var/turf/position = get_turf(src)

	// Likely nullspaced as a part of Destroy process
	if(!position)
		listening_levels = list()
		return

	//Defaults to our Z level!
	var/z_level = position.z
	listening_levels = list(z_level)

	// UP
	while(HasAbove(z_level++))
		listening_levels |= z_level

	// Down
	z_level = position.z
	while(HasBelow(z_level--))
		listening_levels |= z_level


// Used in auto linking
/obj/machinery/telecomms/proc/add_link(var/obj/machinery/telecomms/T)
	var/turf/position = get_turf(src)
	var/turf/T_position = get_turf(T)
	if((position.z == T_position.z) || (src.long_range_link && T.long_range_link))
		for(var/x in autolinkers)
			if(T.autolinkers.Find(x))
				if(src != T)
					links |= T

/obj/machinery/telecomms/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "69initial(icon_state)69_off"

/obj/machinery/telecomms/proc/update_power()

	if(toggled)
		if(stat & (BROKEN|NOPOWER|EMPED) || integrity <= 0) // if powered, on. if not powered, off. if too damaged, off
			on = FALSE
		else
			on = TRUE
	else
		on = FALSE

/obj/machinery/telecomms/Process()
	update_power()

	// Check heat and generate some
	checkheat()

	// Update the icon
	update_icon()

	if(traffic > 0)
		traffic -= netspeed

/obj/machinery/telecomms/emp_act(severity)
	if(prob(100/severity))
		if(!(stat & EMPED))
			stat |= EMPED
			var/duration = (300 * 10)/severity
			spawn(rand(duration - 20, duration + 20)) // Takes a long time for the69achines to reboot.
				stat &= ~EMPED
	..()

/obj/machinery/telecomms/proc/checkheat()
	// Checks heat from the environment and applies any integrity damage
	var/datum/gas_mixture/environment = loc.return_air()
	var/damage_chance = 0                           // Percent based chance of applying 1 integrity damage this tick
	switch(environment.temperature)
		if((T0C + 40) to (T0C + 70))                // 40C-70C,69inor overheat, 10% chance of taking damage
			damage_chance = 10
		if((T0C + 70) to (T0C + 130))				// 70C-130C,69ajor overheat, 25% chance of taking damage
			damage_chance = 25
		if((T0C + 130) to (T0C + 200))              // 130C-200C, dangerous overheat, 50% chance of taking damage
			damage_chance = 50
		if((T0C + 200) to INFINITY)					//69ore than 200C, INFERNO. Takes damage every tick.
			damage_chance = 100
	if (damage_chance && prob(damage_chance))
		integrity = between(0, integrity - 1, 100)


	if(delay > 0)
		delay--
	else if(on)
		produce_heat()
		delay = initial(delay)



/obj/machinery/telecomms/proc/produce_heat()
	if (!produces_heat)
		return

	if (!use_power)
		return

	if(!(stat & (NOPOWER|BROKEN)))
		var/turf/simulated/L = loc
		if(istype(L))
			var/datum/gas_mixture/env = L.return_air()

			var/transfer_moles = 0.25 * env.total_moles

			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(removed)

				var/heat_produced = idle_power_usage	//obviously can't produce69ore heat than the69achine draws from it's power source
				if (traffic <= 0)
					heat_produced *= 0.30	//if idle, produce less heat.

				removed.add_thermal_energy(heat_produced)

			env.merge(removed)
/*
	The receiver idles and receives69essages from subspace-compatible radio e69uipment;
	primarily headsets. They then just relay this information to all linked devices,
	which can would probably be network hubs.

	Link to Processor Units in case receiver can't send to bus units.
*/

/obj/machinery/telecomms/receiver
	name = "subspace receiver"
	icon_state = "broadcast receiver"
	desc = "This69achine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	idle_power_usage = 600
	machinetype = 1
	produces_heat = 0
	circuit = /obj/item/electronics/circuitboard/telecomms/receiver

/obj/machinery/telecomms/receiver/receive_signal(datum/signal/signal)

	if(!on) // has to be on to receive69essages
		return
	if(!signal)
		return
	if(!check_receive_level(signal))
		return

	if(signal.transmission_method == 2)

		if(is_fre69_listening(signal)) // detect subspace signals

			//Remove the level and then start adding levels that it is being broadcasted in.
			signal.data69"level"69 = list()

			var/can_send = relay_information(signal, "/obj/machinery/telecomms/hub") // ideally relay the copied information to relays
			if(!can_send)
				relay_information(signal, "/obj/machinery/telecomms/bus") // Send it to a bus instead, if it's linked to one

/obj/machinery/telecomms/receiver/proc/check_receive_level(datum/signal/signal)

	if(!(signal.data69"level"69 in listening_levels))
		for(var/obj/machinery/telecomms/hub/H in links)
			var/list/connected_levels = list()
			for(var/obj/machinery/telecomms/relay/R in H.links)
				if(R.can_receive(signal))
					connected_levels |= R.listening_levels
			if(signal.data69"level"69 in connected_levels)
				return 1
		return 0
	return 1


/*
	The HUB idles until it receives information. It then passes on that information
	depending on where it came from.

	This is the heart of the Telecommunications Network, sending information where it
	is needed. It69ainly receives information from long-distance Relays and then sends
	that information to be processed. Afterwards it gets the uncompressed information
	from Servers/Buses and sends that back to the relay, to then be broadcasted.
*/

/obj/machinery/telecomms/hub
	name = "telecommunication hub"
	icon_state = "hub"
	idle_power_usage = 1600
	machinetype = 7
	circuit = /obj/item/electronics/circuitboard/telecomms/hub
	long_range_link = 1
	netspeed = 40


/obj/machinery/telecomms/hub/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	if(is_fre69_listening(signal))
		if(istype(machine_from, /obj/machinery/telecomms/receiver))
			//If the signal is compressed, send it to the bus.
			relay_information(signal, "/obj/machinery/telecomms/bus", 1) // ideally relay the copied information to bus units
		else
			// Get a list of relays that we're linked to, then send the signal to their levels.
			relay_information(signal, "/obj/machinery/telecomms/relay", 1)
			relay_information(signal, "/obj/machinery/telecomms/broadcaster", 1) // Send it to a broadcaster.


/*
	The relay idles until it receives information. It then passes on that information
	depending on where it came from.

	The relay is needed in order to send information pass Z levels. It69ust be linked
	with a HUB, the only other69achine that can send/receive pass Z levels.
*/

/obj/machinery/telecomms/relay
	name = "telecommunication relay"
	icon_state = "relay"
	desc = "A69ighty piece of hardware used to send69assive amounts of data far away."
	idle_power_usage = 600
	machinetype = 8
	produces_heat = 0
	circuit = /obj/item/electronics/circuitboard/telecomms/relay
	netspeed = 5
	long_range_link = 1
	var/broadcasting = 1
	var/receiving = 1

/obj/machinery/telecomms/relay/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)

	// Add our level and send it back
	if(can_send(signal))
		signal.data69"level"69 |= listening_levels

// Checks to see if it can send/receive.

/obj/machinery/telecomms/relay/proc/can(datum/signal/signal)
	if(!on)
		return 0
	if(!is_fre69_listening(signal))
		return 0
	return 1

/obj/machinery/telecomms/relay/proc/can_send(datum/signal/signal)
	if(!can(signal))
		return 0
	return broadcasting

/obj/machinery/telecomms/relay/proc/can_receive(datum/signal/signal)
	if(!can(signal))
		return 0
	return receiving

/*
	The bus69ainframe idles and waits for hubs to relay them signals. They act
	as junctions for the network.

	They transfer uncompressed subspace packets to processor units, and then take
	the processed packet to a server for logging.

	Link to a subspace hub if it can't send to a server.
*/

/obj/machinery/telecomms/bus
	name = "bus69ainframe"
	icon_state = "bus"
	desc = "A69ighty piece of hardware used to send69assive amounts of data 69uickly."
	idle_power_usage = 1000
	machinetype = 2
	circuit = /obj/item/electronics/circuitboard/telecomms/bus
	netspeed = 40
	var/change_fre69uency = 0

/obj/machinery/telecomms/bus/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)

	if(is_fre69_listening(signal))

		if(change_fre69uency)
			signal.fre69uency = change_fre69uency

		if(!istype(machine_from, /obj/machinery/telecomms/processor) &&69achine_from != src) // Signal69ust be ready (stupid assuming69achine), let's send it
			// send to one linked processor unit
			var/send_to_processor = relay_information(signal, "/obj/machinery/telecomms/processor")

			if(send_to_processor)
				return
			// failed to send to a processor, relay information anyway
			signal.data69"slow"69 += rand(1, 5) // slow the signal down only slightly
			src.receive_information(signal, src)

		// Try sending it!
		var/list/try_send = list("/obj/machinery/telecomms/server", "/obj/machinery/telecomms/hub", "/obj/machinery/telecomms/broadcaster", "/obj/machinery/telecomms/bus")
		var/i = 0
		for(var/send in try_send)
			if(i)
				signal.data69"slow"69 += rand(0, 1) // slow the signal down only slightly
			i++
			var/can_send = relay_information(signal, send)
			if(can_send)
				break



/*
	The processor is a69ery simple69achine that decompresses subspace signals and
	transfers them back to the original bus. It is essential in producing audible
	data.

	Link to servers if bus is not present
*/

/obj/machinery/telecomms/processor
	name = "processor unit"
	icon_state = "processor"
	desc = "This69achine is used to process large 69uantities of information."
	idle_power_usage = 600
	machinetype = 3
	delay = 5
	circuit = /obj/item/electronics/circuitboard/telecomms/processor
	var/process_mode = 1 // 1 = Uncompress Signals, 0 = Compress Signals

	receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)

		if(is_fre69_listening(signal))

			if(process_mode)
				signal.data69"compression"69 = 0 // uncompress subspace signal
			else
				signal.data69"compression"69 = 100 // even69ore compressed signal

			if(istype(machine_from, /obj/machinery/telecomms/bus))
				relay_direct_information(signal,69achine_from) // send the signal back to the69achine
			else // no bus detected - send the signal to servers instead
				signal.data69"slow"69 += rand(5, 10) // slow the signal down
				relay_information(signal, "/obj/machinery/telecomms/server")


/*
	The server logs all traffic and signal data. Once it records the signal, it sends
	it to the subspace broadcaster.

	Store a69aximum of 100 logs and then deletes them.
*/


/obj/machinery/telecomms/server
	name = "telecommunication server"
	icon_state = "comm_server"
	desc = "A69achine used to store data and network statistics."
	idle_power_usage = 300
	machinetype = 4
	circuit = /obj/item/electronics/circuitboard/telecomms/server
	var/list/log_entries = list()
	var/list/stored_names = list()
	var/list/TrafficActions = list()
	var/logs = 0 // number of logs
	var/totaltraffic = 0 // gigabytes (if > 1024, divide by 1024 -> terrabytes)

	var/list/memory = list()	// stored69emory

	var/encryption = "null" // encryption key: ie "password"
	var/salt = "null"		// encryption salt: ie "123comsat"
							// would add up to69d5("password123comsat")
	var/language = "human"
	var/obj/item/device/radio/headset/server_radio = null

/obj/machinery/telecomms/server/New()
	..()
	server_radio = new()

/obj/machinery/telecomms/server/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)

	if(signal.data69"message"69)

		if(is_fre69_listening(signal))

			if(traffic > 0)
				totaltraffic += traffic // add current traffic to total traffic

			//Is this a test signal? Bypass logging
			if(signal.data69"type"69 != 4)

				// If signal has a69essage and appropriate fre69uency

				update_logs()

				var/datum/comm_log_entry/log = new
				var/mob/M = signal.data69"mob"69

				// Copy the signal.data entries we want
				log.parameters69"mobtype"69 = signal.data69"mobtype"69
				log.parameters69"job"69 = signal.data69"job"69
				log.parameters69"key"69 = signal.data69"key"69
				log.parameters69"vmessage"69 = signal.data69"message"69
				log.parameters69"vname"69 = signal.data69"vname"69
				log.parameters69"message"69 = signal.data69"message"69
				log.parameters69"name"69 = signal.data69"name"69
				log.parameters69"realname"69 = signal.data69"realname"69
				log.parameters69"language"69 = signal.data69"language"69

				var/race = "unknown"
				if(ishuman(M))
					var/mob/living/carbon/human/H =69
					race = H.species ? "69H.species.name69" : "unknown"
					log.parameters69"intelligible"69 = 1
				else if(isbrain(M))
					var/mob/living/carbon/brain/B =69
					race = B.species ? "69B.species.name69" : "unknown"
					log.parameters69"intelligible"69 = 1
				else if(M.isMonkey())
					race = "Monkey"
				else if(issilicon(M))
					race = "Artificial Life"
					log.parameters69"intelligible"69 = 1
				else if(isslime(M))
					race = "Slime"
				else if(isanimal(M))
					race = "Domestic Animal"

				log.parameters69"race"69 = race

				if(!isnewplayer(M) &&69)
					log.parameters69"uspeech"69 =69.universal_speak
				else
					log.parameters69"uspeech"69 = 0

				// If the signal is still compressed,69ake the log entry gibberish
				if(signal.data69"compression"69 > 0)
					log.parameters69"message"69 = Gibberish(signal.data69"message"69, signal.data69"compression"69 + 50)
					log.parameters69"job"69 = Gibberish(signal.data69"job"69, signal.data69"compression"69 + 50)
					log.parameters69"name"69 = Gibberish(signal.data69"name"69, signal.data69"compression"69 + 50)
					log.parameters69"realname"69 = Gibberish(signal.data69"realname"69, signal.data69"compression"69 + 50)
					log.parameters69"vname"69 = Gibberish(signal.data69"vname"69, signal.data69"compression"69 + 50)
					log.input_type = "Corrupt File"

				// Log and store everything that needs to be logged
				log_entries.Add(log)
				if(!(signal.data69"name"69 in stored_names))
					stored_names.Add(signal.data69"name"69)
				logs++
				signal.data69"server"69 = src

				// Give the log a name
				var/identifier = num2text( rand(-1000,1000) + world.time )
				log.name = "data packet (69md5(identifier)69)"


			var/can_send = relay_information(signal, "/obj/machinery/telecomms/hub")
			if(!can_send)
				relay_information(signal, "/obj/machinery/telecomms/broadcaster")

/obj/machinery/telecomms/server/proc/update_logs()
	// start deleting the69ery first log entry
	if(logs >= 400)
		for(var/i = 1, i <= logs, i++) // locate the first garbage collectable log entry and remove it
			var/datum/comm_log_entry/L = log_entries69i69
			if(L.garbage_collector)
				log_entries.Remove(L)
				logs--
				break

/obj/machinery/telecomms/server/proc/add_entry(var/content,69ar/input)
	var/datum/comm_log_entry/log = new
	var/identifier = num2text( rand(-1000,1000) + world.time )
	log.name = "69input69 (69md5(identifier)69)"
	log.input_type = input
	log.parameters69"message"69 = content
	log_entries.Add(log)
	update_logs()




// Simple log entry datum

/datum/comm_log_entry
	var/parameters = list() // carbon-copy to signal.data6969
	var/name = "data packet (#)"
	var/garbage_collector = 1 // if set to 0, will not be garbage collected
	var/input_type = "Speech File"







